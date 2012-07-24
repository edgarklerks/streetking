{-# LANGUAGE EmptyDataDecls, RankNTypes, FlexibleInstances,FlexibleContexts, NoMonomorphismRestriction, ExistentialQuantification, MultiParamTypeClasses #-}
module Data.ComposeModel where 

import Data.SqlTransaction 
import Data.Convertible 
import qualified Data.ByteString.Char8 as B 
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


data ComposeMap = ComposeMap {
                     unComposeMap :: H.HashMap String Box
                     }
data Box = forall a. ToInRule a => Box a 

instance Monoid ComposeMap where 
        mempty = ComposeMap $ H.empty 
        mappend (ComposeMap m) (ComposeMap n) = ComposeMap $ m <> n

newtype ComposeMonad c a = CM {
                unCM  :: ReaderT c (WriterT ComposeMap (SqlTransaction c)) a    
            }

instance MonadIO (ComposeMonad c) where 
        liftIO m = CM $ liftIO m 

instance Functor (ComposeMonad c) where 
        fmap f (CM m) = CM (fmap f m)

instance Monad (ComposeMonad c) where 
        return a = CM $ return a
        (>>=) (CM m) f =  CM $ m >>= \a -> (unCM . f) a

instance MonadWriter ComposeMap (ComposeMonad c) where 
    pass (CM m) =  CM (pass m)
    listen (CM m) = CM (listen m)
    tell x = CM (tell x)

instance MonadReader c (ComposeMonad c) where 
        ask = CM $ ask 
        local f (CM m) = CM $ local f m 

instance ToInRule Box where 
            toInRule (Box b) = toInRule b
instance ToInRule ComposeMap where 
            toInRule (ComposeMap xs) = toInRule $ fmap toInRule xs

instance MonadError String (ComposeMonad c) where 
            throwError e = CM $ throwError e
            catchError (CM m) f = CM $  catchError m (unCM . f) 

runComposeMonad (CM m) f c = do -- (ComposeMap xs)
                                ts <- runSqlTransaction (Right <$> (execWriterT (runReaderT m c ))) (\e -> return $ Left e) c 
                                case ts of 
                                    Left s -> f s  
                                    Right (ComposeMap xs) -> return $ (fmap toInRule xs) 




deep :: DB.IConnection c => String -> ComposeMonad c () -> ComposeMonad c ()
deep s (CM m) = do 
            c <- ask
            a <- liftIO $ runSqlTransaction (Right <$> (execWriterT (runReaderT m c))) (\e -> return $ Left e) c
            case a of 
                Right a -> label s a 
                Left s -> throwError s
             

liftDb :: SqlTransaction c a -> ComposeMonad c a 
liftDb m = CM (lift.lift $ m)

action :: (ToInRule a) => String -> SqlTransaction c a -> ComposeMonad c ()
action x s = do 
                 a <- liftDb s  
                 label x a 

label :: (ToInRule a) => String -> a -> ComposeMonad c ()
label s x =  tell $ ComposeMap $ H.fromList [(s,Box x)]

db :: IO Connection 
db = connectPostgreSQL "user=deosx dbname=streetking_dev password=#*rl& host=db.graffity.me"
