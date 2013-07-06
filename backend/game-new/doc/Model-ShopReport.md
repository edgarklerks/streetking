% Model.ShopReport
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.ShopReport

Documentation
=============

type MInteger = Maybe Integer

type MString = Maybe String

type MBool = Maybe Bool

data ShopReport

Constructors

ShopReport

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
account\_id :: Integer
:    
time :: Integer
:    
report\_type\_id :: Integer
:    
report\_type :: String
:    
report\_descriptor :: String
:    
part\_instance\_id :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
car\_instance\_id :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
car\_id :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
part\_id :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
amount :: Integer
:    
car\_manufacturer\_name :: [MString](Model-ShopReport.html#t:MString)
:    
car\_top\_speed :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
car\_acceleration :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
car\_braking :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
car\_nos :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
car\_handling :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
car\_name :: [MString](Model-ShopReport.html#t:MString)
:    
car\_level :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
car\_year :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
car\_price :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
car\_weight :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
car\_improvement :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
car\_wear :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
part\_weight :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
part\_level :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
part\_car\_model :: [MString](Model-ShopReport.html#t:MString)
:    
part\_parameter1 :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
part\_parameter2 :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
part\_parameter3 :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
part\_parameter1\_type :: [MString](Model-ShopReport.html#t:MString)
:    
part\_parameter2\_type :: [MString](Model-ShopReport.html#t:MString)
:    
part\_parameter3\_type :: [MString](Model-ShopReport.html#t:MString)
:    
part\_parameter1\_name :: [MString](Model-ShopReport.html#t:MString)
:    
part\_parameter2\_name :: [MString](Model-ShopReport.html#t:MString)
:    
part\_parameter3\_name :: [MString](Model-ShopReport.html#t:MString)
:    
part\_modifier :: [MString](Model-ShopReport.html#t:MString)
:    
part\_unique :: [MBool](Model-ShopReport.html#t:MBool)
:    
part\_improvement :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
part\_wear :: [MInteger](Model-ShopReport.html#t:MInteger)
:    
part\_type :: [MString](Model-ShopReport.html#t:MString)
:    
part\_manufacturer\_name :: [MString](Model-ShopReport.html#t:MString)
:    
part\_parameter1\_modifier :: [MString](Model-ShopReport.html#t:MString)
:    
part\_parameter2\_modifier :: [MString](Model-ShopReport.html#t:MString)
:    
part\_parameter3\_modifier :: [MString](Model-ShopReport.html#t:MString)
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [ShopReport](Model-ShopReport.html#t:ShopReport)                                                                                               
  Show [ShopReport](Model-ShopReport.html#t:ShopReport)                                                                                             
  ToJSON [ShopReport](Model-ShopReport.html#t:ShopReport)                                                                                           
  FromJSON [ShopReport](Model-ShopReport.html#t:ShopReport)                                                                                         
  Default [ShopReport](Model-ShopReport.html#t:ShopReport)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [ShopReport](Model-ShopReport.html#t:ShopReport)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [ShopReport](Model-ShopReport.html#t:ShopReport)                                                         
  [Mapable](Model-General.html#t:Mapable) [ShopReport](Model-ShopReport.html#t:ShopReport)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [ShopReport](Model-ShopReport.html#t:ShopReport)    
  ------------------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
