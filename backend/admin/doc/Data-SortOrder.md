% Data.SortOrder
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.SortOrder

Documentation
=============

data SortOrder

Constructors

  ---------------------------------------------------- ---
  OrderBy String [Dir](Data-SortOrder.html#t:Dir)       
  Col [[SortOrder](Data-SortOrder.html#t:SortOrder)]    
  ---------------------------------------------------- ---

Instances

  --------------------------------------------------- ---
  Show [SortOrder](Data-SortOrder.html#t:SortOrder)    
  --------------------------------------------------- ---

data Dir

Constructors

  ------ ---
  Asc     
  Desc    
  ------ ---

Instances

  --------------------------------------- ---
  Show [Dir](Data-SortOrder.html#t:Dir)    
  --------------------------------------- ---

rtp :: [Dir](Data-SortOrder.html#t:Dir) -\> Bool

sortOrder :: [SortOrder](Data-SortOrder.html#t:SortOrder) -\> [String]
-\> Either String [Orders](Data-Database.html#t:Orders)

orderby :: String -\> [Dir](Data-SortOrder.html#t:Dir) -\>
[SortOrder](Data-SortOrder.html#t:SortOrder)

desc :: [Dir](Data-SortOrder.html#t:Dir)

asc :: [Dir](Data-SortOrder.html#t:Dir)

getSortOrder :: String -\> Either String
[SortOrder](Data-SortOrder.html#t:SortOrder)

startp :: Parser [SortOrder](Data-SortOrder.html#t:SortOrder)

stmp :: Parser [[SortOrder](Data-SortOrder.html#t:SortOrder)]

idp :: ParsecT String u Identity [Char]

dirp :: ParsecT String u Identity [Dir](Data-SortOrder.html#t:Dir)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
