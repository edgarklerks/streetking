{-# LANGUAGE ViewPatterns, RankNTypes, GeneralizedNewtypeDeriving, MultiParamTypeClasses, OverloadedStrings, ScopedTypeVariables, TypeSynonymInstances  #-}
-- | Quickcheck is useful for finding corner cases in 
--   functions. You setup a 'law' for your function and
--   then define a property based on that law. 
--
--   QuickCheck will then try to find a fail case 
--   for you. 
--
--   HUnit is useful to test expected behaviour of 
--   functions. This is less strong than a property,
--   but more useful for complex interfaces. 

--  how to write a test with quickCheck  
--
--   Say I want to show emperical that:
--
-- @
--   (a * b) `mod` c = (a `mod` c) * (b `mod` c)
-- @ 
--
--  for (a,b,c) e N 
--
--  which is bullshit ofcourse. 
--  
--  I first define a property. 
--
--  @
-- 
-- prop_modabc = property test 
--      where test :: Int -> Int -> Int -> Bool 
--            test a b c = (a * b) `mod` c == (a `mod` c) * (b `mod` c)
--
--  @
--
--  If you start it with 
--  prop_ we can automagicly run all the tests in this module  
--  If you don't santa clause will come and get you.
--
--  For all other problems use HUnit

module Main where 


import           Application hiding (runDb) 
import           Bot.Type 
import           Bot.Util
import           Control.Applicative 
import           Control.Concurrent 
import           Control.Concurrent.STM 
import           Control.Monad.CatchIO 
import           Control.Monad.Reader hiding (foldM, foldM_, forM, forM_) 
import           Control.Monad.STM 
import           Control.Monad.State hiding (foldM_, foldM, forM_, forM) 
import           Control.Monad.Trans 
import           Data.Aeson hiding (object) 
import           Data.Conversion 
import           Data.Database hiding (Value, Insert,Delete) 
import           Data.DatabaseTemplate 
import           Data.Foldable 
import           Data.Maybe 
import           Data.MemTimeState 
import           Data.Monoid 
import           Data.Notifications
import           Data.SqlTransaction 
import           Data.String 
import           Data.Time.Clock.POSIX
import           Database.HDBC.SqlValue 
import           Model.Functions 
import           Model.General 
import           Prelude hiding (foldr, foldl)
import           Site 
import           Snap.Core 
import           Snap.Snaplet 
import           Snap.Snaplet.Config
import           System.Environment
import           System.Random 
import           Test.HUnit 
import           Test.QuickCheck 
import           Test.QuickCheck.Monadic as Q  
import           Test.QuickCheck.Test 
import qualified Data.ByteString.Char8 as B 
import qualified Data.ByteString.Lazy.Char8 as BL 
import qualified Data.HashMap.Strict as S
import qualified Data.InRules as I  
import qualified Data.IntMap as IM 
import qualified Data.Tournament as TRM
import qualified Database.HDBC as H
import qualified Model.CarInGarage as CIG 
import qualified Model.PreLetter as L 
import qualified Model.Tournament as T 
import qualified Snap.Test as S 


prop_dist_mul_mod = property work
    -- Positive a create only positive Num a  
    where work :: Positive Int -> Positive Int -> Positive Int -> Bool 
          work x y z  = (x * y) `mod` z == (x `mod` z) * (y `mod` z) 


{-- 
- Now I can run the property with:
- --} 

test_dist_mul_mod = quickCheck prop_dist_mul_mod


{-- 
- how to write a Test with HUnit. 
-
- For HUnit we use the 
- RandomM monad, which has in its state/reader context 
- a fresh db connection and a seed of a random generator.
-
- Let's say we want to test if user 36 has cars at all. 
- --}

test_has_cars = do 
                    -- asInRule runs the request in the snap monad embedded
                    -- in RandomM 
                    -- asInRule :: RequestBuilder (RandomM c) () -> RandomM c InRule 
                    a <- asInRule $ do 
                            -- mkJsonPost creates an request out of a route
                            -- and arguments  
                            mkJsonPost "Garage/car" (S.fromList [])
                            -- directly manipulate the query string 
                            S.setQueryStringRaw "userid=36"
                    return (fromInRule (fromJust $ a .> "result") :: [InRule])


{-- Now we defined the actual tests and cases --}

-- bracket takes three computation. The initial comp to 
-- obtain resources ,
-- the final comp, to release resource and the computation,
-- that does something with the resource. 
-- bracket :: m a -> (a -> m c) -> (a -> m b) -> m b 


testHasCars = bracket testcon H.disconnect $ \c -> runRandomIO c $ do 
                    c <- test_has_cars  
                    runTest $ TestList [
                            TestLabel "test_user_has_car" $ 
                                    TestCase $ assertBool "no car for user" (not . null $ c) 

                        ]


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
            print "Test notification, search notifications"
            runRandomIO c $ do 
                            b <- test_search_notification 
                            runTest $ TestLabel "search notification" $ TestCase $ assertBool "search notification is to big" (not . null $ b)

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


-- | Hunit top level notification tests 

test_search_notification = do 
            xs <- asInRule $ do 
                mkJsonPost "User/searchNotification" (S.fromList [("archive", InInteger 0), ("sql", InString "orderby id desc" )])
                S.setQueryStringRaw "userid=36"                                                         
            return (I.toList (fromJust $ xs .> "result") :: [(String, String)]) 
            -- return (not . null $ xs)

-- | Instance to generate random letters 


instance Arbitrary Letter where 
    arbitrary = do 
        (AN ti) <- arbitrary
        (AN msg) <- arbitrary 
        to <- arbitrary `suchThat` (>0)
        frm <- arbitrary `suchThat` (>0) 
        (encode -> xs) <- arbitrary :: Gen Value  
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
-               Unit tests for tournaments,
-               no corner cases yet
--}

