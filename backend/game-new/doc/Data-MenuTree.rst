=============
Data.MenuTree
=============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.MenuTree

Documentation
=============

type Module = String

type Label = String

type Class = String

data Menu

Constructors

+-----------------------------------------------------------------------------------------------------------------------------------+-----+
| Root                                                                                                                              |     |
+-----------------------------------------------------------------------------------------------------------------------------------+-----+
| MenuItem `Label <Data-MenuTree.html#t:Label>`__ `Module <Data-MenuTree.html#t:Module>`__ `Class <Data-MenuTree.html#t:Class>`__   |     |
+-----------------------------------------------------------------------------------------------------------------------------------+-----+
| SubMenu `Label <Data-MenuTree.html#t:Label>`__ `Module <Data-MenuTree.html#t:Module>`__ `Class <Data-MenuTree.html#t:Class>`__    |     |
+-----------------------------------------------------------------------------------------------------------------------------------+-----+
| Tab `Label <Data-MenuTree.html#t:Label>`__ `Module <Data-MenuTree.html#t:Module>`__ `Class <Data-MenuTree.html#t:Class>`__        |     |
+-----------------------------------------------------------------------------------------------------------------------------------+-----+

Instances

+-----------------------------------------------------------------------------------------------------------------+-----+
| Eq `Menu <Data-MenuTree.html#t:Menu>`__                                                                         |     |
+-----------------------------------------------------------------------------------------------------------------+-----+
| Show `Menu <Data-MenuTree.html#t:Menu>`__                                                                       |     |
+-----------------------------------------------------------------------------------------------------------------+-----+
| ToJSON `Menu <Data-MenuTree.html#t:Menu>`__                                                                     |     |
+-----------------------------------------------------------------------------------------------------------------+-----+
| FromJSON `Menu <Data-MenuTree.html#t:Menu>`__                                                                   |     |
+-----------------------------------------------------------------------------------------------------------------+-----+
| Convertible `FlatTree <Data-MenuTree.html#t:FlatTree>`__ [`MenuModel <Model-MenuModel.html#t:MenuModel>`__\ ]   |     |
+-----------------------------------------------------------------------------------------------------------------+-----+
| Convertible [`MenuModel <Model-MenuModel.html#t:MenuModel>`__\ ] `FlatTree <Data-MenuTree.html#t:FlatTree>`__   |     |
+-----------------------------------------------------------------------------------------------------------------+-----+
| Convertible [`MenuModel <Model-MenuModel.html#t:MenuModel>`__\ ] (Tree `Menu <Data-MenuTree.html#t:Menu>`__)    |     |
+-----------------------------------------------------------------------------------------------------------------+-----+
| Convertible (Tree `Menu <Data-MenuTree.html#t:Menu>`__) [`MenuModel <Model-MenuModel.html#t:MenuModel>`__\ ]    |     |
+-----------------------------------------------------------------------------------------------------------------+-----+

mkTabs :: `Module <Data-MenuTree.html#t:Module>`__ ->
[`Label <Data-MenuTree.html#t:Label>`__\ ] -> Tree
`Menu <Data-MenuTree.html#t:Menu>`__

type MenuTree = Tree (Int, `Menu <Data-MenuTree.html#t:Menu>`__)

type FlatTree = [((Int, Int), `Menu <Data-MenuTree.html#t:Menu>`__)]

anotateTree :: Tree `Menu <Data-MenuTree.html#t:Menu>`__ ->
`MenuTree <Data-MenuTree.html#t:MenuTree>`__

stripTree :: `MenuTree <Data-MenuTree.html#t:MenuTree>`__ -> Tree
`Menu <Data-MenuTree.html#t:Menu>`__

toFlat :: Tree `Menu <Data-MenuTree.html#t:Menu>`__ ->
`FlatTree <Data-MenuTree.html#t:FlatTree>`__

fromFlat :: `FlatTree <Data-MenuTree.html#t:FlatTree>`__ -> Tree
`Menu <Data-MenuTree.html#t:Menu>`__

testTree :: Tree `Menu <Data-MenuTree.html#t:Menu>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
