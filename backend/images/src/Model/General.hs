{-# LANGUAGE RankNTypes, MultiParamTypeClasses, TypeSynonymInstances, FlexibleInstances, FlexibleContexts, NoMonomorphismRestriction, FunctionalDependencies #-}
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
        sempty,
        aget,
        agetlist,
        aload,
        adeny

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

class H.IConnection c => Database c a | a -> c where 
    save :: a -> SqlTransaction c Integer
    load :: Integer -> SqlTransaction c (Maybe a) 
    -- Constraints Orders limit offset
    search :: Constraints -> Orders -> Integer -> Integer -> SqlTransaction c [a]
    delete :: a -> Constraints -> SqlTransaction c ()
    fields :: a -> [(String, String)]
    tableName :: a -> String  


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

{-
 - Asserted record fetching tools; move to some appropriate location later
 -}

-- load a record or run f if not found
aload :: Database Connection a => Integer -> SqlTransaction Connection a -> SqlTransaction Connection a
aload n f = do
    s <- load n
    case s of 
        Nothing -> f 
        Just s -> return s 

-- get one record or run f if none found
aget :: Database Connection a => Constraints -> SqlTransaction Connection a -> SqlTransaction Connection a
aget cs f = do
    ss <- search cs [] 1 0
    case ss of 
        [] -> f 
        x:_ -> return x

-- get list of records or run f if none found
agetlist :: Database Connection a => Constraints -> Orders -> Integer -> Integer -> SqlTransaction Connection [a] -> SqlTransaction Connection [a]
agetlist cs os l o f = do
    ss <- search cs os l o 
    case ss of 
        [] -> f 
        xs -> return xs 

-- run f if any records found. note: return is necessary in order to infer search type.
adeny :: Database Connection a => Constraints -> SqlTransaction Connection [a] -> SqlTransaction Connection [a]
adeny cs f = do
    ss <- search cs [] 1 0
    case ss of 
        [] -> return ss
        xs ->  f 

