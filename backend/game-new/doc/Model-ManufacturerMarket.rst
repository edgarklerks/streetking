========================
Model.ManufacturerMarket
========================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.ManufacturerMarket

Documentation
=============

data ManufacturerMarket

Constructors

ManufacturerMarket

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
name :: String
     
picture :: String
     
text :: String
     
label :: String
     
level :: Integer
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `ManufacturerMarket <Model-ManufacturerMarket.html#t:ManufacturerMarket>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `ManufacturerMarket <Model-ManufacturerMarket.html#t:ManufacturerMarket>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `ManufacturerMarket <Model-ManufacturerMarket.html#t:ManufacturerMarket>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `ManufacturerMarket <Model-ManufacturerMarket.html#t:ManufacturerMarket>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `ManufacturerMarket <Model-ManufacturerMarket.html#t:ManufacturerMarket>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `ManufacturerMarket <Model-ManufacturerMarket.html#t:ManufacturerMarket>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `ManufacturerMarket <Model-ManufacturerMarket.html#t:ManufacturerMarket>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `ManufacturerMarket <Model-ManufacturerMarket.html#t:ManufacturerMarket>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `ManufacturerMarket <Model-ManufacturerMarket.html#t:ManufacturerMarket>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