main = do 
    x <- head <$> getArgs
    case x of 
        "tournament" -> do 
                        c <- dbconn 
                        s <- runRandomIO c testTournament 
                        print s

testTournament :: RandomGen g => RandomM g Connection ()
testTournament = do 
        tri <- testCreateTournament 
        joinTournament tri 
        return ()

-- | Join a tournament 
joinTournament id = do 
            xs <- take 3 <$> testCarUsers 
            forM_ xs $ \(i,d) -> do  
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
                        T.image = "http://www.hallomall.com/media/catalog/product/cache/1/thumbnail/50x/9df78eab33525d08d6e5fb8d27136e95/j/u/justin_bieber_face_mask.jpg",
                        T.tournament_type_id = 1
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

-- | shape is a binary relationship. But we pretend it gives back a property, 
-- we can compare:
-- (1)  shp (a `project` b) == shp b 
-- (2)  a `project` (b `project` c) = (a `project` b) `project` c
-- (3)  b `project` c = b, if shp c = shp b  
-- 
--  There is no identity 
--
--  a `project` e = a, b `project` e = b
-- 
-- (a `project` b) `shp` b == True 
--
--



shp xs@(InObject ts) (InObject sp) | S.size  ts /= S.size sp = False 
                                   | otherwise  = S.foldrWithKey step True sp 
            where 
                  step k _ False = False 
                  step lbl y True = case xs .> lbl of 
                                        Nothing -> False 
                                        Just a -> shp a y  
shp (InArray xs) (InArray sp) | length xs /= length sp = False 
                              | otherwise = Prelude.and $ uncurry shp <$> (xs `zip` sp)
shp a b = viewKind a == viewKind b 

test_project = let f = quickCheckWith smallArgs 
               in f prop_shp_eq >> f prop_project_left_cancelative >>  
                  f prop_project_assoc >> 
                  f prop_project_shape 

prop_project_shape = property test
        where test :: IsomorphT -> IsomorphT -> Bool 
              test (IsomorphT b) (IsomorphT c')  = (b `project` c) == b 
                
                    where c = project c' b  

prop_shp_eq = property test 
    where test :: IsomorphT -> Bool 
          test (IsomorphT sh) = shp sh sh 

prop_project_left_cancelative = property test 
        where test :: IsomorphT -> IsomorphT -> Bool 
              test (IsomorphT a) (IsomorphT b) = shp (a `project` b) b 

prop_project_assoc  = property test 
        where test :: IsomorphT -> IsomorphT -> IsomorphT -> Bool 
              test (IsomorphT a) (IsomorphT b) (IsomorphT c) = (a `project` b) `project` c == a `project` (b `project` c) 


{-- 
-
- Test for MemTimeState  
-
- --}

instance Arbitrary Query where 
    arbitrary = oneof [insert,delete,query,ds]
        where insert = do 
                    k <- arbitrary
                    v <- arbitrary 
                    return $ Insert k v 
              delete = do 
                    k <- arbitrary 
                    return $ Delete k 
              query = do 
                    k <- arbitrary 
                    return $ Query k 
              ds = return DumpState 
-- | Test for memstate 
test_query = do 
        ms <- newMemState (1000 * 1000 * 60 * 60) (6000 * 1000) "testshit" 
        qc <- newTQueueIO 
        forkIO $ queryManager "testshit" ms qc
        quickCheck (test_query_insert qc)
        quickCheck (test_delete qc)

-- | Test for deleting out of mem state 
test_delete qc = monadicIO $ do 
                    k <- pick arbitrary 
                    v <- pick arbitrary
                    res <- Q.run $ runQuery qc (Insert k v)
                    test <- Q.run $ runQuery qc (Delete k)
                    ps <- Q.run $ runQuery qc (Query k)
                    Q.assert (ps == NotFound && res == Empty && test == Empty) 

-- | Test for query and insert into mem state 
test_query_insert qc = monadicIO $ do 
        k <- pick arbitrary
        v <- pick arbitrary
        res <- Q.run $ runQuery qc (Insert k v)
        test <- Q.run $ runQuery qc (Query k)
        Q.assert (res == Empty && test == Value v)


-- | Challenge test 
--
-- acceptChallenge have some ununphantomable problem, where 2 emitEvent stmts are
-- runned 1.5 times. Player x get's double fun, player y gets once. This tries to reproduce the problem and identify the
-- minimal program, which fucks up. 

-- oh never mind, I had to do with a double event_stream entry
