% Data.Database
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.Database

Description

Primitive database data types for expression simple queries | Internal
use only

Synopsis

-   [dbconn](#v:dbconn) :: IO
    [Connection](Data-SqlTransaction.html#t:Connection)
-   [doSql](#v:doSql) ::
    [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
    [Connection](Data-SqlTransaction.html#t:Connection) a -\> IO a
-   type [Sql](#t:Sql) = String
-   type [Value](#t:Value) =
    [SqlValue](Data-SqlTransaction.html#t:SqlValue)
-   type [Values](#t:Values) =
    [[SqlValue](Data-SqlTransaction.html#t:SqlValue)]
-   class [Expression](#t:Expression) a where
    -   [sql](#v:sql) :: a -\> [Sql](Data-Database.html#t:Sql)
    -   [values](#v:values) :: a -\>
        [Values](Data-Database.html#t:Values)

-   type [Pair](#t:Pair) = ([Sql](Data-Database.html#t:Sql),
    [Values](Data-Database.html#t:Values))
-   [(.\*)](#v:.-42-) :: [Sql](Data-Database.html#t:Sql) -\>
    [Values](Data-Database.html#t:Values) -\>
    [Pair](Data-Database.html#t:Pair)
-   [pair](#v:pair) :: [Expression](Data-Database.html#t:Expression) a
    =\> a -\> [Pair](Data-Database.html#t:Pair)
-   class [Expressable](#t:Expressable) a where
    -   [express](#v:express) :: a -\> [Pair](Data-Database.html#t:Pair)

-   type [Table](#t:Table) = [Pair](Data-Database.html#t:Pair)
-   [table](#v:table) :: [Sql](Data-Database.html#t:Sql) -\>
    [Table](Data-Database.html#t:Table)
-   type [Selections](#t:Selections) =
    [[Selection](Data-Database.html#t:Selection)]
-   type [Selection](#t:Selection) = [Pair](Data-Database.html#t:Pair)
-   [column](#v:column) :: [Sql](Data-Database.html#t:Sql) -\>
    [Selection](Data-Database.html#t:Selection)
-   [selectAll](#v:selectAll) ::
    [Selection](Data-Database.html#t:Selection)
-   data [Assignments](#t:Assignments)
    -   = [Inserts](#v:Inserts)
        [[Assignment](Data-Database.html#t:Assignment)]
    -   | [Updates](#v:Updates)
        [[Assignment](Data-Database.html#t:Assignment)]

-   data [Assignment](#t:Assignment)
    -   = [Assign](#v:Assign) [Sql](Data-Database.html#t:Sql)
        [Value](Data-Database.html#t:Value)
    -   | [Default](#v:Default) [Sql](Data-Database.html#t:Sql)
        [Sql](Data-Database.html#t:Sql)

-   [(.-\>)](#v:.-45--62-) :: [Sql](Data-Database.html#t:Sql) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Assignment](Data-Database.html#t:Assignment)
-   [(.\#\>)](#v:.-35--62-) :: [Sql](Data-Database.html#t:Sql) -\>
    [Sql](Data-Database.html#t:Sql) -\>
    [Assignment](Data-Database.html#t:Assignment)
-   [devault](#v:devault) ::
    [Assignment](Data-Database.html#t:Assignment) -\>
    [Sql](Data-Database.html#t:Sql)
-   type [Constraints](#t:Constraints) =
    [[Constraint](Data-Database.html#t:Constraint)]
-   data [Constraint](#t:Constraint)
    -   = [Constraint](#v:Constraint)
        [ConOp](Data-Database.html#t:ConOp)
        [Selection](Data-Database.html#t:Selection)
        [Value](Data-Database.html#t:Value)
    -   | [And](#v:And) [Constraint](Data-Database.html#t:Constraint)
        [Constraint](Data-Database.html#t:Constraint)
    -   | [Or](#v:Or) [Constraint](Data-Database.html#t:Constraint)
        [Constraint](Data-Database.html#t:Constraint)

-   [(.&&)](#v:.-38--38-) ::
    [Constraint](Data-Database.html#t:Constraint) -\>
    [Constraint](Data-Database.html#t:Constraint) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   [(.||)](#v:.-124--124-) ::
    [Constraint](Data-Database.html#t:Constraint) -\>
    [Constraint](Data-Database.html#t:Constraint) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   data [ConOp](#t:ConOp)
    -   = [OpLT](#v:OpLT)
    -   | [OpLTE](#v:OpLTE)
    -   | [OpGT](#v:OpGT)
    -   | [OpGTE](#v:OpGTE)
    -   | [OpEQ](#v:OpEQ)
    -   | [OpNEQ](#v:OpNEQ)
    -   | [OpContains](#v:OpContains)
    -   | [OpIContains](#v:OpIContains)
    -   | [OpInList](#v:OpInList)

-   [cLT](#v:cLT) :: [Selection](Data-Database.html#t:Selection) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   [cLTE](#v:cLTE) :: [Selection](Data-Database.html#t:Selection) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   [cGT](#v:cGT) :: [Selection](Data-Database.html#t:Selection) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   [cGTE](#v:cGTE) :: [Selection](Data-Database.html#t:Selection) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   [cEQ](#v:cEQ) :: [Selection](Data-Database.html#t:Selection) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   [cNEQ](#v:cNEQ) :: [Selection](Data-Database.html#t:Selection) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   [cIn](#v:cIn) :: [Selection](Data-Database.html#t:Selection) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   [cIni](#v:cIni) :: [Selection](Data-Database.html#t:Selection) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   [cInList](#v:cInList) :: [Selection](Data-Database.html#t:Selection)
    -\> [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   [(|\<)](#v:-124--60-) :: [Sql](Data-Database.html#t:Sql) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   [(|\<=)](#v:-124--60--61-) :: [Sql](Data-Database.html#t:Sql) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   [(|\>)](#v:-124--62-) :: [Sql](Data-Database.html#t:Sql) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   [(|\>=)](#v:-124--62--61-) :: [Sql](Data-Database.html#t:Sql) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   [(|==)](#v:-124--61--61-) :: [Sql](Data-Database.html#t:Sql) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   [(|\<\>)](#v:-124--60--62-) :: [Sql](Data-Database.html#t:Sql) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   [(|%)](#v:-124--37-) :: [Sql](Data-Database.html#t:Sql) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   [(|%%)](#v:-124--37--37-) :: [Sql](Data-Database.html#t:Sql) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   [(|\~)](#v:-124--126-) :: [Sql](Data-Database.html#t:Sql) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint)
-   type [Orders](#t:Orders) = [[Order](Data-Database.html#t:Order)]
-   data [Order](#t:Order) = [Order](#v:Order)
    [Selection](Data-Database.html#t:Selection)
    [Direction](Data-Database.html#t:Direction)
-   [order](#v:order) :: [Sql](Data-Database.html#t:Sql) -\>
    [Direction](Data-Database.html#t:Direction) -\>
    [Order](Data-Database.html#t:Order)
-   [asc](#v:asc) :: [Direction](Data-Database.html#t:Direction)
-   [desc](#v:desc) :: [Direction](Data-Database.html#t:Direction)
-   type [Direction](#t:Direction) = Bool
-   data [Limit](#t:Limit)
    -   = [Limit](#v:Limit) [Value](Data-Database.html#t:Value)
    -   | [NullLimit](#v:NullLimit)

-   data [Offset](#t:Offset)
    -   = [Offset](#v:Offset) [Value](Data-Database.html#t:Value)
    -   | [NullOffset](#v:NullOffset)

-   data [Select](#t:Select) = [Select](#v:Select)
    [Table](Data-Database.html#t:Table)
    [Selections](Data-Database.html#t:Selections)
    [Constraints](Data-Database.html#t:Constraints)
    [Orders](Data-Database.html#t:Orders)
    [Limit](Data-Database.html#t:Limit)
    [Offset](Data-Database.html#t:Offset)
-   data [Delete](#t:Delete) = [Delete](#v:Delete)
    [Table](Data-Database.html#t:Table)
    [Constraints](Data-Database.html#t:Constraints)
-   data [Insert](#t:Insert) = [Insert](#v:Insert)
    [Table](Data-Database.html#t:Table)
    [Assignments](Data-Database.html#t:Assignments)
-   data [Update](#t:Update) = [Update](#v:Update)
    [Table](Data-Database.html#t:Table)
    [Assignments](Data-Database.html#t:Assignments)
    [Constraints](Data-Database.html#t:Constraints)
-   [constraints](#v:constraints) :: [([Sql](Data-Database.html#t:Sql),
    [Selection](Data-Database.html#t:Selection) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint))] -\>
    [([Sql](Data-Database.html#t:Sql),
    [Value](Data-Database.html#t:Value))] -\>
    [Constraints](Data-Database.html#t:Constraints)
-   [assigns](#v:assigns) :: [([Sql](Data-Database.html#t:Sql),
    [Sql](Data-Database.html#t:Sql))] -\>
    [([Sql](Data-Database.html#t:Sql),
    [Value](Data-Database.html#t:Value))] -\>
    [[Assignment](Data-Database.html#t:Assignment)]
-   [inserts](#v:inserts) :: [([Sql](Data-Database.html#t:Sql),
    [Sql](Data-Database.html#t:Sql))] -\>
    [([Sql](Data-Database.html#t:Sql),
    [Value](Data-Database.html#t:Value))] -\>
    [Assignments](Data-Database.html#t:Assignments)
-   [updates](#v:updates) :: [([Sql](Data-Database.html#t:Sql),
    [Sql](Data-Database.html#t:Sql))] -\>
    [([Sql](Data-Database.html#t:Sql),
    [Value](Data-Database.html#t:Value))] -\>
    [Assignments](Data-Database.html#t:Assignments)
-   [orders](#v:orders) :: [([Sql](Data-Database.html#t:Sql),
    [Value](Data-Database.html#t:Value))] -\>
    [Orders](Data-Database.html#t:Orders)
-   [limit](#v:limit) :: [([Sql](Data-Database.html#t:Sql),
    [Value](Data-Database.html#t:Value))] -\>
    [Limit](Data-Database.html#t:Limit)
-   [offset](#v:offset) :: [([Sql](Data-Database.html#t:Sql),
    [Value](Data-Database.html#t:Value))] -\>
    [Offset](Data-Database.html#t:Offset)
-   [transaction](#v:transaction) ::
    [Expression](Data-Database.html#t:Expression) x =\>
    ([Sql](Data-Database.html#t:Sql) -\>
    [Values](Data-Database.html#t:Values) -\>
    [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
    [Connection](Data-SqlTransaction.html#t:Connection) t) -\> x -\>
    [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
    [Connection](Data-SqlTransaction.html#t:Connection) t
-   [select](#v:select) :: [Sql](Data-Database.html#t:Sql) -\>
    [([Sql](Data-Database.html#t:Sql),
    [Selection](Data-Database.html#t:Selection) -\>
    [Value](Data-Database.html#t:Value) -\>
    [Constraint](Data-Database.html#t:Constraint))] -\>
    [([Sql](Data-Database.html#t:Sql),
    [Value](Data-Database.html#t:Value))] -\>
    [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
    [Connection](Data-SqlTransaction.html#t:Connection) [HashMap
    [Sql](Data-Database.html#t:Sql) [Value](Data-Database.html#t:Value)]
-   [insert](#v:insert) :: [Sql](Data-Database.html#t:Sql) -\>
    [([Sql](Data-Database.html#t:Sql), [Sql](Data-Database.html#t:Sql))]
    -\> [([Sql](Data-Database.html#t:Sql),
    [Value](Data-Database.html#t:Value))] -\>
    [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
    [Connection](Data-SqlTransaction.html#t:Connection)
    [Value](Data-Database.html#t:Value)
-   [update](#v:update) :: [Sql](Data-Database.html#t:Sql) -\>
    [Constraints](Data-Database.html#t:Constraints) -\>
    [([Sql](Data-Database.html#t:Sql), [Sql](Data-Database.html#t:Sql))]
    -\> [([Sql](Data-Database.html#t:Sql),
    [Value](Data-Database.html#t:Value))] -\>
    [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
    [Connection](Data-SqlTransaction.html#t:Connection) ()
-   [upsert](#v:upsert) :: [Sql](Data-Database.html#t:Sql) -\> HashMap
    [Sql](Data-Database.html#t:Sql) [Value](Data-Database.html#t:Value)
    -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
    [Connection](Data-SqlTransaction.html#t:Connection)
    [Value](Data-Database.html#t:Value)
-   [geometry](#v:geometry) ::
    [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
    [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
    [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
    [Connection](Data-SqlTransaction.html#t:Connection)
    [SqlValue](Data-SqlTransaction.html#t:SqlValue)

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
  OpInList       
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

cInList :: [Selection](Data-Database.html#t:Selection) -\>
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

(|\~) :: [Sql](Data-Database.html#t:Sql) -\>
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

constraints: provide map of optional arguments and a dictionary of
operators to use for each one

assigns :: [([Sql](Data-Database.html#t:Sql),
[Sql](Data-Database.html#t:Sql))] -\> [([Sql](Data-Database.html#t:Sql),
[Value](Data-Database.html#t:Value))] -\>
[[Assignment](Data-Database.html#t:Assignment)]

assigns: provide list of allowed fields, default values, and a list of
optional arguments

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

orders: provide map of optional arguments. if found, sort\_field and
sort\_invert is used to generate orderings

limit :: [([Sql](Data-Database.html#t:Sql),
[Value](Data-Database.html#t:Value))] -\>
[Limit](Data-Database.html#t:Limit)

limit: provide map of optional arguments. if found, limit is used to
generate limit

offset :: [([Sql](Data-Database.html#t:Sql),
[Value](Data-Database.html#t:Value))] -\>
[Offset](Data-Database.html#t:Offset)

offset: provide map of optional arguments. if found, offset is used to
generate offset

transaction :: [Expression](Data-Database.html#t:Expression) x =\>
([Sql](Data-Database.html#t:Sql) -\>
[Values](Data-Database.html#t:Values) -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) t) -\> x -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) t

transaction: provide query function and an expression, generates
transaction

select :: [Sql](Data-Database.html#t:Sql) -\>
[([Sql](Data-Database.html#t:Sql),
[Selection](Data-Database.html#t:Selection) -\>
[Value](Data-Database.html#t:Value) -\>
[Constraint](Data-Database.html#t:Constraint))] -\>
[([Sql](Data-Database.html#t:Sql), [Value](Data-Database.html#t:Value))]
-\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) [HashMap
[Sql](Data-Database.html#t:Sql) [Value](Data-Database.html#t:Value)]

select: quick select. table name; [(field name, constraint
constructor)]; map of optional arguments

insert :: [Sql](Data-Database.html#t:Sql) -\>
[([Sql](Data-Database.html#t:Sql), [Sql](Data-Database.html#t:Sql))] -\>
[([Sql](Data-Database.html#t:Sql), [Value](Data-Database.html#t:Value))]
-\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[Value](Data-Database.html#t:Value)

insert: quick insert. table name; defaults; fields names; map of
optional arguments

update :: [Sql](Data-Database.html#t:Sql) -\>
[Constraints](Data-Database.html#t:Constraints) -\>
[([Sql](Data-Database.html#t:Sql), [Sql](Data-Database.html#t:Sql))] -\>
[([Sql](Data-Database.html#t:Sql), [Value](Data-Database.html#t:Value))]
-\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) ()

update: quick update. table name; [(Sql, Selection -\> Value -\>
Constraint)]; constraint arguments; default assigns; assignment
arguments

upsert :: [Sql](Data-Database.html#t:Sql) -\> HashMap
[Sql](Data-Database.html#t:Sql) [Value](Data-Database.html#t:Value) -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[Value](Data-Database.html#t:Value)

upsert: take table name and a record in HashMap format. check if a
record already exists with the id from the Map. if exists, update the
record; if not, insert. return the id of the record.

geometry :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[SqlValue](Data-SqlTransaction.html#t:SqlValue) -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection)
[SqlValue](Data-SqlTransaction.html#t:SqlValue)

geometry: convert geo coordinates to a geometry. this requires a query.

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
