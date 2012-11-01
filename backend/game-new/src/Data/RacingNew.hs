{-# LANGUAGE TemplateHaskell, FlexibleContexts, FlexibleInstances, TypeSynonymInstances, FunctionalDependencies, MultiParamTypeClasses, OverloadedStrings, RankNTypes #-}


module Data.RacingNew (
        RaceResult (..),
        SectionResult (..),
        RaceConfig (..),
        SectionConfig (..),
        RaceData (..),
        RaceDataList,
        RaceM,
        SectionM,
        sectionConfig,
        runSectionM,
        runRaceM,
        raceWithParticipant,
        runRaceWithParticipant,
        race,

        raceData,
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
import qualified Model.AccountProfileMin as APM
import qualified Model.CarInGarage as CIG
import qualified Model.CarMinimal as CMI

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

type SectionM a = ErrorT String (Reader SectionConfig) a

runSectionM :: SectionM a -> SectionConfig -> Either String a
runSectionM m = runReader (runErrorT m)

type MDouble = Maybe Double

$(genMapableRecord "SectionResult" [

        -- section data
        ("sectionId", ''Integer),
       
        -- performance data
        ("performance", ''P.RaceSectionPerformance),
        
        -- effective path: original section modified by intelligence performance
        ("effectiveRadius", ''MDouble),
        ("effectiveArclength", ''Double),
        
        -- distance in section phases
        ("lengthAccelerationPhase", ''Double),
        ("lengthBrakingPhase", ''Double),
        ("lengthConstantPhase", ''Double),
        ("sectionLength", ''Double),

        -- time spent in section phases
        ("timeAccelerationPhase", ''Double),
        ("timeBrakingPhase", ''Double),
        ("timeConstantPhase", ''Double),
        ("sectionTime", ''Double),

        -- speed data
        ("sectionSpeedIn", ''Double),
        ("sectionSpeedOut", ''Double),
        ("sectionSpeedCap", ''Double),
        ("sectionSpeedMax", ''Double),
        ("sectionSpeedAvg", ''Double)
    ])

type SectionResultList = [SectionResult]

$(genMapableRecord "RaceResult" [
        ("trackId", ''Integer),
        ("raceTime", ''Double),
        ("raceSpeedTop", ''Double),
        ("raceSpeedFin", ''Double),
        ("raceSpeedAvg", ''Double),
        ("sectionResults", ''SectionResultList)
   ])

instance Ord RaceResult where 
        compare (raceTime -> x) (raceTime -> y) = compare x y 

type RaceResultList = [RaceResult] 

raceResult :: Integer -> SectionResultList -> RaceResult
raceResult tid [] = RaceResult tid 0 0 0 0 []
raceResult tid rs = RaceResult tid tme spk sfn sag rs
        where
            mrs f = L.map f rs
            tme = L.sum $ mrs sectionTime
            spk = L.maximum $ mrs sectionSpeedMax
            sag = (L.sum $ mrs effectiveArclength) / tme 
            sfn = sectionSpeedOut $ L.last rs

$(genMapableRecord "RaceData" [
            ("rd_user", ''APM.AccountProfileMin),
            ("rd_car", ''CMI.CarMinimal),
            ("rd_result", ''RaceResult)
       ])



type RaceDataList = [RaceData]

-- generate race configuration from a given RaceParticipant, a Track and a random seed
raceConfigWithParticipant :: RP.RaceParticipant -> T.Track -> RaceConfig
raceConfigWithParticipant p t = RaceConfig {
        driver = D.accountDriver $ RP.rp_account p,
        car = C.carInGarageCar $ RP.rp_car p,
        environment = E.defaultEnvironment,
        track = t
    }

-- run race with config
race :: (RandomGen g) => RaceConfig -> g -> Either String RaceResult
race rc g = runRaceM doRace g rc

-- run race with participant and track
raceWithParticipant :: (RandomGen g) => RP.RaceParticipant -> T.Track -> g -> Either String RaceResult
raceWithParticipant p t g = race (raceConfigWithParticipant p t) g


{-
 - Compatibility
 -}


raceData :: RP.RaceParticipant -> RaceResult -> RaceData
raceData p r = RaceData {
                rd_user = RP.rp_account_min p,
                rd_car = RP.rp_car_min p,
                rd_result = r
            }

runRaceWithParticipant :: RP.RaceParticipant -> T.Track -> E.Environment -> RaceResult 
runRaceWithParticipant p t e = case raceWithParticipant p t (mkStdGen 0) of
        Left err -> undefined
        Right res -> raceResult2FE res

-- convert to front-end units (km/h instead of m/s)
raceResult2FE :: RaceResult -> RaceResult
raceResult2FE r = r {
        raceSpeedTop = ms2kmh $ raceSpeedTop r,
        raceSpeedFin = ms2kmh $ raceSpeedFin r,
        raceSpeedAvg = ms2kmh $ raceSpeedAvg r
    }

sectionResult2FE :: SectionResult -> SectionResult
sectionResult2FE r = r {
       sectionSpeedIn = ms2kmh $ sectionSpeedIn r, 
       sectionSpeedOut = ms2kmh $ sectionSpeedOut r, 
       sectionSpeedCap = ms2kmh $ sectionSpeedCap r, 
       sectionSpeedMax = ms2kmh $ sectionSpeedMax r, 
       sectionSpeedAvg= ms2kmh $ sectionSpeedAvg r
    } 

{-
 - Execution
 -}


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
        vs <- forM cs $ \s -> do
                case runSectionM speedCap s of
                        Left e -> throwError e
                        Right r -> return r
        -- run sections; each section affects the next, so a fold is implied.
        (rs, vf) <- foldM worker ([], initialSpeed) $ L.zip cs $ L.tail vs ++ [lightSpeed]
        -- generate race result
        return $ raceResult tid rs
            where
                worker :: ([SectionResult], Speed) -> (SectionConfig, Speed) -> RaceM ([SectionResult], Speed)
                worker (rs, vin) (c, vnext) = do
                    case runSectionM (doSection vin vnext) c of
                            Left e -> throwError e
                            Right r -> return (rs ++ [r], sectionSpeedOut r)

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
                              -- TODO: reducing power also reduces top speed. use a different algorithm.
--                            let f = 0.5 + 0.5 * (P.acceleration q)
--                            return $ f * p
                            return p

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

        i <- S.section_id <$> asks section

        -- ensure sanity
        when (isNaN vin') $ throwError "doSection: vin is not a number"
        when (isNaN vnext') $ throwError $ "doSection: vnext is not a number in section " ++ (show i)

        -- get speed cap for this section
        vcap' <- speedCap 

        -- ensure sanity
        when (isNaN vcap') $ throwError "doSection: vcap is not a number"

        -- determine vin, the minimum of vin' and vcap, and note that it should be equal to vin, unless something went wrong in the last section.
        let vin = min vin' vcap'
        -- determine maximum achievable speed through acceleration across l
        sl <- S.arclength <$> asks section
        
        va' <- achievableSpeed vin sl 
        when (vin > va') $ throwError $ L.concat ["doSection: achievable speed lower than initial speed (vin = ", show vin, ", l = ", show sl, ", va' = ", show va',  ")"]

        let va = min vcap' va'

        -- ensure sanity
        when (isNaN va) $ throwError "doSection: va is not a number"

        -- cap target output speed with local speed cap
        let vnext = min vnext' va

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
                sectionId = sid,
                performance = p,
                effectiveRadius = sr,
                effectiveArclength = sl,
                lengthAccelerationPhase = ala,
                lengthBrakingPhase = bla,
                lengthConstantPhase = cla,
                sectionLength = tla,
                timeAccelerationPhase = ata,
                timeBrakingPhase = bta,
                timeConstantPhase = cta,
                sectionTime = tta,
                sectionSpeedIn = vin,
                sectionSpeedOut = vtgt, 
                sectionSpeedCap = vcap',
                sectionSpeedMax = vaa,
                sectionSpeedAvg = sl / tta
            } 

-- TODO: correct for traction for low initial speeds
achievableSpeed :: Speed -> Length -> SectionM Speed 
achievableSpeed v0 l = do
        when (l < 0) $ throwError "achievableSpeed: section length is negative"
        m <- asks mass 
        k <- asks aero
        s <- asks topSpeed
        let res = ((v0 ** 3 - s ** 3) * (constant "e") ** (-( 3 * k * l) / m) + s ** 3) ** (1/3 :: Double)
        when (v0 > res) $ throwError $ L.concat ["achievableSpeed: result is smaller than initial speed (vin = ", show v0, ", top speed = ", show s, ")"]
        return res 

-- TODO: correct for traction for low initial speeds
accelerationTime :: Speed -> Speed -> SectionM Time 
accelerationTime v0 v1 = do
        when (v0 > v1) $ throwError "accelerationTime: source is greater than target"
        s <- asks topSpeed
        m <- asks mass
        p <- asks power
        let x1 = sqrt(3) * s * (v0-v1) / (s * v0 + s * v1 + 2 * s**2 + 2)
        let x2 = (v1-s)**3 / (v0-s)**3 * (v0**3 - s**3) / (v1**3 - s**3) 
        return $ m * s**2 * (2 * sqrt(3) * atan(x1) - log(x2)) / (6 * p)

-- TODO: correct for traction for low initial speed
accelerationDistance :: Speed -> Speed -> SectionM Double
accelerationDistance v0 v1 = do
        when (v0 > v1) $ throwError "accelerationDistance: source is greater than target"
        s <- asks topSpeed
        m <- asks mass
        p <- asks power
        k <- asks aero
        return $ m * log( (s**3 - v0**3) / (s**3 - v1**3) ) / (3 * k)


-- TODO: include air resistance
brakingTime :: Speed -> Speed -> SectionM Double
brakingTime v0 v1 = do
        when (v1 > v0) $ throwError "brakingTime: target is greater than source"
        m <- asks mass
        b <- asks braking
        return $ (v0 - v1) * m / b

-- TODO: include air resistance
brakingDistance :: Speed -> Speed -> SectionM Double 
brakingDistance v0 v1 = do
        when (v1 > v0) $ throwError "brakingDistance: target is greater than source"
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
        when (h < 0) $ throwError $ L.concat ["lateralAcceleration: negative handling (", show h, ")"]
        when (mu < 0) $ throwError $ L.concat ["lateralAcceleration: negative traction (", show mu, ")"]
        -- TODO: downforce caculation is broken. Set downforce effect to zero for now.
        let df = 0
        when ((1 - r * df / m) < 0) $ throwError $ L.concat ["lateralAcceleration: downforce out of bounds (df = ", show df, ", r = ", show r, ", m = ", show m, ")"]
        let g = constant "g"
        return $ h * mu * g / (1 - r * df / m) 

speedCap :: SectionM Double
speedCap = do
        i <- S.section_id <$> asks section
        r <- S.radius <$> asks section
        case r of
                Nothing -> return lightSpeed
                Just q -> do
                        a <- lateralAcceleration
                        when (a < 0) $ throwError $ "speedCap: encountered negative lateral acceleration limit on section " ++ (show i)
                        when (q < 0) $ throwError $ "speedCap: encountered negative section radius on section " ++ (show i)
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
                sho s "section id" S.section_id
                sho s "arclength" S.arclength
                sho s "radius" S.radius
        return ()

writeRR :: RaceResult -> IO ()
writeRR rr = do
        putStrLn "sections:"
        forM_ (sectionResults rr) $ \sr -> do
                putStrLn ""
                writeSR sr

        putStrLn ""
        putStrLn "final:"
        sho rr "track id" trackId
        sho rr "total time" raceTime
        sho rr "top speed" raceSpeedTop
        sho rr "average speed" raceSpeedAvg
        sho rr "final speed" raceSpeedFin
 
writeSR :: SectionResult -> IO ()
writeSR sr = do
        sho sr "performance" performance
        sho sr "effective radius" effectiveRadius
        sho sr "effective arclength" effectiveArclength
        sho sr "length accelerating" lengthAccelerationPhase
        sho sr "length braking" lengthBrakingPhase
        sho sr "length constant" lengthConstantPhase
        sho sr "length total" sectionLength
        sho sr "time accelerating" timeAccelerationPhase
        sho sr "time braking" timeBrakingPhase
        sho sr "time constant" timeConstantPhase
        sho sr "time total" sectionTime
        sho sr "speed entry" sectionSpeedIn
        sho sr "speed exit" sectionSpeedOut
        sho sr "speed top" sectionSpeedMax
        sho sr "speed avg" sectionSpeedAvg
        sho sr "speed cap" sectionSpeedCap
        return ()

-- account id Pancho: 70
-- car instance id Pancho's Acura: 342

p :: IO ()
p = loadAndTest 70 342 12

b :: IO ()
b = loadAndTest 36 321 4 

a :: IO ()
a = loadAndTest 33 356 1

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




