===============
NodeSnapletTest
===============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

NodeSnapletTest

Documentation
=============

data DHTConfig

Constructors

DHC

 

Fields

\_query :: MVar ()
     
\_ctx :: Context
     
\_addr :: String
     
\_pull :: Socket Pull
     
\_req :: Socket Req
     
\_pc :: (`RequestConfig <MemServerAsyncTest.html#t:RequestConfig>`__,
`IncomingConfig <MemServerAsyncTest.html#t:IncomingConfig>`__,
`UpdateConfig <MemServerAsyncTest.html#t:UpdateConfig>`__)
     

Instances

+--------------------------------------------------------------------------------------------------------------+-----+
| MonadState `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ `NodeTest <NodeSnapletTest.html#t:NodeTest>`__   |     |
+--------------------------------------------------------------------------------------------------------------+-----+

newtype NodeTest a

Constructors

NodeTest

 

Fields

unNodeTest :: StateT `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ IO
a
     

Instances

+--------------------------------------------------------------------------------------------------------------+-----+
| Monad `NodeTest <NodeSnapletTest.html#t:NodeTest>`__                                                         |     |
+--------------------------------------------------------------------------------------------------------------+-----+
| Functor `NodeTest <NodeSnapletTest.html#t:NodeTest>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------+-----+
| MonadPlus `NodeTest <NodeSnapletTest.html#t:NodeTest>`__                                                     |     |
+--------------------------------------------------------------------------------------------------------------+-----+
| Applicative `NodeTest <NodeSnapletTest.html#t:NodeTest>`__                                                   |     |
+--------------------------------------------------------------------------------------------------------------+-----+
| MonadIO `NodeTest <NodeSnapletTest.html#t:NodeTest>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------+-----+
| Alternative `NodeTest <NodeSnapletTest.html#t:NodeTest>`__                                                   |     |
+--------------------------------------------------------------------------------------------------------------+-----+
| MonadState `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ `NodeTest <NodeSnapletTest.html#t:NodeTest>`__   |     |
+--------------------------------------------------------------------------------------------------------------+-----+

runNodeTest :: `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ ->
`NodeTest <NodeSnapletTest.html#t:NodeTest>`__ a -> IO a

data NodeTestParams

Constructors

NTP

 

Fields

nt\_pull :: String
     
nt\_req :: String
     
nt\_dump :: String
     

setupTests :: IO ()

createNodeTest ::
`NodeTestParams <NodeSnapletTest.html#t:NodeTestParams>`__ -> IO ()

sendQuery :: (MonadState
`DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ m, MonadIO m) =>
`Proto <ProtoExtended.html#t:Proto>`__ -> m
`Proto <ProtoExtended.html#t:Proto>`__

req :: Lens' `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ (Socket
Req)

query :: Lens' `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ (MVar
())

pull :: Lens' `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ (Socket
Pull)

pc :: Lens' `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__
(`RequestConfig <MemServerAsyncTest.html#t:RequestConfig>`__,
`IncomingConfig <MemServerAsyncTest.html#t:IncomingConfig>`__,
`UpdateConfig <MemServerAsyncTest.html#t:UpdateConfig>`__)

ctx :: Lens' `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ Context

addr :: Lens' `DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ String

initDHTConfig :: FilePath -> SnapletInit b
`DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__

insertBinary :: (MonadIO m, MonadState
`DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ m, Binary a) =>
ByteString -> a -> m `Proto <ProtoExtended.html#t:Proto>`__

lookupBinary :: (MonadIO m, MonadState
`DHTConfig <NodeSnapletTest.html#t:DHTConfig>`__ m, Binary a) =>
ByteString -> m (Maybe a)

decodeL :: Binary c => ByteString -> c

fromLazy :: Binary a => a -> ByteString

toStrings :: [`Config <Config-ConfigFileParser.html#t:Config>`__\ ] ->
[String]

toString :: `Config <Config-ConfigFileParser.html#t:Config>`__ -> String

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
