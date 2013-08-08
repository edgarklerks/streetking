=============
ProtoExtended
=============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

ProtoExtended

Documentation
=============

data Proto

Constructors

+---------------------------------------------------------------------------------------------+-----+
| TTLReq `TTL <ProtoExtended.html#t:TTL>`__ `Query <Data-MemTimeState.html#t:Query>`__        |     |
+---------------------------------------------------------------------------------------------+-----+
| Version Int `Proto <ProtoExtended.html#t:Proto>`__                                          |     |
+---------------------------------------------------------------------------------------------+-----+
| Route `NodeAddr <ProtoExtended.html#t:NodeAddr>`__ `Proto <ProtoExtended.html#t:Proto>`__   |     |
+---------------------------------------------------------------------------------------------+-----+
| NodeList [`NodeAddr <ProtoExtended.html#t:NodeAddr>`__\ ]                                   |     |
+---------------------------------------------------------------------------------------------+-----+
| Advertisement `NodeAddr <ProtoExtended.html#t:NodeAddr>`__                                  |     |
+---------------------------------------------------------------------------------------------+-----+
| Error String                                                                                |     |
+---------------------------------------------------------------------------------------------+-----+
| Sync                                                                                        |     |
+---------------------------------------------------------------------------------------------+-----+
| StartSync                                                                                   |     |
+---------------------------------------------------------------------------------------------+-----+
| DumpInfo                                                                                    |     |
+---------------------------------------------------------------------------------------------+-----+
| Result `Result <Data-MemTimeState.html#t:Result>`__                                         |     |
+---------------------------------------------------------------------------------------------+-----+

Instances

+----------------------------------------------------+-----+
| Eq `Proto <ProtoExtended.html#t:Proto>`__          |     |
+----------------------------------------------------+-----+
| Show `Proto <ProtoExtended.html#t:Proto>`__        |     |
+----------------------------------------------------+-----+
| Serialize `Proto <ProtoExtended.html#t:Proto>`__   |     |
+----------------------------------------------------+-----+
| Arbitrary `Proto <ProtoExtended.html#t:Proto>`__   |     |
+----------------------------------------------------+-----+

getResult :: `Proto <ProtoExtended.html#t:Proto>`__ -> Maybe
`Result <Data-MemTimeState.html#t:Result>`__

getQuery :: `Proto <ProtoExtended.html#t:Proto>`__ -> Maybe
`Query <Data-MemTimeState.html#t:Query>`__

getCommand :: `Proto <ProtoExtended.html#t:Proto>`__ -> Maybe
`Proto <ProtoExtended.html#t:Proto>`__

isQuery :: `Proto <ProtoExtended.html#t:Proto>`__ -> Bool

isCommand :: `Proto <ProtoExtended.html#t:Proto>`__ -> Bool

isResult :: `Proto <ProtoExtended.html#t:Proto>`__ -> Bool

casePayload :: Monad m => (`Proto <ProtoExtended.html#t:Proto>`__ -> m
()) -> (`Proto <ProtoExtended.html#t:Proto>`__ -> m ()) ->
(`Proto <ProtoExtended.html#t:Proto>`__ -> m ()) ->
`Proto <ProtoExtended.html#t:Proto>`__ -> m ()

predTTL :: `Proto <ProtoExtended.html#t:Proto>`__ ->
`Proto <ProtoExtended.html#t:Proto>`__

getTTL :: `Proto <ProtoExtended.html#t:Proto>`__ -> Maybe
`TTL <ProtoExtended.html#t:TTL>`__

hasRoute :: `Proto <ProtoExtended.html#t:Proto>`__ -> Bool

stripRoute :: `Proto <ProtoExtended.html#t:Proto>`__ ->
`Proto <ProtoExtended.html#t:Proto>`__

headRoute :: `Proto <ProtoExtended.html#t:Proto>`__ -> Maybe
`NodeAddr <ProtoExtended.html#t:NodeAddr>`__

listRoute :: `Proto <ProtoExtended.html#t:Proto>`__ ->
[`NodeAddr <ProtoExtended.html#t:NodeAddr>`__\ ]

tailRoute :: `Proto <ProtoExtended.html#t:Proto>`__ -> Maybe
`Proto <ProtoExtended.html#t:Proto>`__

addRoute :: `NodeAddr <ProtoExtended.html#t:NodeAddr>`__ ->
`Proto <ProtoExtended.html#t:Proto>`__ ->
`Proto <ProtoExtended.html#t:Proto>`__

addRoutes :: `Proto <ProtoExtended.html#t:Proto>`__ ->
`Proto <ProtoExtended.html#t:Proto>`__ ->
`Proto <ProtoExtended.html#t:Proto>`__

inRoute :: `NodeAddr <ProtoExtended.html#t:NodeAddr>`__ ->
`Proto <ProtoExtended.html#t:Proto>`__ -> Bool

versionConst :: Int

withVersion :: `Proto <ProtoExtended.html#t:Proto>`__ ->
`Proto <ProtoExtended.html#t:Proto>`__

result :: `Result <Data-MemTimeState.html#t:Result>`__ ->
`Proto <ProtoExtended.html#t:Proto>`__

route :: `NodeAddr <ProtoExtended.html#t:NodeAddr>`__ ->
`Proto <ProtoExtended.html#t:Proto>`__ ->
`Proto <ProtoExtended.html#t:Proto>`__

