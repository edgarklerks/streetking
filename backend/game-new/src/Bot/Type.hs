{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Bot.Type (
        RandomM(..),
        RandomRequest,
        ParamMap,
        -- | The route of the request 
        Route,
        runRandomIO,
        runRandomM,
        AlphaNumeric(..)
    )where 

import Control.Monad.State hiding (foldM_, foldM, forM_, forM) 
import Control.Monad.Reader hiding (foldM, foldM_, forM, forM_) 
import qualified Data.ByteString.Char8 as B 
import qualified Data.ByteString.Lazy.Char8 as BL 
import Control.Applicative 
import Data.Conversion 
import qualified Snap.Test as S 
import System.Random 
import qualified Data.HashMap.Strict as S
import Test.QuickCheck 
import qualified Data.List as L 

newtype RandomM g c a = RandomM {
                unRandomM :: ReaderT c (StateT g IO) a 
            } deriving (Functor, Monad, MonadState g, MonadReader c, MonadIO, Applicative)

newtype AlphaNumeric = AN {
        unAN :: String 
    }
instance Arbitrary BL.ByteString where 
        arbitrary = BL.pack <$> arbitrary 
        shrink bs = BL.tails bs 

instance Arbitrary B.ByteString where 
        arbitrary = B.pack <$> arbitrary 
        shrink bs = B.tails bs 

instance Arbitrary AlphaNumeric where 
        arbitrary = do 
            xs <- listOf $ elements $ ['0'..'9'] ++ ['a'..'z'] ++ ['A'..'Z']

            return $ AN xs 
        shrink (AN xs) =  AN <$> L.tails xs 

type RandomRequest g c = S.RequestBuilder (RandomM g c)
type ParamMap = S.HashMap String InRule 
type Route = B.ByteString  

-- | Run a test with a random seed in the IO monad 
runRandomIO :: c -> RandomM StdGen c a -> IO a 
runRandomIO c m = do 
            g <- newStdGen 
            runRandomM g c m

-- | Run a test with a determined seed in the IO monad 
runRandomM :: g -> c -> RandomM g c a -> IO a 
runRandomM g c m = evalStateT (runReaderT (unRandomM m) c) g 



