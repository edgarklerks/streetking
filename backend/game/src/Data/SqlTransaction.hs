{-# LANGUAGE GeneralizedNewtypeDeriving, FlexibleInstances, MultiParamTypeClasses, FunctionalDependencies, RankNTypes #-}
module Data.SqlTransaction (
    atomical,
    prepare,
    quickQuery,
    quickQuery',
    rollback,
    waitWhen, 
    waitUnless,
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
    Connection,
    withEncoding,
    newFuture,
    readFuture,
    doneFuture,
    emptyFuture,
    par2,
    par3,
    par4,
    parN,
    parSafe,
    fillFuture 

) where 

import Data.Function 
import Data.Functor
import Control.Concurrent
import Control.Applicative
import Control.Monad 
import Control.Monad.Error 
import Control.Monad.Reader
import Control.Monad.State 
import Control.Monad.Trans
import Data.Monoid
import Data.Tools
import Data.Convertible
import Data.Map (Map)
import qualified Database.HDBC as H
import qualified Data.HashMap.Strict as M
import Database.HDBC.PostgreSQL
import Data.Either 

newtype SqlTransaction c a = SqlTransaction {
                unsafeRunSqlTransaction :: forall r. (c -> a -> IO (Either String r)) -> c -> IO (Either String r)
        }
{--
- Derived from: 
newtype SqlTransaction c a = SqlTransaction {
        unsafeRunSqlTransaction :: ReaderT c (ErrorT String IO) a 
 } deriving (Functor, Alternative, Applicative, Monad, MonadPlus, MonadFix, MonadReader c, MonadError String, MonadIO) 

type SqlTransactionCPS c a = (a -> SqlTransactionCPS c r) -> SqlTransactionCPS c r 
[type SqlTransactionCPS c a] = (a -> c -> IO (Either String r)) -> (c -> IO (Either String r))
--}
runSqlTransaction :: (MonadIO m, H.IConnection c, Applicative m) => SqlTransaction c a -> (String -> m a) -> c -> m a 
runSqlTransaction xs f c = do
                                liftIO $ H.commit c
                                x <- liftIO $ unsafeRunSqlTransaction xs (\_ a -> return (Right a)) c
                                case x of 
                                    Left b -> liftIO (H.rollback c) *> f b <* liftIO (H.commit c)
                                    Right a -> liftIO (H.commit c) >> return a

instance Functor (SqlTransaction c) where 
    fmap f m  = SqlTransaction $ \r -> unsafeRunSqlTransaction m (\c a -> r c $ f a)

instance Monad (SqlTransaction c) where 
    return a = SqlTransaction $ \r c -> r c a
    (>>=) m f = SqlTransaction $ \r -> unsafeRunSqlTransaction m (\c a -> unsafeRunSqlTransaction (f a) r $ c )

catchSqlError :: SqlTransaction c a -> (String -> SqlTransaction c a) -> SqlTransaction c a
catchSqlError m f = SqlTransaction $ \r c -> do 
                                    x <- unsafeRunSqlTransaction m (\_ a -> return (Right a)) c
                                    case x of 
                                        Left s -> unsafeRunSqlTransaction (f s) r c
                                        Right a -> r c a

testCatch :: SqlTransaction Connection () 
testCatch = do 
            s <- catchSqlError (do 
                        liftIO $ print "in catch error"
                        rollback "suck me dick"
                        return 0) (\e -> liftIO $ print e >> return 1)
            liftIO $ print s
            return ()

-- r :: c -> a -> IO (Either String r) 
-- unsafeRunSqlTransaction :: SqlTransaction c a -> (c -> a -> IO (Either String r))  -> c -> IO (Either String r)
-- SqlTransaction :: ( (c -> a -> IO (Either String r)) -> c -> IO (Either String r)) -> SqlTransaction c a 
--
                                                           


 
instance Applicative (SqlTransaction c) where 
    pure = return 
    (<*>) f m = SqlTransaction $ \r -> unsafeRunSqlTransaction m (\c a -> unsafeRunSqlTransaction f (\_ f' -> r c $ f' a) $ c)

instance Alternative (SqlTransaction c) where 
    empty = SqlTransaction $ \r c ->  (return $ Left "empty")
    (<|>) m n = catchSqlError m (const n) 

instance MonadPlus (SqlTransaction c) where 
        mzero = empty 
        mplus = (<|>)
   
instance MonadReader c (SqlTransaction c) where 
        ask = SqlTransaction $ \r c -> r c c
        local f m = SqlTransaction $ \r -> unsafeRunSqlTransaction m (\c a -> r (f c) a)

instance MonadState c (SqlTransaction c) where 
        get = ask 
        put a = SqlTransaction $ \r c -> r a () 

instance MonadError String (SqlTransaction c) where 
       throwError e = SqlTransaction $ \r c -> return (Left e)  
       catchError m f = catchSqlError m f 
                               


instance MonadIO (SqlTransaction c) where 
    liftIO m = SqlTransaction $ \r c -> (m >>= r c)

{--
newtype SqlTransaction c a = SqlTransaction {
        unsafeRunSqlTransaction :: ReaderT c (ErrorT String IO) a 
 } deriving (Functor, Alternative, Applicative, Monad, MonadPlus, MonadFix, MonadReader c, MonadError String, MonadIO) 


runSqlTransaction :: (MonadIO m, H.IConnection c, Applicative m) => SqlTransaction c a -> (String -> m a) -> c -> m a 
runSqlTransaction xs f c = do
                                liftIO $ H.commit c
                                x <- liftIO $ runErrorT (runReaderT (unsafeRunSqlTransaction xs ) c)
                                case x of 
                                    Left b -> liftIO (H.rollback c) *> f b <* liftIO (H.commit c)
                                    Right a -> liftIO (H.commit c) >> return a
  --}    
--instance Convertible a a where 
--	safeConvert = Right . id

type Future a = MVar (Either String a) 

atomical :: H.IConnection c => SqlTransaction c a -> SqlTransaction c a 
atomical trans = do 
                c <- ask 
                liftIO (H.commit c) 
                a <- catchError trans throwError  
                liftIO $ H.commit  c
                return a

forkSqlTransaction m = do 
                c <- ask
                liftIO $ forkIO $ do 
                    (unsafeRunSqlTransaction m) (\_ a -> return (Right a)) c
                    return ()

newFuture :: H.IConnection c => SqlTransaction c a -> SqlTransaction c (Future a)
newFuture m = do 
        c <- ask 
        c' <- liftIO $ H.clone c 
        m1 <- emptyFuture  
        liftIO $ forkIO $ do 
                a <- (unsafeRunSqlTransaction m)(\_ a -> return (Right a)) c'
                putMVar m1 a 
                H.disconnect c' 
        return m1

fillFuture :: Future a -> (Either String a) -> SqlTransaction c ()
fillFuture m = liftIO . putMVar m 

emptyFuture :: SqlTransaction c (Future a)
emptyFuture = liftIO newEmptyMVar

doneFuture :: Future a -> SqlTransaction c Bool
doneFuture = liftIO . isEmptyMVar

readFuture :: Future a -> SqlTransaction c a
readFuture f = do 
                b <- liftIO $ readMVar f
                case b of 
                    Left e -> rollback e
                    Right a -> return a

parSafe :: H.IConnection c => [SqlTransaction c a] -> SqlTransaction c [a]
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


par2 :: H.IConnection c => SqlTransaction c a -> SqlTransaction c b -> SqlTransaction c (a,b)
par2 m n = do 
        m' <- newFuture m 
        n' <- newFuture n 
        (,) <$> readFuture m' <*> readFuture n' 
    
par3 :: H.IConnection c => SqlTransaction c a -> SqlTransaction c b -> SqlTransaction c c -> SqlTransaction c (a,b,c)
par3 p q r = do 
        p' <- newFuture p
        q' <- newFuture q
        r' <- newFuture r 
        (,,) <$> readFuture p' <*> readFuture q' <*> readFuture r'

par4 :: H.IConnection c => SqlTransaction c p -> SqlTransaction c q -> SqlTransaction c r -> SqlTransaction c s -> SqlTransaction c (p,q,r,s)
par4 p q r s = do 
        p' <- newFuture p
        q' <- newFuture q 
        r' <- newFuture r
        s' <- newFuture s 
        (,,,) <$> readFuture p' <*> readFuture q' <*> readFuture r' <*> readFuture s' 

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

withEncoding :: H.IConnection c => String -> SqlTransaction c a -> SqlTransaction c a
withEncoding n m = 
            quickQuery ("SET CLIENT_ENCODING TO " ++ n ) [] *> m <* 
            quickQuery ("SET CLIENT_ENCODING TO " ++ n) []
        

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

waitWhen :: SqlTransaction Connection Bool -> SqlTransaction Connection ()
waitWhen m = do 
                    a <- m 
                    case a of 
                        False -> liftIO (threadDelay 10000) >> waitWhen m 
                        True -> return ()



waitUnless :: SqlTransaction Connection Bool -> SqlTransaction Connection () 
waitUnless = waitWhen . fmap not 


testcon = connectPostgreSQL "host=db.graffity.me password=#*rl& user=deosx dbname=streetking_dev"

runTestDb m = do 
            c <- testcon 
            a <- runSqlTransaction m (\x -> print x >> return undefined ) c
            H.disconnect c 
            return a
