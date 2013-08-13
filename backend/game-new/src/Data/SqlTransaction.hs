{-# LANGUAGE GeneralizedNewtypeDeriving, FlexibleInstances, MultiParamTypeClasses, FunctionalDependencies, RankNTypes, OverloadedStrings #-}
module Data.SqlTransaction (

	quickInsert,
    Connection,
    H.IConnection,
    H.SqlValue(..),
    H.Statement,
    H.disconnect,
    Lock(..),
    SqlTransaction,
    SqlTransactionUser,
    atomical,
    catchSqlError,
    commit,
    dbWithLockBlock,
    dbWithLockNonBlock, 
    doneFuture,
    emptyFuture,
    execute,
    executeMany, 
    executeRaw,
    fetchAllRows',
    fetchAllRows,
    fetchAllRowsAL',
    fetchAllRowsAL,
    fetchAllRowsMap,
    fetchRow,
    fetchRowAl,
    fetchRowMap,
    fillFuture,
    finish,
    forkSqlTransaction,
    get,
    getUser,
    lock,
    newFuture,
    par2,
    par3,
    par4,
    parN,
    parSafe,
    prepare,
    putUser,
    quickQuery',
    quickQuery,
    readFuture,
    rollback,
    run,
    runSqlTransaction,
    runTestDb,
    sExecute,
    sExecuteMany,
    sFetchAllRows',
    sFetchAllRows,
    sFetchRow, 
    sRun,
    SqlError(..),
    sqlExecute,
    sqlGetAll,
    sqlGetAllAssoc,
    sqlGetOne,
    sqlGetRow,
    waitUnless,
    waitWhen, 
    withEncoding
) where 


import           Control.Applicative
import           Control.Concurrent
import           Control.Monad 
import           Control.Monad.Error 
import           Control.Monad.Reader
import           Control.Monad.State 
import           Control.Monad.Trans
import           Data.Convertible
import           Data.Either 
import           Data.Function 
import           Data.Functor
import           Data.Map (Map)
import           Data.Monoid
import           Data.Tools
import           Data.String 
import           Database.HDBC.PostgreSQL as H
import qualified Data.HashMap.Strict as M
import qualified Database.HDBC as H
import qualified LockSnaplet as L
import qualified Control.Monad.CatchIO as CIO 
import qualified GHC.Exception as E 

-- | Sql transaction is a monad, which encapsulate computations in a transaction
--   By throwing an error the transaction will be rolled back
--   The SqlTransactionUser gives the possibility to add a user state
--   In SqlTransaction the user state is a mechanism to lock a certain operation
--   Other capabilities are: 
--
--      * paralel queries 
--
--      * atomical actions
--
--      * exception catching (`Control.Monad.Error`)
--
--      * error handling 
--
--      * server level locking 
--  
--   The monad is hand rolled and CPS transformed for efficiency 
--  
type SqlTransaction c a = SqlTransactionUser L.Lock c a 

-- | Exception data type.
data SqlError = UError String -- ^ User error  
              | DBError String -- ^ Database error 
        deriving Show 

instance Error SqlError where 
        strMsg = UError 
        noMsg = UError "failed"
-- | For usability SqlError is a 'Data.String.IsString'
instance IsString SqlError where 
    fromString = UError 

-- | This is the core monad. It is a hand rolled CPS transformed monadstack. It handles state and exception handling
--
-- It is derived from the following stack:
--
-- @
--   newtype SqlTransaction l c a = SqlTransaction {
--     unsafeRunSqlTransaction :: StateT (c,l) (ErrorT String IO) a 
--   } deriving (Functor, Alternative, Applicative, Monad, MonadPlus, MonadFix, MonadState c, MonadError String, MonadIO) 
-- @
--

newtype SqlTransactionUser l c a = SqlTransaction {
                unsafeRunSqlTransaction :: forall r. ((c,l) -> a -> IO (Either SqlError r)) -> (c,l) -> IO (Either SqlError r)
        }
-- | Commits the current data to the database and starts a new transaction
commit :: SqlTransaction Connection ()
commit = do 
            c <- ask 
            liftIO . H.commit $ c
            liftIO . H.begin $ c
            return ()

-- | Encapsulates the computation in a transaction and handles any errors in the user supplied function
runSqlTransaction xs f c l = do
                                x <- liftIO $ unsafeRunSqlTransaction xs (\_ a -> return (Right a)) (c,l)
                                case x of 
                                    Left (UError b) -> liftIO (H.rollback c) *> f b <* liftIO (H.commit c)
                                    Left (DBError b) -> f b <* liftIO (H.commit c)
                                    Right a -> liftIO (H.commit c) >> return a

instance Functor (SqlTransactionUser l c) where 
    fmap f m  = SqlTransaction $ \r -> unsafeRunSqlTransaction m (\c a -> r c $ f a)

instance Monad (SqlTransactionUser l c) where 
    return a = SqlTransaction $ \r c -> r c a
    (>>=) m f = SqlTransaction $ \r -> unsafeRunSqlTransaction m (\c a -> unsafeRunSqlTransaction (f a) r $ c )

-- | Catch an error thrown in the SqlTransaction monad, if there is an error the continuation provided by the user will be run  
catchSqlError :: H.IConnection c => SqlTransactionUser l c a -> (SqlError -> SqlTransactionUser l c a) -> SqlTransactionUser l c a
catchSqlError m f = SqlTransaction $ \r c -> do -- IO  
                                    x <- CIO.try (unsafeRunSqlTransaction m (\_ a -> return (Right a)) c) 
                                    case x of 
                                        Left (E.SomeException e) -> do
                                                H.rollback (fst c)
                                                (unsafeRunSqlTransaction (f $ DBError $ show e) r c) 
                                        Right (Left e) -> do
                                                H.rollback (fst c)
                                                (unsafeRunSqlTransaction (f e) r c) 
                                        Right (Right a) -> r c a 

testCatch :: SqlTransaction Connection () 
testCatch = do 
            s <- catchSqlError (do 
                        liftIO $ print "in catch error"
                        rollback "suck me dick"
                        return 0) (\e -> liftIO $ print "catched it" >> return 1)
            liftIO $ print s
            return ()

testCatch2 :: SqlTransaction Connection () 
testCatch2 = do 
            x <- return $ Just ( error "terrible" )
            s <- catchSqlError (do 
                        case x of 
                          Just a -> a 
                          Nothing -> undefined 
                        return 0) (\e -> liftIO $ print ("catched it " ++ show e) >> return 1)
            liftIO $ print s
            return ()



 
instance Applicative (SqlTransactionUser l c) where 
    pure = return 
    (<*>) f m = SqlTransaction $ \r -> unsafeRunSqlTransaction m (\c a -> unsafeRunSqlTransaction f (\_ f' -> r c $ f' a) $ c)

-- | The alternative instance catches an error and runs the next computation when failed 
instance H.IConnection c => Alternative (SqlTransactionUser l c) where 
    empty = SqlTransaction $ \r c ->  (return $ Left "empty")
    (<|>) m n = catchSqlError m (const n) 

-- | The same as alternative 
instance H.IConnection c => MonadPlus (SqlTransactionUser l c) where 
        mzero = empty 
        mplus = (<|>)

-- | The Reader class is accessing the state. This was needed for some legacy code.  
instance MonadReader c (SqlTransactionUser l c) where 
        ask = SqlTransaction $ \r c@(t,l) -> r c t
        local f m = SqlTransaction $ \r -> unsafeRunSqlTransaction m (\(c,l) a -> r (f c,l) a)

-- | Retrieve the user state 
getUser = SqlTransaction $ \r c@(t,l) -> r c l 
-- | Put the user state 
putUser a = SqlTransaction $ \r (c,_) -> r (c,a) ()

-- | Do a SqlTransaction action and put a lock on the provided label. If the lock can't be acquired, don't block.    
--
--   Example
--
-- @
-- withLockNonBlock "namespace" "key" $ do ... 
-- @
--
dbWithLockNonBlock n a m = do 
        l <- getUser 
        L.withLockNonBlock l n a m 

-- | Do a SqlTransaction action, lock on server level only blocks until lock is acquired  
dbWithLockBlock n a m = do 
        l <- getUser 
        L.withLockBlock l n a m 


instance MonadState c (SqlTransactionUser l c) where 
        get = ask 
        put a = SqlTransaction $ \r (_,l) -> r (a,l) () 

instance H.IConnection c => MonadError SqlError (SqlTransactionUser l c) where 
       throwError e = SqlTransaction $ \r c -> return (Left e)  
       catchError m f = catchSqlError m f 
                               


instance MonadIO (SqlTransactionUser l c) where 
    liftIO m = SqlTransaction $ \r c -> (m >>= r c)

-- | A minimal implementation of a future value
--   that is a value, which will be calculated in paralel
type Future a = MVar (Either SqlError a) 

-- | Explicitly encapsulates a computation in a transaction block.
--   This commits the previous computation
atomical :: SqlTransaction Connection a -> SqlTransaction Connection a 
atomical trans = do 
                c <- ask 
                liftIO (H.commit c) 
                liftIO (H.begin c)
                a <- catchError trans throwError  
                liftIO $ H.commit  c
                liftIO (H.begin c)
                return a
-- | Fork a SqlTransaction, so it can calculate the computation concurrently 
--   This shares the database connection, so it the parent should be done with all the operations on the database. 
--   Errors don't roll back the parent 
forkSqlTransaction :: SqlTransaction Connection () -> SqlTransaction Connection ThreadId 
forkSqlTransaction m = do 
                c <- ask -- current database connection
                l <- getUser -- user environment 
                liftIO $ forkIO $ do 
                    (unsafeRunSqlTransaction m) (\_ a -> return (Right a)) (c,l)
                    return ()
-- | Creates a new future in the SqlTransaction monad with a calculation 
--   The database connection will be cloned, so it is safe for the parent 
--   to operate on the database 
newFuture :: H.IConnection c => 
	SqlTransaction c a -- ^ calculation needed in the future 
	-> SqlTransaction c (Future a) 
newFuture m = do 
        c <- ask 
        l <- getUser 
        c' <- liftIO $ H.clone c 
        m1 <- emptyFuture  
        liftIO $ forkIO $ do 
                a <- (unsafeRunSqlTransaction m) (\_ a -> return (Right a)) (c',l)
                putMVar m1 a 
                H.disconnect c' 
        return m1

-- | Fill a future with a value
--   This is an internal function 
fillFuture :: Future a -> (Either SqlError a) -> SqlTransaction c ()
fillFuture m = liftIO . putMVar m 

-- | Create an empty future 
emptyFuture :: SqlTransaction c (Future a)
emptyFuture = liftIO newEmptyMVar

-- | Check if the future is done calculating 
doneFuture :: Future a -> SqlTransaction c Bool
doneFuture = liftIO . isEmptyMVar

-- | Read the future, this will force the calculation.
--   Any exception will be thrown in the parent 
readFuture :: H.IConnection c => Future a -> SqlTransaction c a
readFuture f = do 
                b <- liftIO $ readMVar f
                case b of 
                    Left e -> throwError e
                    Right a -> return a

-- | Run queries in paralel
--   Example:
--
-- @
-- parSafe [comp1, comp2, comp3]
-- @
-- This will return all the results or roll back the parent computation on an error 
parSafe xs = do 
            ts <- forM xs $ \i -> do 
                    down <- liftIO $ newEmptyMVar 
                    up <- liftIO $ newEmptyMVar 
                    run down up i
                    return (down, up)
            rs <- forM (fst <$> ts) $ liftIO . takeMVar 
            case (lefts $ rs) of 
                    [] -> forM_ (snd <$> ts) $ \i -> liftIO $ putMVar i False 
                    otherwise -> forM_ (snd <$> ts) $ \i -> liftIO $ putMVar i True
            return (rights rs) 
     where run d u m  = forkSqlTransaction $ do 
                        a <- catchError (Right <$> m) (\e -> return (Left e)) 
                        liftIO $ putMVar d a 
                        u <- liftIO $ takeMVar u 
                        case u of 
                           True -> rollback ""
                           False -> return () 

-- | Run two computations paralel
par2 :: H.IConnection c => SqlTransaction c a -> SqlTransaction c b -> SqlTransaction c (a,b)
par2 m n = do 
        m' <- newFuture m 
        n' <- newFuture n 
        (,) <$> readFuture m' <*> readFuture n' 

-- | Run three computations paralel
par3 :: H.IConnection c => SqlTransaction c a -> SqlTransaction c b -> SqlTransaction c c -> SqlTransaction c (a,b,c)
par3 p q r = do 
        p' <- newFuture p
        q' <- newFuture q
        r' <- newFuture r 
        (,,) <$> readFuture p' <*> readFuture q' <*> readFuture r'

-- | Run four computations in paralel
par4 :: H.IConnection c => SqlTransaction c p -> SqlTransaction c q -> SqlTransaction c r -> SqlTransaction c s -> SqlTransaction c (p,q,r,s)
par4 p q r s = do 
        p' <- newFuture p
        q' <- newFuture q 
        r' <- newFuture r
        s' <- newFuture s 
        (,,,) <$> readFuture p' <*> readFuture q' <*> readFuture r' <*> readFuture s' 

-- | run n computations in paralel
parN :: H.IConnection c => [SqlTransaction c p] -> SqlTransaction c [p]
parN xs = do 
            m <- forM xs newFuture
            forM m readFuture 
                         
 
prepare ::  H.IConnection c =>  String -> SqlTransaction c H.Statement 
prepare s = ask >>= liftIO . flip H.prepare s

quickQuery :: H.IConnection c => String -> [H.SqlValue] -> SqlTransaction c [[H.SqlValue]]   
quickQuery s xs = ask >>= liftIO . flip (flip H.quickQuery s) xs

quickQuery' :: H.IConnection c => String -> [H.SqlValue] -> SqlTransaction c [[H.SqlValue]]
quickQuery' s xs = ask >>= liftIO . flip (flip H.quickQuery' s) xs 

-- | Rollback the computation, throws an user error 
rollback :: H.IConnection m => String -> SqlTransaction m t 
rollback = throwError . UError 

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

-- | Get the first value from the query 
sqlGetOne :: H.IConnection c => String -> [H.SqlValue] -> SqlTransaction c H.SqlValue
sqlGetOne s =  fmap (head . head) .  quickQuery' s 
-- | get one row from the query 
sqlGetRow :: H.IConnection c => String -> [H.SqlValue] -> SqlTransaction c [H.SqlValue]
sqlGetRow s = fmap (head) . quickQuery' s  

-- | Get all rows from the query 
sqlGetAll :: H.IConnection c => String -> [H.SqlValue] -> SqlTransaction c [[H.SqlValue]]
sqlGetAll s = quickQuery' s 

-- | Get all rows as a 'M.HashMap'
sqlGetAllAssoc :: H.IConnection c => String -> [H.SqlValue] -> SqlTransaction c [M.HashMap String H.SqlValue]
sqlGetAllAssoc s xs = do 
                    stm <- prepare s
                    execute stm xs 
                    ys <- fetchAllRowsAL' stm
                    return (fmap M.fromList ys)

-- | Execute a statement 
sqlExecute :: H.IConnection c => String -> [H.SqlValue] -> SqlTransaction c ()
sqlExecute s xs = do
                    stm <- prepare s
                    execute stm xs
                    return ()

-- | Change the encoding of the database 
withEncoding :: H.IConnection c => String -> SqlTransaction c a -> SqlTransaction c a
withEncoding n m = 
            quickQuery ("SET CLIENT_ENCODING TO " ++ n ) [] *> m <* 
            quickQuery ("SET CLIENT_ENCODING TO " ++ n) []
        

-- | makeQueryInsert: generate a query to insert data into the specified table for the specified fields
makeQueryInsert :: String -> [String] -> String
makeQueryInsert tbl fields = "insert into \"" ++ tbl ++ "\" (" ++ fstr ++ ") values (" ++ vstr ++ ") returning lastval();"
	where
		fstr = foldl (\x y -> x ++ (cma x) ++ "\"" ++ y ++ "\"") "" fields
		vstr = foldl (\x y -> x ++ (cma x) ++ "?") "" fields
		cma x = if (length x > 0) then ", " else ""

-- | quickInsert: insert data map into a single specified table. data map has the form [(field, value)]. values are SqlValues. lastval() is returned.
quickInsert :: H.IConnection c => String -> [(String, H.SqlValue)] -> SqlTransaction c H.SqlValue
quickInsert tbl datamap = H.fromSql <$> sqlGetOne (makeQueryInsert tbl (map fst datamap)) (map snd datamap)

-- | Wait on an event in the database. If the computation returns true, go further
waitWhen :: SqlTransaction Connection Bool -> SqlTransaction Connection ()
waitWhen m = do 
                    a <- m 
                    case a of 
                        False -> liftIO (threadDelay 10000) >> waitWhen m 
                        True -> return ()


-- | The reverse of waitWhen
waitUnless :: SqlTransaction Connection Bool -> SqlTransaction Connection () 
waitUnless = waitWhen . fmap not 

testLock = atomical $ do 
                    lock "account" RowExclusive $ do  
                        liftIO $ threadDelay 100000
                        xs <- quickQuery "select * from account" [] 
                        liftIO $ print xs 
                        return ()

adsn = "dbname=postgres user=postgres password=wetwetwet port=5432 host=localhost sslmode=disable application_name=streetking_game keepalives=1 options='-c client_min_messages=ERROR'"
testcon = connectPostgreSQL adsn   -- "host= port=5439 password=wetwetwet user=postgres dbname=deosx"

runTestDb m = do 
            c <- testcon 
            a <- runSqlTransaction m (\x -> print x >> return undefined ) c undefined
            H.disconnect c 
            return a

-- | Several locks in the postgresql database 
data Lock = AccessShare 
          | RowShare 
          | RowExclusive 
          | ShareUpdateExclusive 
          | Share 
          | ShareRowExclusive 
          | AccessExclusive 

instance Show Lock where 
    show AccessShare = "ACCESS SHARE"
    show RowShare = "ROW SHARE"
    show RowExclusive = "ROW EXCLUSIVE"
    show ShareUpdateExclusive = "SHARE UPDATE EXCLUSIVE"
    show Share = "SHARE"
    show ShareRowExclusive = "SHARE ROW EXCLUSIVE"
    show AccessExclusive = "ACCESS EXCLUSIVE"

-- | Lock a table with Lock and do a computation when locked 
--
--  Example
--
-- @
-- f = lock "account" RowExclusive $ do ... 
-- @
lock :: String -> Lock -> SqlTransaction Connection a -> SqlTransaction Connection a 
lock table n s = atomical $  
                    sqlExecute ("LOCK TABLE " <> table <> " IN " <> (show n) <> " MODE") [] *> 
                    s  
