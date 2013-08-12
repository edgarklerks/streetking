=================
Data.MemTimeState
=================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.MemTimeState

Synopsis

-  data `MemState <#t:MemState>`__
-  data `Query <#t:Query>`__ where

   -  `Insert <#v:Insert>`__ :: Key -> Value ->
      `Query <Data-MemTimeState.html#t:Query>`__
   -  `Delete <#v:Delete>`__ :: Key ->
      `Query <Data-MemTimeState.html#t:Query>`__
   -  `Query <#v:Query>`__ :: Key ->
      `Query <Data-MemTimeState.html#t:Query>`__
   -  `DumpState <#v:DumpState>`__ ::
      `Query <Data-MemTimeState.html#t:Query>`__

-  data `Result <#t:Result>`__ where

   -  `Value <#v:Value>`__ :: ByteString ->
      `Result <Data-MemTimeState.html#t:Result>`__
   -  `NotFound <#v:NotFound>`__ ::
      `Result <Data-MemTimeState.html#t:Result>`__
   -  `Empty <#v:Empty>`__ ::
      `Result <Data-MemTimeState.html#t:Result>`__
   -  `Except <#v:Except>`__ :: String ->
      `Result <Data-MemTimeState.html#t:Result>`__
   -  `KeyVal <#v:KeyVal>`__ :: ByteString -> ByteString ->
      `Result <Data-MemTimeState.html#t:Result>`__

-  type `QueryChan <#t:QueryChan>`__ = TQueue
   (`Query <Data-MemTimeState.html#t:Query>`__, Unique
   `Result <Data-MemTimeState.html#t:Result>`__)
-  `runQuery <#v:runQuery>`__ ::
   `QueryChan <Data-MemTimeState.html#t:QueryChan>`__ ->
   `Query <Data-MemTimeState.html#t:Query>`__ -> IO
   `Result <Data-MemTimeState.html#t:Result>`__
-  `newMemState <#v:newMemState>`__ :: Time -> Time -> FilePath -> IO
   `MemState <Data-MemTimeState.html#t:MemState>`__
-  `queryManager <#v:queryManager>`__ :: FilePath ->
   `MemState <Data-MemTimeState.html#t:MemState>`__ ->
   `QueryChan <Data-MemTimeState.html#t:QueryChan>`__ -> IO ()

Documentation
=============

data MemState

The Map is a mapping from a bytestring key to the internal used key. \|
MemMap contains the binary data, indexed by the internal key \| TimeMap
contains the internal keys index by time

data Query where

Constructors

+------------------------------------------------------------------------+-----+
| Insert :: Key -> Value -> `Query <Data-MemTimeState.html#t:Query>`__   |     |
+------------------------------------------------------------------------+-----+
| Delete :: Key -> `Query <Data-MemTimeState.html#t:Query>`__            |     |
+------------------------------------------------------------------------+-----+
| Query :: Key -> `Query <Data-MemTimeState.html#t:Query>`__             |     |
+------------------------------------------------------------------------+-----+
| DumpState :: `Query <Data-MemTimeState.html#t:Query>`__                |     |
+------------------------------------------------------------------------+-----+

Instances

+--------------------------------------------------------+-----+
| Eq `Query <Data-MemTimeState.html#t:Query>`__          |     |
+--------------------------------------------------------+-----+
| Show `Query <Data-MemTimeState.html#t:Query>`__        |     |
+--------------------------------------------------------+-----+
| Serialize `Query <Data-MemTimeState.html#t:Query>`__   |     |
+--------------------------------------------------------+-----+
| Arbitrary `Query <Data-MemTimeState.html#t:Query>`__   |     |
+--------------------------------------------------------+-----+

data Result where

Constructors

+--------------------------------------------------------------------------------------+-----+
| Value :: ByteString -> `Result <Data-MemTimeState.html#t:Result>`__                  |     |
+--------------------------------------------------------------------------------------+-----+
| NotFound :: `Result <Data-MemTimeState.html#t:Result>`__                             |     |
+--------------------------------------------------------------------------------------+-----+
| Empty :: `Result <Data-MemTimeState.html#t:Result>`__                                |     |
+--------------------------------------------------------------------------------------+-----+
| Except :: String -> `Result <Data-MemTimeState.html#t:Result>`__                     |     |
+--------------------------------------------------------------------------------------+-----+
| KeyVal :: ByteString -> ByteString -> `Result <Data-MemTimeState.html#t:Result>`__   |     |
+--------------------------------------------------------------------------------------+-----+

Instances

+----------------------------------------------------------+-----+
| Eq `Result <Data-MemTimeState.html#t:Result>`__          |     |
+----------------------------------------------------------+-----+
| Show `Result <Data-MemTimeState.html#t:Result>`__        |     |
+----------------------------------------------------------+-----+
| Serialize `Result <Data-MemTimeState.html#t:Result>`__   |     |
+----------------------------------------------------------+-----+
| Arbitrary `Result <Data-MemTimeState.html#t:Result>`__   |     |
+----------------------------------------------------------+-----+

type QueryChan = TQueue (`Query <Data-MemTimeState.html#t:Query>`__,
Unique `Result <Data-MemTimeState.html#t:Result>`__)

runQuery :: `QueryChan <Data-MemTimeState.html#t:QueryChan>`__ ->
`Query <Data-MemTimeState.html#t:Query>`__ -> IO
`Result <Data-MemTimeState.html#t:Result>`__

newMemState :: Time -> Time -> FilePath -> IO
`MemState <Data-MemTimeState.html#t:MemState>`__

queryManager :: FilePath ->
`MemState <Data-MemTimeState.html#t:MemState>`__ ->
`QueryChan <Data-MemTimeState.html#t:QueryChan>`__ -> IO ()

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
