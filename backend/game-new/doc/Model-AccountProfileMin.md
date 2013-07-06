-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.AccountProfileMin

Documentation
=============

type MString = Maybe String

type MInteger = Maybe Integer

data AccountProfileMin

Constructors

AccountProfileMin

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

nickname :: String  
 

picture\_small :: [MString](Model-AccountProfileMin.html#t:MString)  
 

picture\_medium :: [MString](Model-AccountProfileMin.html#t:MString)  
 

picture\_large :: [MString](Model-AccountProfileMin.html#t:MString)  
 

level :: Integer  
 

city\_name :: String  
 

continent\_name :: String  
 

Instances

||
|Eq [AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin)| |
|Show [AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin)| |
|ToJSON [AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin)| |
|FromJSON [AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin)| |
|Default [AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin)| |
|[Mapable](Model-General.html#t:Mapable) [AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

class ToAccountProfileMin a where

Methods

toAPM :: a -\> [AccountProfileMin](Model-AccountProfileMin.html#t:AccountProfileMin)

Instances

||
|[ToAccountProfileMin](Model-AccountProfileMin.html#t:ToAccountProfileMin) [Account](Model-Account.html#t:Account)| |
|[ToAccountProfileMin](Model-AccountProfileMin.html#t:ToAccountProfileMin) [AccountProfile](Model-AccountProfile.html#t:AccountProfile)| |

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
