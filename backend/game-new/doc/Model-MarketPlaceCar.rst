====================
Model.MarketPlaceCar
====================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.MarketPlaceCar

Documentation
=============

type MInteger = Maybe Integer

data MarketPlaceCar

Constructors

MarketPlaceCar

 

Fields

car\_instance\_id :: `Id <Model-General.html#t:Id>`__
     
price :: Integer
     
top\_speed :: Integer
     
acceleration :: Integer
     
cornering :: Integer
     
stopping :: Integer
     
nitrous :: Integer
     
weight :: Integer
     
manufacturer\_name :: String
     
level :: Integer
     
year :: Integer
     
wear :: Integer
     
improvement :: Integer
     
account\_id :: Integer
     
model :: String
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `MarketPlaceCar <Model-MarketPlaceCar.html#t:MarketPlaceCar>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `MarketPlaceCar <Model-MarketPlaceCar.html#t:MarketPlaceCar>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `MarketPlaceCar <Model-MarketPlaceCar.html#t:MarketPlaceCar>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `MarketPlaceCar <Model-MarketPlaceCar.html#t:MarketPlaceCar>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `MarketPlaceCar <Model-MarketPlaceCar.html#t:MarketPlaceCar>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `MarketPlaceCar <Model-MarketPlaceCar.html#t:MarketPlaceCar>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `MarketPlaceCar <Model-MarketPlaceCar.html#t:MarketPlaceCar>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `MarketPlaceCar <Model-MarketPlaceCar.html#t:MarketPlaceCar>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `MarketPlaceCar <Model-MarketPlaceCar.html#t:MarketPlaceCar>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
