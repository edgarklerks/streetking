{-# LANGUAGE ViewPatterns, BangPatterns, DoAndIfThenElse #-}
module Data.Role where 
   
import qualified Data.TimedMap as T 
import           Text.Parsec.String
import           Text.Parsec.Combinator
import           Text.Parsec.Expr
import           Text.Parsec.Prim hiding (many)
import           Text.Parsec.Char
import           Control.Applicative
import           Control.Monad
import           Control.Concurrent.STM
import           Control.Concurrent
import qualified Data.Map as M 
import           Data.List (isInfixOf, sort, group, head, findIndex)
import           System.Entropy 
import           Control.Monad.Trans
import qualified Data.ByteString as B           
import qualified Data.ByteString.Lazy as BL 
import           Data.Int
import           Data.Maybe
import qualified Data.Binary as B 
import qualified Data.Binary.Get as B
import qualified Data.Binary.Put as B
import           System.Directory (doesFileExist)



type RolePair k = (T.TimedMap k [Role], RoleSetMap)

data RoleSetFile = Roles [String] [RoleSetFile]
                 | Resource String [String]
            deriving Show 
data RestRight = Put 
                | Get 
                | Post 
                | Delete 
        deriving (Show, Eq)

newtype RoleSetMap = RSM {
        unRSM :: TVar RoleSet 
    }

type Resource = String 
type Id = Integer
data Role = Developer (Maybe Id)
          | User (Maybe Id)  
          | Server (Maybe Id)
          | All 
        deriving (Show, Read)

instance B.Binary Role where 
   put (Developer x) = do 
        B.putWord8 0
        B.put x
   put (User x) = do 
        B.putWord8 1
        B.put x
   put (Server x) = do 
        B.putWord8 2
        B.put x 
   put (All) = do 
        B.putWord8 3
   get = do 
        t <- B.getWord8 
        case t of 
            0 -> Developer <$> B.get
            1 -> User <$> B.get
            2 -> Server <$> B.get
            3 -> pure All




data OpaqueRole = ODeveloper 
                | OUser 
                | OServer 
                | OAll 
        deriving (Eq, Ord, Show)

viewOpaque :: Role -> OpaqueRole 
viewOpaque (Developer _) = ODeveloper
viewOpaque (User _) = OUser 
viewOpaque All = OAll 
viewOpaque (Server _) = OServer 

instance Ord Role where 
    (viewOpaque -> x) `compare` (viewOpaque -> y) = compare x y

instance Eq Role where 
    (viewOpaque -> x) == (viewOpaque -> y) = x == y

newtype RoleSet = RS {
            unRS :: M.Map Resource (M.Map Role [RestRight])
        } deriving (Show)

{-- Loading the initalize rolepair --}
initRP :: MonadIO m => FilePath -> m (RolePair B.ByteString)
initRP f = do x <- liftIO $ parseFromFile roleSet f 
              case x of
                Left e -> error (show e)
                Right xs -> do 
                        p <- liftIO $ newTVarIO (zipRoleSet xs)
                        z <- liftIO $ T.newTimedMap 
                        return (z, RSM p)

-- | File store handler 
fileStore :: FilePath -> T.TimedMapStore B.ByteString [Role]
fileStore f = B.writeFile f . B.concat . BL.toChunks . B.encode   
-- | File restore handler 
fileRestore :: FilePath -> T.TimedMapRestore B.ByteString [Role]
fileRestore f = do 
        b <- doesFileExist f
        if b then do  
            xs <- B.decodeFile f
            xs `seq` return xs
        else return []
                

-- | Empty Store handler
voidStore :: Ord k => T.TimedMapStore k a
voidStore _ = return ()

-- | Empty Restore handler 
voidRestore :: Ord k => T.TimedMapRestore k a   
voidRestore = return [] 

-- | Retrieve all the roles from a RoleState from the given token. 
getRoles :: MonadIO m => RolePair B.ByteString -> B.ByteString -> m [Role]
getRoles t@(fst -> xs) a = do 
            updateTimeRole t a
            t <- liftIO $ atomically $ T.lookup xs a 

            case t of 
                Nothing -> return []
                Just xs -> return xs 

updateTimeRole :: MonadIO m => RolePair B.ByteString -> B.ByteString -> m ()
updateTimeRole (fst -> xs) k = do 
        e <- liftIO $ T.getTimeStamp
        liftIO $ atomically $ T.updateTime xs e k 

-- | Lookup from the RoleState if a user may access a resource as role with restright
may :: MonadIO m => RolePair B.ByteString -> Resource -> Role -> RestRight -> m Bool
may (snd -> xs) a b c  = do 
    t <- liftIO $ atomically $ readTVar $  unRSM xs 
    return (may' t a b c)

-- | Adds a role to the RoleState under the given token.
addRole :: MonadIO m => RolePair B.ByteString -> B.ByteString -> Role -> m ()
addRole (fst -> xs) a b = do 
            x <- liftIO $ T.getTimeStamp
            liftIO $ atomically $ do  
                        ns <- T.lookup xs a 
                        case ns of 
                            Just ns -> T.insert xs x a (fmap head $ group $ sort $ b:ns)
                            Nothing -> T.insert xs x a [b] 
-- | Drop all the roles from token in the RoleState
dropRoles :: MonadIO m => RolePair B.ByteString -> B.ByteString -> m ()
dropRoles (fst -> xs) a = liftIO . atomically $ T.delete xs a 
                
-- | Cleanup all expired tokens 
runCleanup :: RolePair B.ByteString -> Int64 -> IO () 
runCleanup (fst -> xs) ttl = do 
            ys <- T.getTimeStamp 
            atomically $ do 
                T.cleanup xs (ys - ttl) 

-- | Start separated thread to cleanup all tokens wich are expired
initCleanup :: RolePair B.ByteString -> Int64 -> IO (ThreadId)  
initCleanup x e = forkIO . forever  $ do runCleanup x e >> threadDelay (30 * 60  * 10000)

-- | Start the storing thread, which periodically stores the whole RoleState with the given handler
initStore :: RolePair B.ByteString -> T.TimedMapStore B.ByteString [Role] -> IO (ThreadId)
initStore (fst -> x) f = threadDelay 10000 *> (forkIO . forever $ T.storeTimedMap f x >> threadDelay (30 * 60 * 10000))
                    
-- | Restore the roleState from the given handler  
runRestore :: RolePair B.ByteString -> T.TimedMapRestore B.ByteString [Role] -> IO ()
runRestore (fst -> x) f = T.restoreTimedMap x f 

-- | Debug function to dump the internal state 
dumpAll :: MonadIO m => RolePair B.ByteString -> m String 
dumpAll xs = liftIO $ atomically $ do 
           ts <- readTVar (T.unTimeMap  (fst xs)) 
           zs <- readTVar (unRSM (snd xs)) 
           return $ show (ts, zs)
-- | Pure function to lookup from a RoleSet if a Role can acces a resource under the given rights 
may' :: RoleSet -> Resource -> Role -> RestRight -> Bool 
may' xs rs rl rr = case M.lookup rs (unRS xs) >>= \xs -> M.lookup rl xs of 
                        Nothing -> False
                        Just xs -> rr `elem` xs 
{-- RoleSet Parser 
 -  Internal stuff 
 - --}

roleSet :: Parser RoleSetFile 
roleSet = Roles <$> (spaces *> roleHeader <* hsep) <*> (fmap (uncurry Resource) <$>  roleResources) 

roleResources :: Parser [(String, [String])]
roleResources = resourceRule `sepEndBy` hsep

roleHeader :: Parser [String]
roleHeader = roles `sepEndBy1` vsepH 

resourceRule :: Parser (String, [String])
resourceRule = (,) <$> many1 identifier  <*> (vsepB *> (many $ defs <* vsepB))

hsep :: Parser Char 
hsep =  vsepH0 *> char '\n' <* vsepH0

defs :: Parser String
defs = many $ vsepH0 *> oneOf  "_crud" <* vsepH0 

vsepB :: Parser Char
vsepB = vsepH0 *> char '|'

vsepH0 :: Parser String
vsepH0 = many (char ' ')

vsepH :: Parser String 
vsepH = many1 (char ' ') 

roles :: Parser String
roles = many1 identifier 

identifier :: Parser Char 
identifier = oneOf $ ['a'..'z'] ++ ['A' .. 'Z'] ++ "/."

zipRoleSet :: RoleSetFile -> RoleSet
zipRoleSet (Roles xs ys) =  RS . M.fromList $ fmap rstep ys
            where rstep (Resource ns ts) = (ns, M.fromList ((fmap readRole xs) `zip` (foldr rds [] <$> ts)))
                  rds 'c' z = Put : z
                  rds 'u' z = Post : z
                  rds 'r' z = Get : z
                  rds 'd' z = Delete : z
                  rds  _  z = z

readRole :: String -> Role 
readRole ("User") = User Nothing
readRole ("Developer") = Developer Nothing 
readRole _ = All 


