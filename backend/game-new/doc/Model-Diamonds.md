-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Diamonds

Documentation
=============

data DiamondTransaction

Constructors

DiamondTransaction

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

amount :: Integer  
 

current :: Integer  
 

type :: String  
 

type\_id :: Integer  
 

time :: Integer  
 

account\_id :: Integer  
 

Instances

||
|Eq [DiamondTransaction](Model-Diamonds.html#t:DiamondTransaction)| |
|Show [DiamondTransaction](Model-Diamonds.html#t:DiamondTransaction)| |
|ToJSON [DiamondTransaction](Model-Diamonds.html#t:DiamondTransaction)| |
|FromJSON [DiamondTransaction](Model-Diamonds.html#t:DiamondTransaction)| |
|Default [DiamondTransaction](Model-Diamonds.html#t:DiamondTransaction)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [DiamondTransaction](Model-Diamonds.html#t:DiamondTransaction)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [DiamondTransaction](Model-Diamonds.html#t:DiamondTransaction)| |
|[Mapable](Model-General.html#t:Mapable) [DiamondTransaction](Model-Diamonds.html#t:DiamondTransaction)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [DiamondTransaction](Model-Diamonds.html#t:DiamondTransaction)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

transactionDiamonds :: Integer -\> [DiamondTransaction](Model-Diamonds.html#t:DiamondTransaction) -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
