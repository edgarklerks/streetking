% Data.Hstore
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.Hstore

Documentation
=============

parseHStore :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[HStore](Data-Hstore.html#t:HStore)

newtype HStore

Constructors

HS

 

Fields

unHS :: HashMap String String
:    

Instances

  ------------------------------------------------------------------------------------------------- ---
  Eq [HStore](Data-Hstore.html#t:HStore)                                                             
  Show [HStore](Data-Hstore.html#t:HStore)                                                           
  Default [HStore](Data-Hstore.html#t:HStore)                                                        
  Convertible [SqlValue](Data-SqlTransaction.html#t:SqlValue) [HStore](Data-Hstore.html#t:HStore)    
  Convertible [HStore](Data-Hstore.html#t:HStore) [SqlValue](Data-SqlTransaction.html#t:SqlValue)    
  ------------------------------------------------------------------------------------------------- ---

ppHStore :: [HStore](Data-Hstore.html#t:HStore) -\> String

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
