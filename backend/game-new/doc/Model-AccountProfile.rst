====================
Model.AccountProfile
====================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.AccountProfile

Documentation
=============

type MString = Maybe String

type MInteger = Maybe Integer

data AccountProfile

Constructors

AccountProfile

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
firstname :: `MString <Model-AccountProfile.html#t:MString>`__
     
lastname :: `MString <Model-AccountProfile.html#t:MString>`__
     
nickname :: `MString <Model-AccountProfile.html#t:MString>`__
     
picture\_small :: `MString <Model-AccountProfile.html#t:MString>`__
     
picture\_medium :: `MString <Model-AccountProfile.html#t:MString>`__
     
picture\_large :: `MString <Model-AccountProfile.html#t:MString>`__
     
level :: `MInteger <Model-AccountProfile.html#t:MInteger>`__
     
skill\_acceleration :: Integer
     
skill\_braking :: Integer
     
skill\_control :: Integer
     
skill\_reactions :: Integer
     
skill\_intelligence :: Integer
     
money :: Integer
     
respect :: Integer
     
diamonds :: Integer
     
energy :: Integer
     
max\_energy :: Integer
     
energy\_recovery :: Integer
     
energy\_updated :: Integer
     
busy\_until :: Integer
     
till :: Integer
     
city\_id :: Integer
     
city\_name :: String
     
continent\_id :: Integer
     
continent\_name :: String
     
skill\_unused :: Integer
     
busy\_subject\_id :: Integer
     
busy\_type :: String
     
busy\_timeleft :: Integer
     
free\_car :: Bool
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `AccountProfile <Model-AccountProfile.html#t:AccountProfile>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `AccountProfile <Model-AccountProfile.html#t:AccountProfile>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `AccountProfile <Model-AccountProfile.html#t:AccountProfile>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `AccountProfile <Model-AccountProfile.html#t:AccountProfile>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `AccountProfile <Model-AccountProfile.html#t:AccountProfile>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `AccountProfile <Model-AccountProfile.html#t:AccountProfile>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `AccountProfile <Model-AccountProfile.html#t:AccountProfile>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `AccountProfile <Model-AccountProfile.html#t:AccountProfile>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToAccountProfileMin <Model-AccountProfileMin.html#t:ToAccountProfileMin>`__ `AccountProfile <Model-AccountProfile.html#t:AccountProfile>`__                          |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `AccountProfile <Model-AccountProfile.html#t:AccountProfile>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
