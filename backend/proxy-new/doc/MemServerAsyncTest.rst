==================
MemServerAsyncTest
==================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

MemServerAsyncTest

Synopsis

-  newtype `ProtoMonad <#t:ProtoMonad>`__ c a =
   `ProtoMonad <#v:ProtoMonad>`__ {

   -  `unProtoMonad <#v:unProtoMonad>`__ :: ReaderT c IO a

   }
-  `runProtoMonad <#v:runProtoMonad>`__ :: c ->
   `ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__ c a -> IO a
-  type `RequestMonad <#t:RequestMonad>`__ =
   `ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__
   `RequestConfig <MemServerAsyncTest.html#t:RequestConfig>`__
-  `startNode <#v:startNode>`__ ::
   `ConfigParameters <MemServerAsyncTest.html#t:ConfigParameters>`__ ->
   IO (`RequestConfig <MemServerAsyncTest.html#t:RequestConfig>`__,
   `IncomingConfig <MemServerAsyncTest.html#t:IncomingConfig>`__,
   `UpdateConfig <MemServerAsyncTest.html#t:UpdateConfig>`__)
-  data `ConfigParameters <#t:ConfigParameters>`__ = `RP <#v:RP>`__ {

   -  `param\_pull <#v:param_pull>`__ :: String
   -  `param\_req <#v:param_req>`__ :: String
   -  `param\_qc <#v:param_qc>`__ ::
      `QueryChan <Data-MemTimeState.html#t:QueryChan>`__
   -  `debug <#v:debug>`__ :: Bool

   }
-  data `RequestConfig <#t:RequestConfig>`__ = `PC <#v:PC>`__ {

   -  `pc\_context <#v:pc_context>`__ :: Context
   -  `pc\_memstate <#v:pc_memstate>`__ ::
      `QueryChan <Data-MemTimeState.html#t:QueryChan>`__
   -  `pc\_request <#v:pc_request>`__ ::
      `RequestSocket <MemServerAsyncTest.html#t:RequestSocket>`__
   -  `pc\_upstream\_map <#v:pc_upstream_map>`__ ::
      `UpstreamMap <MemServerAsyncTest.html#t:UpstreamMap>`__
   -  `pc\_request\_answer\_chan <#v:pc_request_answer_chan>`__ ::
      TQueue (`NodeAddr <ProtoExtended.html#t:NodeAddr>`__,
      `Proto <ProtoExtended.html#t:Proto>`__)
   -  `pc\_address <#v:pc_address>`__ ::
      `NodeAddr <ProtoExtended.html#t:NodeAddr>`__
   -  `pc\_incoming <#v:pc_incoming>`__ ::
      `NodeAddr <ProtoExtended.html#t:NodeAddr>`__
   -  `pc\_debug <#v:pc_debug>`__ :: Bool
   -  `pc\_log <#v:pc_log>`__ :: TQueue String

   }
-  type `UpstreamMap <#t:UpstreamMap>`__ = TVar (HashMap
   `NodeAddr <ProtoExtended.html#t:NodeAddr>`__
   `UpstreamSocket <MemServerAsyncTest.html#t:UpstreamSocket>`__)
-  type `RequestSocket <#t:RequestSocket>`__ = Socket Rep
-  type `UpstreamSocket <#t:UpstreamSocket>`__ = Socket Req
-  `requestEngine <#v:requestEngine>`__ ::
   `RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__ ()
-  `handleQuery <#v:handleQuery>`__ ::
   `RequestSocket <MemServerAsyncTest.html#t:RequestSocket>`__ ->
   `Proto <ProtoExtended.html#t:Proto>`__ ->
   `RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__ ()
-  `sendAnswer <#v:sendAnswer>`__ ::
   `NodeAddr <ProtoExtended.html#t:NodeAddr>`__ ->
   `Proto <ProtoExtended.html#t:Proto>`__ ->
   `RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__ ()
-  `handleCommand <#v:handleCommand>`__ :: Sender a => Socket a ->
   `Proto <ProtoExtended.html#t:Proto>`__ ->
   `RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__ ()
-  `connectToNode <#v:connectToNode>`__ ::
   `NodeAddr <ProtoExtended.html#t:NodeAddr>`__ ->
   `RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__ ()
-  `runMemQuery <#v:runMemQuery>`__ ::
   `Query <Data-MemTimeState.html#t:Query>`__ ->
   `RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__
   `Result <Data-MemTimeState.html#t:Result>`__
