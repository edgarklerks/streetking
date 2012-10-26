{-# LANGUAGE TemplateHaskell, FlexibleContexts, FlexibleInstances, TypeSynonymInstances, FunctionalDependencies, MultiParamTypeClasses, OverloadedStrings, RankNTypes #-}


module Data.RacingNew (
        RaceResult (..),
        SectionResult (..),
        RaceConfig (..),
        SectionConfig (..),
        RaceM,
        SectionM,
        sectionConfig,
        runSectionM,
        runRaceM,
        raceWithParticipant,
        race,

        accelerationTime,
        brakingDistance,
        lateralAcceleration
    ) where

import Model.TH
import Model.General
import Data.InRules
import Data.Conversion
import qualified Data.Aeson as AS
import Data.Text
import Data.Database
import Data.SqlTransaction
import Database.HDBC (toSql, fromSql)
import Control.Applicative
import Control.Monad
import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Random
import Data.Maybe
import qualified Data.List as L

import qualified Data.RaceParticipant as RP
import qualified Data.RaceReward as RW
--import qualified Data.CarDerivedParameters as CDP
import qualified Data.RaceSectionPerformance as P
import qualified Data.Car as C
import qualified Data.Driver as D
import qualified Data.Environment as E
import           Data.Constants

import qualified Data.Track as T
import qualified Data.Section as S

import qualified Model.Account as A
import qualified Model.CarInGarage as CIG

import Control.Monad.Error 

type Speed = Double
type Length = Double
type Time = Double
type Radius = Double

lightSpeed :: Speed
lightSpeed = 299792458

initialSpeed :: Speed
initialSpeed = 0

-- race configuration: data available in the RaceM environment
data RaceConfig = RaceConfig {
        car :: C.Car,
        driver :: D.Driver,
        environment :: E.Environment,
        track :: T.Track
    } deriving Show

type RaceM a = RandomGen g => ErrorT String (RandT g (Reader RaceConfig)) a

runRaceM :: (RandomGen g) => RaceM a -> g -> RaceConfig -> Either String a 
runRaceM m g = runReader (evalRandT (runErrorT m) g)

-- section configuration: data available in the SectionM environment
data SectionConfig = SectionConfig {
        section :: S.Section,
        sectionPerformance :: P.RaceSectionPerformance,
        mass :: Double,
        aero :: Double,
        downforce :: Double,
        power :: Double,
        braking :: Double,
        traction :: Double,
        handling :: Double,
        topSpeed :: Double
} deriving Show

type SectionM a = Reader SectionConfig a

runSectionM :: SectionM a -> SectionConfig -> a
runSectionM = runReader

type MDouble = Maybe Double

$(genMapableRecord "SectionResult" [

        -- section data
        ("section_id", ''Integer),
       
        -- performance data
        ("performance", ''P.RaceSectionPerformance),
        
        -- effective path: original section modified by intelligence performance
        ("effective_radius", ''MDouble),
        ("effective_arclength", ''Double),
        
        -- distance in section phases
        ("length_acceleration_phase", ''Double),
        ("length_braking_phase", ''Double),
        ("length_constant_phase", ''Double),
        ("length_section", ''Double),

        -- time spent in section phases
        ("time_acceleration_phase", ''Double),
        ("time_braking_phase", ''Double),
        ("time_constant_phase", ''Double),
        ("time_section", ''Double),

        -- speed data
        ("speed_entry", ''Double),
        ("speed_exit", ''Double),
        ("speed_cap", ''Double),
        ("speed_top", ''Double),
        ("speed_avg", ''Double)
    ])

type SectionResultList = [SectionResult]

$(genMapableRecord "RaceResult" [
        ("track_id", ''Integer),
        ("race_time", ''Double),
        ("race_speed_top", ''Double),
        ("race_speed_finish", ''Double),
        ("race_speed_avg", ''Double),
        ("sections", ''SectionResultList)
   ])

instance Ord RaceResult where 
        compare (race_time -> x) (race_time -> y) = compare x y 

type RaceResultList = [RaceResult] 

raceResult :: Integer -> SectionResultList -> RaceResult
raceResult tid [] = RaceResult tid 0 0 0 0 []
raceResult tid rs = RaceResult tid tme spk sfn sag rs
        where
            mrs f = L.map f rs
            tme = L.sum $ mrs time_section 
            spk = L.maximum $ mrs speed_top
            sag = (L.sum $ mrs effective_arclength) / tme 
            sfn = speed_exit $ L.last rs

-- generate race configuration from a given RaceParticipant, a Track and a random seed
raceConfigWithParticipant :: RP.RaceParticipant -> T.Track -> RaceConfig
raceConfigWithParticipant p t = RaceConfig {
        driver = D.accountDriver $ RP.account p,
        car = C.carInGarageCar $ RP.car p,
        environment = E.defaultEnvironment,
        track = t
    }

-- run race with config
race :: (RandomGen g) => RaceConfig -> g -> Either String RaceResult
race rc g = runRaceM doRace g rc

-- run race with participant and track
raceWithParticipant :: (RandomGen g) => RP.RaceParticipant -> T.Track -> g -> Either String RaceResult
raceWithParticipant p t g = race (raceConfigWithParticipant p t) g

--runSection :: SectionConfig -> Speed -> Speed -> RaceM SectionResult
--runSection c v0 v1 = return $ runReader (doSection v0 v1) c

-- perform race calculations
doRace :: RaceM RaceResult 
doRace = do
        -- get track id
        tid <- T.track_id <$> asks track
        -- get track sections
        ss <- T.sections <$> asks track
        -- generate section configuration for each section
        cs <- forM ss $ \s -> do
                q <- randomPerformance
                sectionConfig s q
        -- get maximum speed in each section and shift by one position, to get maximum speed in the next section for each section
        vs <- forM cs $ \s -> return $ runSectionM sectionSpeedCap s 
        -- run sections; each section affects the next, so a fold is implied.
        (rs, vf) <- foldM worker ([], initialSpeed) $ L.zip cs $ L.tail vs ++ [lightSpeed]
        -- generate race result
        return $ raceResult tid rs
            where
                worker :: ([SectionResult], Speed) -> (SectionConfig, Speed) -> RaceM ([SectionResult], Speed)
                worker (rs, vin) (c, vnext) = do
                    let r = runSectionM (doSection vin vnext) c
                    return (rs ++ [r], speed_exit r)

-- generate performance given a random seed
randomPerformance :: RaceM P.RaceSectionPerformance
randomPerformance = do

        d <- asks driver
        
        int <- performanceOne $ D.intelligence d
        acc <- performanceOne $ D.acceleration d
        brk <- performanceOne $ D.braking d
        con <- performanceOne $ D.control d
        rac <- performanceOne $ D.reactions d

        return $ P.RaceSectionPerformance {
                P.intelligence = int,
                P.acceleration = acc,
                P.braking = brk,
                P.control = con,
                P.reactions = rac
            }

performanceOne :: Double -> RaceM Double
performanceOne k = do
        -- TODO: use a distribution or formula that favours the area around k but is nonzero across [0-1>
--        r <- getRandomR (0, 1 :: Double)
--        return $ r * k
        -- simple algorithm: 50% chance result < k, 50% chance result > k; cosntant distribution in each case.
        let r = 1 - k
        a <- getRandomR (0, 1 :: Double)
        case a < 0.5 of
                True -> do
                        let b = a / 0.5
                        return $ b * k
                False -> do
                        let b = (a - 0.5) / 0.5
                        return $ k + b * (1 - k)

-- generate section configuration for a section
sectionConfig :: S.Section -> P.RaceSectionPerformance -> RaceM SectionConfig
sectionConfig s q = do

        k <- effAero q
        p <- effPower q
        b <- effBraking q
        t <- effTraction q 
        h <- effHandling q
        d <- effDownforce q
        m <- effMass q

        -- perturbed section: new radius and arclength due to path taken in the corner. depends on track width and a factor 0-1 from reactions and intelligence performance by driver.
        let s' = S.perturb ( (P.intelligence q) * (P.reactions q) ) s

        return $ SectionConfig {
                section = s',
                sectionPerformance = q,
                mass = m, 
                aero = k,
                power = p,
                downforce = d,
                handling = h,
                braking = b,
                traction = t,
                topSpeed = (p / k) ** (1/3 :: Double)
            }

                where

                    -- car mass. no performance effects.
                    effMass :: P.RaceSectionPerformance -> RaceM Double
                    effMass _ = C.mass <$> asks car 

                    -- aerodynamic constant due to air resistance and car aerodynamic quality. no performance effects.
                    effAero :: P.RaceSectionPerformance -> RaceM Double
                    effAero _ = do
                            c <- asks car
                            e <- asks environment
                            return $ 0.5 * (E.rho e) * (C.cda c)

                    -- traction due to tyre quality and weather effects. no performance effects.
                    effTraction :: P.RaceSectionPerformance -> RaceM Double
                    effTraction _ = do
                            t <- C.tco <$> asks car
                            e <- E.mtraction <$> asks environment
                            return $ t * e
                    
                    -- downforce due to aerodynamics. no performance effects.
                    effDownforce :: P.RaceSectionPerformance -> RaceM Double
                    effDownforce _ = C.dnf <$> asks car

                    -- handling multiplier for lateral acceleration limit due to traction, including downforce effects.
                    -- handling for car is multiplied by handling for driver control performance.
                    effHandling :: P.RaceSectionPerformance -> RaceM Double
                    effHandling q = do
                            h <- C.hlm <$> asks car
                            let f = 0.5 + 0.5 * (P.control q)
                            return $ f * h

                    -- car power available for acceleration.
                    -- driver acceleration performance applies a factor 0.5 - 1
                    effPower :: P.RaceSectionPerformance -> RaceM Double
                    effPower q = do
                            p <- C.pwr <$> asks car
                            let f = 0.5 + 0.5 * (P.acceleration q)
                            return $ f * p

                    -- braking is % of tyre traction available to slow down car. traction force is mu * m * g
                    -- driver braking performance applies a factor 0.5 - 1
                    effBraking :: P.RaceSectionPerformance -> RaceM Double
                    effBraking q = do
                            b <- C.brp <$> asks car
                            m <- C.mass <$> asks car
                            t <- effTraction q
                            let f = 0.5 + 0.5 * (P.braking q)
                            return $ f * b * t * m * (constant "g")


-- perform section calculations
doSection :: Speed -> Speed -> SectionM SectionResult
doSection vin' vnext' = do
        vcap' <- sectionSpeedCap 
        -- determine vin, the minimum of vin' and vcap, and note that it should be equal to vin, unless something went wrong in the last section.
        let vin = min vin' vcap'
        -- determine maximum achievable speed through acceleration across l
        sl <- S.arclength <$> asks section
        va <- (min vcap') <$> achievableSpeed vin sl 
        -- cap target output speed with local speed cap
        let vnext = min vnext' va
        when (vin > va) $ error "doSection: achievable speed lower than initial speed"
        -- determine braking distance from achievable speed to target exit speed
        bl <- brakingDistance va vnext
        -- if distance > length, do not accelerate at all
        -- reserve braking distance and calculate new achievable speed. note that, since this speed is lower than the previous one, the required braking distance will also be smaller.
        vaa <- case bl >= sl of
                True -> return vin
                False -> (min vcap') <$> achievableSpeed vin (sl - bl)
        let vtgt = min vnext vaa
        -- get new braking distance
        -- NOTE: if braking distance is greater than section length, extra length is "created" to allow the car to slow down for the next section. This is a temporary solution.
        -- TODO: each section projects a speed cap onto all previous sections according to the speed reduction possible in the cumulative length leading up to it.
        bla <- brakingDistance vaa vtgt
        -- get acceleration distance
        ala <- accelerationDistance vin vaa
        -- get constant distance
        let cla = max 0 $ sl - ala - bla
        -- get acceleration time
        ata <- accelerationTime vin vaa 
        -- get braking time
        bta <- brakingTime vaa vtgt 
        -- get constant time
        let cta = cla / vaa

        -- get total time
        let tta = ata + bta + cta
        -- get total length
        let tla = ala + bla + cla

        sid <- S.section_id <$> asks section
        p <- asks sectionPerformance
        sr <- S.radius <$> asks section

        con <- ask

        return $ SectionResult {
                section_id = sid,
                performance = p,
                effective_radius = sr,
                effective_arclength = sl,
                length_acceleration_phase = ala,
                length_braking_phase = bla,
                length_constant_phase = cla,
                length_section = tla,
                time_acceleration_phase = ata,
                time_braking_phase = bta,
                time_constant_phase = cta,
                time_section = tta,
                speed_entry = vin,
                speed_exit = vtgt, 
                speed_cap = vcap',
                speed_top = vaa,
                speed_avg = sl / tta
            } 

-- TODO: correct for traction for low initial speeds
achievableSpeed :: Speed -> Length -> SectionM Speed 
achievableSpeed v0 l = do
        when (l < 0) $ error "achievableSpeed: section length is negative"
        m <- asks mass 
        k <- asks aero
        s <- asks topSpeed
        return $ ((v0 ** 3 - s ** 3) * (constant "e") ** (-( 3 * k * l) / m) + s ** 3) ** (1/3 :: Double)

-- TODO: correct for traction for low initial speeds
accelerationTime :: Speed -> Speed -> SectionM Time 
accelerationTime v0 v1 = do
        when (v0 > v1) $ error "accelerationTime: source is greater than target"
        s <- asks topSpeed
        m <- asks mass
        p <- asks power
        let x1 = sqrt(3) * s * (v0-v1) / (s * v0 + s * v1 + 2 * s**2 + 2)
        let x2 = (v1-s)**3 / (v0-s)**3 * (v0**3 - s**3) / (v1**3 - s**3) 
        return $ m * s**2 * (2 * sqrt(3) * atan(x1) - log(x2)) / (6 * p)

-- TODO: correct for traction for low initial speed
accelerationDistance :: Speed -> Speed -> SectionM Double
accelerationDistance v0 v1 = do
        when (v0 > v1) $ error "accelerationDistance: source is greater than target"
        s <- asks topSpeed
        m <- asks mass
        p <- asks power
        k <- asks aero
        return $ m * log( (s**3 - v0**3) / (s**3 - v1**3) ) / (3 * k)


-- TODO: include air resistance
brakingTime :: Speed -> Speed -> SectionM Double
brakingTime v0 v1 = do
        when (v1 > v0) $ error "brakingTime: target is greater than source"
        m <- asks mass
        b <- asks braking
        return $ (v0 - v1) * m / b

-- TODO: include air resistance
brakingDistance :: Speed -> Speed -> SectionM Double 
brakingDistance v0 v1 = do
        when (v1 > v0) $ error "brakingDistance: target is greater than source"
        m <- asks mass
        b <- asks braking
        return $ 0.5 * (v0 ** 2 - v1 ** 2) * m / b

lateralAcceleration :: SectionM Double
lateralAcceleration = do
        r <- (maybe 0 id) . S.radius <$> asks section
        h <- asks handling 
        mu <- asks traction
        df <- asks downforce
        m <- asks mass
        let g = constant "g"
        return $ h * mu * g / (1 - r * df / m) 

sectionSpeedCap :: SectionM Double
sectionSpeedCap = do
        r <- S.radius <$> asks section
        case r of
                Nothing -> return lightSpeed
                Just q -> do
                        a <- lateralAcceleration
                        return $ sqrt (q * a)








{-
 -
 - Testing
 -
 -}



-- test the structure's components
testM :: RaceM Double 
testM = do
        r <- getRandomR (0,1 :: Double)
        when (r < 0.5) $ throwError $ "lalala too small: " ++ (show r)
        d <- ask
        return r

-- run a test 
doTestM :: IO ()
doTestM = do
        g <- newStdGen
        let r = runRaceM testM g undefined
        case r of
                Left e -> putStrLn $ "error: " ++ e
                Right res -> putStrLn $ "result: " ++ (show res)
        return ()

sho :: Show a => t -> String -> (t -> a) -> IO ()
sho s n f = putStrLn (n ++ ": " ++ (show $ f s))

writeRC :: RaceConfig -> IO ()
writeRC rc = do
        sho rc "driver" driver
        sho rc "car" car
        sho rc "env" environment
        sho (track rc) "track id" T.track_id
        putStrLn "sections:"
        forM_ (T.sections $ track rc) $ \s -> do
                putStrLn ""
                sho s "arclength" S.arclength
                sho s "radius" S.radius
        return ()

writeRR :: RaceResult -> IO ()
writeRR rr = do
        sho rr "track id" track_id
        sho rr "total time" race_time
        sho rr "top speed" race_speed_top
        sho rr "average speed" race_speed_avg
        sho rr "final speed" race_speed_finish
        putStrLn "sections:"
        forM_ (sections rr) $ \sr -> do
                putStrLn ""
                writeSR sr

writeSR :: SectionResult -> IO ()
writeSR sr = do
        sho sr "performance" performance
        sho sr "effective radius" effective_radius
        sho sr "effective arclength" effective_arclength
        sho sr "length accelerating" length_acceleration_phase
        sho sr "length braking" length_braking_phase
        sho sr "length constant" length_constant_phase
        sho sr "length total" length_section
        sho sr "time accelerating" time_acceleration_phase
        sho sr "time braking" time_braking_phase
        sho sr "time constant" time_constant_phase
        sho sr "time total" time_section
        sho sr "speed entry" speed_entry
        sho sr "speed exit" speed_exit
        sho sr "speed top" speed_top
        sho sr "speed avg" speed_avg
        sho sr "speed cap" speed_cap
        return ()

-- account id Pancho: 70
-- car instance id Pancho's Acura: 342

p :: IO ()
p = loadAndTest 70 342 12

loadCar :: Integer -> SqlTransaction Connection C.Car
loadCar cid = C.carInGarageCar <$> aload cid (rollback $ "cannot find car for id " ++ show cid)

loadDriver :: Integer -> SqlTransaction Connection D.Driver
loadDriver aid = D.accountDriver <$> aload aid (rollback $ "cannot find account for id " ++ show aid)

loadTrack :: Integer -> SqlTransaction Connection T.Track
loadTrack tid = T.trackDetailsTrack <$> agetlist ["track_id" |== toSql tid] [] 1000 0 (rollback $ "cannot find track data for id " ++ show tid)

loadAndTest :: Integer -> Integer -> Integer -> IO ()
loadAndTest aid cid tid = do

        (d, c, t) <- doSql $ do
                d <- loadDriver aid
                c <- loadCar cid
                t <- loadTrack tid 
                return (d, c, t)

        testRace d c t

testRace :: D.Driver -> C.Car -> T.Track -> IO ()
testRace d c t = do
        let rc = RaceConfig c d E.defaultEnvironment t
        g <- newStdGen

        putStrLn "--- [[ CONFIG ]]"
        writeRC rc

        putStrLn ""
        case race rc g of
                Right rr -> do
                        putStrLn "--- [[ RESULT ]]"
                        writeRR rr
                Left err -> print err

        return ()

testPerformance :: D.Driver -> IO ()
testPerformance d = do
        let rc = RaceConfig undefined d undefined undefined
        g <- newStdGen
        case runRaceM randomPerformance g rc of
                Right p -> print $ show p 
                Left err -> print err
        return ()

testPerturbation :: S.Section -> IO ()
testPerturbation s = do
        let xs = L.map (/10) [0..10] :: [Double]
        forM_ xs $ \x -> do
                let s' = S.perturb x s
                print $ L.concat [show x, " -> ", show s']
                return ()
        return ()




