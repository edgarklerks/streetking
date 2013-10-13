{-# LANGUAGE TemplateHaskell, OverloadedStrings, FlexibleContexts, NoMonomorphismRestriction, GeneralizedNewtypeDeriving #-}
module NodeSnapletTest where 

import           Config.ConfigFileParser 
import           Control.Applicative
import           Control.Concurrent
import           Control.Monad 
import           Control.Monad.State
import           Control.Concurrent.STM  
import           Control.Monad.Trans
import           Control.Lens hiding (Context)
import           Data.MemTimeState
import           Snap.Core 
import           Snap.Snaplet
import           System.Random 
import qualified Data.Binary as B 
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as L 
import qualified Control.Monad.CatchIO as CIO 
import           GHC.Exception
import qualified Data.Redis as R 

data DHTConfig v = DHC {
               _redis :: Tree B.ByteString v 
    }

newtype NodeTest v a = NodeTest {
            unNodeTest :: StateT (DHTConfig v) IO a
    } deriving (Functor, Applicative, Monad, MonadIO, MonadState DHTConfig, Alternative, MonadPlus)

runNodeTest :: DHTConfig v -> NodeTest a -> IO a 
runNodeTest dhc m = evalStateT (unNodeTest m) dhc 



insertBinary k v = do 
    r <- gets _redis
    liftIO $ R.insert r k v 

find k = do 
    r <- gets _redis 
    liftIO $ R.find r k 



makeLenses ''DHTConfig

initDHTConfig :: FilePath -> SnapletInit b (DHTConfig v)
initDHTConfig fp = makeSnaplet "DistributedHashNodeSnaplet" "distributed hashnode" Nothing $ do 
        xs <- liftIO $ readConfig fp  
        r <- loadTree "root" "node"
        return $ DHC r 