-  `toNodes <#v:toNodes>`__ :: `Proto <ProtoExtended.html#t:Proto>`__ ->
   `RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__ ()
-  `sendUpstream <#v:sendUpstream>`__ ::
   `Proto <ProtoExtended.html#t:Proto>`__ ->
   `RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__ ()
-  type `UpdateMonad <#t:UpdateMonad>`__ =
   `ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__
   `UpdateConfig <MemServerAsyncTest.html#t:UpdateConfig>`__
-  data `UpdateConfig <#t:UpdateConfig>`__ = `UC <#v:UC>`__ {

   -  `uc\_context <#v:uc_context>`__ :: Context
   -  `uc\_updates\_map <#v:uc_updates_map>`__ ::
      `UpdatesMap <MemServerAsyncTest.html#t:UpdatesMap>`__
   -  `uc\_request\_answer\_chan <#v:uc_request_answer_chan>`__ ::
      TQueue (`NodeAddr <ProtoExtended.html#t:NodeAddr>`__,
      `Proto <ProtoExtended.html#t:Proto>`__)
   -  `uc\_debug <#v:uc_debug>`__ :: Bool
   -  `uc\_log <#v:uc_log>`__ :: TQueue String

   }
-  type `UpdatesMap <#t:UpdatesMap>`__ = TVar (HashMap
   `NodeAddr <ProtoExtended.html#t:NodeAddr>`__
   `UpdatesSocket <MemServerAsyncTest.html#t:UpdatesSocket>`__)
-  type `UpdatesSocket <#t:UpdatesSocket>`__ = Socket Push
-  `updateEngine <#v:updateEngine>`__ ::
   `UpdateMonad <MemServerAsyncTest.html#t:UpdateMonad>`__ ()
-  `toClient <#v:toClient>`__ ::
   `NodeAddr <ProtoExtended.html#t:NodeAddr>`__ ->
   `Proto <ProtoExtended.html#t:Proto>`__ ->
   `UpdateMonad <MemServerAsyncTest.html#t:UpdateMonad>`__ ()
-  data `IncomingConfig <#t:IncomingConfig>`__ = `IC <#v:IC>`__ {

   -  `ic\_context <#v:ic_context>`__ :: Context
   -  `ic\_incoming <#v:ic_incoming>`__ ::
      `Incoming <MemServerAsyncTest.html#t:Incoming>`__
   -  `ic\_request\_answer\_chan <#v:ic_request_answer_chan>`__ ::
      TQueue (`NodeAddr <ProtoExtended.html#t:NodeAddr>`__,
      `Proto <ProtoExtended.html#t:Proto>`__)
   -  `ic\_debug <#v:ic_debug>`__ :: Bool
   -  `ic\_log <#v:ic_log>`__ :: TQueue String

   }
-  type `Incoming <#t:Incoming>`__ = Socket Pull
-  type `IncomingMonad <#t:IncomingMonad>`__ =
   `ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__
   `IncomingConfig <MemServerAsyncTest.html#t:IncomingConfig>`__
-  `incomingEngine <#v:incomingEngine>`__ ::
   `IncomingMonad <MemServerAsyncTest.html#t:IncomingMonad>`__ ()
-  `receiveProto <#v:receiveProto>`__ :: (MonadIO m, Receiver a,
   `PrintDebug <MemServerAsyncTest.html#t:PrintDebug>`__ m) => Socket a
   -> m `Proto <ProtoExtended.html#t:Proto>`__
