=============
Model.Account
=============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Account

Documentation
=============

type MString = Maybe String

data Account

Constructors

Account

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
firstname :: `MString <Model-Account.html#t:MString>`__
     
lastname :: `MString <Model-Account.html#t:MString>`__
     
nickname :: String
     
picture\_small :: `MString <Model-Account.html#t:MString>`__
     
picture\_medium :: `MString <Model-Account.html#t:MString>`__
     
picture\_large :: `MString <Model-Account.html#t:MString>`__
     
level :: Integer
     
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
     
password :: String
     
email :: String
     
skill\_unused :: Integer
     
city :: Integer
     
busy\_type :: Integer
     
busy\_subject\_id :: Integer
     
free\_car :: Bool
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Account <Model-Account.html#t:Account>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Account <Model-Account.html#t:Account>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Account <Model-Account.html#t:Account>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Account <Model-Account.html#t:Account>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `Account <Model-Account.html#t:Account>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Account <Model-Account.html#t:Account>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Account <Model-Account.html#t:Account>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Account <Model-Account.html#t:Account>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToAccountProfileMin <Model-AccountProfileMin.html#t:ToAccountProfileMin>`__ `Account <Model-Account.html#t:Account>`__                          |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToDriver `Account <Model-Account.html#t:Account>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Account <Model-Account.html#t:Account>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
