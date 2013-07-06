% Model.Transaction
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Transaction

Documentation
=============

data Transaction

Constructors

Transaction

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
amount :: Integer
:    
current :: Integer
:    
type :: String
:    
type\_id :: Integer
:    
time :: Integer
:    
account\_id :: Integer
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [Transaction](Model-Transaction.html#t:Transaction)                                                                                               
  Show [Transaction](Model-Transaction.html#t:Transaction)                                                                                             
  ToJSON [Transaction](Model-Transaction.html#t:Transaction)                                                                                           
  FromJSON [Transaction](Model-Transaction.html#t:Transaction)                                                                                         
  Default [Transaction](Model-Transaction.html#t:Transaction)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [Transaction](Model-Transaction.html#t:Transaction)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [Transaction](Model-Transaction.html#t:Transaction)                                                         
  [Mapable](Model-General.html#t:Mapable) [Transaction](Model-Transaction.html#t:Transaction)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Transaction](Model-Transaction.html#t:Transaction)    
  --------------------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

transactionMoney :: Integer -\>
[Transaction](Model-Transaction.html#t:Transaction) -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) ()

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