-  `sendProto <#v:sendProto>`__ ::
   (`PrintDebug <MemServerAsyncTest.html#t:PrintDebug>`__ m, MonadIO m,
   Sender a) => Socket a -> `Proto <ProtoExtended.html#t:Proto>`__ -> m
   ()
-  `asksTVar <#v:asksTVar>`__ :: (c -> TVar a) ->
   `ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__ c a
-  `modifysTVar <#v:modifysTVar>`__ :: (c -> TVar a) -> (a -> a) ->
   `ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__ c ()
-  `liftSTM <#v:liftSTM>`__ :: STM a ->
   `ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__ c a
-  `queryNode <#v:queryNode>`__ ::
   `QueryChan <Data-MemTimeState.html#t:QueryChan>`__ -> Socket Pull ->
   Socket Req -> String -> `Proto <ProtoExtended.html#t:Proto>`__ -> IO
   `Proto <ProtoExtended.html#t:Proto>`__
-  `get\_ic\_config <#v:get_ic_config>`__ :: (t, t1, t2) -> t1
-  `get\_pc\_config <#v:get_pc_config>`__ :: (t, t1, t2) -> t
-  `get\_uc\_config <#v:get_uc_config>`__ :: (t, t1, t2) -> t2
-  `client' <#v:client-39->`__ :: Socket Pull -> Socket Req -> String ->
   `Proto <ProtoExtended.html#t:Proto>`__ -> IO
   `Proto <ProtoExtended.html#t:Proto>`__
-  `tryTakeMVarT <#v:tryTakeMVarT>`__ :: Int -> MVar
   `Proto <ProtoExtended.html#t:Proto>`__ -> IO
   `Proto <ProtoExtended.html#t:Proto>`__
-  class `PrintDebug <#t:PrintDebug>`__ m where

   -  `printDebug <#v:printDebug>`__ :: Show a => a -> m ()

-  `clientCommand <#v:clientCommand>`__ :: String -> String ->
   `Proto <ProtoExtended.html#t:Proto>`__ -> IO ()

Documentation
=============

newtype ProtoMonad c a

Constructors

ProtoMonad

 

Fields

unProtoMonad :: ReaderT c IO a
     

Instances

+---------------------------------------------------------------------------------------------------------------------+-----+
| `PrintDebug <MemServerAsyncTest.html#t:PrintDebug>`__ `IncomingMonad <MemServerAsyncTest.html#t:IncomingMonad>`__   |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| `PrintDebug <MemServerAsyncTest.html#t:PrintDebug>`__ `UpdateMonad <MemServerAsyncTest.html#t:UpdateMonad>`__       |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| `PrintDebug <MemServerAsyncTest.html#t:PrintDebug>`__ `RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__     |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| MonadReader c (`ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__ c)                                             |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| Monad (`ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__ c)                                                     |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| Functor (`ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__ c)                                                   |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| MonadPlus (`ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__ c)                                                 |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| Applicative (`ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__ c)                                               |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| MonadIO (`ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__ c)                                                   |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| Alternative (`ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__ c)                                               |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| MonadCatchIO (`ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__ c)                                              |     |
+---------------------------------------------------------------------------------------------------------------------+-----+

runProtoMonad :: c ->
`ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__ c a -> IO a

type RequestMonad =
`ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__
`RequestConfig <MemServerAsyncTest.html#t:RequestConfig>`__

Request engine, - accepts incoming requests and processes them \|

startNode ::
`ConfigParameters <MemServerAsyncTest.html#t:ConfigParameters>`__ -> IO
(`RequestConfig <MemServerAsyncTest.html#t:RequestConfig>`__,
`IncomingConfig <MemServerAsyncTest.html#t:IncomingConfig>`__,
`UpdateConfig <MemServerAsyncTest.html#t:UpdateConfig>`__)

data ConfigParameters

Constructors

RP

 

Fields

param\_pull :: String
     
param\_req :: String
     
param\_qc :: `QueryChan <Data-MemTimeState.html#t:QueryChan>`__
     
debug :: Bool
     

data RequestConfig

Constructors

PC

 

Fields

pc\_context :: Context
     
pc\_memstate :: `QueryChan <Data-MemTimeState.html#t:QueryChan>`__
     
pc\_request ::
`RequestSocket <MemServerAsyncTest.html#t:RequestSocket>`__
     
pc\_upstream\_map ::
`UpstreamMap <MemServerAsyncTest.html#t:UpstreamMap>`__
     
pc\_request\_answer\_chan :: TQueue
(`NodeAddr <ProtoExtended.html#t:NodeAddr>`__,
`Proto <ProtoExtended.html#t:Proto>`__)
     
pc\_address :: `NodeAddr <ProtoExtended.html#t:NodeAddr>`__
     
pc\_incoming :: `NodeAddr <ProtoExtended.html#t:NodeAddr>`__
     
pc\_debug :: Bool
     
pc\_log :: TQueue String
     

Instances

+-------------------------------------------------------------------------------------------------------------------+-----+
| `PrintDebug <MemServerAsyncTest.html#t:PrintDebug>`__ `RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__   |     |
+-------------------------------------------------------------------------------------------------------------------+-----+

type UpstreamMap = TVar (HashMap
`NodeAddr <ProtoExtended.html#t:NodeAddr>`__
`UpstreamSocket <MemServerAsyncTest.html#t:UpstreamSocket>`__)

