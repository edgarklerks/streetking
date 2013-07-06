% ProtoExtended
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

ProtoExtended

Documentation
=============

data Proto

Constructors

  ------------------------------------------------------------------------------------- ---
  TTLReq [TTL](ProtoExtended.html#t:TTL) [Query](Data-MemTimeState.html#t:Query)         
  Version Int [Proto](ProtoExtended.html#t:Proto)                                        
  Route [NodeAddr](ProtoExtended.html#t:NodeAddr) [Proto](ProtoExtended.html#t:Proto)    
  NodeList [[NodeAddr](ProtoExtended.html#t:NodeAddr)]                                   
  Advertisement [NodeAddr](ProtoExtended.html#t:NodeAddr)                                
  Error String                                                                           
  Sync                                                                                   
  StartSync                                                                              
  DumpInfo                                                                               
  Result [Result](Data-MemTimeState.html#t:Result)                                       
  ------------------------------------------------------------------------------------- ---

Instances

  ----------------------------------------------- ---
  Eq [Proto](ProtoExtended.html#t:Proto)           
  Show [Proto](ProtoExtended.html#t:Proto)         
  Serialize [Proto](ProtoExtended.html#t:Proto)    
  Arbitrary [Proto](ProtoExtended.html#t:Proto)    
  ----------------------------------------------- ---

getResult :: [Proto](ProtoExtended.html#t:Proto) -\> Maybe
[Result](Data-MemTimeState.html#t:Result)

getQuery :: [Proto](ProtoExtended.html#t:Proto) -\> Maybe
[Query](Data-MemTimeState.html#t:Query)

getCommand :: [Proto](ProtoExtended.html#t:Proto) -\> Maybe
[Proto](ProtoExtended.html#t:Proto)

isQuery :: [Proto](ProtoExtended.html#t:Proto) -\> Bool

isCommand :: [Proto](ProtoExtended.html#t:Proto) -\> Bool

isResult :: [Proto](ProtoExtended.html#t:Proto) -\> Bool

casePayload :: Monad m =\> ([Proto](ProtoExtended.html#t:Proto) -\> m
()) -\> ([Proto](ProtoExtended.html#t:Proto) -\> m ()) -\>
([Proto](ProtoExtended.html#t:Proto) -\> m ()) -\>
[Proto](ProtoExtended.html#t:Proto) -\> m ()

predTTL :: [Proto](ProtoExtended.html#t:Proto) -\>
[Proto](ProtoExtended.html#t:Proto)

getTTL :: [Proto](ProtoExtended.html#t:Proto) -\> Maybe
[TTL](ProtoExtended.html#t:TTL)

hasRoute :: [Proto](ProtoExtended.html#t:Proto) -\> Bool

stripRoute :: [Proto](ProtoExtended.html#t:Proto) -\>
[Proto](ProtoExtended.html#t:Proto)

headRoute :: [Proto](ProtoExtended.html#t:Proto) -\> Maybe
[NodeAddr](ProtoExtended.html#t:NodeAddr)

listRoute :: [Proto](ProtoExtended.html#t:Proto) -\>
[[NodeAddr](ProtoExtended.html#t:NodeAddr)]

tailRoute :: [Proto](ProtoExtended.html#t:Proto) -\> Maybe
[Proto](ProtoExtended.html#t:Proto)

addRoute :: [NodeAddr](ProtoExtended.html#t:NodeAddr) -\>
[Proto](ProtoExtended.html#t:Proto) -\>
[Proto](ProtoExtended.html#t:Proto)

addRoutes :: [Proto](ProtoExtended.html#t:Proto) -\>
[Proto](ProtoExtended.html#t:Proto) -\>
[Proto](ProtoExtended.html#t:Proto)

inRoute :: [NodeAddr](ProtoExtended.html#t:NodeAddr) -\>
[Proto](ProtoExtended.html#t:Proto) -\> Bool

versionConst :: Int

withVersion :: [Proto](ProtoExtended.html#t:Proto) -\>
[Proto](ProtoExtended.html#t:Proto)

result :: [Result](Data-MemTimeState.html#t:Result) -\>
[Proto](ProtoExtended.html#t:Proto)

route :: [NodeAddr](ProtoExtended.html#t:NodeAddr) -\>
[Proto](ProtoExtended.html#t:Proto) -\>
[Proto](ProtoExtended.html#t:Proto)

withTTL :: [TTL](ProtoExtended.html#t:TTL) -\>
[Query](Data-MemTimeState.html#t:Query) -\>
[Proto](ProtoExtended.html#t:Proto)

dumpInfo :: [Proto](ProtoExtended.html#t:Proto)

query :: [TTL](ProtoExtended.html#t:TTL) -\> ByteString -\>
[Proto](ProtoExtended.html#t:Proto)

nodeList :: [[NodeAddr](ProtoExtended.html#t:NodeAddr)] -\>
[Proto](ProtoExtended.html#t:Proto)

advertise :: [NodeAddr](ProtoExtended.html#t:NodeAddr) -\>
[Proto](ProtoExtended.html#t:Proto)

insert :: ByteString -\> ByteString -\>
[Proto](ProtoExtended.html#t:Proto)

delete :: [TTL](ProtoExtended.html#t:TTL) -\> ByteString -\>
[Proto](ProtoExtended.html#t:Proto)

sync :: [Proto](ProtoExtended.html#t:Proto)

startSync :: [Proto](ProtoExtended.html#t:Proto)

type TTL = Int

data NodeAddr

Constructors

  -------------- ---
  Addr String     
  Local String    
  -------------- ---

Instances

  ----------------------------------------------------- ---
  Eq [NodeAddr](ProtoExtended.html#t:NodeAddr)           
  Show [NodeAddr](ProtoExtended.html#t:NodeAddr)         
  Hashable [NodeAddr](ProtoExtended.html#t:NodeAddr)     
  Serialize [NodeAddr](ProtoExtended.html#t:NodeAddr)    
  Arbitrary [NodeAddr](ProtoExtended.html#t:NodeAddr)    
  ----------------------------------------------------- ---

data ProtoException

Constructors

  ---------------------------------------------------- ---
  VersionMisMatch Int Int                               
  UnspecifiedFailure                                    
  SpecifiedFailure String                               
  DecodeError String ByteString                         
  UnexpectedResponse                                    
  IOException String                                    
  MissingRouting [Proto](ProtoExtended.html#t:Proto)    
  NakedRequest [Proto](ProtoExtended.html#t:Proto)      
  ---------------------------------------------------- ---

Instances

  ----------------------------------------------------------------- ---
  Show [ProtoException](ProtoExtended.html#t:ProtoException)         
  Typeable [ProtoException](ProtoExtended.html#t:ProtoException)     
  Error [ProtoException](ProtoExtended.html#t:ProtoException)        
  Exception [ProtoException](ProtoExtended.html#t:ProtoException)    
  ----------------------------------------------------------------- ---

data ServerException

Constructors

  ------------------- ---
  NotFoundException    
  SocketGone           
  ------------------- ---

Instances

  ------------------------------------------------------------------- ---
  Show [ServerException](ProtoExtended.html#t:ServerException)         
  Typeable [ServerException](ProtoExtended.html#t:ServerException)     
  Exception [ServerException](ProtoExtended.html#t:ServerException)    
  ------------------------------------------------------------------- ---

missingRouting :: MonadError
[ProtoException](ProtoExtended.html#t:ProtoException) m =\>
[Proto](ProtoExtended.html#t:Proto) -\> m a

versionMismatch :: MonadError
[ProtoException](ProtoExtended.html#t:ProtoException) m =\> Int -\> Int
-\> m a

unspecifiedFailure :: MonadError
[ProtoException](ProtoExtended.html#t:ProtoException) m =\> m a

specifiedFailure :: MonadError
[ProtoException](ProtoExtended.html#t:ProtoException) m =\> String -\> m
a

decodeError :: MonadError
[ProtoException](ProtoExtended.html#t:ProtoException) m =\> String -\>
ByteString -\> m a

unexpectedResponse :: MonadError
[ProtoException](ProtoExtended.html#t:ProtoException) m =\> m a

ioException :: MonadError
[ProtoException](ProtoExtended.html#t:ProtoException) m =\> String -\> m
a

nakedRequest :: MonadError
[ProtoException](ProtoExtended.html#t:ProtoException) m =\>
[Proto](ProtoExtended.html#t:Proto) -\> m a

iso\_decode\_test :: Property

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
