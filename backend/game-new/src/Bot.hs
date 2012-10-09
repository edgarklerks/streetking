{-# LANGUAGE ViewPatterns, RankNTypes, GeneralizedNewtypeDeriving, MultiParamTypeClasses, OverloadedStrings, ScopedTypeVariables, TypeSynonymInstances  #-}
module Bot where 


import Data.SqlTransaction 
import Snap.Core 
import qualified Snap.Test as S 
import Application hiding (runDb) 
import Site 
import Test.HUnit 
import qualified Database.HDBC as H
import Database.HDBC.SqlValue 
import qualified Data.Tournament as TRM
import Model.General 
import qualified Model.Tournament as T 
import Control.Monad.Trans 
import Control.Applicative 
import Data.Time.Clock.POSIX
import System.Random 
import Data.Foldable 
import Prelude hiding (foldr, foldl)
import Control.Monad.State hiding (foldM_, foldM, forM_, forM) 
import Control.Monad.Reader hiding (foldM, foldM_, forM, forM_) 
import Data.Aeson 
import Snap.Snaplet 
import Snap.Snaplet.Config
import Data.Conversion 
import Data.Monoid 
import qualified Data.HashMap.Strict as S
import qualified Data.ByteString.Char8 as B 
import qualified Data.ByteString.Lazy.Char8 as BL 
import Data.String 
import qualified Model.CarInGarage as CIG 
import Data.Database hiding (Value) 
import Data.DatabaseTemplate 
import Data.Maybe 
import Model.Functions 
import Bot.Util
import Bot.Type 
import Test.QuickCheck 
import Test.QuickCheck.Monadic 
import Data.Notifications


{-- 
-
-               Unit tests for notifications 
-
--}

-- | I use monadic quickcheck, because it is more general than HUnit


notificationTests :: IO ()
notificationTests = do 
        -- | setup the postoffice 
        po <- openPostOffice 

         
        return ()

-- | Top level stuff 

instance Arbitrary Letter where 
    arbitrary = do 
        return undefined 


 

{-- 
-
-               Unit tests for tournaments,
-               no corner cases yet
-
--}

testTournament :: RandomGen g => RandomM g c ()
testTournament = do 
        tri <- testCreateTournament 
        joinTournament tri 
        return ()

-- | Join a tournament 
joinTournament id = do 
            xs <- take 4 <$> testCarUsers 
            forM_ xs $ \(i,d) -> do  
                    liftIO $ print (i,d)
                    s <- asInRule $ do 
                        mkJsonPost "Tournament/join" (S.fromList [("tournament_id", toInRule id), ("car_instance_id", toInRule d)])
                        S.setQueryStringRaw $ "userid=" <> (B.pack $ show i)
                    runTest $ TestList [
                                TestLabel ("join tournament uid:" <> (show i))  
                                    (TestCase $ assertEqual "couldn't join tournament" (Just 1 :: Maybe Integer) (fromInRule <$> s .> "result"))
                        ]
                    return ()




-- | Creates the tournament used for different tests 
testCreateTournament :: RandomGen g => RandomM g c Integer  
testCreateTournament = do 
        nm <- humanString 
        runDb $ do 
            st <- (*1000) <$> unix_timestamp   
            TRM.createTournament (def {
                        T.start_time = Just $ st + 2 * 60 * 1000,
                        T.costs = 0,
                        T.minlevel = 0,
                        T.maxlevel = 100000,
                        T.track_id = 1,
                        T.players = 4, 
                        T.name = nm,
                        T.image = ""
                })

        runTest $ TestList [TestLabel "tournament exist" $ tournamentExist nm ,
                             TestLabel "tournament trigger exist" $ tournamentTrigger nm ]
        fromSql <$> (runDb $ sqlGetOne "select id from tournament where name = ?" [toSql nm])

tournamentTrigger nm = TestCase $ runDb $ do 
                                tr <- sqlGetOne "select id from tournament where name = ?" [toSql nm] 
                                r <- sqlGetOne "select task_id from task_trigger where target_id = ? " [toSql tr]
                                tid <- sqlGetOne "select count(*) from task where id = ?" [toSql r]
                                when ((fromSql tid :: Int) == 0) $ liftIO $ assertFailure "tournament task doesn't exist"
                                return ()


tournamentExist nm =  TestCase $ runDb $ do 
                               r <- quickQuery "select count(*) from tournament where name = ?" [toSql nm] 
                               case r of 
                                 [[t]] -> do when ((fromSql t :: Int) == 0) $ 
                                                liftIO $ assertString $ "create tournament " ++ nm 
                                             when ((fromSql t :: Int) > 0) $ 
                                                liftIO $ assertString ""
                                        
                                 otherwise -> liftIO $ assertString $ "create tournament db " ++ nm  