type RequestSocket = Socket Rep

type UpstreamSocket = Socket Req

requestEngine ::
`RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__ ()

handleQuery ::
`RequestSocket <MemServerAsyncTest.html#t:RequestSocket>`__ ->
`Proto <ProtoExtended.html#t:Proto>`__ ->
`RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__ ()

sendAnswer :: `NodeAddr <ProtoExtended.html#t:NodeAddr>`__ ->
`Proto <ProtoExtended.html#t:Proto>`__ ->
`RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__ ()

handleCommand :: Sender a => Socket a ->
`Proto <ProtoExtended.html#t:Proto>`__ ->
`RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__ ()

connectToNode :: `NodeAddr <ProtoExtended.html#t:NodeAddr>`__ ->
`RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__ ()

runMemQuery :: `Query <Data-MemTimeState.html#t:Query>`__ ->
`RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__
`Result <Data-MemTimeState.html#t:Result>`__

toNodes :: `Proto <ProtoExtended.html#t:Proto>`__ ->
`RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__ ()

sendUpstream :: `Proto <ProtoExtended.html#t:Proto>`__ ->
`RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__ ()

type UpdateMonad = `ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__
`UpdateConfig <MemServerAsyncTest.html#t:UpdateConfig>`__

Update engine, - accepts a local update and processes them \|

data UpdateConfig

Constructors

UC

 

Fields

uc\_context :: Context
     
uc\_updates\_map ::
`UpdatesMap <MemServerAsyncTest.html#t:UpdatesMap>`__
     
uc\_request\_answer\_chan :: TQueue
(`NodeAddr <ProtoExtended.html#t:NodeAddr>`__,
`Proto <ProtoExtended.html#t:Proto>`__)
     
uc\_debug :: Bool
     
uc\_log :: TQueue String
     

Instances

+-----------------------------------------------------------------------------------------------------------------+-----+
| `PrintDebug <MemServerAsyncTest.html#t:PrintDebug>`__ `UpdateMonad <MemServerAsyncTest.html#t:UpdateMonad>`__   |     |
+-----------------------------------------------------------------------------------------------------------------+-----+

type UpdatesMap = TVar (HashMap
`NodeAddr <ProtoExtended.html#t:NodeAddr>`__
`UpdatesSocket <MemServerAsyncTest.html#t:UpdatesSocket>`__)

type UpdatesSocket = Socket Push

updateEngine :: `UpdateMonad <MemServerAsyncTest.html#t:UpdateMonad>`__
()

