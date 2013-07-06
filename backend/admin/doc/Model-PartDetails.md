% Model.PartDetails
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.PartDetails

Documentation
=============

type MInteger = Maybe Integer

type MString = Maybe String

data PartDetails

Constructors

PartDetails

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
name :: String
:    
weight :: Integer
:    
parameter1 :: [MInteger](Model-PartDetails.html#t:MInteger)
:    
parameter1\_name :: [MString](Model-PartDetails.html#t:MString)
:    
parameter1\_unit :: [MString](Model-PartDetails.html#t:MString)
:    
parameter2 :: [MInteger](Model-PartDetails.html#t:MInteger)
:    
parameter2\_name :: [MString](Model-PartDetails.html#t:MString)
:    
parameter2\_unit :: [MString](Model-PartDetails.html#t:MString)
:    
parameter3 :: [MInteger](Model-PartDetails.html#t:MInteger)
:    
parameter3\_name :: [MString](Model-PartDetails.html#t:MString)
:    
parameter3\_unit :: [MString](Model-PartDetails.html#t:MString)
:    
car\_id :: Integer
:    
d3d\_model\_id :: Integer
:    
level :: Integer
:    
price :: Integer
:    
car\_model :: [MString](Model-PartDetails.html#t:MString)
:    
manufacturer\_name :: [MString](Model-PartDetails.html#t:MString)
:    
part\_modifier :: String
:    
unique :: Bool
:    
sort\_part\_type :: Integer
:    
required :: Bool
:    
fixed :: Bool
:    
hidden :: Bool
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [PartDetails](Model-PartDetails.html#t:PartDetails)                                                                                               
  Show [PartDetails](Model-PartDetails.html#t:PartDetails)                                                                                             
  ToJSON [PartDetails](Model-PartDetails.html#t:PartDetails)                                                                                           
  FromJSON [PartDetails](Model-PartDetails.html#t:PartDetails)                                                                                         
  Default [PartDetails](Model-PartDetails.html#t:PartDetails)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [PartDetails](Model-PartDetails.html#t:PartDetails)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [PartDetails](Model-PartDetails.html#t:PartDetails)                                                         
  [Mapable](Model-General.html#t:Mapable) [PartDetails](Model-PartDetails.html#t:PartDetails)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [PartDetails](Model-PartDetails.html#t:PartDetails)    
  --------------------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
