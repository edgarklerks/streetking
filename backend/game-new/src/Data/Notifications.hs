{-# LANGUAGE ViewPatterns #-}
-- | The notification system is modeled after a postal office
--   we can sort the letters, then send letters in order of priority to
--   the user boxes 
module Data.Notifications where 

import qualified Data.PriorityQueue as PQ 
import qualified Data.IntMap as IM 
import           Control.Applicative
import           Control.Monad hiding (forM_) 
import           Data.Time.Clock.POSIX 
import           Control.Monad.STM 
import           Control.Concurrent.STM 
import           Data.Monoid 
import qualified Model.PreLetter as P 
import           Model.General
import           Data.SqlTransaction 
import           Database.HDBC.PostgreSQL (Connection)
import           Control.Monad.Trans 
import           Data.Maybe 
import           Data.Database
import           Database.HDBC.SqlValue
import           Data.Foldable 
import           Prelude hiding (foldr, foldl, foldl1, foldr1)
import qualified Data.LimitList as LL 
import           Model.Functions 


type Letters = [Letter]

type Letter = P.PreLetter 
type Time = Integer

newtype PrioService = PQS {
            runPrioService :: TVar (PQ.Prio Time Int)
        }

newtype PostSorter = PS {
            runPostSorter :: TVar (IM.IntMap Letter)
        }

newtype UserBoxes = UB {
            runUserBoxes :: TVar (IM.IntMap (TVar (LL.LimitList Int)))
        }

-- | Get all letters in the postoffice with an index
readPostSorter :: PostOffice -> STM (IM.IntMap Letter)
readPostSorter (PO (_, ps, _)) = readTVar (runPostSorter ps)

-- | Modify all the letters in the post office 
modifyPostSorter :: PostOffice -> (IM.IntMap Letter -> IM.IntMap Letter) -> STM ()
modifyPostSorter (PO (_, ps,_)) f = modifyTVar (runPostSorter ps) f

-- | Replace all letters in the post office 
writePostSorter :: PostOffice -> IM.IntMap Letter -> STM ()
writePostSorter (PO (_,ps,_)) = writeTVar (runPostSorter ps) 

-- | Read a specific user box 
readUserBoxes :: PostOffice -> STM (IM.IntMap (TVar (LL.LimitList Int)))
readUserBoxes (PO (_,_,x)) = readTVar (runUserBoxes x)

-- | Modify a user box 
modifyUserBoxes :: PostOffice -> (IM.IntMap (TVar (LL.LimitList Int)) -> IM.IntMap (TVar (LL.LimitList Int))) -> STM () 
modifyUserBoxes (PO (_,_,x)) = modifyTVar (runUserBoxes x)

-- | Replace a user box 
writeUserBoxes :: PostOffice -> IM.IntMap (TVar (LL.LimitList Int)) -> STM ()
writeUserBoxes (PO (_,_,x)) = writeTVar (runUserBoxes x) 

-- | get the priority queue from the postoffice 
readPrioService :: PostOffice -> STM (PQ.Prio Time Int)
readPrioService (PO (x,_,_)) = readTVar (runPrioService x)

-- | modify the priority service of the postoffice 
modifyPrioService :: PostOffice -> (PQ.Prio Time Int -> PQ.Prio Time Int) -> STM ()
modifyPrioService (PO (x, _, _)) = modifyTVar (runPrioService x) 


-- | Replace the priority service in the postoffice 
writePrioService :: PostOffice -> PQ.Prio Time Int -> STM ()
writePrioService (PO (x,_,_)) = writeTVar (runPrioService x) 

-- | Modify a specific letter 
modifyLetter :: PostOffice -> Int -> (Letter -> Letter) -> STM ()
modifyLetter po i f = modifyPostSorter po $ IM.update (Just . f) i   

-- | Delete a letter from the postoffice 
deleteLetter :: PostOffice -> Int -> STM ()
deleteLetter po i = modifyPostSorter po $ IM.delete i   



type UserId = Integer 

-- | Get the id from a letter 
getId :: Letter -> Int 
getId it = fromInteger $ fromJust $ P.id it 

withPriority it f | (getPrio $ it)  == Nothing = return ()
                  | otherwise = f (fromJust $ getPrio it)

-- | Get the priority of the letter 
getPrio :: Letter -> Maybe Time 
getPrio l | P.ttl l == Nothing = Nothing 
          | otherwise = Just $ (fromJust $ P.ttl l) 

-- | A post office has a PrioService, PostSorter and UserBoxes 
newtype PostOffice = PO {
        -- | close the post office 
        closePostOffice ::  (PrioService,PostSorter,UserBoxes) 
    }

-- | Send a letter with postoffice to a user 
sendLocal :: PostOffice -> UserId -> Letter -> IO ()
sendLocal po uid it = do 
            atomically $ do 
                ubl <-   readUserBoxes po 
                -- Add it to the user box of a user 
                case IM.lookup (fromEnum uid) ubl of 
                    Nothing -> do 
                            tv <- newTVar $ LL.insert (getId it) (LL.new 10) 
                            writeUserBoxes po (IM.insert (fromEnum uid) tv ubl)    
                    Just tv -> do 
                        modifyTVar tv (\z -> (getId it) LL.|> z)
                -- throw it in the postsorter  
                modifyPostSorter po (\z -> IM.insert (getId it) it z) 
                
                -- Add the priority of the message 
                
                withPriority it $ \prio -> do 
                            modifyPrioService po $ \z -> PQ.insert prio (getId it) z  




-- | open the post office 
openPostOffice :: IO PostOffice 
openPostOffice = do 
            pqs <- newTVarIO mempty
            ps  <- newTVarIO mempty
            ub  <- newTVarIO mempty
            return $ PO (
                        PQS pqs,
                        PS  ps,
                        UB  ub
                    )

-- | send a message to that users locally and to the central post center (database) 
sendLetter :: PostOffice -> UserId -> Letter -> SqlTransaction Connection Letter
sendLetter po uid lt = sendCentral uid lt >>= \c -> (liftIO . sendLocal po uid) c  >> return c


-- Send a letter to the database 
sendCentral ::  UserId -> Letter -> SqlTransaction Connection Letter 
sendCentral uid it = do 
                    a <- milliTime  
                    let prit = P.PreLetter Nothing ((+) <$> P.ttl it <*> pure (P.sendat it)) (P.message it) (P.title it) (a) (uid) (P.from it) False False (P.data it) (P.type it) 
                    id <- save  prit 
                    return (prit { P.id = Just id}) 

-- | Flag letter read  
setRead :: PostOffice -> UserId -> Integer -> SqlTransaction Connection () 
setRead po uid id = do 
                   liftIO $ atomically $ modifyLetter po (fromInteger id) (\x -> x { P.read = True })
                   x <- aget ["id"  |== (toSql id) .&& "to" |== (toSql uid)] (rollback "no such letter")  :: SqlTransaction Connection Letter 
                   liftIO $ atomically $ deleteLetter po (fromIntegral id)
                   save (x { P.read = True } :: Letter) :: SqlTransaction Connection Integer 
                   return ()

-- | Flag letter archived 
setArchive :: PostOffice -> UserId -> Integer -> SqlTransaction Connection ()
setArchive po uid id = do 
                   liftIO $ atomically $ modifyLetter po (fromInteger id) (\x -> x { P.archive = True })
                   x <- aget ["id"  |== (toSql id) .&& "to" |== (toSql uid)] (rollback "no such letter")  :: SqlTransaction Connection Letter 
                   liftIO $ atomically $ deleteLetter po (fromIntegral id)
                   save (x { P.archive = True } :: Letter) :: SqlTransaction Connection Integer 
                   return ()



        

-- | receive your messages 
checkMailBox :: PostOffice -> UserId -> SqlTransaction Connection Letters
checkMailBox po u@(fromEnum -> uid) = haulPost po u *> do 
                ub' <- liftIO $ atomically $ readUserBoxes po 
                case IM.lookup uid ub' of 
                        Just us -> do 
                                xs <- liftIO $ readTVarIO us 
                                ps' <- liftIO $ atomically $ readPostSorter po  
                                return $ toList $ LL.catMaybes $  (\i -> IM.lookup i ps') <$> xs 

                        Nothing -> return [] 
{--
flushBoxes :: PostOffice -> UserId -> STM () 
flushBoxes po = do 
            let (_, runUserBoxes -> ub, _) = closePostOffice po 
            ts <- readTVar ub 
            undefined 
--}


-- | Get post from the regional office (database)
haulPost :: PostOffice -> UserId -> SqlTransaction Connection ()
haulPost po uid = do 
            xs <- search ["archive" |== (toSql False) .&& "read" |== (toSql False) .&& "to" |== (toSql $ fromEnum uid)] [] 10 0 :: SqlTransaction Connection [Letter]
            forM_ xs $ \it -> liftIO $ atomically $ do 

                        -- check if message exists 
                        ps' <- readPostSorter po 
                        when (not $ IM.member (getId it) ps') $ do   
                            ubl <- readUserBoxes po 
                            case IM.lookup (fromEnum uid) ubl of 
                            -- Add it to the user box of a user 
                                Nothing -> do 
                                    tv <- newTVar (LL.insert (getId it) $ LL.new 10)
                                    writeUserBoxes po (IM.insert (fromEnum uid) tv ubl)    
                                Just tv -> do 
                                    modifyTVar tv (\z -> (getId it) LL.|> z)
                                   -- throw it in the postsorter  
                                    modifyPostSorter po (\z -> IM.insert (getId it) it z) 
                    
                              -- Add the priority of the message 
                    
                            withPriority it $ \prio -> do 
                                   modifyPrioService po $ \z -> PQ.insert prio (getId it) z  


-- | get all message letters since .. 
extractSince :: Time -> PostOffice -> STM [Int]
extractSince t po = do 
                        xs <- readPrioService po
                        let (bs, ts) = (PQ.extractTill t xs) 
                        writePrioService po ts 
                        return bs 

-- | clean up that postoffice a bit 
goin'Postal :: PostOffice -> IO ()
goin'Postal po = do 
            t <- floor . (*1000) <$> getPOSIXTime :: IO Integer 
            liftIO $ atomically $ do 
                    ms <- extractSince t po 
                    modifyPostSorter po $ \z -> foldr (\x z -> IM.delete x z) z ms 


-- | Sending bulk mail to everybody 
sendBulkMail :: PostOffice -> Letter -> SqlTransaction Connection () 
sendBulkMail po l = liftIO (sendBulkLocal po l) *> sendBulkCentral po l 

sendBulkLocal :: PostOffice -> Letter -> IO ()
sendBulkLocal = undefined 

sendBulkCentral :: PostOffice -> Letter -> SqlTransaction Connection ()
sendBulkCentral = undefined 


-- | Some tools 
milliTime :: SqlTransaction Connection Time 
milliTime = (*1000) <$> unix_timestamp 


