=============
Model.Support
=============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Support

Documentation
=============

type AAS = Value

data Support

Constructors

Support

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
account\_id :: Integer
     
message :: String
     
data :: String
     
processed :: Bool
     
created :: Integer
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Support <Model-Support.html#t:Support>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Support <Model-Support.html#t:Support>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Support <Model-Support.html#t:Support>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Support <Model-Support.html#t:Support>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `Support <Model-Support.html#t:Support>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Support <Model-Support.html#t:Support>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Support <Model-Support.html#t:Support>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Support <Model-Support.html#t:Support>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Support <Model-Support.html#t:Support>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
