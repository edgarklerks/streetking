=================
Model.EventStream
=================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.EventStream

Documentation
=============

type Stream = Maybe [`Event <Data-Event.html#t:Event>`__\ ]

data EventStream

Constructors

EventStream

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
account\_id :: `Id <Model-General.html#t:Id>`__
     
rule\_id :: `Id <Model-General.html#t:Id>`__
     
stream :: `Stream <Model-EventStream.html#t:Stream>`__
     
active :: Bool
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `EventStream <Model-EventStream.html#t:EventStream>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `EventStream <Model-EventStream.html#t:EventStream>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `EventStream <Model-EventStream.html#t:EventStream>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `EventStream <Model-EventStream.html#t:EventStream>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `EventStream <Model-EventStream.html#t:EventStream>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `EventStream <Model-EventStream.html#t:EventStream>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `EventStream <Model-EventStream.html#t:EventStream>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `EventStream <Model-EventStream.html#t:EventStream>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `EventStream <Model-EventStream.html#t:EventStream>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

getEventStream :: Convertible a
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ => a -> IO
[`EventStream <Model-EventStream.html#t:EventStream>`__\ ]

emitEvent :: Integer -> `Event <Data-Event.html#t:Event>`__ ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ ()

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
