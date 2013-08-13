============
Model.Config
============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.Config

Documentation
=============

data Config

Constructors

Config

 

Fields

key :: String
     
value :: String
     

Instances

+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `Config <Model-Config.html#t:Config>`__                                                                                                    |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `Config <Model-Config.html#t:Config>`__                                                                                                  |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Config <Model-Config.html#t:Config>`__                                                                                                |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Config <Model-Config.html#t:Config>`__                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `Config <Model-Config.html#t:Config>`__                                                                                               |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Config <Model-Config.html#t:Config>`__                                                       |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Config <Model-Config.html#t:Config>`__                                                           |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `Config <Model-Config.html#t:Config>`__                                                            |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `Config <Model-Config.html#t:Config>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

getKey :: Read a => String ->
`SqlTransaction <Data-SqlTransaction.html#t:SqlTransaction>`__
`Connection <Data-SqlTransaction.html#t:Connection>`__ a

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
