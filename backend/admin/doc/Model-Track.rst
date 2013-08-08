===========
Model.Track
===========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Track

Documentation
=============

type MInteger = Maybe Integer

type Data = Maybe String

data Track

Constructors

Track

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
name :: String
     
city\_id :: Integer
     
level :: Integer
     
data :: `Data <Model-Track.html#t:Data>`__
     
loop :: Bool
     
length :: Integer
     
top\_time\_id :: `MInteger <Model-Track.html#t:MInteger>`__
     
energy\_cost :: Integer
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Track <Model-Track.html#t:Track>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Track <Model-Track.html#t:Track>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Track <Model-Track.html#t:Track>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Track <Model-Track.html#t:Track>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `Track <Model-Track.html#t:Track>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Track <Model-Track.html#t:Track>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Track <Model-Track.html#t:Track>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Track <Model-Track.html#t:Track>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Track <Model-Track.html#t:Track>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
