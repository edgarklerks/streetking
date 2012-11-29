{-# LANGUAGE RankNTypes, FlexibleInstances, FlexibleContexts,
     NoMonomorphismRestriction, ExistentialQuantification,
     MultiParamTypeClasses, GeneralizedNewtypeDeriving #-}

module Data.ComposeModel(
        action,
        label,
        runComposeMonad,
        ComposeMonad,
        deep,
        abort,
        liftDb,
        getComposeUser
    )where 

import Data.SqlTransaction 
import Data.Convertible 
import qualified Data.ByteString.Char8 as B 
import qualified Data.ByteString.Lazy.Char8 as BL 
import qualified Database.HDBC as DB
import qualified Data.HashMap.Strict as H
import Data.InRules
import Data.Conversion 
import Control.Monad.Writer 
import Control.Monad.Reader
import Data.Monoid 
import Control.Arrow
import Control.Applicative
import Control.Monad.Error 
import Database.HDBC.PostgreSQL
import Control.Concurrent
import qualified Model.Account as A 
import qualified Model.Garage as G 
import Model.General
import Data.Database
import Data.Aeson 
import Control.Monad.Cont 
import qualified LockSnaplet as L 





data ComposeMap = ComposeMap {
                     unComposeMap :: H.HashMap String Box
                     }
data Box = forall a. ToInRule a => Box a 

instance Monoid ComposeMap where 
        mempty = ComposeMap  H.empty 
        mappend (ComposeMap m) (ComposeMap n) = ComposeMap $ m <> n



newtype ComposeMonad r c a = CM {
                unCM  :: ContT r (ReaderT c (WriterT ComposeMap (SqlTransactionUser L.Lock c))) a    
            } deriving (Functor, Applicative, Monad, MonadReader c, MonadIO, MonadCont) 


getComposeUser = CM $ lift $ lift $ lift getUser 

instance MonadError String (ComposeMonad r c) where 
            throwError c = CM $ lift (throwError c)
            catchError m f = CM $ ContT $ \r -> do 
                      x <- catchError (Right <$> runContT (unCM m) r) (return . Left)
                      case x of 
                        Left s -> runContT (unCM (f s)) r 
                        Right a -> return a


instance MonadWriter ComposeMap (ComposeMonad r c) where 
                tell w = CM $ lift (tell w) 
                listen _ = throwError "ComposeMonad doesn't support listen"
                pass _ = throwError "ComposeMonad doesn't support pass"

instance Alternative (ComposeMonad r c) where 
                empty = throwError "empty alternative"
                (<|>) m n = catchError m (const n)

instance MonadPlus (ComposeMonad r c) where 
                mzero = empty 
                mplus = (<|>)

instance Monoid (ComposeMonad r c ()) where 
                mempty = empty 
                mappend a b = CM $ ContT $ \r -> do 
                                c <- ask 
                                a <-  lift $ lift $ (execWriterT (runReaderT (runContT  (unCM a) r) c))
                                b <-  lift $ lift $ (execWriterT (runReaderT (runContT  (unCM b) r) c))
                                lift $ tell (a <> b)
                                r ()

                
unsafeRunCompose l c (CM m) = runSqlTransaction (fmap Right . execWriterT $ runReaderT (runContT m (return)) c) (return . Left) c l



instance ToInRule Box where 
            toInRule (Box b) = toInRule b
instance ToInRule ComposeMap where 
            toInRule = toInRule . fmap toInRule . unComposeMap 

-- runComposeMonad :: (Applicative m, MonadIO m) => ComposeMonad a Connection a -> (String -> m (H.HashMap String InRule)) -> Connection -> m (H.HashMap String InRule)
runComposeMonad l m f c = do -- (ComposeMap xs)
                                ts <- unsafeRunCompose l c m 
                                case ts of 
                                    Left s -> f s  
                                    Right (ComposeMap xs) -> return $ (fmap toInRule xs) 



deep :: String -> ComposeMonad a Connection a -> ComposeMonad r Connection ()
deep s m = do 
            c <- ask
            l <- getComposeUser 
            a <- liftIO $ unsafeRunCompose l c m 
            case a of 
                Right a -> label s a 
                Left s -> throwError s

jumpDeep = abort () 

shift m = CM $ do 
    ContT $ \r -> do 
        runContT (m $ \u -> runContT (return u) r) return  

liftDb :: SqlTransaction  c a -> ComposeMonad r c a 
liftDb = CM . lift . lift  . lift 

action :: (ToInRule a) => String -> SqlTransaction c a -> ComposeMonad r c a 
action x s = do 
                s' <- liftDb s 
                label x s' 
                return s'

label :: (ToInRule a) => String -> a -> ComposeMonad r c ()
label s x =  tell . ComposeMap . H.fromList $ [(s,Box x)]

db :: IO Connection 
db = connectPostgreSQL "user=deosx dbname=streetking_dev password=#*rl& host=db.graffity.me"


abort m = CM $ ContT $ \abort -> return m 


runTest m = do 
            c <- db 
            runComposeMonad (error "do not use") m error c

expand :: ToInRule a => [(String, a)] -> ComposeMonad r c ()
expand xs = forM_ xs $ \(s,x) -> label s x 

