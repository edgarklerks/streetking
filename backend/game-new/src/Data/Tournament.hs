{-# LANGUAGE ViewPatterns, TypeSynonymInstances, FlexibleInstances, OverloadedStrings, RankNTypes, Arrows, TemplateHaskell , NoMonomorphismRestriction, DeriveGeneric, OverloadedStrings, TupleSections  #-}
module Data.Tournament (
        createTournament,
        joinTournament,
        Tournament,
        runTournament,
        initTournament,
        getResults,
        getPlayers,
        processTournamentRace,
        runTournamentRounds, 
        loadTournamentFull,
        testTournament
        
    ) where 
{-- Change log:
- 17-11-2012 
- Edgar - added immutable flag set to addClownToTournament for car_instance 
- Edgar - added immutable flag unset to getResults for car_instance  
- Edgar - added bots to the tournament. This is a little bit shaky, because
- a function return the raceparticipant and mutates the database.
-
-
- --}
import Control.Monad.Trans 
import Model.TH
import Model.TournamentPlayers as TP
import Model.Tournament as T
import Model.General 
import Control.Arrow 
import           Data.Time.Clock 
import           Data.Time.Clock.POSIX
import Control.Category as C 
import Data.Convertible 
import Data.InRules 
import Data.List 
import qualified Data.Aeson as AS
import qualified Data.Aeson.Parser as ASP 
import Data.SqlTransaction
import Model.Transaction as TR  
import Model.CarInstance  
import Model.Functions 
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
import Debug.Trace 
import GHC.Exts 
import qualified Model.Account as A 
import qualified Model.AccountProfileMin as AM 
import qualified Model.CarInGarage as GC 
import qualified Model.CarMinimal as CM 
import qualified Model.Race as R 
import qualified Model.TrackDetails as TD
import qualified Model.TrackMaster as TT
import qualified Model.Report as RP 
import qualified Model.RaceReward as RWD
--import           Data.Racing
import           Data.RacingNew
import           Data.RaceParticipant
import           Data.RaceReward
import qualified Data.Task as Task
import           Data.Event 
import           Data.Track
import           Data.Environment
import           Model.General
import           Prelude hiding ((.),id)
import           Data.Conversion 
import           Data.Convertible 
import qualified Model.TournamentResult as TR
import qualified Model.TournamentPlayers as TP 
import           GHC.Generics 
import           Data.Text (Text) 
import           Test.QuickCheck 
import           System.Random 
import           Data.Monoid 
import qualified Notifications as N 
import qualified Model.TournamentReport as TRP 
import qualified Model.EventStream as ES 
import           Control.Concurrent 
import           Data.Tools
import           Data.SqlTransaction

data TournamentTask = RunTournament
            deriving (Eq, Show, Generic, Read)


instance AS.ToJSON TournamentTask where 
    toJSON a = AS.toJSON $ S.fromList [("RunTournament" :: Text, True)]

instance AS.FromJSON TournamentTask where 
    parseJSON (AS.Object xs) = case S.lookup  "RunTournament" xs of 
                                            Nothing -> mzero 
                                            Just a -> return RunTournament
    parseJSON _ = mzero 

-- number of players return total slots
numberOfPlayers :: Integer -> SqlTransaction Connection (Integer, Integer)
numberOfPlayers sid = do 
                trn <- aload sid (rollback "can't find tournament") :: SqlTransaction Connection Tournament 
                let total_sloth = T.players trn :: Integer 
                xs <- search ["deleted" |== (toSql False) .&& "tournament_id" |== toSql sid] [] 10000 0 :: SqlTransaction Connection [TournamentPlayer]

                return (fromIntegral $ length xs, total_sloth)


joinTournament :: Integer -> Integer -> Integer -> SqlTransaction Connection () 
joinTournament cinst n acid = do 
                trn <- load n :: SqlTransaction Connection (Maybe Tournament)
                ac <- fromJust <$> load acid
                
            
                when (isNothing trn) $ rollback "no such tournament"
                
                lock "tournament_players" RowShare $ do  

                    checkPrequisites ac (fromJust $ trn) cinst 
                    addClownToTournament ac (fromJust $ trn) cinst 
                    


                return () 
    where 
            addClownToTournament :: A.Account -> Tournament -> Integer -> SqlTransaction Connection ()
            addClownToTournament a t cinst = do 
                        transactionMoney (fromJust $ A.id a) (def {
                                    amount = -(T.costs t),
                                    type_id = 10,
                                    TR.type = "tournament_cost" 
                                })
                              
                        save (def {
                            TP.car_instance_id = Just cinst,
                            TP.account_id = A.id a, 
                            TP.tournament_id = T.id t 
                                    } :: TP.TournamentPlayer )
                        setImmutable cinst 
                        return ()

-- | check car, enough money, time prequisites
checkPrequisites :: A.Account -> Tournament -> Integer -> SqlTransaction Connection () 
checkPrequisites a (T.Tournament id cid st cs mnl mxl rw tid plys nm dn rn im) cinst = do 
        (n,t) <- numberOfPlayers (fromJust id)
        when dn $ rollback "this tournament is already done" 
        when rn $ rollback "tournament is already running"
        when (n >= t) $ rollback "cannot join tournament anymore: too much players"
        when (isJust cid) $ do 
                    xs <- search ["car_id" |== (toSql $ cid) .&& "id" |== (toSql cinst) .&& "account_id" |== (toSql $ A.id a)] [] 1 0 :: SqlTransaction Connection [CarInGarage]
                    when (null xs) $ rollback "doesn't own correct car"
        when ( A.money a < cs ) $ rollback "you do not have enough money" 
        when (A.level a > mxl) $ rollback "your level is too high"
        when (A.level a < mnl) $ rollback "your level is not high enough"
        xs <- search ["tournament_id" |== (toSql $ id ) .&& "account_id" |== (toSql $ A.id a) .&& "deleted" |== (toSql False)] [] 1 0 :: SqlTransaction Connection [TournamentPlayer] 
        when (not . null $ xs) $ rollback "you are already in the tournament" 


type Races = [R.Race]
$(genMapableRecord "RoundResult" [
                ("players_result", ''Races) 
                ])
type RoundResults = S.HashMap Int [RoundResult]

type TournamentPlayers = [TournamentPlayer] 

$(genMapableRecord "TournamentFullData" [
            ("tournament",  ''Tournament),
            ("tournamentPlayers", ''TournamentPlayers)
        ])
                          

milliTime :: IO Integer
milliTime = floor <$> (*1000) <$> getPOSIXTime :: IO Integer


sameLength :: [a] -> [b] -> Bool 
sameLength (_:xs) (_:ys) = sameLength xs ys
sameLength [] [] = True 
sameLength _ _ = False 

test_samelength_prop = property testSamelength 
    where   testSamelength :: [Int] -> [Char] -> Bool 
            testSamelength xs ys = (length xs == length ys) == (sameLength xs ys) && 
                            (sameLength xs xs == sameLength ys ys)

getPlayers :: Integer -> SqlTransaction Connection [[(AM.AccountProfileMin,AM.AccountProfileMin, Id)]]
getPlayers mid = do 
            tr <- aload mid (rollback "cannot find tournament") :: SqlTransaction Connection T.Tournament 
            mt <- liftIO milliTime 
            rs <- search ["tournament_id" |== (toSql mid)] [] 1000 0 :: SqlTransaction Connection [TR.TournamentResult]
            -- fugly waterfall structure 
            if (T.done tr) then returnAll rs 
                           else returnSince mt rs  

    where 
          
          step :: Integer -> TR.TournamentResult -> SqlTransaction Connection Bool 
          step mt (TR.TournamentResult _ tid rid _ _ _ _ _ _ _ ) = do 
                                                r <- aload (fromJust rid) (rollback "cannot find race") :: SqlTransaction Connection R.Race  
                                                return (R.start_time r < mt)

          returnAll = retrieveAccounts 
          returnStart = return []  
          returnSince mt rs = filterM (step mt) rs >>= retrieveAccounts 

          retrieveAccounts :: [TR.TournamentResult] -> SqlTransaction Connection [[(AM.AccountProfileMin, AM.AccountProfileMin, Id)]]
          retrieveAccounts  xs = forM (groupByRound xs) $ \rs -> do 
                                                    forM rs $ \r -> (,,) <$> aload (fromJust $ TR.participant1_id r) (rollback "fuckfuckfuck i hate this world") <*> aload (fromJust $ TR.participant2_id r) (rollback "lololi") <*> pure (TR.race_id r)  
                                                            
          groupByRound :: [TR.TournamentResult] -> [[TR.TournamentResult]]
          groupByRound = groupBy (\x y -> TR.round x == TR.round y)


getResults :: Integer -> SqlTransaction Connection [TR.TournamentResult] 
getResults mid = do
                tr <- aload mid (rollback "cannot find tournament") :: SqlTransaction Connection T.Tournament
                mt <- liftIO milliTime
                rs <- search ["tournament_id" |== (toSql mid)] [] 1000 0  :: SqlTransaction Connection [TR.TournamentResult] 
                if (T.done tr) then return rs 
                               else do 
                                ss <- filterM (step mt) rs 
                                when (ss `sameLength` rs) $ do 
                                                xs <- search ["tournament_id" |== toSql (T.id tr)] [] 1000 0 :: SqlTransaction Connection [TP.TournamentPlayer]
                                                forM_ xs $ setMutable . fromJust . TP.car_instance_id 
                                                toArchive (fromJust $ T.id tr) ss 
                                                save (tr { T.running = False, T.done = True}) 

                                                let winners = (\(x,y,z) -> x) <$> getWinners ss 
                                                forM_ ss $ \r -> do 
                                                           let car1 = TR.car1_id r 
                                                           let car2 = TR.car2_id r 
                                                           let account1 = TR.participant1_id r
                                                           let account2 = TR.participant2_id r 
                                                           -- create health
                                                           -- loss and wear
                                                           -- loss of car. 
                                                           return ()
                                                forM_ (winners `zip` [1..]) $ \(w,p) -> do 
                                                            cons $ "user: " <> (show w) <> " pos: " <> (show p) <> " tid:" <> (show mid)
                                                            ES.emitEvent w (Data.Event.Tournament p mid) 


                                return ss 
        where step :: Integer -> TR.TournamentResult -> SqlTransaction Connection Bool 
              step mt (TR.TournamentResult _ tid rid _ _ _ _ _ _ _) = do 
                                                r <- aload (fromJust rid) (rollback "cannot find race") :: SqlTransaction Connection R.Race  
                                                return (R.end_time r < mt)
                


toArchive :: Integer -> [TR.TournamentResult] -> SqlTransaction Connection ()
toArchive mid xs = do 
                tt <- liftIO $ milliTime
                tr <- load mid :: SqlTransaction Connection (Maybe T.Tournament)
                ss <- search ["tournament_id" |== (toSql mid)] [] 100000 0 :: SqlTransaction Connection [TP.TournamentPlayer]
                forM_ ss $ \(TP.account_id -> x) -> 
                    void $ save (def {
                            TRP.tournament_id  = mid,
                            TRP.tournament_result = xs,
                            TRP.tournament = tr,
                            TRP.account_id = fromJust $ x,
                            TRP.players = ss,
                            TRP.created = tt 
                        } :: TRP.TournamentReport)


divideClowns :: Tournament -> SqlTransaction Connection [[TP.TournamentPlayer]]
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


unsort :: [a] -> IO [a] 
unsort = foldM (\z x -> uninsert x z) []  
        where uninsert a [] = return [a]
              uninsert a ts@(x:xs) = do
                        s <- randomIO 
                        if s then return (a:ts)
                             else uninsert a xs >>= \xs -> return (x:xs)

fillRaceParticipant :: T.Tournament -> [RaceParticipant] -> SqlTransaction Connection [RaceParticipant]
fillRaceParticipant t@(fromInteger . T.players -> n) xs | length xs == n = do 
                                                                    cons "do not attach bots"          
                                                                    pure xs  
                                                        | otherwise = do
                                                              cons $ "tournament id:" <> (show (T.id t))
                                                              cons $ "adding: " <> show (n - length xs) <> " bots"
                                                              cs <- search ["prototype" |== toSql True .&& "prototype_available" |== toSql True] [] 1000 0 :: SqlTransaction Connection [CarInGarage]
                                                              as <- search ["bot" |== toSql True] [] 1000 0 :: SqlTransaction Connection [A.Account]
                                                              (xs<>) <$> replicateM (n - length xs) (createPlayers as cs)
                where createPlayers :: [A.Account] -> [CarInGarage] -> SqlTransaction Connection RaceParticipant 
                      createPlayers as cs = do 
                            cons "Creating player"
                            p <- liftIO $ randomPick as 
                            c <- liftIO $ randomPick cs 
                            cons (p,c)
                            am <- fromJust <$> load (fromJust $ A.id p) :: SqlTransaction Connection (AM.AccountProfileMin)
                            let cm = fromInRule $ toInRule c :: CM.CarMinimal
                            cons "Created player"

                            
                            
                            let bots = (def {
                                rp_account = p,
                                rp_account_min = am,
                                rp_car = c,
                                rp_car_min = cm 
                                        })
                            cons "Constructed bot:"
                            cons bots 

                            -- add players to tournament_players 

                            save (def {
                                    TP.car_instance_id = Model.CarInGarage.id c,
                                    TP.account_id = A.id p, 
                                    TP.tournament_id = T.id t,
                                    TP.deleted = False 
                                } :: TP.TournamentPlayer)
                            -- commit player to database
                            commit 
                            cons "Added player to tournament"
                            return bots 
 

-- runs all the tournament rounds  
runTournamentRounds :: t -> TournamentFullData -> SqlTransaction Connection [[(Integer, [(RaceParticipant, RaceResult)])]]  
runTournamentRounds po tfd = 
                          let tr = T.track_id . tournament $ tfd 
                              tid = T.id . tournament $ tfd
                              plys = tournamentPlayers tfd
                              rp (TournamentPlayer (Just id) (Just aid) (Just tid) (Just cid) _) =  mkRaceParticipant cid aid Nothing 
                              step tdif xs = do 
                                races <- forM xs $ \xs -> do
                                             cons "process races"
                                             processTournamentRace (tdif) xs tr <* cons "finished process"
                                let (ps', ts) = split3 races 
                                let ps = sortRounds ps'
                                let tmax = maximum ts  

                                if (one ps) 
                                        then return [races]
                                        else do rest <- step (tdif + tmax) (twothree ps) 
                                                return $ races : rest
                         in do 
                               forM_ plys $ \(TP.account_id -> pl) -> N.sendCentralNotification (fromJust $ pl) (
                                                                                        N.tournamentStart {
                                    N.tournament_id = fromJust $ tid 
                                                                                                })

                               flip catchSqlError error $ do 
                                   ys <- mapM rp plys >>= liftIO . unsort 
                                   rs <- fillRaceParticipant (tournament tfd) ys
                                   xs <- step 0 (twothree (rs))
                                    -- commit the transaction to database
                                    -- and start looping. 
                                   return $ fmap (fst . split3) $ xs 



one :: [a] -> Bool 
one [x] = True 
one _ = False 

split3 :: [(a,b,c)] -> ([(a,b)], [c])
split3  = foldr step ([], [])
    where step (a,b,c) (ls,rs) = ((a,b):ls,c:rs)

testEmitTournament = runTestDb $ ES.emitEvent 34 (Data.Event.Tournament 9 9)

cons a = return () 
                {--
    x <- unix_timestamp  
    liftIO $ print (x,a)
    --}
-- users: 36,34,33,71
testTournament = runTestDb $ do 
            b <- (*1000) <$> unix_timestamp 
            -- Created a tournament 
            cons "creating tournament"
            tid <- save (def {
                             start_time = Just b,
                             costs = 0,
                             minlevel = 0,
                             maxlevel = 10000,
                             rewards = Nothing,
                             T.track_id = 12,
                             players = 8,
                             T.name = "auto tournament xxx"
                    } :: T.Tournament)
            -- finding users with useful car 
            cons "searching cars"
            rs <- search ["active" |== (toSql True) .&& "ready" |== (toSql True)] [] 100 0 :: SqlTransaction Connection [CarInGarage]
            cons "joining tournament"
            forM_ (take 2 rs) $ \r -> do 
                            joinTournament (fromJust $ GC.id r) tid (GC.account_id r)
            -- loaded tournament 
            cons "loading tournament"
            tf <- loadTournamentFull tid 
            cons "saving tournament"
            save ((tournament tf) {running = True})
            cons "run tournament rounds"
            xs <- runTournamentRounds undefined tf
            cons xs
            saveResultTree tid xs 
            cons "saved tournament"
            {--
            whileM $ do 
                cons "Getting tournament"
                ps <- getResults tid
                rs <- search ["tournament_id" |== (toSql tid)] [] 1000 0  :: SqlTransaction Connection [TR.TournamentResult] 
                liftIO $ print (length ps, length rs) 
                liftIO $ threadDelay 10000
                return $ ps /= rs 
            --}

whileM :: Monad m => m Bool -> m ()
whileM m = do
        b <- m
        if b then whileM m
             else return ()






sortRounds :: [(Integer,[(RaceParticipant, RaceResult)])]  -> [RaceParticipant]
sortRounds [] = [] 
sortRounds ((rid,ys):xs) = (fst . head) (sortBy (\x y -> compare (snd x) (snd y)) ys) : sortRounds xs 




processTournamentRace :: Integer -> [RaceParticipant] -> Integer -> SqlTransaction Connection (Integer, [(RaceParticipant, RaceResult)], Integer) 
processTournamentRace t' ps tid = do

        let env = defaultEnvironment
        trk <- trackDetailsTrack <$> (agetlist ["track_id" |== toSql tid] [] 1000 0 (rollback "track data not found") :: SqlTransaction Connection [TD.TrackDetails])
        tdt <- aget ["track_id" |== toSql tid] (rollback "track not found") :: SqlTransaction Connection TT.TrackMaster
        rs' <- forM ps $ \p -> do
                g <- liftIO $ newStdGen
                case raceWithParticipant p trk g of
                        Left e -> rollback e
                        Right r -> return (p, r)
        let rs = L.sortBy (\(_, a) (_, b) -> compare (raceTime a) (raceTime b)) rs'

        -- current time, finishing times, race time (slowest finishing time) 

        t <- (+t') <$> liftIO milliTime
        ct <- liftIO milliTime 
            
        let fin r = (t+) $ ceiling $ (*1000) $ raceTime r  
        let te = fin . snd . last $ rs

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
        return (rid, rs,te - t)


tournamentTrigger :: Integer -> SqlTransaction Connection () 
tournamentTrigger i = do 
                x <- loadTournament i
                tid <- Task.task RunTournament (fromJust $ T.start_time x) $ mkData $ do 
                        set "id" $ (T.id x)

                void $ Task.trigger Task.Cron (fromJust $ T.id x) tid  
                
runTournament :: TK.Task -> t -> SqlTransaction Connection Bool
runTournament tk po = return False <* (do
                let id = "id" .<< (TK.data tk) ::  Integer
                tf <- loadTournamentFull id  
                xs <- runTournamentRounds po tf  
                save ( (tournament tf) { running = True })
                saveResultTree id xs)

saveResultTree :: Integer -> [[(Integer, [(RaceParticipant, RaceResult)])]] -> SqlTransaction Connection ()
saveResultTree tid xs = forM_ (xs `zip` [0..])  $ \(xs,r) -> forM_ xs (lmb r)

            where lmb r (i, sortBy (\x y -> compare (snd x) (snd y)) -> (x:y:_)) = do 
                                save (def {
                                    TR.tournament_id = Just tid,
                                    TR.race_id = Just i,
                                    TR.participant1_id = A.id $ rp_account $ fst x,
                                    TR.participant2_id = A.id $ rp_account $ fst y,
                                    TR.round = r,
                                    -- TR.raceresult1 = Nothing -- Just x,
                                    -- TR.raceresult2 = Nothing -- Just y
                                    TR.race_time1 = raceTime $ snd x,
                                    TR.race_time2 = raceTime $ snd y,
                                    TR.car1_id =  rp_car_id $ fst x ,
                                    TR.car2_id = rp_car_id $ fst y 


                                        } :: TR.TournamentResult)
                  lmb r xs =  return 0 

initTournament po = registerTask pred (executeTask po)
          where pred t | "action" .< (TK.data t) == Just RunTournament = True
                       | otherwise = False 
executeTask po d | "action" .< (TK.data d) == Just RunTournament  = runTournament d po *> return True  


taskRewards :: Integer -> Integer -> RaceRewards -> Integer -> SqlTransaction Connection () 
taskRewards = undefined  
--            unless ((==0) $ respect r) $ Task.giveRespect t u (


{--
data TournamentFullData = TFD {
        tournament :: Tournament,
        roundResult :: S.HashMap Int [RoundResult],
        tournamentPlayers :: [TournamentPlayer]
        }
--}
loadTournamentFull :: Integer -> SqlTransaction Connection TournamentFullData
loadTournamentFull n = TournamentFullData <$> loadTournament n <*> loadPlayers n 

loadTournament :: Integer -> SqlTransaction Connection Tournament 
loadTournament = load >=> \x -> when (isNothing x) (rollback "no such tournament") >> return (fromJust x)


loadPlayers :: Integer -> SqlTransaction Connection [TournamentPlayer] 
loadPlayers i = search ["tournament_id" |== (toSql i) .&& "deleted" |== (toSql False)] [] 1000000 0 

-- want this out of this function: 1324
getWinners = removeSeen . sortBy (sortF) . splice 
        where splice = foldr step [] 
                where step x z = (fromJust $ TR.participant1_id x, getTime1 x, TR.round x) : (fromJust $ TR.participant2_id x, getTime2 x, TR.round x) : z
                      getTime1 = TR.race_time1
                      getTime2 = TR.race_time2
              sortF :: (a,Double, Integer) -> (a, Double, Integer) -> Ordering 
              sortF (_,ta,ra) (_,tb,rb) | ra > rb = GT 
                                        | ra < rb = LT 
                                        | ra == rb = (flip compare) ta tb
              removeSeen :: [(Integer, Double, Integer)] -> [(Integer, Double, Integer)]
              removeSeen  = reverse . foldr step [] 
                    where step (p,d,i) z 
                                    | [p] `isInfixOf` (fst3 <$> z) = z 
                                    | otherwise = (p,d,i) : z
                          fst3 (a,b,c) = a



                

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


newtype ListArrow a b = LA {
        unLA :: [a] -> [b]                  
    }

instance Functor (ListArrow a) where 
        fmap f = LA . (fmap f.) . unLA 

instance Category ListArrow where 
        id = LA C.id 
        (.) (LA f) (LA g) = LA $ \(~xs) -> f' (g' xs)
                where g' (~xs) = g xs 
                      f' (~xs) = f xs 

instance Arrow ListArrow where 
        arr f = LA $ \(~xs) -> lazy $ lfmap (\x -> lazy $ f (lazy x)) xs  
        first (LA f) = LA $ \(~xs) -> lazy $ (lazy $ f $ fst `lfmap` xs) `lzip` (lazy $ snd `lfmap` xs)  
        second (LA f) = LA $ \(~xs) -> (fst `lfmap` xs) `lzip` (lazy $ f $ lazy $  snd `lfmap` xs)


lzip :: [a] -> [b] -> [(a,b)]
lzip [] xs = [] 
lzip ys [] = [] 
lzip ~(~x:xs) ~(~y:ys) = lazy (lazy x, lazy y) : lazy (lzip xs ys)
        
lfmap f [] = [] 
lfmap f ~(~x:xs) = lazy (f (lazy x)) : lfmap f xs 
instance ArrowChoice ListArrow where 
        left (LA f) = LA (lefts f)
        right (LA f) = LA (rights f)

instance ArrowZero ListArrow where 
        zeroArrow = LA $ \_ -> []

instance ArrowPlus ListArrow where 
        (<+>) (LA f) (LA g) = LA $ \(~xs) -> f' xs ++ g' xs 
                where f' (~xs) = f xs 
                      g' (~xs) = g xs 

instance ArrowLoop ListArrow where 
        loop (LA f) = LA $ \xs -> let (unzip -> ~(~as,~b)) = trace "loop" $ f (xs `zip` b)
                                  in as 


rights :: ([a] -> [b]) -> [(Either d a)] -> [(Either d b)] 
rights f xs = let ~(~a, ~d) = splitLR xs ([],[]) 
             in  (Left `lfmap` a) ++ ( Right `lfmap` f d)
    where   splitLR :: [(Either a d)] -> ([a],[d]) -> ([a],[d])
            splitLR [] z = z 
            splitLR ~(~x:xs) ~(~ls,~rs) = case lazy x of
                                            Left a -> splitLR xs (a:ls,rs)
                                            Right a -> splitLR xs (ls, a:rs)


lefts :: ([a] -> [b]) -> [(Either a d)] -> [(Either b d)] 
lefts f xs = let ~(~a,~d) = splitLR xs ([],[]) 
             in  (Left `lfmap` f a) ++ ( Right `lfmap` d)
    where splitLR :: [(Either a d)] -> ([a],[d]) -> ([a],[d])
          splitLR [] z = z
          splitLR ~(~x:xs) ~(~ls,~rs) = case x of
                                            Left a -> splitLR xs (a:ls, rs)
                                            Right a -> splitLR xs  (ls, a:rs)

runListArrow :: ListArrow a b -> [a] -> [b] 
runListArrow (LA f) ~(~xs)= f xs 


test2 :: ListArrow Double Double 
test2 = proc x -> do 
            y <- arr (*2) -< x
            z <- arr (*2.1) -< y
            if z > 10 then returnA -< 0
                      else returnA -< z

testn :: ListArrow Int Int 
testn = proc x -> do 
            if x < 1 then returnA -< 1  
                     else do 
                        t1 <- arr pred -< x 
                        t2 <- arr (pred.pred) -< x 
                        y1 <- testn -< {-# CORE "second" #-} traceShow t1 $ t1
                        y2 <- testn -< traceShow t2 $ t2
                        returnA -< traceShow (y1 + y2) $ y1 + y2 


main = print (runListArrow testn [1..10])

createTournament :: Tournament -> SqlTransaction Connection ()
createTournament tr = do 
                tid <- save tr  
                void $ tournamentTrigger tid 


newtype MultiState s a b = MS {
            runMS :: [(s,a)] -> [(s,b)] 
        }

instance Functor (MultiState s a) where 
        fmap f = MS . (fmap (second f) .) . runMS 

instance Category (MultiState s) where 
        id = MS $ \xs -> xs  
        (.) f g = MS $ runMS f . runMS g  

instance Arrow (MultiState s) where 
        arr f = MS $ \xs -> fmap (second f) xs 
        first  = MS . transform  . runMS 
        second = MS . transform' . runMS 

instance ArrowChoice (MultiState s) where 
       left = MS . transformLeft . runMS  
       right = MS . transformRight . runMS 
       (+++) (MS f) (MS g) = MS (f `transformPlus` g)
       (|||) (MS f) (MS g) = MS (f `transformSum`  g)

transformSum :: ([(s,a)] -> [(s,d)]) -> ([(s,a')] -> [(s,d)]) -> [(s, Either a a')] -> [(s, d)]
transformSum f g xs = let (sa,sa') = unzip3Either xs 
                      in f sa ++ g sa' 

transformLeft :: ([(s,a)] -> [(s,b)]) -> [(s,Either a d)] -> [(s, Either b d)]
transformLeft f xs =  let (sa,sd) = unzip3Either xs
                      in zip3Either (f sa) sd

transformRight :: ([(s,a)] -> [(s,b)]) -> [(s, Either d a)] -> [(s, Either d b)] 
transformRight f xs = let (sd, sa) = unzip3Either xs 
                      in zip3Either sd (f sa)

transformPlus :: ([(s,a)] -> [(s,b)]) -> ([(s,a')] -> [(s,b')]) -> [(s, Either a a')] -> [(s, Either b b')]
transformPlus f g xs = let (sa,sa') = unzip3Either xs 
                       in zip3Either (f sa) (g sa')

zip3Either :: [(s,a)] -> [(s,d)] -> [(s, Either a d)] 
zip3Either sa sd = fmap (second Left) sa ++ fmap (second Right) sd 

unzip3Either :: [(s,Either a d)] -> ([(s,a)], [(s,d)])
unzip3Either xs = foldr step ([], []) xs 
        where step (s,Left a) (ls,xs) = ((s,a):ls,xs)
              step (s, Right a) (ls, xs) = (ls, (s,a):xs) 
            

transform :: ([(s,a)] -> [(s,b)]) -> [(s, (a,d))] -> [(s,(b,d))]
transform f xs = let (asss, ds) = unzip3' xs 
                 in zip3' (f asss) ds 
transform' :: ([(s,a)] -> [(s,b)]) -> [(s,(d,a))] -> [(s,(d,b))] 
transform' f xs = let (asss, ds) = unzip3'' xs 
                  in zip3'' (f asss) ds 
zip3' :: [(s,a)] -> [d] -> [(s,(a,d))] 
zip3' = zipWith (\(s,a) d -> (s, (a,d))) 

zip3'' :: [(s,a)] -> [d] -> [(s, (d,a))]
zip3'' = zipWith (\(s,a) d -> (s, (d, a)))


unzipWith :: (d -> (a,b)) -> [d] -> ([a],[b])
unzipWith f xs = foldr step ([], []) xs 
    where step x (ls,rs) = let ab = f x in (fst ab : ls, snd ab : rs)  

unzip3' :: [(s,(a,d))] -> ([(s,a)], [d])
unzip3' = unzipWith (\(s,(a,d)) -> ((s,a), d))

unzip3'' :: [(s, (d, a))] -> ([(s,a)], [d])
unzip3'' = unzipWith (\(s,(d,a)) -> ((s,a),d))



fetch :: MultiState s a (s,a) 
fetch = MS $ fmap (\(s,a) -> (s, (s, a)))

store :: MultiState s s () 
store = MS $ fmap (\(_,s) -> (s,()))


runMultiState :: MultiState s a b -> [(s,a)] -> [(s, b)] 
runMultiState (MS f) xs = f xs 


testll = runMultiState $ proc x -> do 
                    (s,a) <- fetch -< x
                    if s > a then do 
                                    y <-  store -< (s / a)
                                    returnA -< a 
                             else do 
                                    y <- store -< (s * a)
                                    returnA -< a


unroll :: ((a -> b) -> b) -> a -> b -> b
unroll f a b = f (const b)  

roll :: (a -> b -> b) -> (a -> b) -> b
roll f g = g undefined  


swap :: ((a -> b) -> b) -> b -> a -> b
swap f b _ = f (const b)

unswap :: (b -> (a -> b)) -> (a -> b) -> b 
unswap f g = g undefined 

ids :: (b -> a -> b) -> (b -> a -> b) 
ids = swap . unswap  


