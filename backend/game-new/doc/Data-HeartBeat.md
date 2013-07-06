-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.HeartBeat

Synopsis

-   type [Address](#t:Address) = String
-   data [Beat](#t:Beat) where
    -   [Alive](#v:Alive) :: [Address](Data-HeartBeat.html#t:Address) -\> Maybe ByteString -\> [Beat](Data-HeartBeat.html#t:Beat)
    -   [Error](#v:Error) :: [Beat](Data-HeartBeat.html#t:Beat)

-   type [ClientC](#t:ClientC) = Either String () -\> IO (Maybe ByteString)
-   type [ServerC](#t:ServerC) = [Beat](Data-HeartBeat.html#t:Beat) -\> IO (Either String ())
-   [delay](#v:delay) :: Int
-   [checkin](#v:checkin) :: [Address](Data-HeartBeat.html#t:Address) -\> [Address](Data-HeartBeat.html#t:Address) -\> [ClientC](Data-HeartBeat.html#t:ClientC) -\> IO ()
-   [hotelManager](#v:hotelManager) :: [Cycle](Data-ExternalLog.html#t:Cycle) -\> [Address](Data-HeartBeat.html#t:Address) -\> [ServerC](Data-HeartBeat.html#t:ServerC) -\> IO ()
-   [hotelManager'](#v:hotelManager-39-) :: [Cycle](Data-ExternalLog.html#t:Cycle) -\> [Address](Data-HeartBeat.html#t:Address) -\> [ServerC](Data-HeartBeat.html#t:ServerC) -\> IO ()
-   [testHeartBeat](#v:testHeartBeat) :: IO ()

Documentation
=============

type Address = String

-   - We need to a way to let the proxy server know, that a client is: - \* Still alive - \* Wants to be connected - - We can do this by a heartbeat. Send over a separate channel. - - The proxy server has a server running, which accepts new connections. - A backend server can connect to the proxy and announce itself. - The proxy can accept it or decline it. - In accept the backend server sends every n seconds a alive beat. - - This can be extended by some statistics to make the load-balancing - function more advanced. - |

data Beat where

Constructors

||
|Alive :: [Address](Data-HeartBeat.html#t:Address) -\> Maybe ByteString -\> [Beat](Data-HeartBeat.html#t:Beat)| |
|Error :: [Beat](Data-HeartBeat.html#t:Beat)| |

Instances

||
|Show [Beat](Data-HeartBeat.html#t:Beat)| |
|Serialize [Beat](Data-HeartBeat.html#t:Beat)| |

type ClientC = Either String () -\> IO (Maybe ByteString)

type ServerC = [Beat](Data-HeartBeat.html#t:Beat) -\> IO (Either String ())

delay :: Int

checkin :: [Address](Data-HeartBeat.html#t:Address) -\> [Address](Data-HeartBeat.html#t:Address) -\> [ClientC](Data-HeartBeat.html#t:ClientC) -\> IO ()

check your self into a proxy and start heartbeating

hotelManager :: [Cycle](Data-ExternalLog.html#t:Cycle) -\> [Address](Data-HeartBeat.html#t:Address) -\> [ServerC](Data-HeartBeat.html#t:ServerC) -\> IO ()

handle authorizations by binding to the address

hotelManager' :: [Cycle](Data-ExternalLog.html#t:Cycle) -\> [Address](Data-HeartBeat.html#t:Address) -\> [ServerC](Data-HeartBeat.html#t:ServerC) -\> IO ()

testHeartBeat :: IO ()

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
