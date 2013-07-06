% MemServerAsyncTest
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

MemServerAsyncTest

Synopsis

-   newtype [ProtoMonad](#t:ProtoMonad) c a =
    [ProtoMonad](#v:ProtoMonad) {
    -   [unProtoMonad](#v:unProtoMonad) :: ReaderT c IO a

    }
-   [runProtoMonad](#v:runProtoMonad) :: c -\>
    [ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad) c a -\> IO a
-   type [RequestMonad](#t:RequestMonad) =
    [ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad)
    [RequestConfig](MemServerAsyncTest.html#t:RequestConfig)
-   [startNode](#v:startNode) ::
    [ConfigParameters](MemServerAsyncTest.html#t:ConfigParameters) -\>
    IO ([RequestConfig](MemServerAsyncTest.html#t:RequestConfig),
    [IncomingConfig](MemServerAsyncTest.html#t:IncomingConfig),
    [UpdateConfig](MemServerAsyncTest.html#t:UpdateConfig))
-   data [ConfigParameters](#t:ConfigParameters) = [RP](#v:RP) {
    -   [param\_pull](#v:param_pull) :: String
    -   [param\_req](#v:param_req) :: String
    -   [param\_qc](#v:param_qc) ::
        [QueryChan](Data-MemTimeState.html#t:QueryChan)
    -   [debug](#v:debug) :: Bool

    }
-   data [RequestConfig](#t:RequestConfig) = [PC](#v:PC) {
    -   [pc\_context](#v:pc_context) :: Context
    -   [pc\_memstate](#v:pc_memstate) ::
        [QueryChan](Data-MemTimeState.html#t:QueryChan)
    -   [pc\_request](#v:pc_request) ::
        [RequestSocket](MemServerAsyncTest.html#t:RequestSocket)
    -   [pc\_upstream\_map](#v:pc_upstream_map) ::
        [UpstreamMap](MemServerAsyncTest.html#t:UpstreamMap)
    -   [pc\_request\_answer\_chan](#v:pc_request_answer_chan) :: TQueue
        ([NodeAddr](ProtoExtended.html#t:NodeAddr),
        [Proto](ProtoExtended.html#t:Proto))
    -   [pc\_address](#v:pc_address) ::
        [NodeAddr](ProtoExtended.html#t:NodeAddr)
    -   [pc\_incoming](#v:pc_incoming) ::
        [NodeAddr](ProtoExtended.html#t:NodeAddr)
    -   [pc\_debug](#v:pc_debug) :: Bool
    -   [pc\_log](#v:pc_log) :: TQueue String

    }
-   type [UpstreamMap](#t:UpstreamMap) = TVar (HashMap
    [NodeAddr](ProtoExtended.html#t:NodeAddr)
    [UpstreamSocket](MemServerAsyncTest.html#t:UpstreamSocket))
-   type [RequestSocket](#t:RequestSocket) = Socket Rep
-   type [UpstreamSocket](#t:UpstreamSocket) = Socket Req
-   [requestEngine](#v:requestEngine) ::
    [RequestMonad](MemServerAsyncTest.html#t:RequestMonad) ()
-   [handleQuery](#v:handleQuery) ::
    [RequestSocket](MemServerAsyncTest.html#t:RequestSocket) -\>
    [Proto](ProtoExtended.html#t:Proto) -\>
    [RequestMonad](MemServerAsyncTest.html#t:RequestMonad) ()
-   [sendAnswer](#v:sendAnswer) ::
    [NodeAddr](ProtoExtended.html#t:NodeAddr) -\>
    [Proto](ProtoExtended.html#t:Proto) -\>
    [RequestMonad](MemServerAsyncTest.html#t:RequestMonad) ()
-   [handleCommand](#v:handleCommand) :: Sender a =\> Socket a -\>
    [Proto](ProtoExtended.html#t:Proto) -\>
    [RequestMonad](MemServerAsyncTest.html#t:RequestMonad) ()
-   [connectToNode](#v:connectToNode) ::
    [NodeAddr](ProtoExtended.html#t:NodeAddr) -\>
    [RequestMonad](MemServerAsyncTest.html#t:RequestMonad) ()
-   [runMemQuery](#v:runMemQuery) ::
    [Query](Data-MemTimeState.html#t:Query) -\>
    [RequestMonad](MemServerAsyncTest.html#t:RequestMonad)
    [Result](Data-MemTimeState.html#t:Result)
-   [toNodes](#v:toNodes) :: [Proto](ProtoExtended.html#t:Proto) -\>
    [RequestMonad](MemServerAsyncTest.html#t:RequestMonad) ()
-   [sendUpstream](#v:sendUpstream) ::
    [Proto](ProtoExtended.html#t:Proto) -\>
    [RequestMonad](MemServerAsyncTest.html#t:RequestMonad) ()
-   type [UpdateMonad](#t:UpdateMonad) =
    [ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad)
    [UpdateConfig](MemServerAsyncTest.html#t:UpdateConfig)
-   data [UpdateConfig](#t:UpdateConfig) = [UC](#v:UC) {
    -   [uc\_context](#v:uc_context) :: Context
    -   [uc\_updates\_map](#v:uc_updates_map) ::
        [UpdatesMap](MemServerAsyncTest.html#t:UpdatesMap)
    -   [uc\_request\_answer\_chan](#v:uc_request_answer_chan) :: TQueue
        ([NodeAddr](ProtoExtended.html#t:NodeAddr),
        [Proto](ProtoExtended.html#t:Proto))
    -   [uc\_debug](#v:uc_debug) :: Bool
    -   [uc\_log](#v:uc_log) :: TQueue String

    }
-   type [UpdatesMap](#t:UpdatesMap) = TVar (HashMap
    [NodeAddr](ProtoExtended.html#t:NodeAddr)
    [UpdatesSocket](MemServerAsyncTest.html#t:UpdatesSocket))
-   type [UpdatesSocket](#t:UpdatesSocket) = Socket Push
-   [updateEngine](#v:updateEngine) ::
    [UpdateMonad](MemServerAsyncTest.html#t:UpdateMonad) ()
-   [toClient](#v:toClient) :: [NodeAddr](ProtoExtended.html#t:NodeAddr)
    -\> [Proto](ProtoExtended.html#t:Proto) -\>
    [UpdateMonad](MemServerAsyncTest.html#t:UpdateMonad) ()
-   data [IncomingConfig](#t:IncomingConfig) = [IC](#v:IC) {
    -   [ic\_context](#v:ic_context) :: Context
    -   [ic\_incoming](#v:ic_incoming) ::
        [Incoming](MemServerAsyncTest.html#t:Incoming)
    -   [ic\_request\_answer\_chan](#v:ic_request_answer_chan) :: TQueue
        ([NodeAddr](ProtoExtended.html#t:NodeAddr),
        [Proto](ProtoExtended.html#t:Proto))
    -   [ic\_debug](#v:ic_debug) :: Bool
    -   [ic\_log](#v:ic_log) :: TQueue String

    }
-   type [Incoming](#t:Incoming) = Socket Pull
-   type [IncomingMonad](#t:IncomingMonad) =
    [ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad)
    [IncomingConfig](MemServerAsyncTest.html#t:IncomingConfig)
-   [incomingEngine](#v:incomingEngine) ::
    [IncomingMonad](MemServerAsyncTest.html#t:IncomingMonad) ()
-   [receiveProto](#v:receiveProto) :: (MonadIO m, Receiver a,
    [PrintDebug](MemServerAsyncTest.html#t:PrintDebug) m) =\> Socket a
    -\> m [Proto](ProtoExtended.html#t:Proto)
-   [sendProto](#v:sendProto) ::
    ([PrintDebug](MemServerAsyncTest.html#t:PrintDebug) m, MonadIO m,
    Sender a) =\> Socket a -\> [Proto](ProtoExtended.html#t:Proto) -\> m
    ()
-   [asksTVar](#v:asksTVar) :: (c -\> TVar a) -\>
    [ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad) c a
-   [modifysTVar](#v:modifysTVar) :: (c -\> TVar a) -\> (a -\> a) -\>
    [ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad) c ()
-   [liftSTM](#v:liftSTM) :: STM a -\>
    [ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad) c a
-   [queryNode](#v:queryNode) ::
    [QueryChan](Data-MemTimeState.html#t:QueryChan) -\> Socket Pull -\>
    Socket Req -\> String -\> [Proto](ProtoExtended.html#t:Proto) -\> IO
    [Proto](ProtoExtended.html#t:Proto)
-   [get\_ic\_config](#v:get_ic_config) :: (t, t1, t2) -\> t1
-   [get\_pc\_config](#v:get_pc_config) :: (t, t1, t2) -\> t
-   [get\_uc\_config](#v:get_uc_config) :: (t, t1, t2) -\> t2
-   [client'](#v:client-39-) :: Socket Pull -\> Socket Req -\> String
    -\> [Proto](ProtoExtended.html#t:Proto) -\> IO
    [Proto](ProtoExtended.html#t:Proto)
-   [tryTakeMVarT](#v:tryTakeMVarT) :: Int -\> MVar
    [Proto](ProtoExtended.html#t:Proto) -\> IO
    [Proto](ProtoExtended.html#t:Proto)
-   class [PrintDebug](#t:PrintDebug) m where
    -   [printDebug](#v:printDebug) :: Show a =\> a -\> m ()

-   [clientCommand](#v:clientCommand) :: String -\> String -\>
    [Proto](ProtoExtended.html#t:Proto) -\> IO ()

Documentation
=============

newtype ProtoMonad c a

Constructors

ProtoMonad

 

Fields

unProtoMonad :: ReaderT c IO a
:    

Instances

  ------------------------------------------------------------------------------------------------------------- ---
  [PrintDebug](MemServerAsyncTest.html#t:PrintDebug) [IncomingMonad](MemServerAsyncTest.html#t:IncomingMonad)    
  [PrintDebug](MemServerAsyncTest.html#t:PrintDebug) [UpdateMonad](MemServerAsyncTest.html#t:UpdateMonad)        
  [PrintDebug](MemServerAsyncTest.html#t:PrintDebug) [RequestMonad](MemServerAsyncTest.html#t:RequestMonad)      
  MonadReader c ([ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad) c)                                           
  Monad ([ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad) c)                                                   
  Functor ([ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad) c)                                                 
  MonadPlus ([ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad) c)                                               
  Applicative ([ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad) c)                                             
  MonadIO ([ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad) c)                                                 
  Alternative ([ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad) c)                                             
  MonadCatchIO ([ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad) c)                                            
  ------------------------------------------------------------------------------------------------------------- ---

runProtoMonad :: c -\>
[ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad) c a -\> IO a

type RequestMonad = [ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad)
[RequestConfig](MemServerAsyncTest.html#t:RequestConfig)

Request engine, - accepts incoming requests and processes them |

startNode ::
[ConfigParameters](MemServerAsyncTest.html#t:ConfigParameters) -\> IO
([RequestConfig](MemServerAsyncTest.html#t:RequestConfig),
[IncomingConfig](MemServerAsyncTest.html#t:IncomingConfig),
[UpdateConfig](MemServerAsyncTest.html#t:UpdateConfig))

data ConfigParameters

Constructors

RP

 

Fields

param\_pull :: String
:    
param\_req :: String
:    
param\_qc :: [QueryChan](Data-MemTimeState.html#t:QueryChan)
:    
debug :: Bool
:    

data RequestConfig

Constructors

PC

 

Fields

pc\_context :: Context
:    
pc\_memstate :: [QueryChan](Data-MemTimeState.html#t:QueryChan)
:    
pc\_request :: [RequestSocket](MemServerAsyncTest.html#t:RequestSocket)
:    
pc\_upstream\_map :: [UpstreamMap](MemServerAsyncTest.html#t:UpstreamMap)
:    
pc\_request\_answer\_chan :: TQueue ([NodeAddr](ProtoExtended.html#t:NodeAddr), [Proto](ProtoExtended.html#t:Proto))
:    
pc\_address :: [NodeAddr](ProtoExtended.html#t:NodeAddr)
:    
pc\_incoming :: [NodeAddr](ProtoExtended.html#t:NodeAddr)
:    
pc\_debug :: Bool
:    
pc\_log :: TQueue String
:    

Instances

  ----------------------------------------------------------------------------------------------------------- ---
  [PrintDebug](MemServerAsyncTest.html#t:PrintDebug) [RequestMonad](MemServerAsyncTest.html#t:RequestMonad)    
  ----------------------------------------------------------------------------------------------------------- ---

type UpstreamMap = TVar (HashMap
[NodeAddr](ProtoExtended.html#t:NodeAddr)
[UpstreamSocket](MemServerAsyncTest.html#t:UpstreamSocket))

type RequestSocket = Socket Rep

type UpstreamSocket = Socket Req

requestEngine :: [RequestMonad](MemServerAsyncTest.html#t:RequestMonad)
()

handleQuery :: [RequestSocket](MemServerAsyncTest.html#t:RequestSocket)
-\> [Proto](ProtoExtended.html#t:Proto) -\>
[RequestMonad](MemServerAsyncTest.html#t:RequestMonad) ()

sendAnswer :: [NodeAddr](ProtoExtended.html#t:NodeAddr) -\>
[Proto](ProtoExtended.html#t:Proto) -\>
[RequestMonad](MemServerAsyncTest.html#t:RequestMonad) ()

handleCommand :: Sender a =\> Socket a -\>
[Proto](ProtoExtended.html#t:Proto) -\>
[RequestMonad](MemServerAsyncTest.html#t:RequestMonad) ()

connectToNode :: [NodeAddr](ProtoExtended.html#t:NodeAddr) -\>
[RequestMonad](MemServerAsyncTest.html#t:RequestMonad) ()

runMemQuery :: [Query](Data-MemTimeState.html#t:Query) -\>
[RequestMonad](MemServerAsyncTest.html#t:RequestMonad)
[Result](Data-MemTimeState.html#t:Result)

toNodes :: [Proto](ProtoExtended.html#t:Proto) -\>
[RequestMonad](MemServerAsyncTest.html#t:RequestMonad) ()

sendUpstream :: [Proto](ProtoExtended.html#t:Proto) -\>
[RequestMonad](MemServerAsyncTest.html#t:RequestMonad) ()

type UpdateMonad = [ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad)
[UpdateConfig](MemServerAsyncTest.html#t:UpdateConfig)

Update engine, - accepts a local update and processes them |

data UpdateConfig

Constructors

UC

 

Fields

uc\_context :: Context
:    
uc\_updates\_map :: [UpdatesMap](MemServerAsyncTest.html#t:UpdatesMap)
:    
uc\_request\_answer\_chan :: TQueue ([NodeAddr](ProtoExtended.html#t:NodeAddr), [Proto](ProtoExtended.html#t:Proto))
:    
uc\_debug :: Bool
:    
uc\_log :: TQueue String
:    

Instances

  --------------------------------------------------------------------------------------------------------- ---
  [PrintDebug](MemServerAsyncTest.html#t:PrintDebug) [UpdateMonad](MemServerAsyncTest.html#t:UpdateMonad)    
  --------------------------------------------------------------------------------------------------------- ---

type UpdatesMap = TVar (HashMap
[NodeAddr](ProtoExtended.html#t:NodeAddr)
[UpdatesSocket](MemServerAsyncTest.html#t:UpdatesSocket))

type UpdatesSocket = Socket Push

updateEngine :: [UpdateMonad](MemServerAsyncTest.html#t:UpdateMonad) ()

toClient :: [NodeAddr](ProtoExtended.html#t:NodeAddr) -\>
[Proto](ProtoExtended.html#t:Proto) -\>
[UpdateMonad](MemServerAsyncTest.html#t:UpdateMonad) ()

data IncomingConfig

Constructors

IC

 

Fields

ic\_context :: Context
:    
ic\_incoming :: [Incoming](MemServerAsyncTest.html#t:Incoming)
:    
ic\_request\_answer\_chan :: TQueue ([NodeAddr](ProtoExtended.html#t:NodeAddr), [Proto](ProtoExtended.html#t:Proto))
:    
ic\_debug :: Bool
:    
ic\_log :: TQueue String
:    

Instances

  ------------------------------------------------------------------------------------------------------------- ---
  [PrintDebug](MemServerAsyncTest.html#t:PrintDebug) [IncomingMonad](MemServerAsyncTest.html#t:IncomingMonad)    
  ------------------------------------------------------------------------------------------------------------- ---

type Incoming = Socket Pull

type IncomingMonad = [ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad)
[IncomingConfig](MemServerAsyncTest.html#t:IncomingConfig)

incomingEngine ::
[IncomingMonad](MemServerAsyncTest.html#t:IncomingMonad) ()

receiveProto :: (MonadIO m, Receiver a,
[PrintDebug](MemServerAsyncTest.html#t:PrintDebug) m) =\> Socket a -\> m
[Proto](ProtoExtended.html#t:Proto)

Some tools |

sendProto :: ([PrintDebug](MemServerAsyncTest.html#t:PrintDebug) m,
MonadIO m, Sender a) =\> Socket a -\>
[Proto](ProtoExtended.html#t:Proto) -\> m ()

asksTVar :: (c -\> TVar a) -\>
[ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad) c a

modifysTVar :: (c -\> TVar a) -\> (a -\> a) -\>
[ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad) c ()

liftSTM :: STM a -\> [ProtoMonad](MemServerAsyncTest.html#t:ProtoMonad)
c a

queryNode :: [QueryChan](Data-MemTimeState.html#t:QueryChan) -\> Socket
Pull -\> Socket Req -\> String -\> [Proto](ProtoExtended.html#t:Proto)
-\> IO [Proto](ProtoExtended.html#t:Proto)

get\_ic\_config :: (t, t1, t2) -\> t1

get\_pc\_config :: (t, t1, t2) -\> t

get\_uc\_config :: (t, t1, t2) -\> t2

client' :: Socket Pull -\> Socket Req -\> String -\>
[Proto](ProtoExtended.html#t:Proto) -\> IO
[Proto](ProtoExtended.html#t:Proto)

tryTakeMVarT :: Int -\> MVar [Proto](ProtoExtended.html#t:Proto) -\> IO
[Proto](ProtoExtended.html#t:Proto)

class PrintDebug m where

Methods

printDebug :: Show a =\> a -\> m ()

Instances

  ------------------------------------------------------------------------------------------------------------- ---
  [PrintDebug](MemServerAsyncTest.html#t:PrintDebug) IO                                                          
  [PrintDebug](MemServerAsyncTest.html#t:PrintDebug) [IncomingMonad](MemServerAsyncTest.html#t:IncomingMonad)    
  [PrintDebug](MemServerAsyncTest.html#t:PrintDebug) [UpdateMonad](MemServerAsyncTest.html#t:UpdateMonad)        
  [PrintDebug](MemServerAsyncTest.html#t:PrintDebug) [RequestMonad](MemServerAsyncTest.html#t:RequestMonad)      
  ------------------------------------------------------------------------------------------------------------- ---

clientCommand :: String -\> String -\>
[Proto](ProtoExtended.html#t:Proto) -\> IO ()

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