withTTL :: `TTL <ProtoExtended.html#t:TTL>`__ ->
`Query <Data-MemTimeState.html#t:Query>`__ ->
`Proto <ProtoExtended.html#t:Proto>`__

dumpInfo :: `Proto <ProtoExtended.html#t:Proto>`__

query :: `TTL <ProtoExtended.html#t:TTL>`__ -> ByteString ->
`Proto <ProtoExtended.html#t:Proto>`__

nodeList :: [`NodeAddr <ProtoExtended.html#t:NodeAddr>`__\ ] ->
`Proto <ProtoExtended.html#t:Proto>`__

advertise :: `NodeAddr <ProtoExtended.html#t:NodeAddr>`__ ->
`Proto <ProtoExtended.html#t:Proto>`__

insert :: ByteString -> ByteString ->
`Proto <ProtoExtended.html#t:Proto>`__

delete :: `TTL <ProtoExtended.html#t:TTL>`__ -> ByteString ->
`Proto <ProtoExtended.html#t:Proto>`__

sync :: `Proto <ProtoExtended.html#t:Proto>`__

startSync :: `Proto <ProtoExtended.html#t:Proto>`__

type TTL = Int

data NodeAddr

Constructors

+----------------+-----+
| Addr String    |     |
+----------------+-----+
| Local String   |     |
+----------------+-----+

Instances

+----------------------------------------------------------+-----+
| Eq `NodeAddr <ProtoExtended.html#t:NodeAddr>`__          |     |
+----------------------------------------------------------+-----+
| Show `NodeAddr <ProtoExtended.html#t:NodeAddr>`__        |     |
+----------------------------------------------------------+-----+
| Hashable `NodeAddr <ProtoExtended.html#t:NodeAddr>`__    |     |
+----------------------------------------------------------+-----+
| Serialize `NodeAddr <ProtoExtended.html#t:NodeAddr>`__   |     |
+----------------------------------------------------------+-----+
| Arbitrary `NodeAddr <ProtoExtended.html#t:NodeAddr>`__   |     |
+----------------------------------------------------------+-----+

data ProtoException

Constructors

+---------------------------------------------------------+-----+
| VersionMisMatch Int Int                                 |     |
+---------------------------------------------------------+-----+
| UnspecifiedFailure                                      |     |
+---------------------------------------------------------+-----+
| SpecifiedFailure String                                 |     |
+---------------------------------------------------------+-----+
| DecodeError String ByteString                           |     |
+---------------------------------------------------------+-----+
| UnexpectedResponse                                      |     |
+---------------------------------------------------------+-----+
| IOException String                                      |     |
+---------------------------------------------------------+-----+
| MissingRouting `Proto <ProtoExtended.html#t:Proto>`__   |     |
+---------------------------------------------------------+-----+
| NakedRequest `Proto <ProtoExtended.html#t:Proto>`__     |     |
+---------------------------------------------------------+-----+

Instances

+----------------------------------------------------------------------+-----+
| Show `ProtoException <ProtoExtended.html#t:ProtoException>`__        |     |
+----------------------------------------------------------------------+-----+
| Typeable `ProtoException <ProtoExtended.html#t:ProtoException>`__    |     |
+----------------------------------------------------------------------+-----+
| Error `ProtoException <ProtoExtended.html#t:ProtoException>`__       |     |
+----------------------------------------------------------------------+-----+
| Exception `ProtoException <ProtoExtended.html#t:ProtoException>`__   |     |
+----------------------------------------------------------------------+-----+

data ServerException

Constructors

+---------------------+-----+
| NotFoundException   |     |
+---------------------+-----+
| SocketGone          |     |
+---------------------+-----+

Instances

+------------------------------------------------------------------------+-----+
| Show `ServerException <ProtoExtended.html#t:ServerException>`__        |     |
+------------------------------------------------------------------------+-----+
| Typeable `ServerException <ProtoExtended.html#t:ServerException>`__    |     |
+------------------------------------------------------------------------+-----+
| Exception `ServerException <ProtoExtended.html#t:ServerException>`__   |     |
+------------------------------------------------------------------------+-----+

missingRouting :: MonadError
`ProtoException <ProtoExtended.html#t:ProtoException>`__ m =>
`Proto <ProtoExtended.html#t:Proto>`__ -> m a

versionMismatch :: MonadError
`ProtoException <ProtoExtended.html#t:ProtoException>`__ m => Int -> Int
-> m a

unspecifiedFailure :: MonadError
`ProtoException <ProtoExtended.html#t:ProtoException>`__ m => m a

specifiedFailure :: MonadError
`ProtoException <ProtoExtended.html#t:ProtoException>`__ m => String ->
m a

decodeError :: MonadError
`ProtoException <ProtoExtended.html#t:ProtoException>`__ m => String ->
ByteString -> m a

unexpectedResponse :: MonadError
`ProtoException <ProtoExtended.html#t:ProtoException>`__ m => m a

ioException :: MonadError
`ProtoException <ProtoExtended.html#t:ProtoException>`__ m => String ->
m a

nakedRequest :: MonadError
`ProtoException <ProtoExtended.html#t:ProtoException>`__ m =>
`Proto <ProtoExtended.html#t:Proto>`__ -> m a

iso\_decode\_test :: Property

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
