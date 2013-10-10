{-# Language ViewPatterns #-}
module Data.Redis (
    loadTree,
    onRedis,
    find, 
    insert,
    getNode,
    reduceTreeBU,
    reduceTreeTD
) where 

import Database.Redis 
import qualified Data.Serialize as S
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString as BS
import Control.Monad 
import Control.Applicative 
import Network.Socket (PortNumber)
import Data.Default

data Tree k v = Tree {
        root :: k,
        connection :: Connection 
    }


onRedis :: Tree k v -> Redis a -> IO a
onRedis t m = runRedis (connection t) m 

loadTree :: S.Serialize v => String -> v -> String -> Integer -> IO (Tree String v)
loadTree sn v s p = do 
                    let ci = defaultConnectInfo {
                            connectHost = s,
                            connectPort = PortNumber  $ fromInteger p}
                    c <- connect ci  
                    let t =  Tree {
                        connection = c,
                        root = sn 
                    }
                    x <- find t sn 
                    case x `asTypeOf` (Just v) of 
                        Nothing -> void $ onRedis t $ set (S.encode sn) (S.encode (v)) 
                        Just sn -> return ()
                    return t 



getValue k = do 
        x <- get (S.encode k)
        case x of 
            Left e -> return Nothing
            Right a -> case a of 
                            Just a -> case S.decode a of 
                                            Left _ -> error "Decode error" 
                                            Right (Nothing) -> return Nothing 
                                            Right (Just a) -> return (Just a)

        

find :: (S.Serialize k, S.Serialize v) => Tree k v -> k -> IO (Maybe v)
find t k = onRedis t $ do 
                   x <- getValue k
                   case x of 
                    Nothing -> return Nothing
                    Just (Nothing, v, Nothing) -> return (Just v)
                    Just (Nothing, v, Just((`asTypeOf` k) -> _)) -> return (Just v)
                    Just (Just((`asTypeOf` k) -> _), v, Just((`asTypeOf` k) -> _)) -> return (Just v)
                    Just (Just((`asTypeOf` k) -> _), v, Nothing) -> return (Just v)

getNode :: (S.Serialize k, S.Serialize v) => Tree k v -> k -> IO (Maybe k, v, Maybe k)
getNode t k = onRedis t $ do 
                x <- getValue k 
                case x of 
                    Nothing -> error "cannot return nothing"
                    Just a -> return a


singleton :: (S.Serialize k, S.Serialize v) => Tree k v -> k -> v -> IO (Tree k v)
singleton t k v = onRedis t $ do  
                        x <- set (S.encode k) (encodeNode k v (Nothing, v, Nothing))
                        return $ t {root = k}


insert :: (S.Serialize k, S.Serialize v, Ord k) => Tree k v -> k -> v -> IO ()
insert t k v = onRedis t $ insert' t k v 
insert' t k v = do 
                        x <- getValue (root t) 
                        case x of 
                            Nothing -> error "no valid root node" 
                            Just a -> case a of 
                                (Nothing, v', Nothing) -> 
                                        if k > root t 
                                            then do
                                                set (S.encode k) (encodeNode k v (Nothing, v, Nothing))
                                                void $ set (S.encode $ root t) (encodeNode k v (Nothing, v', Just k))
                                            else do 
                                                set (S.encode k) (encodeNode k v (Nothing, v, Nothing))
                                                void $ set (S.encode $ root t) (encodeNode k v (Just k, v', Nothing)) 
                                (Just a, v', Nothing) -> 
                                        if k > root t 
                                            then do 
                                                set (S.encode k) (encodeNode k v (Nothing, v, Nothing))
                                                void $ set (S.encode $ root t) (encodeNode k v (Just a, v', Just k))
                                            else do 
                                                void $ insert' (t {root = a}) k v 
                                (Nothing, v', Just a) -> 
                                        if k <= root t 
                                            then do 
                                                set (S.encode k) (encodeNode k v (Nothing, v, Nothing))
                                                void $ set (S.encode $ root t) (encodeNode k v (Just k, v', Just a)) 
                                            else do 
                                                void $ insert' (t {root = a}) k v 
                                (Just p, v', Just q) -> do 
                                                if k > root t
                                                    then void $ insert' (t {root = q}) k v
                                                    else void $ insert' (t {root = p}) k v  
                                                    
reduceTreeTD :: S.Serialize k => S.Serialize v => Tree k v -> (k -> v -> c -> c) -> c -> IO c 
reduceTreeTD t f c = onRedis t $ reduceTree' t f c 
        where reduceTree' t f c = do 
                        x <- getValue $ root t 
                        case x of 
                                    Nothing  -> return c
                                    Just ((`asTypeOf` Just (root t)) -> Nothing, v, (`asTypeOf` Just (root t)) -> Nothing) ->  return $ f (root t) v c 
                                    Just (Just k, v, Nothing) -> do 
                                            let n = f (root t) v c
                                            reduceTree' (t {root = k}) f n
                                    Just (Nothing, v, Just k) -> do 
                                            let n = f (root t) v c 
                                            reduceTree' (t {root = k}) f n 
                                    Just (Just k, v, Just k2) -> do 
                                            let n = f (root t) v c 
                                            n' <- reduceTree' (t {root = k}) f n
                                            reduceTree' (t {root = k2}) f n'


reduceTreeBU :: S.Serialize k => S.Serialize v => Tree k v -> (k -> v -> c -> c) -> c -> IO c 
reduceTreeBU t f c = onRedis t $ reduceTree' t f c 
    where reduceTree' t f c = do 
                    x <- getValue $ root t
                    case x of 
                        Nothing -> return c
                        Just ((`asTypeOf` Just (root t)) -> Nothing, v, (`asTypeOf` Just (root t)) -> Nothing) ->  return $ f (root t) v c

                        Just (Just k, v, Nothing) -> do 
                                                    n' <- reduceTree' (t {root = k}) f c
                                                    return $ f (root t) v n' 
                        Just (Nothing, v, Just k) -> do 
                                                    n' <- reduceTree' (t {root = k}) f c
                                                    return $ f (root t) v n'
                        Just (Just k, v, Just k2) -> do 
                                                    n' <- reduceTree' (t {root = k}) f c
                                                    n'' <- reduceTree' (t {root = k2}) f n'
                                                    return $ f (root t) v n''



sumTreeTD t = reduceTreeTD t (\_ x z -> x + z) 0
sumTreeBU t = reduceTreeBU t (\_ x z -> x + z) 0


nodeRep :: (S.Serialize k, S.Serialize v) => k -> v -> (Maybe k, v, Maybe k)
nodeRep k v = (Just k, v, Just k)

decodeAs :: (S.Serialize a) => a -> BS.ByteString -> a
decodeAs _ a = case S.decode a of 
                    Right a -> a
                    Left e -> error $ "decode error" ++ (show e)
encodeNode :: (S.Serialize v, S.Serialize k) => k -> v -> (Maybe k, v, Maybe k) -> BS.ByteString 
encodeNode k v = S.encode  


test = do 
    re <- connect defaultConnectInfo
    t <- singleton (Tree { connection = re, root = undefined}) "a" (3 :: Integer)
    insert t "b" 4
    insert t "c" 2
    insert t "d" 1
    insert t "e" 5
    s <- find t "e"
    q <- getNode t "a"
    print s
    print q
    xs <- sumTreeTD t
    ys <- sumTreeBU t
    print xs
    print ys



