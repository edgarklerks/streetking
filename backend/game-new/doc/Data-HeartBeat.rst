==============
Data.HeartBeat
==============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.HeartBeat

Synopsis

-  type `Address <#t:Address>`__ = String
-  data `Beat <#t:Beat>`__ where

   -  `Alive <#v:Alive>`__ ::
      `Address <Data-HeartBeat.html#t:Address>`__ -> Maybe ByteString ->
      `Beat <Data-HeartBeat.html#t:Beat>`__
   -  `Error <#v:Error>`__ :: `Beat <Data-HeartBeat.html#t:Beat>`__

-  type `ClientC <#t:ClientC>`__ = Either String () -> IO (Maybe
   ByteString)
-  type `ServerC <#t:ServerC>`__ = `Beat <Data-HeartBeat.html#t:Beat>`__
   -> IO (Either String ())
-  `delay <#v:delay>`__ :: Int
-  `checkin <#v:checkin>`__ ::
   `Address <Data-HeartBeat.html#t:Address>`__ ->
   `Address <Data-HeartBeat.html#t:Address>`__ ->
   `ClientC <Data-HeartBeat.html#t:ClientC>`__ -> IO ()
-  `hotelManager <#v:hotelManager>`__ ::
   `Cycle <Data-ExternalLog.html#t:Cycle>`__ ->
   `Address <Data-HeartBeat.html#t:Address>`__ ->
   `ServerC <Data-HeartBeat.html#t:ServerC>`__ -> IO ()
-  `hotelManager' <#v:hotelManager-39->`__ ::
   `Cycle <Data-ExternalLog.html#t:Cycle>`__ ->
   `Address <Data-HeartBeat.html#t:Address>`__ ->
   `ServerC <Data-HeartBeat.html#t:ServerC>`__ -> IO ()
-  `testHeartBeat <#v:testHeartBeat>`__ :: IO ()

Documentation
=============

type Address = String

-  - We need to a way to let the proxy server know, that a client is: -
   \* Still alive - \* Wants to be connected - - We can do this by a
   heartbeat. Send over a separate channel. - - The proxy server has a
   server running, which accepts new connections. - A backend server can
   connect to the proxy and announce itself. - The proxy can accept it
   or decline it. - In accept the backend server sends every n seconds a
   alive beat. - - This can be extended by some statistics to make the
   load-balancing - function more advanced. - \|

data Beat where

Constructors

+---------------------------------------------------------------------------------------------------------------------+-----+
| Alive :: `Address <Data-HeartBeat.html#t:Address>`__ -> Maybe ByteString -> `Beat <Data-HeartBeat.html#t:Beat>`__   |     |
+---------------------------------------------------------------------------------------------------------------------+-----+
| Error :: `Beat <Data-HeartBeat.html#t:Beat>`__                                                                      |     |
+---------------------------------------------------------------------------------------------------------------------+-----+

Instances

+---------------------------------------------------+-----+
| Show `Beat <Data-HeartBeat.html#t:Beat>`__        |     |
+---------------------------------------------------+-----+
| Serialize `Beat <Data-HeartBeat.html#t:Beat>`__   |     |
+---------------------------------------------------+-----+

type ClientC = Either String () -> IO (Maybe ByteString)

type ServerC = `Beat <Data-HeartBeat.html#t:Beat>`__ -> IO (Either
String ())

delay :: Int

checkin :: `Address <Data-HeartBeat.html#t:Address>`__ ->
`Address <Data-HeartBeat.html#t:Address>`__ ->
`ClientC <Data-HeartBeat.html#t:ClientC>`__ -> IO ()

check your self into a proxy and start heartbeating

hotelManager :: `Cycle <Data-ExternalLog.html#t:Cycle>`__ ->
`Address <Data-HeartBeat.html#t:Address>`__ ->
`ServerC <Data-HeartBeat.html#t:ServerC>`__ -> IO ()

handle authorizations by binding to the address

hotelManager' :: `Cycle <Data-ExternalLog.html#t:Cycle>`__ ->
`Address <Data-HeartBeat.html#t:Address>`__ ->
`ServerC <Data-HeartBeat.html#t:ServerC>`__ -> IO ()

testHeartBeat :: IO ()

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