toClient :: `NodeAddr <ProtoExtended.html#t:NodeAddr>`__ ->
`Proto <ProtoExtended.html#t:Proto>`__ ->
`UpdateMonad <MemServerAsyncTest.html#t:UpdateMonad>`__ ()

data IncomingConfig

Constructors

IC

 

Fields

ic\_context :: Context
     
ic\_incoming :: `Incoming <MemServerAsyncTest.html#t:Incoming>`__
     
ic\_request\_answer\_chan :: TQueue
(`NodeAddr <ProtoExtended.html#t:NodeAddr>`__,
`Proto <ProtoExtended.html#t:Proto>`__)
     
ic\_debug :: Bool
     
ic\_log :: TQueue String
     

Instances

+---------------------------------------------------------------------------------------------------------------------+-----+
| `PrintDebug <MemServerAsyncTest.html#t:PrintDebug>`__ `IncomingMonad <MemServerAsyncTest.html#t:IncomingMonad>`__   |     |
+---------------------------------------------------------------------------------------------------------------------+-----+

type Incoming = Socket Pull

type IncomingMonad =
`ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__
`IncomingConfig <MemServerAsyncTest.html#t:IncomingConfig>`__

incomingEngine ::
`IncomingMonad <MemServerAsyncTest.html#t:IncomingMonad>`__ ()

receiveProto :: (MonadIO m, Receiver a,
`PrintDebug <MemServerAsyncTest.html#t:PrintDebug>`__ m) => Socket a ->
m `Proto <ProtoExtended.html#t:Proto>`__

Some tools \|

sendProto :: (`PrintDebug <MemServerAsyncTest.html#t:PrintDebug>`__ m,
MonadIO m, Sender a) => Socket a ->
`Proto <ProtoExtended.html#t:Proto>`__ -> m ()

asksTVar :: (c -> TVar a) ->
`ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__ c a

modifysTVar :: (c -> TVar a) -> (a -> a) ->
`ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__ c ()

liftSTM :: STM a ->
`ProtoMonad <MemServerAsyncTest.html#t:ProtoMonad>`__ c a

queryNode :: `QueryChan <Data-MemTimeState.html#t:QueryChan>`__ ->
Socket Pull -> Socket Req -> String ->
`Proto <ProtoExtended.html#t:Proto>`__ -> IO
`Proto <ProtoExtended.html#t:Proto>`__

get\_ic\_config :: (t, t1, t2) -> t1

get\_pc\_config :: (t, t1, t2) -> t

get\_uc\_config :: (t, t1, t2) -> t2

client' :: Socket Pull -> Socket Req -> String ->
`Proto <ProtoExtended.html#t:Proto>`__ -> IO
`Proto <ProtoExtended.html#t:Proto>`__

tryTakeMVarT :: Int -> MVar `Proto <ProtoExtended.html#t:Proto>`__ -> IO
`Proto <ProtoExtended.html#t:Proto>`__

class PrintDebug m where

Methods

printDebug :: Show a => a -> m ()

Instances

+---------------------------------------------------------------------------------------------------------------------+-----+
| `PrintDebug <MemServerAsyncTest.html#t:PrintDebug>`__ IO                                                            |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| `PrintDebug <MemServerAsyncTest.html#t:PrintDebug>`__ `IncomingMonad <MemServerAsyncTest.html#t:IncomingMonad>`__   |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| `PrintDebug <MemServerAsyncTest.html#t:PrintDebug>`__ `UpdateMonad <MemServerAsyncTest.html#t:UpdateMonad>`__       |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| `PrintDebug <MemServerAsyncTest.html#t:PrintDebug>`__ `RequestMonad <MemServerAsyncTest.html#t:RequestMonad>`__     |     |
+---------------------------------------------------------------------------------------------------------------------+-----+

clientCommand :: String -> String ->
`Proto <ProtoExtended.html#t:Proto>`__ -> IO ()

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
