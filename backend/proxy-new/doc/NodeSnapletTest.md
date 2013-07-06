% NodeSnapletTest
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

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
:    
\_ctx :: Context
:    
\_addr :: String
:    
\_pull :: Socket Pull
:    
\_req :: Socket Req
:    
\_pc :: ([RequestConfig](MemServerAsyncTest.html#t:RequestConfig), [IncomingConfig](MemServerAsyncTest.html#t:IncomingConfig), [UpdateConfig](MemServerAsyncTest.html#t:UpdateConfig))
:    

Instances

  ------------------------------------------------------------------------------------------------------ ---
  MonadState [DHTConfig](NodeSnapletTest.html#t:DHTConfig) [NodeTest](NodeSnapletTest.html#t:NodeTest)    
  ------------------------------------------------------------------------------------------------------ ---

newtype NodeTest a

Constructors

NodeTest

 

Fields

unNodeTest :: StateT [DHTConfig](NodeSnapletTest.html#t:DHTConfig) IO a
:    

Instances

  ------------------------------------------------------------------------------------------------------ ---
  Monad [NodeTest](NodeSnapletTest.html#t:NodeTest)                                                       
  Functor [NodeTest](NodeSnapletTest.html#t:NodeTest)                                                     
  MonadPlus [NodeTest](NodeSnapletTest.html#t:NodeTest)                                                   
  Applicative [NodeTest](NodeSnapletTest.html#t:NodeTest)                                                 
  MonadIO [NodeTest](NodeSnapletTest.html#t:NodeTest)                                                     
  Alternative [NodeTest](NodeSnapletTest.html#t:NodeTest)                                                 
  MonadState [DHTConfig](NodeSnapletTest.html#t:DHTConfig) [NodeTest](NodeSnapletTest.html#t:NodeTest)    
  ------------------------------------------------------------------------------------------------------ ---

runNodeTest :: [DHTConfig](NodeSnapletTest.html#t:DHTConfig) -\>
[NodeTest](NodeSnapletTest.html#t:NodeTest) a -\> IO a

data NodeTestParams

Constructors

NTP

 

Fields

nt\_pull :: String
:    
nt\_req :: String
:    
nt\_dump :: String
:    

setupTests :: IO ()

createNodeTest ::
[NodeTestParams](NodeSnapletTest.html#t:NodeTestParams) -\> IO ()

sendQuery :: (MonadState [DHTConfig](NodeSnapletTest.html#t:DHTConfig)
m, MonadIO m) =\> [Proto](ProtoExtended.html#t:Proto) -\> m
[Proto](ProtoExtended.html#t:Proto)

req :: Lens' [DHTConfig](NodeSnapletTest.html#t:DHTConfig) (Socket Req)

query :: Lens' [DHTConfig](NodeSnapletTest.html#t:DHTConfig) (MVar ())

pull :: Lens' [DHTConfig](NodeSnapletTest.html#t:DHTConfig) (Socket
Pull)

pc :: Lens' [DHTConfig](NodeSnapletTest.html#t:DHTConfig)
([RequestConfig](MemServerAsyncTest.html#t:RequestConfig),
[IncomingConfig](MemServerAsyncTest.html#t:IncomingConfig),
[UpdateConfig](MemServerAsyncTest.html#t:UpdateConfig))

ctx :: Lens' [DHTConfig](NodeSnapletTest.html#t:DHTConfig) Context

addr :: Lens' [DHTConfig](NodeSnapletTest.html#t:DHTConfig) String

initDHTConfig :: FilePath -\> SnapletInit b
[DHTConfig](NodeSnapletTest.html#t:DHTConfig)

insertBinary :: (MonadIO m, MonadState
[DHTConfig](NodeSnapletTest.html#t:DHTConfig) m, Binary a) =\>
ByteString -\> a -\> m [Proto](ProtoExtended.html#t:Proto)

lookupBinary :: (MonadIO m, MonadState
[DHTConfig](NodeSnapletTest.html#t:DHTConfig) m, Binary a) =\>
ByteString -\> m (Maybe a)

decodeL :: Binary c =\> ByteString -\> c

fromLazy :: Binary a =\> a -\> ByteString

toStrings :: [[Config](Config-ConfigFileParser.html#t:Config)] -\>
[String]

toString :: [Config](Config-ConfigFileParser.html#t:Config) -\> String

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
