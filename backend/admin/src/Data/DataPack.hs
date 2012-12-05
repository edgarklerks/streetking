{-# LANGUAGE FlexibleContexts, FlexibleInstances, TypeSynonymInstances, FunctionalDependencies, MultiParamTypeClasses, OverloadedStrings, RankNTypes #-}

module Data.DataPack (
        Data,
        emptyData,
        Pack,
        emptyData,
        setField,
        (.>),
        (.<),
        getField,
        getFieldWithDefault,
        getFieldForced,
        (.<<),
        packData,
        unpackData,
        DataM,
        set,
        get,
        readData,
        withData,
        mkData 

    ) where

import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Lazy as LB
import qualified Data.ByteString.Lazy.Char8 as LBC
import qualified Data.Aeson as AS
import qualified Data.Conversion as IR 
import           Control.Monad.Error
import           Data.HashMap.Strict as HM
import           Data.Maybe
import           Data.Default

type Key = LB.ByteString
newtype Data = Data {
             unData ::  HM.HashMap Key AS.Value
            } deriving (Show, Eq)

type Pack = C.ByteString -- TODO: InRule support for ByteString.Lazy to allow Pack to be of this type

-- empty data
emptyData :: Data
emptyData = Data $ HM.empty 

-- set data field
setField :: forall a. AS.ToJSON a => (Key, a) -> Data -> Data
setField (k, v) (Data d) = Data $ HM.insert k (AS.toJSON v) d

(.>) :: forall a. AS.ToJSON a => (Key, a) -> Data -> Data
(.>) = setField
infixr 7 .>

-- get data field of specified type
getField :: forall a. AS.FromJSON a => Key -> Data -> Maybe a
getField k (Data d) = case fmap AS.fromJSON $ HM.lookup k d of
        Just (AS.Success v) -> Just v
        _ -> Nothing

(.<) :: forall a. AS.FromJSON a => Key -> Data -> Maybe a
(.<) = getField
infixr 7 .<

-- get data field with default
getFieldWithDefault :: forall a. AS.FromJSON a => a -> Key -> Data -> a 
getFieldWithDefault f k d = maybe f id $ getField k d

-- force get data field
getFieldForced :: forall a. AS.FromJSON a => Key -> Data -> a
getFieldForced k d = getFieldWithDefault (error $ "Data: force get: field not found") k d

{-
getm :: (MonadError String m, AS.FromJSON a) => Key -> Data -> m a
getm k d = case get k d of 
            Just a -> return a 
            Nothing -> throwError $ strMsg $ "Data: force get: field not found: " ++ (LBC.unpack k)
-}

(.<<) :: forall a. AS.FromJSON a => Key -> Data -> a
(.<<) = getFieldForced
infixr 7 .<<

-- pack data
packData :: forall a. AS.ToJSON a => a -> Pack 
packData = C.pack . LBC.unpack . AS.encode

-- unpack data
unpackData :: forall a. AS.FromJSON a => Pack -> Maybe a
unpackData = AS.decode . LBC.pack . C.unpack

-- force unpack data
unpackDataForced :: forall a. AS.FromJSON a => Pack -> a
unpackDataForced = fromJust . AS.decode . LBC.pack . C.unpack


instance Default Data where
    def = emptyData

-- InRule instances to allow Data as a record field.
-- NOTE: the path Data -> InRule -> HashMap -> JSON causes Data to end up as a JSON string inside the JSON object.
-- TODO: use InObject or update InRules to accomodate Data.
instance IR.ToInRule Data where
    toInRule d = IR.toInRule $ packData (unData d) 
instance IR.FromInRule Data where
    fromInRule (IR.InByteString s) = Data $ maybe (error "FromInRule to Data conversion failed") id $ unpackData s
    fromInRule _ = error "You gave not a ByteString"

instance AS.FromJSON Data where 
        parseJSON xs = fmap Data $ AS.parseJSON xs 

instance AS.ToJSON Data where 
        toJSON (Data a) =  AS.toJSON a

-- Data Monad

newtype DataM s a = DM { unDM :: s -> (a, s) }

instance Monad (DataM s) where
    return a = DM $ \d -> (a, d)
    (>>=) m k = DM $ \d -> let (a, d') = unDM m d in unDM (k a) d'

set :: forall a. AS.ToJSON a => Key -> a -> DataM Data ()
set k v = DM $ \s -> ((), setField (k, v) s)

get :: forall a. AS.FromJSON a => Key -> DataM Data a
get k = DM $ \s -> (getFieldForced k s, s)

readData :: Data -> DataM Data a -> a
readData d m = fst $ unDM m d 

withData :: Data -> DataM Data () -> Data
withData d m = snd $ unDM m d 

mkData :: DataM Data () -> Data
mkData = withData emptyData


