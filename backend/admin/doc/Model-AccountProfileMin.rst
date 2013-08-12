=======================
Model.AccountProfileMin
=======================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.AccountProfileMin

Documentation
=============

type MString = Maybe String

type MInteger = Maybe Integer

data AccountProfileMin

Constructors

AccountProfileMin

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
nickname :: String
     
picture\_small :: `MString <Model-AccountProfileMin.html#t:MString>`__
     
picture\_medium :: `MString <Model-AccountProfileMin.html#t:MString>`__
     
picture\_large :: `MString <Model-AccountProfileMin.html#t:MString>`__
     
level :: Integer
     
city\_name :: String
     
continent\_name :: String
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

class ToAccountProfileMin a where

Methods

toAPM :: a ->
`AccountProfileMin <Model-AccountProfileMin.html#t:AccountProfileMin>`__

Instances

+------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToAccountProfileMin <Model-AccountProfileMin.html#t:ToAccountProfileMin>`__ `AccountProfile <Model-AccountProfile.html#t:AccountProfile>`__   |     |
+------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToAccountProfileMin <Model-AccountProfileMin.html#t:ToAccountProfileMin>`__ `Account <Model-Account.html#t:Account>`__                        |     |
+------------------------------------------------------------------------------------------------------------------------------------------------+-----+

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
