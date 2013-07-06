-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Escrow

Documentation
=============

data Escrow

Constructors

Escrow

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

account\_id :: Integer  
 

amount :: Integer  
 

deleted :: Bool  
 

Instances

||
|Eq [Escrow](Model-Escrow.html#t:Escrow)| |
|Show [Escrow](Model-Escrow.html#t:Escrow)| |
|ToJSON [Escrow](Model-Escrow.html#t:Escrow)| |
|FromJSON [Escrow](Model-Escrow.html#t:Escrow)| |
|Default [Escrow](Model-Escrow.html#t:Escrow)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [Escrow](Model-Escrow.html#t:Escrow)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [Escrow](Model-Escrow.html#t:Escrow)| |
|[Mapable](Model-General.html#t:Mapable) [Escrow](Model-Escrow.html#t:Escrow)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Escrow](Model-Escrow.html#t:Escrow)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

deposit :: Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) Integer

cancel :: Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

release :: Integer -\> Integer -\> [SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction) [Connection](Data-SqlTransaction.html#t:Connection) ()

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
