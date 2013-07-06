==============
Data.SortOrder
==============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.SortOrder

Documentation
=============

data SortOrder

Constructors

+-----------------------------------------------------------+-----+
| OrderBy String `Dir <Data-SortOrder.html#t:Dir>`__        |     |
+-----------------------------------------------------------+-----+
| Col [`SortOrder <Data-SortOrder.html#t:SortOrder>`__\ ]   |     |
+-----------------------------------------------------------+-----+

Instances

+--------------------------------------------------------+-----+
| Show `SortOrder <Data-SortOrder.html#t:SortOrder>`__   |     |
+--------------------------------------------------------+-----+

data Dir

Constructors

+--------+-----+
| Asc    |     |
+--------+-----+
| Desc   |     |
+--------+-----+

Instances

+--------------------------------------------+-----+
| Show `Dir <Data-SortOrder.html#t:Dir>`__   |     |
+--------------------------------------------+-----+

rtp :: `Dir <Data-SortOrder.html#t:Dir>`__ -> Bool

sortOrder :: `SortOrder <Data-SortOrder.html#t:SortOrder>`__ -> [String]
-> Either String `Orders <Data-Database.html#t:Orders>`__

orderby :: String -> `Dir <Data-SortOrder.html#t:Dir>`__ ->
`SortOrder <Data-SortOrder.html#t:SortOrder>`__

desc :: `Dir <Data-SortOrder.html#t:Dir>`__

asc :: `Dir <Data-SortOrder.html#t:Dir>`__

getSortOrder :: String -> Either String
`SortOrder <Data-SortOrder.html#t:SortOrder>`__

startp :: Parser `SortOrder <Data-SortOrder.html#t:SortOrder>`__

stmp :: Parser [`SortOrder <Data-SortOrder.html#t:SortOrder>`__\ ]

idp :: ParsecT String u Identity [Char]

dirp :: ParsecT String u Identity `Dir <Data-SortOrder.html#t:Dir>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
