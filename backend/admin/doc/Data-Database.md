% Data.Database
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.Database

Documentation
=============

dbconn :: IO [Connection](Data-SqlTransaction.html#t:Connection)

doSql :: [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) a -\> IO a

type Sql = String

type Value = [SqlValue](Data-SqlTransaction.html#t:SqlValue)

type Values = [[SqlValue](Data-SqlTransaction.html#t:SqlValue)]

class Expression a where

Methods

sql :: a -\> [Sql](Data-Database.html#t:Sql)

values :: a -\> [Values](Data-Database.html#t:Values)

Instances

  ----------------------------------------------------------------------------------------------- ---
  [Expression](Data-Database.html#t:Expression) [Update](Data-Database.html#t:Update)              
  [Expression](Data-Database.html#t:Expression) [Insert](Data-Database.html#t:Insert)              
  [Expression](Data-Database.html#t:Expression) [Delete](Data-Database.html#t:Delete)              
  [Expression](Data-Database.html#t:Expression) [Select](Data-Database.html#t:Select)              
  [Expression](Data-Database.html#t:Expression) [Offset](Data-Database.html#t:Offset)              
  [Expression](Data-Database.html#t:Expression) [Limit](Data-Database.html#t:Limit)                
  [Expression](Data-Database.html#t:Expression) [Direction](Data-Database.html#t:Direction)        
  [Expression](Data-Database.html#t:Expression) [Order](Data-Database.html#t:Order)                
  [Expression](Data-Database.html#t:Expression) [Orders](Data-Database.html#t:Orders)              
  [Expression](Data-Database.html#t:Expression) [ConOp](Data-Database.html#t:ConOp)                
  [Expression](Data-Database.html#t:Expression) [Constraint](Data-Database.html#t:Constraint)      
  [Expression](Data-Database.html#t:Expression) [Constraints](Data-Database.html#t:Constraints)    
  [Expression](Data-Database.html#t:Expression) [Assignment](Data-Database.html#t:Assignment)      
  [Expression](Data-Database.html#t:Expression) [Assignments](Data-Database.html#t:Assignments)    
  [Expression](Data-Database.html#t:Expression) [Selections](Data-Database.html#t:Selections)      
  [Expression](Data-Database.html#t:Expression) [Pair](Data-Database.html#t:Pair)                  
  ----------------------------------------------------------------------------------------------- ---

type Pair = ([Sql](Data-Database.html#t:Sql),
[Values](Data-Database.html#t:Values))

(.\*) :: [Sql](Data-Database.html#t:Sql) -\>
[Values](Data-Database.html#t:Values) -\>
[Pair](Data-Database.html#t:Pair)

pair :: [Expression](Data-Database.html#t:Expression) a =\> a -\>
[Pair](Data-Database.html#t:Pair)

class Expressable a where

Methods

express :: a -\> [Pair](Data-Database.html#t:Pair)

Instances

  --------------------------------------------------------------------------------------- ---
  [Expressable](Data-Database.html#t:Expressable) [Values](Data-Database.html#t:Values)    
  [Expressable](Data-Database.html#t:Expressable) [Value](Data-Database.html#t:Value)      
  [Expressable](Data-Database.html#t:Expressable) [Sql](Data-Database.html#t:Sql)          
  --------------------------------------------------------------------------------------- ---

type Table = [Pair](Data-Database.html#t:Pair)

table :: [Sql](Data-Database.html#t:Sql) -\>
[Table](Data-Database.html#t:Table)

type Selections = [[Selection](Data-Database.html#t:Selection)]

type Selection = [Pair](Data-Database.html#t:Pair)

column :: [Sql](Data-Database.html#t:Sql) -\>
[Selection](Data-Database.html#t:Selection)

selectAll :: [Selection](Data-Database.html#t:Selection)

data Assignments

Constructors

  --------------------------------------------------------- ---
  Inserts [[Assignment](Data-Database.html#t:Assignment)]    
  Updates [[Assignment](Data-Database.html#t:Assignment)]    
  --------------------------------------------------------- ---

Instances

  ----------------------------------------------------------------------------------------------- ---
  Show [Assignments](Data-Database.html#t:Assignments)                                             
  [Expression](Data-Database.html#t:Expression) [Assignments](Data-Database.html#t:Assignments)    
  ----------------------------------------------------------------------------------------------- ---

data Assignment

Constructors

  ---------------------------------------------------------------------------- ---
  Assign [Sql](Data-Database.html#t:Sql) [Value](Data-Database.html#t:Value)    
  Default [Sql](Data-Database.html#t:Sql) [Sql](Data-Database.html#t:Sql)       
  ---------------------------------------------------------------------------- ---

Instances

  --------------------------------------------------------------------------------------------- ---
  Show [Assignment](Data-Database.html#t:Assignment)                                             
  [Expression](Data-Database.html#t:Expression) [Assignment](Data-Database.html#t:Assignment)    
  --------------------------------------------------------------------------------------------- ---

(.-\>) :: [Sql](Data-Database.html#t:Sql) -\>
[Value](Data-Database.html#t:Value) -\>
[Assignment](Data-Database.html#t:Assignment)

(.\#\>) :: [Sql](Data-Database.html#t:Sql) -\>
[Sql](Data-Database.html#t:Sql) -\>
[Assignment](Data-Database.html#t:Assignment)

devault :: [Assignment](Data-Database.html#t:Assignment) -\>
[Sql](Data-Database.html#t:Sql)

type Constraints = [[Constraint](Data-Database.html#t:Constraint)]

data Constraint

Constructors

  -------------------------------------------------------------------------------------------------------------------------------- ---
  Constraint [ConOp](Data-Database.html#t:ConOp) [Selection](Data-Database.html#t:Selection) [Value](Data-Database.html#t:Value)    
  And [Constraint](Data-Database.html#t:Constraint) [Constraint](Data-Database.html#t:Constraint)                                   
  Or [Constraint](Data-Database.html#t:Constraint) [Constraint](Data-Database.html#t:Constraint)                                    
  -------------------------------------------------------------------------------------------------------------------------------- ---

Instances

  ----------------------------------------------------------------------------------------------- ---
  Show [Constraint](Data-Database.html#t:Constraint)                                               
  [Expression](Data-Database.html#t:Expression) [Constraint](Data-Database.html#t:Constraint)      
  [Expression](Data-Database.html#t:Expression) [Constraints](Data-Database.html#t:Constraints)    
  ----------------------------------------------------------------------------------------------- ---

(.&&) :: [Constraint](Data-Database.html#t:Constraint) -\>
[Constraint](Data-Database.html#t:Constraint) -\>
[Constraint](Data-Database.html#t:Constraint)

(.||) :: [Constraint](Data-Database.html#t:Constraint) -\>
[Constraint](Data-Database.html#t:Constraint) -\>
[Constraint](Data-Database.html#t:Constraint)

data ConOp

Constructors

  ------------- ---
  OpLT           
  OpLTE          
  OpGT           
  OpGTE          
  OpEQ           
  OpNEQ          
  OpContains     
  OpIContains    
  ------------- ---

Instances

  ----------------------------------------------------------------------------------- ---
  Show [ConOp](Data-Database.html#t:ConOp)                                             
  [Expression](Data-Database.html#t:Expression) [ConOp](Data-Database.html#t:ConOp)    
  ----------------------------------------------------------------------------------- ---

cLT :: [Selection](Data-Database.html#t:Selection) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint)

cLTE :: [Selection](Data-Database.html#t:Selection) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint)

cGT :: [Selection](Data-Database.html#t:Selection) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint)

cGTE :: [Selection](Data-Database.html#t:Selection) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint)

cEQ :: [Selection](Data-Database.html#t:Selection) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint)

cNEQ :: [Selection](Data-Database.html#t:Selection) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint)

cIn :: [Selection](Data-Database.html#t:Selection) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint)

cIni :: [Selection](Data-Database.html#t:Selection) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint)

(|\<) :: [Sql](Data-Database.html#t:Sql) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint)

(|\<=) :: [Sql](Data-Database.html#t:Sql) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint)

(|\>) :: [Sql](Data-Database.html#t:Sql) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint)

(|\>=) :: [Sql](Data-Database.html#t:Sql) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint)

(|==) :: [Sql](Data-Database.html#t:Sql) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint)

(|\<\>) :: [Sql](Data-Database.html#t:Sql) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint)

(|%) :: [Sql](Data-Database.html#t:Sql) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint)

(|%%) :: [Sql](Data-Database.html#t:Sql) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint)

type Orders = [[Order](Data-Database.html#t:Order)]

data Order

Constructors

  ----------------------------------------------------------------------------------------------- ---
  Order [Selection](Data-Database.html#t:Selection) [Direction](Data-Database.html#t:Direction)    
  ----------------------------------------------------------------------------------------------- ---

Instances

  ------------------------------------------------------------------------------------- ---
  Show [Order](Data-Database.html#t:Order)                                               
  [Expression](Data-Database.html#t:Expression) [Order](Data-Database.html#t:Order)      
  [Expression](Data-Database.html#t:Expression) [Orders](Data-Database.html#t:Orders)    
  ------------------------------------------------------------------------------------- ---

order :: [Sql](Data-Database.html#t:Sql) -\>
[Direction](Data-Database.html#t:Direction) -\>
[Order](Data-Database.html#t:Order)

asc :: [Direction](Data-Database.html#t:Direction)

desc :: [Direction](Data-Database.html#t:Direction)

type Direction = Bool

data Limit

Constructors

  ------------------------------------------- ---
  Limit [Value](Data-Database.html#t:Value)    
  NullLimit                                    
  ------------------------------------------- ---

Instances

  ----------------------------------------------------------------------------------- ---
  Show [Limit](Data-Database.html#t:Limit)                                             
  [Expression](Data-Database.html#t:Expression) [Limit](Data-Database.html#t:Limit)    
  ----------------------------------------------------------------------------------- ---

data Offset

Constructors

  -------------------------------------------- ---
  Offset [Value](Data-Database.html#t:Value)    
  NullOffset                                    
  -------------------------------------------- ---

Instances

  ------------------------------------------------------------------------------------- ---
  Show [Offset](Data-Database.html#t:Offset)                                             
  [Expression](Data-Database.html#t:Expression) [Offset](Data-Database.html#t:Offset)    
  ------------------------------------------------------------------------------------- ---

data Select

Constructors

  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---
  Select [Table](Data-Database.html#t:Table) [Selections](Data-Database.html#t:Selections) [Constraints](Data-Database.html#t:Constraints) [Orders](Data-Database.html#t:Orders) [Limit](Data-Database.html#t:Limit) [Offset](Data-Database.html#t:Offset)    
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---

Instances

  ------------------------------------------------------------------------------------- ---
  [Expression](Data-Database.html#t:Expression) [Select](Data-Database.html#t:Select)    
  ------------------------------------------------------------------------------------- ---

data Delete

Constructors

  -------------------------------------------------------------------------------------------- ---
  Delete [Table](Data-Database.html#t:Table) [Constraints](Data-Database.html#t:Constraints)    
  -------------------------------------------------------------------------------------------- ---

Instances

  ------------------------------------------------------------------------------------- ---
  [Expression](Data-Database.html#t:Expression) [Delete](Data-Database.html#t:Delete)    
  ------------------------------------------------------------------------------------- ---

data Insert

Constructors

  -------------------------------------------------------------------------------------------- ---
  Insert [Table](Data-Database.html#t:Table) [Assignments](Data-Database.html#t:Assignments)    
  -------------------------------------------------------------------------------------------- ---

Instances

  ------------------------------------------------------------------------------------- ---
  [Expression](Data-Database.html#t:Expression) [Insert](Data-Database.html#t:Insert)    
  ------------------------------------------------------------------------------------- ---

data Update

Constructors

  -------------------------------------------------------------------------------------------------------------------------------------------- ---
  Update [Table](Data-Database.html#t:Table) [Assignments](Data-Database.html#t:Assignments) [Constraints](Data-Database.html#t:Constraints)    
  -------------------------------------------------------------------------------------------------------------------------------------------- ---

Instances

  ------------------------------------------------------------------------------------- ---
  [Expression](Data-Database.html#t:Expression) [Update](Data-Database.html#t:Update)    
  ------------------------------------------------------------------------------------- ---

constraints :: [([Sql](Data-Database.html#t:Sql),
[Selection](Data-Database.html#t:Selection) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint))] -\>
[([Sql](Data-Database.html#t:Sql), [Value](Data-Database.html#t:Value))]
-\> [Constraints](Data-Database.html#t:Constraints)

assigns :: [([Sql](Data-Database.html#t:Sql),
[Sql](Data-Database.html#t:Sql))] -\> [([Sql](Data-Database.html#t:Sql),
[Value](Data-Database.html#t:Value))] -\>
[[Assignment](Data-Database.html#t:Assignment)]

inserts :: [([Sql](Data-Database.html#t:Sql),
[Sql](Data-Database.html#t:Sql))] -\> [([Sql](Data-Database.html#t:Sql),
[Value](Data-Database.html#t:Value))] -\>
[Assignments](Data-Database.html#t:Assignments)

updates :: [([Sql](Data-Database.html#t:Sql),
[Sql](Data-Database.html#t:Sql))] -\> [([Sql](Data-Database.html#t:Sql),
[Value](Data-Database.html#t:Value))] -\>
[Assignments](Data-Database.html#t:Assignments)

orders :: [([Sql](Data-Database.html#t:Sql),
[Value](Data-Database.html#t:Value))] -\>
[Orders](Data-Database.html#t:Orders)

limit :: [([Sql](Data-Database.html#t:Sql),
[Value](Data-Database.html#t:Value))] -\>
[Limit](Data-Database.html#t:Limit)

offset :: [([Sql](Data-Database.html#t:Sql),
[Value](Data-Database.html#t:Value))] -\>
[Offset](Data-Database.html#t:Offset)

transaction :: [Expression](Data-Database.html#t:Expression) x =\>
([Sql](Data-Database.html#t:Sql) -\>
[Values](Data-Database.html#t:Values) -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) t) -\> x -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) t

select :: [Sql](Data-Database.html#t:Sql) -\>
[([Sql](Data-Database.html#t:Sql),
[Selection](Data-Database.html#t:Selection) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint))] -\>
[([Sql](Data-Database.html#t:Sql), [Value](Data-Database.html#t:Value))]
-\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) [HashMap
[Sql](Data-Database.html#t:Sql) [Value](Data-Database.html#t:Value)]

insert :: [Sql](Data-Database.html#t:Sql) -\>
[([Sql](Data-Database.html#t:Sql), [Sql](Data-Database.html#t:Sql))] -\>
[([Sql](Data-Database.html#t:Sql), [Value](Data-Database.html#t:Value))]
-\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[Value](Data-Database.html#t:Value)

update :: [Sql](Data-Database.html#t:Sql) -\>
[Constraints](Data-Database.html#t:Constraints) -\>
[([Sql](Data-Database.html#t:Sql), [Sql](Data-Database.html#t:Sql))] -\>
[([Sql](Data-Database.html#t:Sql), [Value](Data-Database.html#t:Value))]
-\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) ()

upsert :: [Sql](Data-Database.html#t:Sql) -\> HashMap
[Sql](Data-Database.html#t:Sql) [Value](Data-Database.html#t:Value) -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[Value](Data-Database.html#t:Value)

geometry :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[SqlValue](Data-SqlTransaction.html#t:SqlValue)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
