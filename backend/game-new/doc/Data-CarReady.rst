=============
Data.CarReady
=============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.CarReady

Documentation
=============

type Car = HashMap Integer Part

data CarReadyState

Constructors

CarReadyState

 

Fields

ready :: Bool
     
missing :: Types
     
worn :: Parts
     

Instances

+----------------------------------------------------------------------------------------------------------+-----+
| Eq `CarReadyState <Data-CarReady.html#t:CarReadyState>`__                                                |     |
+----------------------------------------------------------------------------------------------------------+-----+
| Show `CarReadyState <Data-CarReady.html#t:CarReadyState>`__                                              |     |
+----------------------------------------------------------------------------------------------------------+-----+
| ToJSON `CarReadyState <Data-CarReady.html#t:CarReadyState>`__                                            |     |
+----------------------------------------------------------------------------------------------------------+-----+
| FromJSON `CarReadyState <Data-CarReady.html#t:CarReadyState>`__                                          |     |
+----------------------------------------------------------------------------------------------------------+-----+
| Default `CarReadyState <Data-CarReady.html#t:CarReadyState>`__                                           |     |
+----------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `CarReadyState <Data-CarReady.html#t:CarReadyState>`__   |     |
+----------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `CarReadyState <Data-CarReady.html#t:CarReadyState>`__       |     |
+----------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `CarReadyState <Data-CarReady.html#t:CarReadyState>`__        |     |
+----------------------------------------------------------------------------------------------------------+-----+

carReadyState :: `Car <Data-CarReady.html#t:Car>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`CarReadyState <Data-CarReady.html#t:CarReadyState>`__

carReady :: Integer ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`CarReadyState <Data-CarReady.html#t:CarReadyState>`__

carFromParts :: Parts ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__
`Car <Data-CarReady.html#t:Car>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
