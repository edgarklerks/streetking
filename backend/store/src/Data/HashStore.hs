{-# LANGUAGE NoMonomorphismRestriction, ViewPatterns, GeneralizedNewtypeDeriving, ScopedTypeVariables, FlexibleContexts, FlexibleInstances, OverloadedStrings, RankNTypes, ImpredicativeTypes #-}
module Data.HashStore where 

import Control.Monad
import Control.Applicative
import Control.Monad.State.Strict
import Control.Monad.Trans

import qualified Data.HashMap.Strict as H
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as C
import Control.Concurrent
import Control.Concurrent.STM.TVar
import Control.Concurrent.STM
import qualified Data.Serialize as S
import System.IO
import qualified Data.Foldable as F 
import qualified Data.Hashable as H
import Control.Arrow 
import Data.Word
import Data.Monoid
import System.Directory
import Control.Monad.Error 
import Data.String
import Test.QuickCheck
import Test.QuickCheck.Property
import Prelude hiding (lookup)
import System.IO.Unsafe
import Debug.Trace 
import Data.List (nub)
import Data.HashQuery 


data HashStore a = HS {
                    unHS :: TMVar (H.HashMap B.ByteString (TVar a)),
                    lock :: TMVar (),
                    tmp :: FilePath,
                    index :: FilePath,
                    database :: FilePath,
                    indexMap :: Maybe Index 
                }


newtype HashMonad b m a = HM {
                    unHM :: ErrorT String (StateT (HashStore b) m) a 
                } deriving (Functor, Applicative, Monad, Alternative, MonadPlus, MonadFix, MonadError String, MonadIO, MonadState (HashStore b))


instance MonadTrans (HashMonad b) where 
        lift = HM . lift . lift


runHashMonad :: Monad m => HashMonad b m a -> m (Either String a) 
runHashMonad a = evalStateT (runErrorT $ unHM a) (error "blackhole")

evalHashMonad :: Monad m => HashStore b -> HashMonad b m a -> m (Either String a)
evalHashMonad f a = evalStateT (runErrorT $ unHM a)  f


runSafe :: (Monad m) => HashMonad b m a -> HashMonad b m (Either String (HashStore b, a))
runSafe m = do 
            p <- get 
            a <- lift $ evalHashMonad p (m >>= \x -> get >>= \s -> return (s,x)) 
            return a

type HM m a = forall b. HashMonad b m a

newtype Index = Index {
            unIndex :: H.HashMap B.ByteString IndexObject  
    }

data IndexObject = IndexObject {
            pos :: Word64,
            size :: Word64
    } deriving (Show, Read)

instance (Eq k, S.Serialize k, H.Hashable k, S.Serialize v) => S.Serialize (H.HashMap k v) where 
        put = S.put . H.toList 
        get = H.fromList <$> S.get


instance S.Serialize IndexObject where 
        put (IndexObject p s) = S.put p *> S.put s
        get = IndexObject <$> S.get <*> S.get

instance S.Serialize Index  where 
        put = S.put . unIndex 
        get = Index <$> S.get

{-- Index 
-  key:pos:size 
--}

newHashStore :: (Functor m, S.Serialize b, MonadIO m) => FilePath -> FilePath -> FilePath -> HashMonad b m () 
newHashStore db idx tmp =  do 
               p <- liftIO $ newTMVarIO H.empty 
               s <- liftIO $ newTMVarIO ()
               b <- liftIO $ doesFileExist idx 
               case b of 
                True -> do 
                    put $ ( HS p s tmp idx db Nothing)
                    loadIndex 
                    return ()
                False -> do 
                    put $ HS p s tmp idx db Nothing 
                    writeHashStore 
                        

readTMVarIO = liftIO . atomically . readTMVar 

delete :: (Functor m, S.Serialize b, MonadIO m) =>  B.ByteString -> HashMonad b m ()
delete k = do 
            f <- unHS <$> get
            p <- readTMVarIO f 
            case H.lookup k p of 
                    Nothing -> return ()
                    Just x -> liftIO $ atomically $ do 
                                s <- takeTMVar f 
                                putTMVar f (H.delete k s) 

            
lookup :: (Functor m, S.Serialize b, MonadIO m) => B.ByteString -> HashMonad b m b  
lookup k = do 
                 f <- get 
                 p <- readTMVarIO (unHS f)
                 case H.lookup k p of 
                            Nothing -> do 
                                          a <- loadFromDisk k
                                          insert k a 
                                          return a
                            Just a -> liftIO $ atomically $ readTVar a 



update :: (Functor m, MonadIO m, S.Serialize a) => B.ByteString -> (a -> a) -> HashMonad a m () 
update k v = do 
                  f <- get 
                  p <- readTMVarIO (unHS f)
                  case H.lookup k p of 
                            Nothing -> do 
                                        a <- loadFromDisk k 
                                        insert k a 
                                        return () 
                            Just tv -> liftIO $ atomically $ modifyTVar tv v 
                                
test = runHashMonad $ do 
                newHashStore "shit1" "shit2" "shit3" :: HashMonad String IO ()
                x <- get
                insert "a" "a"
                insert "" ""
                insert "\ETX" "\ETX" 
                writeHashStore

test2 :: IO (Either String String)
test2 = runHashMonad $ do 
                newHashStore "shit1" "shit2" "shit3" :: HashMonad String IO ()
                lookup "\ETX" 


insert :: MonadIO m => B.ByteString -> b -> HashMonad b m () 
insert k v = do 
        f <- get    
        liftIO $ do 
            p <- readTMVarIO (unHS f)
            case H.lookup k p of 
                      Nothing -> atomically $ do 
                            takeTMVar (unHS f) 
                            e <- newTVar v
                            putTMVar (unHS f) (H.insert k e p) 
                      Just tv -> atomically $ do 
                            writeTVar tv v



writeHashStore :: (MonadIO m, S.Serialize b, Functor m) =>  HashMonad b m ()
writeHashStore  = get >>= \st@(tmp -> h) -> do 
                            xs <- liftIO $ atomically $ takeTMVar (unHS st)
                            fp <- liftIO $ openBinaryFile h WriteMode 
                            withLock $ do 
                                i <- loadIndex               
                                evalStateT (step st fp $ H.toList xs) (unIndex i,0)
                            liftIO $ atomically $ putTMVar (unHS st) xs
    where step :: (MonadIO m, S.Serialize a, Functor m) => HashStore a -> Handle -> [(B.ByteString, TVar a)] -> StateT (H.HashMap B.ByteString IndexObject, Integer) m ()
          step st h [] = do 
                    m <- gets fst
                    liftIO $ B.writeFile (index st) $ S.encode m
                    liftIO $ hFlush h *> hClose h 
                    liftIO $ void $ forkIO $ renameFile (tmp st) (database st)
                    
          step st h (x':xs) = do 
                    l <- toInteger <$> getPos
                    x <- liftIO $ atomically $ readTVar (snd x')
                    let blockData = S.encode x 
                    let block = blockData 
                    s <- liftIO $ B.hPutStr h block *> hTell h 
                    setPos s 
                    insertMap (fst x') (IndexObject (fromInteger l) (fromInteger $ s - l))
                    step st h xs

          getPos = gets snd 
          setPos = modify . second . const  
          insertMap k = modify . first . H.insert k
          writeBlock b = B.hPutStr

loadFromDisk :: (S.Serialize b, Functor m, MonadIO m) => B.ByteString -> HashMonad b m b 
loadFromDisk b = do 
                    s <- withLock $ loadIndex 
                    case H.lookup b (unIndex s) of 
                            Nothing -> throwError $ "no such key " <-> b 
                            Just x -> withLock $ do 
                                db <- gets database 
                                fp <- liftIO $ openBinaryFile db ReadMode  
                                liftIO $ hSeek fp AbsoluteSeek (toInteger $ pos x)
                                xs <- liftIO $ B.hGet fp (fromIntegral $ size x) 
                                liftIO $ hClose fp
                                liftEither (S.decode xs)




loadIndex :: (Functor m, MonadIO m) => HashMonad b m Index
loadIndex = do 
            h <- get
            case indexMap h of 
                    Nothing -> do 
                        s <- liftIO $ B.readFile (index h)
                        a <- liftEither $ S.decode s
                        put $ h { indexMap = Just a }
                        return a
                    Just a -> return a

liftEither :: (Monad m) => Either String a -> HashMonad b m a 
liftEither  = HM . ErrorT . return  

(<->) c f = c <> C.unpack f 


lockDB :: (Monad m, Functor m, MonadIO m) => HashMonad b m ()
lockDB = get >>= void . (liftIO . atomically . takeTMVar) . lock 

unlockDB :: (Monad m, Functor m, MonadIO m ) => HashMonad b m ()
unlockDB = get >>= liftIO . atomically . flip putTMVar ()  . lock 

withLock :: (Monad m, Functor m, MonadIO m) => HashMonad b m a -> HashMonad b m a
withLock f = lockDB  *> f <* unlockDB


runQuery :: (S.Serialize b, Functor m, MonadIO m) => HashQuery b -> HashMonad b m (Maybe b)
runQuery (Add a b) = do d <- runSafe $ insert a b *> return Nothing 
                        case d of 
                            Left s -> return Nothing 
                            Right (s,p) -> put s *> return p 
runQuery (Remove a) = do d <- runSafe $ delete a *> return Nothing 
                         case d of 
                            Left s -> return Nothing 
                            Right (s,p) -> put s *> return p
runQuery (Search a) = do d <- runSafe $ lookup a
                         case d of 
                            Left s -> return Nothing 
                            Right (s,p) -> put s *> return (Just p)

