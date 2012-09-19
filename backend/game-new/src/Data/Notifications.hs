{-# LANGUAGE ViewPatterns #-}
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


type UserId = Integer 

getId :: Letter -> Int 
getId it = fromInteger $ fromJust $ P.id it 
withPriority it f | (getPrio $ it)  == Nothing = return ()
                  | otherwise = f (fromJust $ getPrio it)

getPrio :: Letter -> Maybe Time 
getPrio l | P.ttl l == Nothing = Nothing 
          | otherwise = Just $ (fromJust $ P.ttl l) + P.sendat l


newtype PostOffice = PO {
        -- | close the post office 
        closePostOffice ::  (PrioService,PostSorter,UserBoxes) 
    }
sendLocal :: PostOffice -> UserId -> Letter -> IO ()
sendLocal po uid it = do 
            let (runPrioService -> ps,  runPostSorter -> pos, runUserBoxes -> ub) = closePostOffice po 
            atomically $ do 
                ubl <- readTVar  ub 
                -- Add it to the user box of a user 
                case IM.lookup (fromEnum uid) ubl of 
                    Nothing -> do 
                            tv <- newTVar $ LL.insert (getId it) (LL.new 100) 
                            writeTVar ub (IM.insert (fromEnum uid) tv ubl)    
                    Just tv -> do 
                        modifyTVar tv (\z -> (getId it) LL.|> z)
                -- throw it in the postsorter  
                modifyTVar pos (\z -> IM.insert (getId it) it z) 
                
                -- Add the priority of the message 
                
                withPriority it $ \prio -> do 
                            modifyTVar ps $ \z -> PQ.insert prio (getId it) z  




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

-- | send a message to that users 
sendLetter :: PostOffice -> UserId -> Letter -> SqlTransaction Connection () 
sendLetter po uid lt = sendCentral po uid lt >>= liftIO . sendLocal po uid 


                         
                         
                         -- undefined 

sendCentral :: PostOffice -> UserId -> Letter -> SqlTransaction Connection Letter 
sendCentral po uid it = do 
                    a <- liftIO $ milliTime  
                    let prit = P.PreLetter Nothing (P.ttl it) (P.message it) (P.title it) (a) (uid) (P.from it)  
                    id <- save  prit 
                    return (prit { P.id = Just id}) 


-- | receive your messages 
checkMailBox :: PostOffice -> UserId -> SqlTransaction Connection Letters
checkMailBox p@(PO (_,ps,ub)) u@(fromEnum -> uid) = do 
                ub' <- liftIO $ readTVarIO (runUserBoxes ub )
                case IM.lookup uid ub' of 
                        Just us -> do 
                                xs <- liftIO $ readTVarIO us 
                                ps' <- liftIO $ readTVarIO (runPostSorter ps)
                                forkSqlTransaction (haulPost p u) 
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
haulPost (PO (prios, ps, ub)) uid = do 
            t <- liftIO $ milliTime 
            xs <- search ["to" |== (toSql $ fromEnum uid) .&& "ttl" |>= (toSql t)] [] 100 0 :: SqlTransaction Connection [Letter]
            forM_ xs $ \it -> liftIO $ atomically $ do 

                        -- check if message exists 
                        ps' <- readTVar (runPostSorter ps)
                        when (not $ IM.member (getId it) ps') $ do   
                            ubl <- readTVar  (runUserBoxes ub)
                            case IM.lookup (fromEnum uid) ubl of 
                            -- Add it to the user box of a user 
                                Nothing -> do 
                                    tv <- newTVar (LL.insert (getId it) $ LL.new 100)
                                    writeTVar (runUserBoxes ub) (IM.insert (fromEnum uid) tv ubl)    
                                Just tv -> do 
                                    modifyTVar tv (\z -> (getId it) LL.|> z)
                                   -- throw it in the postsorter  
                                    modifyTVar (runPostSorter ps) (\z -> IM.insert (getId it) it z) 
                    
                              -- Add the priority of the message 
                    
                            withPriority it $ \prio -> do 
                                   modifyTVar (runPrioService prios) $ \z -> PQ.insert prio (getId it) z  



extractSince :: Time -> PostOffice -> STM [Int]
extractSince t (PO (runPrioService -> prio,_,_)) = do 
                        xs <- readTVar prio 
                        let (bs, ts) = (PQ.extractTill t xs) 
                        writeTVar prio ts 
                        return bs 

-- | clean up that postoffice a bit 
goin'Postal :: PostOffice -> IO ()
goin'Postal po = do 
            t <- liftIO $ milliTime 
            let (prio, runPostSorter -> ps, runUserBoxes -> ub) = closePostOffice po 
            liftIO $ atomically $ do 
                    ms <- extractSince t po 
                    modifyTVar ps $ \z -> foldr (\x z -> IM.delete x z) z ms 


-- | Sending bulk mail to everybody 
sendBulkMail :: PostOffice -> Letter -> SqlTransaction Connection () 
sendBulkMail po l = liftIO (sendBulkLocal po l) *> sendBulkCentral po l 

sendBulkLocal :: PostOffice -> Letter -> IO ()
sendBulkLocal = undefined 

sendBulkCentral :: PostOffice -> Letter -> SqlTransaction Connection ()
sendBulkCentral = undefined 


-- | Some tools 
milliTime :: IO Time 
milliTime = floor <$> (*1000) <$> getPOSIXTime :: IO Integer


