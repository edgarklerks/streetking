% Data.Relation
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.Relation

Documentation
=============

data Relation

Instances

  ---------------------------------------------------- ---
  Show [Relation](Data-Relation.html#t:Relation)        
  ToValues [Relation](Data-Relation.html#t:Relation)    
  ToSql [Relation](Data-Relation.html#t:Relation)       
  ---------------------------------------------------- ---

type RelationM = State [Relation](Data-Relation.html#t:Relation) ()

getResult :: [RelationM](Data-Relation.html#t:RelationM) -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) Result

getAssoc :: [RelationM](Data-Relation.html#t:RelationM) -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) ResultAssoc

toAssoc :: Result -\> ResultAssoc

fromAssoc :: Schema -\> ResultAssoc -\> Result

raw :: Sql -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\>
Schema -\> [RelationM](Data-Relation.html#t:RelationM)

table :: String -\> Schema -\>
[RelationM](Data-Relation.html#t:RelationM)

view :: String -\> Schema -\>
[RelationM](Data-Relation.html#t:RelationM)

identity :: [RelationM](Data-Relation.html#t:RelationM)

project :: Schema -\> [RelationM](Data-Relation.html#t:RelationM)

projectAs :: [(Key, Key)] -\>
[RelationM](Data-Relation.html#t:RelationM)

select :: Condition -\> [RelationM](Data-Relation.html#t:RelationM)

unite :: [RelationM](Data-Relation.html#t:RelationM) -\>
[RelationM](Data-Relation.html#t:RelationM)

intersect :: [RelationM](Data-Relation.html#t:RelationM) -\>
[RelationM](Data-Relation.html#t:RelationM)

diff :: [RelationM](Data-Relation.html#t:RelationM) -\>
[RelationM](Data-Relation.html#t:RelationM)

cross :: [RelationM](Data-Relation.html#t:RelationM) -\>
[RelationM](Data-Relation.html#t:RelationM)

rename :: [(Key, Key)] -\> [RelationM](Data-Relation.html#t:RelationM)

join :: Condition -\> [RelationM](Data-Relation.html#t:RelationM) -\>
[RelationM](Data-Relation.html#t:RelationM)

take :: Integer -\> [RelationM](Data-Relation.html#t:RelationM)

drop :: Integer -\> [RelationM](Data-Relation.html#t:RelationM)

sort :: Orderings -\> [RelationM](Data-Relation.html#t:RelationM)

data Direction

Constructors

  ------ ---
  Asc     
  Desc    
  ------ ---

Instances

  ------------------------------------------------------ ---
  Show [Direction](Data-Relation.html#t:Direction)        
  ToValues [Direction](Data-Relation.html#t:Direction)    
  ToValues Orderings                                      
  ToValues Ordering                                       
  ToSql [Direction](Data-Relation.html#t:Direction)       
  ToSql Orderings                                         
  ToSql Ordering                                          
  ------------------------------------------------------ ---

(\<&&\>) :: Condition -\> Condition -\> Condition

(\<||\>) :: Condition -\> Condition -\> Condition

(|==|) :: String -\> String -\> Condition

(|\>|) :: String -\> String -\> Condition

(|\>=|) :: String -\> String -\> Condition

(|\<\>|) :: String -\> String -\> Condition

(|\<|) :: String -\> String -\> Condition

(|\<=|) :: String -\> String -\> Condition

(|%|) :: String -\> String -\> Condition

(|%%|) :: String -\> String -\> Condition

(\*==|) :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> String
-\> Condition

(\*\>|) :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> String
-\> Condition

(\*\>=|) :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> String
-\> Condition

(\*\<\>|) :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> String
-\> Condition

(\*\<|) :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> String
-\> Condition

(\*\<=|) :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> String
-\> Condition

(\*%|) :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> String -\>
Condition

(\*%%|) :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> String
-\> Condition

(|==\*) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue)
-\> Condition

(|\>\*) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue)
-\> Condition

(|\>=\*) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue)
-\> Condition

(|\<\>\*) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue)
-\> Condition

(|\<\*) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue)
-\> Condition

(|\<=\*) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue)
-\> Condition

(|%\*) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
Condition

(|%%\*) :: String -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue)
-\> Condition

(\*==\*) :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> Condition

(\*\>\*) :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> Condition

(\*\>=\*) :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> Condition

(\*\<\>\*) :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> Condition

(\*\<\*) :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> Condition

(\*\<=\*) :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> Condition

(\*%\*) :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> Condition

(\*%%\*) :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> Condition

and :: [Condition] -\> Condition

or :: [Condition] -\> Condition

as :: Sql -\> [[SqlValue](Data-SqlTransaction.html#t:SqlValue)] -\>
Condition

not :: Bool -\> Bool

isnull :: String -\> Condition

notnull :: String -\> Condition

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
