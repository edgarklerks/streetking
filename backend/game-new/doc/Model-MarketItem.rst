================
Model.MarketItem
================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.MarketItem

Documentation
=============

type MInteger = Maybe Integer

data MarketItem

Constructors

MarketItem

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
car\_instance\_id :: `MInteger <Model-MarketItem.html#t:MInteger>`__
     
part\_instance\_id :: `MInteger <Model-MarketItem.html#t:MInteger>`__
     
price :: Integer
     
account\_id :: Integer
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `MarketItem <Model-MarketItem.html#t:MarketItem>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `MarketItem <Model-MarketItem.html#t:MarketItem>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `MarketItem <Model-MarketItem.html#t:MarketItem>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `MarketItem <Model-MarketItem.html#t:MarketItem>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `MarketItem <Model-MarketItem.html#t:MarketItem>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `MarketItem <Model-MarketItem.html#t:MarketItem>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `MarketItem <Model-MarketItem.html#t:MarketItem>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `MarketItem <Model-MarketItem.html#t:MarketItem>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `MarketItem <Model-MarketItem.html#t:MarketItem>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
