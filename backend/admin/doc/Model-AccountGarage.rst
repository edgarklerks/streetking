===================
Model.AccountGarage
===================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.AccountGarage

Documentation
=============

type MString = Maybe String

type MInteger = Maybe Integer

data AccountGarage

Constructors

AccountGarage

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
firstname :: `MString <Model-AccountGarage.html#t:MString>`__
     
lastname :: `MString <Model-AccountGarage.html#t:MString>`__
     
nickname :: `MString <Model-AccountGarage.html#t:MString>`__
     
picture\_small :: `MString <Model-AccountGarage.html#t:MString>`__
     
picture\_medium :: `MString <Model-AccountGarage.html#t:MString>`__
     
picture\_large :: `MString <Model-AccountGarage.html#t:MString>`__
     
level :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     
skill\_acceleration ::
`MInteger <Model-AccountGarage.html#t:MInteger>`__
     
skill\_braking :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     
skill\_control :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     
skill\_reactions :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     
skill\_intelligence ::
`MInteger <Model-AccountGarage.html#t:MInteger>`__
     
money :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     
respect :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     
diamonds :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     
energy :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     
max\_energy :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     
energy\_recovery :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     
energy\_updated :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     
busy\_until :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     
email :: String
     
till :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     
city\_id :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     
city\_name :: String
     
continent\_id :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     
continent\_name :: String
     
skill\_unused :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     
busy\_subject\_id :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     
busy\_type :: String
     
busy\_timeleft :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     
free\_car :: Bool
     
garage\_id :: `MInteger <Model-AccountGarage.html#t:MInteger>`__
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `AccountGarage <Model-AccountGarage.html#t:AccountGarage>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `AccountGarage <Model-AccountGarage.html#t:AccountGarage>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `AccountGarage <Model-AccountGarage.html#t:AccountGarage>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `AccountGarage <Model-AccountGarage.html#t:AccountGarage>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `AccountGarage <Model-AccountGarage.html#t:AccountGarage>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `AccountGarage <Model-AccountGarage.html#t:AccountGarage>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `AccountGarage <Model-AccountGarage.html#t:AccountGarage>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `AccountGarage <Model-AccountGarage.html#t:AccountGarage>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `AccountGarage <Model-AccountGarage.html#t:AccountGarage>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
