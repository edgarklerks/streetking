{-# LANGUAGE GeneralizedNewtypeDeriving, FlexibleInstances, MultiParamTypeClasses, FunctionalDependencies #-}
module Data.SqlTransaction (
    atomical,
    prepare,
    quickQuery,
    quickQuery',
    rollback,
    run,
    sRun,
    execute,
    executeMany, 
    executeRaw,
    sExecute,
    sExecuteMany,
    fetchRow,
    fetchRowAl,
    fetchRowMap,
    fetchAllRows,
    fetchAllRows',
    fetchAllRowsAL,
    fetchAllRowsAL',
    fetchAllRowsMap,
    sFetchRow, 
    sFetchAllRows,
    sFetchAllRows',
    finish,
    SqlTransaction,
    runSqlTransaction,
    H.SqlValue(..),
    H.IConnection,
    H.Statement,
    H.disconnect,
    sqlGetOne,
    sqlGetRow,
    sqlGetAll,
    sqlGetAllAssoc,
    sqlExecute,
	quickInsert,
    Connection

) where 

import Data.Function 
import Data.Functor
import Control.Applicative
import Control.Monad 
import Control.Monad.Error 
import Control.Monad.Reader
import Control.Monad.Trans
import Data.Monoid
import Data.Tools
import Data.Convertible
import Data.Map (Map)
import qualified Database.HDBC as H
import qualified Data.HashMap.Strict as M
import Database.HDBC.PostgreSQL

newtype SqlTransaction c a = SqlTransaction {
        unsafeRunSqlTransaction :: ReaderT c (ErrorT String IO) a 
 } deriving (Functor, Alternative, Applicative, Monad, MonadPlus, MonadFix, MonadReader c, MonadError String, MonadIO) 

--instance Convertible a a where 
--	safeConvert = Right . id

atomical :: H.IConnection c => SqlTransaction c a -> SqlTransaction c a 
atomical trans = ask >>= \c -> liftIO (H.commit c) >> catchError trans throwError  >>= \a ->  (liftIO . H.commit $ c) >> return a

runSqlTransaction :: (MonadIO m, H.IConnection c, Applicative m) => SqlTransaction c a -> (String -> m a) -> c -> m a 
runSqlTransaction xs f c = do
                                liftIO $ H.commit c
                                x <- liftIO $ runErrorT (runReaderT (unsafeRunSqlTransaction xs ) c)
                                case x of 
                                    Left b -> liftIO (H.rollback c) *> f b <* liftIO (H.commit c)
                                    Right a -> liftIO (H.commit c) >> return a
                               
 
prepare ::  H.IConnection c =>  String -> SqlTransaction c H.Statement 
prepare s = ask >>= liftIO . flip H.prepare s

quickQuery :: H.IConnection c => String -> [H.SqlValue] -> SqlTransaction c [[H.SqlValue]]   
quickQuery s xs = ask >>= liftIO . flip (flip H.quickQuery s) xs

quickQuery' :: H.IConnection c => String -> [H.SqlValue] -> SqlTransaction c [[H.SqlValue]]
quickQuery' s xs = ask >>= liftIO . flip (flip H.quickQuery' s) xs 

rollback :: String -> SqlTransaction m t 
rollback = throwError 

run :: H.IConnection c => String -> [H.SqlValue] -> SqlTransaction c Integer  
run s xs = ask >>= liftIO . flip (flip H.run s) xs

sRun :: H.IConnection c => String -> [Maybe String] -> SqlTransaction c Integer 
sRun s xs = ask >>= liftIO . flip (flip H.sRun s) xs

execute :: H.IConnection c => H.Statement -> [H.SqlValue] -> SqlTransaction c Integer 
execute s = liftIO .  H.execute s 

executeMany :: H.IConnection c => H.Statement -> [[H.SqlValue]] ->  SqlTransaction c () 
executeMany s = liftIO . H.executeMany s

executeRaw :: H.IConnection c => H.Statement -> SqlTransaction c ()
executeRaw = liftIO . H.executeRaw

sExecute :: H.IConnection c => H.Statement -> [Maybe String] -> SqlTransaction c Integer  
sExecute s = liftIO . H.sExecute s 

sExecuteMany :: H.IConnection c => H.Statement -> [[Maybe String]] -> SqlTransaction c () 
sExecuteMany s = liftIO . H.sExecuteMany s 

fetchRow :: H.IConnection c => H.Statement -> SqlTransaction c (Maybe [H.SqlValue])  
fetchRow = liftIO . H.fetchRow 

