{-# LANGUAGE ViewPatterns, TypeSynonymInstances, FlexibleInstances, OverloadedStrings, RankNTypes, Arrows, TemplateHaskell #-}
module Data.Tournament (
        joinTournament                   
    ) where 

import Model.TH
import Model.TournamentPlayers as TP
import Model.Tournament as T
import Model.General 
import Control.Arrow 
import Control.Category as C 
import Data.Convertible 
import Data.InRules 
import qualified Data.Aeson as AS
import Data.SqlTransaction
import Model.Account as A 
import Model.Transaction as TR  
import Model.CarInstance  
import Model.CarInGarage 
import Data.Maybe 
import Model.General 
import Control.Monad 
import Control.Applicative
import Data.Database
import Database.HDBC.SqlValue 
import qualified Data.List as L
import Test.QuickCheck as Q 
import Data.Chain 
import qualified Data.HashMap.Strict as S 
import qualified Model.Task as TK
import Data.DataPack 
import qualified Model.Race as R 
import qualified Model.TrackDetails as TD
import qualified Model.TrackMaster as TT
import qualified Model.Report as RP 
import qualified Model.RaceReward as RWD
import           Data.Racing
import qualified Data.Task as Task
import           Data.Track
import           Data.Environment
import           Model.General
import           Prelude hiding ((.),id)
import           Data.Conversion 
import           Data.Convertible 

data TournamentTask = RunTournament
            deriving (Eq, Show)


instance AS.FromJSON TournamentTask where 
        parseJSON = undefined   


joinTournament :: Integer -> Integer -> SqlTransaction Connection () 
joinTournament n acid = do 
                trn <- load n :: SqlTransaction Connection (Maybe Tournament)
                ac <- fromJust <$> load acid
                
            
                when (isNothing trn) $ rollback "no such tournament"
                
                checkPrequisites ac (fromJust $ trn)
                addClownToTournament ac (fromJust $ trn)

                return () 

addClownToTournament :: Account -> Tournament -> SqlTransaction Connection ()
addClownToTournament a t = do 
                        transactionMoney (fromJust $ A.id a) (def {
                                    amount = -(T.costs t),
                                    type_id = 10,
                                    TR.type = "tournament_cost" 
                                })
                              
                        save (def {
                            TP.account_id = A.id a, 
                            TP.tournament_id = T.id t 
                                    } :: TP.TournamentPlayer )
                        return ()
-- | check car, enough money, time prequisites
checkPrequisites :: Account -> Tournament -> SqlTransaction Connection () 
checkPrequisites a (Tournament id cid st cs mnl mxl rw tid ) = do 
        when (isJust cid) $ do 
                    xs <- search ["car_id" |== (toSql $ cid) .&& "account_id" |== (toSql $ A.id a)] [] 1 0 :: SqlTransaction Connection [CarInGarage]
                    when (null xs) $ rollback "doesn't own correct car"
        when ( A.money a < cs ) $ rollback "you do not have enough money" 
        when (A.level a > mxl) $ rollback "your level is too high"
        when (A.level a < mnl) $ rollback "your level is not high enough"


                           




-- divideClowns :: Tournament -> SqlTransaction Connection [(TP.TournamentPlayer, TP.TournamentPlayer)]
divideClowns t = do 
                xs <- search ["tournament_id" |== (toSql $ T.id t)] [] 10000 0 :: SqlTransaction Connection [TP.TournamentPlayer]
                return (divd xs) 




-- 2 | 3 solutions 
--
--

twothree :: [a] -> [[a]]
twothree [] = [] 
twothree [x] = [[x]]
twothree [x,y] = [[x,y]]
twothree [x,y,z] = [[x,y,z]]
twothree (x:y:xs) = [x,y] : twothree xs 

-- | Problem: I have to divide a group fairly into groups of 2,3,5,7 etc, with fair 
-- dirty solution, calc mod of list length at 2,3,5,7 etc 
-- more dirty, just search solution from list [1..100] 
divd :: [a] -> [[a]]
divd xs@(length -> l) = dvd (fromJust prs) xs 
        where prs = L.find (\x -> l `mod` x == 0 || (l - (l `div` 2)) `mod` x == 0) [2..(l - 1)]


dvd :: Int -> [a] -> [[a]] 
dvd n [] = []
dvd n [x,y] = [[x,y]]
dvd n [x,y,z] = [[x,y,z]]
dvd n xs = take n xs : dvd n (drop n xs)


testlnotone = property test
    where test :: [()] -> Bool
          test [] = True 
          test [x] = True 
          test xs = minimum (fmap length $ divd xs) > 1

testpnotone = property test 
    where test :: [()] -> Bool 
          test [] = True 
          test [x] = True 
          test xs = minimum (fmap length $ twothree xs) > 1


processTournamentRace :: Integer -> [RaceParticipant] -> Integer -> SqlTransaction Connection (Integer, [(RaceParticipant, RaceResult)]) 

processTournamentRace t ps tid = do

        let env = defaultEnvironment
        trk <- trackDetailsTrack <$> (agetlist ["track_id" |== toSql tid] [] 1000 0 (rollback "track data not found") :: SqlTransaction Connection [TD.TrackDetails])
        tdt <- aget ["track_id" |== toSql tid] (rollback "track not found") :: SqlTransaction Connection TT.TrackMaster
 
          -- race participants
        let rs = L.sortBy (\(_,a) (_,b) -> compare (raceTime a) (raceTime b)) $ map (\p -> (p, runRaceWithParticipant p trk env)) ps

        -- current time, finishing times, race time (slowest finishing time) 
--        t <- liftIO (floor <$> getPOSIXTime :: IO Integer)
        let fin r = (t+) $ ceiling $ raceTime r  
        let te = (\(_,r) -> fin r) $ last rs

        -- save race data
        rid <- save $ (def :: R.Race) {
                    R.track_id = tid,
                    R.start_time = t,
                    R.end_time = te,
                    R.type = 1,
                    R.data = map (\(p,r) -> raceData p r) rs 
                }

        let winner_id = rp_account_id $ fst $ head rs

        parN $ flip map rs $ \(p,r) -> do
            
                let uid = rp_account_id p
                let ft = fin r
                let isWinner = uid == winner_id

                -- set account busy until user finish
--                a  <- aload (rp_account_id p) (rollback $ "account not found for id " ++ (show $ rp_account_id p)) :: SqlTransaction Connection A.Account
--                save (a { A.busy_type = 2, A.busy_subject_id = rid, A.busy_until = fin r })
                update "account" ["id" |== toSql uid] [] [("busy_until", toSql ft), ("busy_subject_id", toSql rid), ("busy_type", SqlInteger 2)]

                -- task: update race time on user finish
                Task.trackTime ft tid uid (raceTime r)


                -- store user race report -- TODO: determine relevant information
                RP.report RP.Race uid ft $ mkData $ do
                    set "track_id" tid
                    set "race_id" rid
                    set "start_time" t
                    set "finish_time" ft
                    set "race_time" $ raceTime r
                    set "track_data" tdt
                    set "participant" p
                    set "result" r

        -- return race id
        return (rid, rs)


runTournament :: TK.Task -> SqlTransaction Connection ()
runTournament tk = undefined  

instance Execute One where 
        executeTask f d | "action" .< (TK.data d) == Just RunTournament  = runTournament d *> return True  
                        | otherwise = executeTask (plus f) d 


type Races = [R.Race]
$(genMapableRecord "RoundResult" [
                ("players_result", ''Races) 
                ])
type RoundResults = S.HashMap Int [RoundResult]

type TournamentPlayers = [TournamentPlayer] 

$(genMapableRecord "TournamentFullData" [
            ("tournament",  ''Tournament),
            ("roundresult", ''RoundResults),
            ("tournamentPlayers", ''TournamentPlayers)
        ])
{--
data TournamentFullData = TFD {
        tournament :: Tournament,
        roundResult :: S.HashMap Int [RoundResult],
        tournamentPlayers :: [TournamentPlayer]
        }
--}
loadTournamentFull :: Integer -> SqlTransaction Connection TournamentFullData
loadTournamentFull n = TournamentFullData <$> loadTournament n <*> loadResults n <*> loadPlayers n 

loadTournament :: Integer -> SqlTransaction Connection Tournament 
loadTournament = load >=> \x -> when (isNothing x) (rollback "no such tournament") >> return (fromJust x)

loadResults :: Integer -> SqlTransaction Connection (S.HashMap Int [RoundResult])
loadResults n = undefined  

loadPlayers :: Integer -> SqlTransaction Connection [TournamentPlayer] 
loadPlayers = undefined 

newtype CartesianMap a b = CM {
        runCM :: [a -> b] 
    }

instance Functor (CartesianMap a) where 
        fmap f = CM . fmap (f.) . runCM 


instance Category CartesianMap where 
        id = CM [C.id]
        (.) (CM ff) (CM gs) = CM $ [ f.g | f <- ff, g <- gs] 

instance Arrow CartesianMap where 
        arr f = CM [f]
        first (CM fs) = CM [first f | f <- fs]
        second (CM fs) = CM [second f | f <- fs]


instance ArrowChoice CartesianMap where 
        left (CM fs) = CM [left f | f <- fs]
        right (CM fs) = CM [right f | f <- fs] 

instance ArrowZero CartesianMap where 
        zeroArrow = CM []


instance ArrowLoop CartesianMap where 
        loop (CM fs) = CM $ [loop f | f <- fs]

instance ArrowPlus CartesianMap where 
        (<+>) (CM a) (CM b) = CM (a ++ b)

arrM :: [a -> b] -> CartesianMap a b  
arrM xs = CM xs 

test :: CartesianMap Double (Maybe Double)
test = proc x -> do 
                y <- arrM [(*3),(*4),(*2)] -< x
                z <- arrM [(/2), (/3), (/4)] -< y 
                if z < 1 then returnA -< Nothing 
                         else returnA -< (Just z)


runCartesianMap :: CartesianMap a b -> a -> [b]
runCartesianMap (CM xs) f = fmap ( $ f ) xs
