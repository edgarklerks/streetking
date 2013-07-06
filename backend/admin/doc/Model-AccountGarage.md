-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.AccountGarage

Documentation
=============

type MString = Maybe String

type MInteger = Maybe Integer

data AccountGarage

Constructors

AccountGarage

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

firstname :: [MString](Model-AccountGarage.html#t:MString)  
 

lastname :: [MString](Model-AccountGarage.html#t:MString)  
 

nickname :: [MString](Model-AccountGarage.html#t:MString)  
 

picture\_small :: [MString](Model-AccountGarage.html#t:MString)  
 

picture\_medium :: [MString](Model-AccountGarage.html#t:MString)  
 

picture\_large :: [MString](Model-AccountGarage.html#t:MString)  
 

level :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

skill\_acceleration :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

skill\_braking :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

skill\_control :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

skill\_reactions :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

skill\_intelligence :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

money :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

respect :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

diamonds :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

energy :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

max\_energy :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

energy\_recovery :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

energy\_updated :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

busy\_until :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

email :: String  
 

till :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

city\_id :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

city\_name :: String  
 

continent\_id :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

continent\_name :: String  
 

skill\_unused :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

busy\_subject\_id :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

busy\_type :: String  
 

busy\_timeleft :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

free\_car :: Bool  
 

garage\_id :: [MInteger](Model-AccountGarage.html#t:MInteger)  
 

Instances

||
|Eq [AccountGarage](Model-AccountGarage.html#t:AccountGarage)| |
|Show [AccountGarage](Model-AccountGarage.html#t:AccountGarage)| |
|ToJSON [AccountGarage](Model-AccountGarage.html#t:AccountGarage)| |
|FromJSON [AccountGarage](Model-AccountGarage.html#t:AccountGarage)| |
|Default [AccountGarage](Model-AccountGarage.html#t:AccountGarage)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [AccountGarage](Model-AccountGarage.html#t:AccountGarage)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [AccountGarage](Model-AccountGarage.html#t:AccountGarage)| |
|[Mapable](Model-General.html#t:Mapable) [AccountGarage](Model-AccountGarage.html#t:AccountGarage)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [AccountGarage](Model-AccountGarage.html#t:AccountGarage)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