fetchRowAl :: H.IConnection c => H.Statement -> SqlTransaction c (Maybe [(String, H.SqlValue)])   
fetchRowAl = liftIO . H.fetchRowAL

fetchRowMap :: H.IConnection c => H.Statement -> SqlTransaction c (Maybe (Map String H.SqlValue))
fetchRowMap = liftIO . H.fetchRowMap

fetchAllRows :: H.IConnection c => H.Statement -> SqlTransaction c ([[H.SqlValue]]) 
fetchAllRows = liftIO . H.fetchAllRows

fetchAllRows' :: H.IConnection c => H.Statement -> SqlTransaction c ([[H.SqlValue]])
fetchAllRows' = liftIO . H.fetchAllRows 

fetchAllRowsAL :: H.IConnection c => H.Statement -> SqlTransaction c ([[(String, H.SqlValue)]])
fetchAllRowsAL = liftIO . H.fetchAllRowsAL

fetchAllRowsAL' :: H.IConnection c => H.Statement -> SqlTransaction c ([[(String, H.SqlValue)]])
fetchAllRowsAL' = liftIO . H.fetchAllRowsAL'

fetchAllRowsMap :: H.IConnection c => H.Statement -> SqlTransaction c [Map String H.SqlValue]
fetchAllRowsMap = liftIO . H.fetchAllRowsMap

fetchAllRowsMap' :: H.IConnection c => H.Statement -> SqlTransaction c [Map String H.SqlValue]
fetchAllRowsMap' = liftIO . H.fetchAllRowsMap'

sFetchRow :: H.Statement -> SqlTransaction c (Maybe [Maybe String])   
sFetchRow = liftIO . H.sFetchRow

finish :: H.Statement -> SqlTransaction c ()
finish = liftIO . H.finish

sFetchAllRows :: H.IConnection c => H.Statement -> SqlTransaction c [[Maybe String]]  
sFetchAllRows = liftIO . H.sFetchAllRows

sFetchAllRows' :: H.IConnection c => H.Statement -> SqlTransaction c [[Maybe String]]  
sFetchAllRows' = liftIO . H.sFetchAllRows'

sqlGetOne :: H.IConnection c => String -> [H.SqlValue] -> SqlTransaction c H.SqlValue
sqlGetOne s =  fmap (head . head) .  quickQuery' s 

sqlGetRow :: H.IConnection c => String -> [H.SqlValue] -> SqlTransaction c [H.SqlValue]
sqlGetRow s = fmap (head) . quickQuery' s  

sqlGetAll :: H.IConnection c => String -> [H.SqlValue] -> SqlTransaction c [[H.SqlValue]]
sqlGetAll s = quickQuery' s 

-- sqlGetAllAssoc :: H.IConnection c => String -> [H.SqlValue] -> SqlTransaction c [M.HashMap String H.SqlValue]
sqlGetAllAssoc :: H.IConnection c => String -> [H.SqlValue] -> SqlTransaction c [M.HashMap String H.SqlValue]
sqlGetAllAssoc s xs = do 
                    stm <- prepare s
                    execute stm xs 
                    ys <- fetchAllRowsAL' stm
                    return (fmap M.fromList ys)

sqlExecute :: H.IConnection c => String -> [H.SqlValue] -> SqlTransaction c ()
sqlExecute s xs = do
                    stm <- prepare s
                    execute stm xs
                    return ()

{-
	Query helper functions
-}

-- makeQueryInsert: generate a query to insert data into the specified table for the specified fields
makeQueryInsert :: String -> [String] -> String
makeQueryInsert tbl fields = "insert into \"" ++ tbl ++ "\" (" ++ fstr ++ ") values (" ++ vstr ++ ") returning lastval();"
	where
		fstr = foldl (\x y -> x ++ (cma x) ++ "\"" ++ y ++ "\"") "" fields
		vstr = foldl (\x y -> x ++ (cma x) ++ "?") "" fields
		cma x = if (length x > 0) then ", " else ""

-- quickInsert: insert data map into a single specified table. data map has the form [(field, value)]. values are SqlValues. lastval() is returned.
quickInsert :: H.IConnection c => String -> [(String, H.SqlValue)] -> SqlTransaction c H.SqlValue
quickInsert tbl datamap = H.fromSql <$> sqlGetOne (makeQueryInsert tbl (map fst datamap)) (map snd datamap)
