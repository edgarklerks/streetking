-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Account

Documentation
=============

type MString = Maybe String

data Account

Constructors

Account

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

firstname :: [MString](Model-Account.html#t:MString)  
 

lastname :: [MString](Model-Account.html#t:MString)  
 

nickname :: String  
 

picture\_small :: [MString](Model-Account.html#t:MString)  
 

picture\_medium :: [MString](Model-Account.html#t:MString)  
 

picture\_large :: [MString](Model-Account.html#t:MString)  
 

level :: Integer  
 

skill\_acceleration :: Integer  
 

skill\_braking :: Integer  
 

skill\_control :: Integer  
 

skill\_reactions :: Integer  
 

skill\_intelligence :: Integer  
 

money :: Integer  
 

respect :: Integer  
 

diamonds :: Integer  
 

energy :: Integer  
 

max\_energy :: Integer  
 

energy\_recovery :: Integer  
 

energy\_updated :: Integer  
 

busy\_until :: Integer  
 

password :: String  
 

email :: String  
 

skill\_unused :: Integer  
 

city :: Integer  
 

busy\_type :: Integer  
 

busy\_subject\_id :: Integer  
 

free\_car :: Bool  
 

Instances

||
|Eq [Account](Model-Account.html#t:Account)| |
|Show [Account](Model-Account.html#t:Account)| |
|ToJSON [Account](Model-Account.html#t:Account)| |
|FromJSON [Account](Model-Account.html#t:Account)| |
|Default [Account](Model-Account.html#t:Account)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [Account](Model-Account.html#t:Account)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [Account](Model-Account.html#t:Account)| |
|[Mapable](Model-General.html#t:Mapable) [Account](Model-Account.html#t:Account)| |
|[ToAccountProfileMin](Model-AccountProfileMin.html#t:ToAccountProfileMin) [Account](Model-Account.html#t:Account)| |
|ToDriver [Account](Model-Account.html#t:Account)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Account](Model-Account.html#t:Account)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
