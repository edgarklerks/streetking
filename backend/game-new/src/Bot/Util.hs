{-# LANGUAGE ScopedTypeVariables, OverloadedStrings, ViewPatterns,
 MultiParamTypeClasses #-}
module Bot.Util (
        runTest,
        runDb,
        runDbRaw, 
        runSite,
        asInRule,
        RandomSeq(..),
        testCarUsers,
        humanString,
        mkJsonPost,
        testUsers,
        testUser1,
        testUser2,
        testUser3,
        testUser4,
        getCar, 
        randomsRange,
        randomsSeq,
        testcon,
        IsomorphT(..),
        smallArgs 

) where 


import Bot.Type 
import Snap.Snaplet 
import Snap.Snaplet.Config
import qualified Database.HDBC as H
import Snap.Core 
import Control.Monad.Trans 
import qualified Snap.Test as S 
import qualified Data.HashMap.Strict as S
import Data.SqlTransaction 
import qualified Model.CarInGarage as CIG 
import Model.General 
import Data.Database hiding (Value) 
import Data.DatabaseTemplate 

import Database.HDBC.SqlValue 
import Data.Maybe 
import Control.Applicative 
import Data.Conversion
import Data.Aeson 
import qualified Data.ByteString.Lazy.Char8 as BL 
import qualified Data.ByteString.Char8 as B 
import Data.Monoid 
import Site 
import Database.HDBC.PostgreSQL
import System.Random 
import Control.Monad.State 
import Test.HUnit 
import Control.Monad.Reader 
import Test.QuickCheck 
runTest :: Test -> RandomM g c Counts 
runTest = liftIO . runTestTT 

-- | Run a SqlTransaction in the RandomM monad 
runDb m = ask >>= \c -> (liftIO $ do 
            a <- runSqlTransaction m  (\x -> print x >> return undefined ) c undefined
            return a)


runDbRaw c m = liftIO $ do 
            runSqlTransaction m (\x -> print x >> return undefined) c undefined 




testcon = connectPostgreSQL "host=192.168.4.9 password=wetwetwet  user=postgres dbname=postgres"
{--         
-
-
-           Utility functions for tests 
-
-
--}


runSite :: RandomRequest g c () -> RandomM g c Response 
runSite req = do 
        (msgs, site, cleanup) <- liftIO $ runSnaplet Nothing (app False)
        S.runHandler req site 

asInRule :: RandomRequest g c () -> RandomM g c InRule 
asInRule req = do 
            b <- runSite req
            n <- liftIO $ S.getResponseBody b
            case decode (BL.fromChunks [n]) of 
                        Nothing -> return InNull
                        Just (x :: Value) -> return (toInRule x)


-- | Creates an json post request 
mkJsonPost :: Route -> ParamMap -> RandomRequest g c ()
mkJsonPost r s = S.postRaw r "text/json" (mconcat $ BL.toChunks $ encode $ (fromInRule :: InRule -> Value) $ toInRule s) 

-- | Some test users 
testUser1 :: Integer 
testUser1 = 36
testUser2 :: Integer 
testUser2 = 34 
testUser3 :: Integer 
testUser3 = 33 
testUser4 :: Integer 
testUser4 = 71 

-- | A list of test users 
testUsers = [testUser1, testUser2, testUser3, testUser4]

-- | testCarUsers returns a (user, active_car) tuple
testCarUsers :: RandomM g Connection [(Integer, Integer)]
testCarUsers = runDb $ do 
            r <- search ["active" |== (toSql True) .&& "ready" |== (toSql True) 
                         ] [] 100 0 :: SqlTransaction Connection [CIG.CarInGarage]

            return $ foldr step []  r 
    where step x z = (CIG.account_id x, fromJust $ CIG.id x) : z

-- | get a car from the user account
getCar :: Integer -> RandomM g Connection Integer
getCar uid = runDb $ do 
            r <- sqlGetOne "select id from garage where account_id = ?" [toSql uid]
            s <- sqlGetOne "select id from car_instance where deleted = false and garage_id = ?" [r]
            return (fromSql s :: Integer)

class RandomSeq m c where 
        randomSeq :: m c
        randomRange :: Bounded c => (c,c) -> m c 

instance RandomGen g => RandomSeq (RandomM g c) Int where 
        randomSeq = do 
                g <- get 
                let (a, g1) = random g 
                put g1
                return a
        randomRange (lb,ub) = do 
                        g <- get 
                        let (a, g1) = randomR (lb, ub) g 
                        put g1
                        return a

instance RandomGen g => RandomSeq (RandomM g c) Integer where 
        randomSeq = do 
                g <- get 
                let (a, g1) = random g 
                put g1
                return a
        randomRange (lb,ub) = do 
                        g <- get 
                        let (a, g1) = randomR (lb, ub) g 
                        put g1
                        return a


instance RandomGen g => RandomSeq (RandomM g c) Char where 
        randomSeq = do 
                g <- get 
                let (a, g1) = random g 
                put g1
                return a
        randomRange (lb,ub) = do 
                        g <- get 
                        let (a, g1) = randomR (lb, ub) g 
                        put g1
                        return a





unfoldr :: (b -> (a, b)) -> b -> [a]
unfoldr f b = let (a, c) = f b 
              in a : unfoldr f c 

randomsSeq :: (RandomGen g, Random a) =>  RandomM g c [a] 
randomsSeq  = do 
                 (split -> (g1, g2)) <- get
                 put g2 
                 return $ (unfoldr step g1)
            where step g = random g 


randomsRange :: (RandomGen g, Random a) => (a,a) -> RandomM g c [a]
randomsRange (lb, ub) = do 
                    (split -> (g1,g2)) <- get 
                    put g2
                    return $ unfoldr step g1
           where step g = randomR (lb, ub) g


humanString :: RandomGen g => RandomM g c String 
humanString = do 
        s <- randomsRange ('a','z')
        t <- randomsRange ('A','Z')
        return $ take 20 $ s `interleave` t


interleave :: [a] -> [a] -> [a]  
interleave (x:xs) (y:ys) = x : y : interleave xs ys 
interleave xs [] =  xs 
interleave [] ys = ys 

newtype IsomorphT = IsomorphT {
        unIsomorphT :: InRule 
    } deriving Show
{-- 
 - The bijective map  of a subset of InRule with Value is: 
 - InInteger Integer            <->      Number (I Integer)
 - InDouble  Double             <->      Number (D Double)
 - InByteString B.ByteString    <->      String (Text) 
 - InArray  [InRule]            <->      Array (Vector Value)  
 - InObject M.Map String InRule <->      Object M.Map Text Value  
 - InBool Bool                  <->      Bool Bool
 - InNull                       <->      Null
 -
 ---}
 --
smallArgs = Args {
        replay = Nothing,
        maxSuccess = 10000,
        maxSize = 40,
        chatty = True,
        maxDiscard = 10
    }

instance Arbitrary IsomorphT where 
    arbitrary = do 
        let int = arbitrary :: Gen Integer
        let dbl = arbitrary :: Gen Double 
        let str = arbitrary :: Gen String
        let arr = listOf arbitrary :: Gen [IsomorphT]
        let obj = listOf arbitrary :: Gen [(String, IsomorphT)]
        let bl = arbitrary :: Gen Bool 
        let ps = [(1900,fmap InDouble dbl), (1900, fmap InInteger int), (1900, fmap (InByteString . B.pack) $ str), (250, fmap (InObject . S.fromList . fmap (\(x,y) -> (x,unIsomorphT y))) obj), (250, fmap (InArray . fmap unIsomorphT) arr), (1900, fmap InBool bl), (1900,return InNull)]
        fmap IsomorphT $ frequency ps

instance Arbitrary Value where 
    arbitrary = fromInRule . unIsomorphT <$> (arbitrary :: Gen IsomorphT)
