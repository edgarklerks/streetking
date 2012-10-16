{-# LANGUAGE DeriveDataTypeable, FlexibleContexts, ScopedTypeVariables, RankNTypes, BangPatterns #-}
module Proto where 

import           Data.MemTimeState 
import qualified Data.Serialize as S
import qualified Control.Monad.CatchIO as CIO
import           Control.Monad.Error 
import           Data.Word 
import           Control.Applicative
import           Data.Typeable
import qualified Data.ByteString as B
import           Data.Maybe 
import GHC.Exception (SomeException)

data Proto = TTLReq !TTL !Query 
           | Version !Int !Proto
           | Route !NodeAddr !Proto 
           | NodeList [NodeAddr]
           | Advertisement !NodeAddr 
           | Error !String 
           | Sync 
           | StartSync 
           | DumpInfo 
           | Result !Result 
    deriving Show 
{-- Payload --}

getResult :: Proto -> Maybe Result  
getResult p = w $ stripRoute p 
    where w (Result p) = Just p 
          w p = Nothing 

getQuery :: Proto -> Maybe Query 
getQuery p = w $ stripRoute p 
        where w (TTLReq n p) = Just p
              w _ = Nothing 

getCommand :: Proto -> Maybe Proto 
getCommand p = w $ stripRoute p
            where w (TTLReq _ _) = Nothing 
                  w (Result _) = Nothing 
                  w p = Just p 
isQuery :: Proto -> Bool 
isQuery = isJust . getQuery

isCommand :: Proto -> Bool 
isCommand = isJust . getCommand

isResult :: Proto -> Bool 
isResult = isJust . getResult 

casePayload :: Monad m => (Proto -> m ()) -> (Proto -> m ()) -> (Proto -> m ()) -> Proto -> m ()  
casePayload fres fquery fcmd p | isResult p = fres p 
                               | isQuery p = fquery p
                               | isCommand p = fcmd p 
                               | otherwise = return ()



{-- TTL Tools --}


predTTL :: Proto -> Proto 
predTTL (Version n p) = Version n $ predTTL p
predTTL (Route n p) = Route n $ predTTL p 
predTTL (TTLReq 0 p) = TTLReq 0 p 
predTTL (TTLReq n p) = TTLReq (pred n) p 
predTTL p = p 


getTTL :: Proto -> Maybe TTL 
getTTL (Version n p) = getTTL p 
getTTL (Route n p) = getTTL p 
getTTL (TTLReq n p) = Just n  
getTTL p = Nothing 


{-- Routing tools --}

hasRoute :: Proto -> Bool 
hasRoute (Version n p) = hasRoute p 
hasRoute (Route n p) = True 
hasRoute _ = False 

stripRoute :: Proto -> Proto 
stripRoute (Version n p) =stripRoute p 
stripRoute (Route n p) = stripRoute p 
stripRoute p = p 

headRoute :: Proto -> Maybe NodeAddr 
headRoute (Version n p) = headRoute p 
headRoute (Route n p) = Just n
headRoute _ = Nothing 

listRoute :: Proto -> [NodeAddr]
listRoute (Version n p) = listRoute p 
listRoute  (Route n p) = n : listRoute  p
listRoute _ = [] 

tailRoute :: Proto -> Maybe Proto 
tailRoute (Version n p) = Version n <$> tailRoute p 
tailRoute (Route n p) = Just p 
tailRoute p = Nothing 

addRoute :: NodeAddr -> Proto -> Proto
addRoute a (Version n p) = Version n (addRoute a p)
addRoute a (Route n p) = Route a (Route n p)
addRoute a p = Route a p 

addRoutes :: Proto -> Proto -> Proto 
addRoutes p s = foldr addRoute s (listRoute p) 

inRoute :: NodeAddr -> Proto -> Bool 
inRoute n p = n `elem` listRoute p

{-- Protocol constructors --}

versionConst :: Int 
versionConst = 0

withVersion :: Proto -> Proto 
withVersion = Version versionConst 

result :: Result ->  Proto 
result = withVersion . Result 

route :: NodeAddr -> Proto -> Proto 
route n = withVersion . Route n 

withTTL :: TTL -> Query -> Proto 
withTTL n = TTLReq n 


dumpInfo :: Proto 
dumpInfo = withVersion DumpInfo 

query :: TTL -> B.ByteString -> Proto 
query n = withVersion . withTTL n . Query 

nodeList :: [NodeAddr] -> Proto 
nodeList = withVersion . NodeList 

advertise :: NodeAddr -> Proto 
advertise = withVersion . Advertisement 

insert :: B.ByteString -> B.ByteString -> Proto 
insert k = withVersion . withTTL 1 . Insert k 

delete :: TTL -> B.ByteString -> Proto 
delete n = withVersion . withTTL 1 . Delete 

sync :: Proto 
sync = withVersion Sync 

startSync :: Proto 
startSync = withVersion StartSync 

instance S.Serialize Proto where 
        put (Version v p) = S.put (1 :: Word8) *>
                            S.put v *> S.put p 
        put (TTLReq n q) = S.put (0 :: Word8) *> 
                           S.put n *> S.put q
        put (NodeList xs) = S.put (2 :: Word8) *> 
                            S.put xs 
        put (Advertisement p) = S.put (3 :: Word8) *> S.put p
        put (Error s) = S.put (4 :: Word8) *> S.put s
        put (Sync) = S.put (5 :: Word8) 
        put (StartSync) = S.put (6 :: Word8)
        put (DumpInfo) = S.put (7 :: Word8)
        put (Result x) = S.put (8 :: Word8) *> S.put x
        put (Route n x) = S.put (9 :: Word8) *> S.put n *> S.put x
        get = do 
            b <- S.get :: S.Get Word8 
            case b of 
                0 -> TTLReq <$> S.get <*> S.get
                1 -> Version <$> S.get <*> S.get
                2 -> NodeList <$> S.get 
                3 -> Advertisement <$> S.get
                4 -> Error <$> S.get
                5 -> pure Sync 
                6 -> pure StartSync 
                7 -> pure DumpInfo
                8 -> Result <$> S.get
                9 -> Route <$> S.get <*> S.get


type TTL = Int 
type NodeAddr = String 

data ProtoException = VersionMisMatch Int Int 
                    | UnspecifiedFailure
                    | SpecifiedFailure String 
                    | DecodeError String B.ByteString
                    | UnexpectedResponse 
                    | IOException String 
                    | MissingRouting Proto 
                    | NakedRequest Proto 
        deriving (Show, Typeable)

data ServerException = NotFoundException  
                     | SocketGone 
    deriving (Show, Typeable)

instance CIO.Exception ServerException 

missingRouting :: MonadError ProtoException m => Proto -> m a
missingRouting = throwError . MissingRouting 
versionMismatch :: MonadError ProtoException m  => Int -> Int -> m a 
versionMismatch p = throwError . VersionMisMatch p 

unspecifiedFailure :: MonadError ProtoException m => m a
unspecifiedFailure = throwError UnspecifiedFailure 

specifiedFailure :: MonadError ProtoException m => String -> m a 
specifiedFailure = throwError . SpecifiedFailure 

decodeError :: MonadError ProtoException m => String -> B.ByteString -> m a
decodeError b = throwError . DecodeError b

unexpectedResponse :: MonadError ProtoException m =>  m a 
unexpectedResponse = throwError UnexpectedResponse 

ioException :: MonadError ProtoException m => String -> m a 
ioException = throwError . IOException

nakedRequest :: MonadError ProtoException m => Proto -> m a 
nakedRequest = throwError . NakedRequest 




instance CIO.Exception ProtoException 

instance Error ProtoException where 
            noMsg = UnspecifiedFailure 
            strMsg = SpecifiedFailure 




