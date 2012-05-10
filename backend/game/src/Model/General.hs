{-# LANGUAGE RankNTypes, MultiParamTypeClasses, TypeSynonymInstances, FlexibleInstances, FlexibleContexts, NoMonomorphismRestriction #-}
module Model.General
    (
        module Data.Default,
        Database(..),
        Mapable(..),
        Id,
        nlookup,
        nempty,
        htsql,
        thsql,
        ninsert,
        sinsert,
        mlookup,
        mco,
        mfp,
        nhead,
        sempty

    )

where 


import           Data.SqlTransaction
import qualified Data.HashMap.Strict as S  
import qualified Data.Map as M 
import qualified Database.HDBC as H
import qualified Data.Aeson as A
import           Data.Maybe 
import           Data.Convertible
import           Control.Monad
import           Data.Database
import           Data.Default
import           Data.Hstore 

class H.IConnection c => Database c a where 
    save :: a -> SqlTransaction c Integer
    load :: Integer -> SqlTransaction c (Maybe a) 
    -- Constraints Orders limit offset
    search :: Constraints -> Orders -> Integer -> Integer -> SqlTransaction c [a]
    delete :: a -> Constraints -> SqlTransaction c ()


class Mapable a where 
    fromMap :: M.Map String SqlValue -> Maybe a
    toMap :: a -> M.Map String SqlValue  
    fromHashMap :: S.HashMap String SqlValue -> Maybe a 
    toHashMap :: a -> S.HashMap String SqlValue 
    updateMap :: M.Map String SqlValue -> a -> a 
    updateHashMap :: S.HashMap String SqlValue -> a -> a
    updateMap x a = fromJust $ fromMap (M.union x $ toMap a)
    updateHashMap x a = fromJust $ fromHashMap (S.union x $ toHashMap a) 


type Id = Maybe Integer 


mlookup :: Convertible SqlValue a => String -> M.Map String SqlValue -> Maybe a 
mlookup = (fmap convert .). M.lookup 

sempty :: M.Map String SqlValue 
sempty = M.empty 

sinsert = M.insert

htsql :: Convertible a H.SqlValue => a -> H.SqlValue 
htsql = convert

nempty :: S.HashMap String SqlValue 
nempty = S.empty 

ninsert = S.insert 

nlookup :: Convertible SqlValue a => String -> S.HashMap String SqlValue -> Maybe a
nlookup = (fmap convert .). S.lookup 

nhead = ((fmap . fmap) join . fmap) (fmap fromHashMap . listToMaybe)
thsql :: H.SqlValue -> Integer 
thsql = convert 
mco = (fmap) thsql 

mfp = (fmap catMaybes) . (fmap.fmap) fromHashMap


