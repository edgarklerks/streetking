===============
Model.PreLetter
===============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.PreLetter

Documentation
=============

type MInteger = Maybe Integer

type BString = Maybe ByteString

type MString = Maybe String

data PreLetter

Constructors

PreLetter

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
ttl :: `MInteger <Model-PreLetter.html#t:MInteger>`__
     
message :: String
     
title :: String
     
sendat :: Integer
     
to :: Integer
     
from :: `MInteger <Model-PreLetter.html#t:MInteger>`__
     
read :: Bool
     
archive :: Bool
     
data :: `BString <Model-PreLetter.html#t:BString>`__
     
type :: `MString <Model-PreLetter.html#t:MString>`__
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `PreLetter <Model-PreLetter.html#t:PreLetter>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `PreLetter <Model-PreLetter.html#t:PreLetter>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `PreLetter <Model-PreLetter.html#t:PreLetter>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `PreLetter <Model-PreLetter.html#t:PreLetter>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `PreLetter <Model-PreLetter.html#t:PreLetter>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `PreLetter <Model-PreLetter.html#t:PreLetter>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `PreLetter <Model-PreLetter.html#t:PreLetter>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `PreLetter <Model-PreLetter.html#t:PreLetter>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `PreLetter <Model-PreLetter.html#t:PreLetter>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
