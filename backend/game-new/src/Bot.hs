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
import Data.Aeson hiding (object) 
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
import Test.QuickCheck.Monadic as Q  
import Data.Notifications
import qualified Model.PreLetter as L 
import Control.Monad.STM 
import Control.Concurrent.STM 
import qualified Data.IntMap as IM 
import Test.QuickCheck.Test 
import Control.Monad.CatchIO 
import Control.Concurrent 
import qualified Data.InRules as I  


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
        c <- testcon
        bracket testcon (H.disconnect) $ \c -> do   
            print "Test postoffice, read write stm"
            quickCheck $ prop_read_write_notification_stm po
            print "Test postoffice, max length 10"
            quickCheck $ prop_length_less_then_ten po 
            print "Test postoffice, read write db+stm"
            quickCheck $ prop_read_write_notification_dbstm c po 
            print "Test postoffice, read write db"
            quickCheck $ prop_read_write_notification_db c po 
        return ()


prop_read_write_notification_db c po = monadicIO $ do 
                                s <- pick arbitrary
                                q <- Q.run $ (work $ s { L.to = 10 })
                                return ()
     where work :: Letter -> IO Bool 
           work lt = do 
                ltn <- runDbRaw c $ sendCentral 10 lt 
                liftIO $ threadDelay 1000
                xs <- runDbRaw c $ Data.Notifications.checkMailBox po 10 
                return $ Prelude.any (==ltn) xs 

                

prop_length_less_then_ten po = monadicIO $ do 
                                    s <- pick arbitrary 
                                    q <- Q.run $ (work $ s { L.to = 10 })
                                    Q.assert q 

        where work :: Letter -> IO Bool 
              work lt = do 
                    
                    liftIO $ sendLocal po 10 lt 
                    atomically $ do 
                           xs <- readUserBoxes po 
                           case IM.lookup 10 xs of 
                                    Just a -> do 
                                        s <- readTVar a
                                        return $ (length $ Data.Foldable.toList s) <= 10

                                    Nothing -> return False 





prop_read_write_notification_dbstm c po = monadicIO $ do 
                                        s <- pick arbitrary 
                                        q <- Q.run $ work s 
                                        Q.assert q 
        where work :: Letter -> IO Bool 
              work lt' = do 
                    let lt = lt' {
                            L.id = Nothing     
                            }
                    let uid = L.to lt 

                    ltn <- runDbRaw c $ Data.Notifications.sendLetter po uid lt 
                    xs <- replicateM 3 $ runDbRaw c $ Data.Notifications.checkMailBox  po uid 
                    return $ Prelude.or $ Prelude.any (==ltn) <$> xs 


                    


prop_read_write_notification_stm po = monadicIO $ do 
                                        s <- pick arbitrary 
                                        q <- Q.run $ work s
                                        Q.assert q 

    where work :: Letter -> IO Bool 
          work lt = do 
                let uid = L.to lt 
                let msgid = fromJust $ L.id lt 
                liftIO $ sendLocal po (uid) lt 
                atomically $ do 
                    s <- readPostSorter po 
                    case IM.lookup (fromEnum msgid) s of 
                            Just a -> return (a == lt)
                            Nothing -> return False 


-- | Top level stuff 


-- | Instance to generate random letters 


instance Arbitrary Letter where 
    arbitrary = do 
        (AN ti) <- arbitrary
        (AN msg) <- arbitrary
        to <- arbitrary `suchThat` (>0)
        frm <- arbitrary `suchThat` (>0) 
        (AN (BL.pack -> xs)) <- arbitrary 
        id <- arbitrary `suchThat` (>0) 

        return (def {
               L.id = Just id,
               L.title = ti,
               L.message = msg,
               L.data = Just xs,
               L.type = Just $ "generated",
               L.to = to,
               L.from = Just $ frm 
            })


 

{-- 
-
-               Unit tests for tournaments,
-               no corner cases yet
-
--}

testTournament :: RandomGen g => RandomM g Connection ()
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
testCreateTournament :: RandomGen g => RandomM g Connection Integer  
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
        c <- ask 
        runTest $ TestList [TestLabel "tournament exist" $ tournamentExist c nm ,
                             TestLabel "tournament trigger exist" $ tournamentTrigger c nm ]
        fromSql <$> (runDb $ sqlGetOne "select id from tournament where name = ?" [toSql nm])

tournamentTrigger c nm = TestCase $ runDbRaw c $ do 
                                tr <- sqlGetOne "select id from tournament where name = ?" [toSql nm] 
                                r <- sqlGetOne "select task_id from task_trigger where target_id = ? " [toSql tr]
                                tid <- sqlGetOne "select count(*) from task where id = ?" [toSql r]
                                when ((fromSql tid :: Int) == 0) $ liftIO $ assertFailure "tournament task doesn't exist"
                                return ()


tournamentExist c nm =  TestCase $ runDbRaw c $ do 
                               r <- quickQuery "select count(*) from tournament where name = ?" [toSql nm] 
                               case r of 
                                 [[t]] -> do when ((fromSql t :: Int) == 0) $ 
                                                liftIO $ assertString $ "create tournament " ++ nm 
                                             when ((fromSql t :: Int) > 0) $ 
                                                liftIO $ assertString ""
                                        
                                 otherwise -> liftIO $ assertString $ "create tournament db " ++ nm  




test_pfold_longest_path = (==4) . I.longest_path $ inrules_test_obj 
test_pmap_replace_length = pmap step $ inrules_test_obj
        where step :: [InKey] -> InRule -> InRule 
              step (I.ckey -> l :: Int) x = toInRule $ l 


inrules_test_obj = object [
                                    ("test", object [ 
                                                ("bla", toInRule (1 :: Int)),
                                                ("ble", toInRule (2 :: Int))
                                ])
                                ,   ("test2", object [
                                                     ("blas", object [
                                                                ("x", (
                                                                    toInRule
                                                                        [ toInRule 'c'
                                                                        , toInRule ( "test" :: String)
                                                                        ]
                                                                    )
                                                                )
                                                            ]
                                                        )
                                                ])
                                        ]
