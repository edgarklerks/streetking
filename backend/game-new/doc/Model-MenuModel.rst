===============
Model.MenuModel
===============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Model.MenuModel

Documentation
=============

type MString = Maybe String

data MenuModel

Constructors

MenuModel

 

Fields

id :: `Id <Model-General.html#t:Id>`__
     
number :: Int
     
parent :: Int
     
type :: String
     
label :: String
     
module :: String
     
class :: String
     
menu\_type :: `MString <Model-MenuModel.html#t:MString>`__
     

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `MenuModel <Model-MenuModel.html#t:MenuModel>`__                                                                                                    |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `MenuModel <Model-MenuModel.html#t:MenuModel>`__                                                                                                  |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `MenuModel <Model-MenuModel.html#t:MenuModel>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `MenuModel <Model-MenuModel.html#t:MenuModel>`__                                                                                              |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Default `MenuModel <Model-MenuModel.html#t:MenuModel>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `MenuModel <Model-MenuModel.html#t:MenuModel>`__                                                       |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `MenuModel <Model-MenuModel.html#t:MenuModel>`__                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Mapable <Model-General.html#t:Mapable>`__ `MenuModel <Model-MenuModel.html#t:MenuModel>`__                                                            |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| `Database <Model-General.html#t:Database>`__ `Connection <Data-SqlTransaction.html#t:Connection>`__ `MenuModel <Model-MenuModel.html#t:MenuModel>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible `FlatTree <Data-MenuTree.html#t:FlatTree>`__ [`MenuModel <Model-MenuModel.html#t:MenuModel>`__\ ]                                          |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible [`MenuModel <Model-MenuModel.html#t:MenuModel>`__\ ] `FlatTree <Data-MenuTree.html#t:FlatTree>`__                                          |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible [`MenuModel <Model-MenuModel.html#t:MenuModel>`__\ ] (Tree `Menu <Data-MenuTree.html#t:Menu>`__)                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible (Tree `Menu <Data-MenuTree.html#t:Menu>`__) [`MenuModel <Model-MenuModel.html#t:MenuModel>`__\ ]                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----+

relation :: `RelationM <Data-Relation.html#t:RelationM>`__

schema :: [[Char]]

tagMenuModel :: String ->
[`MenuModel <Model-MenuModel.html#t:MenuModel>`__\ ] ->
[`MenuModel <Model-MenuModel.html#t:MenuModel>`__\ ]

logintree :: Tree `Menu <Data-MenuTree.html#t:Menu>`__

gametree :: Tree `Menu <Data-MenuTree.html#t:Menu>`__

market\_tabstree :: Tree `Menu <Data-MenuTree.html#t:Menu>`__

garage\_tabstree :: Tree `Menu <Data-MenuTree.html#t:Menu>`__

saveTree :: Convertible a
[`MenuModel <Model-MenuModel.html#t:MenuModel>`__\ ] => String -> a ->
IO [Integer]

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
