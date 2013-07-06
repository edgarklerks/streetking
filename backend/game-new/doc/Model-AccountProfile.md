-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.AccountProfile

Documentation
=============

type MString = Maybe String

type MInteger = Maybe Integer

data AccountProfile

Constructors

AccountProfile

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

firstname :: [MString](Model-AccountProfile.html#t:MString)  
 

lastname :: [MString](Model-AccountProfile.html#t:MString)  
 

nickname :: [MString](Model-AccountProfile.html#t:MString)  
 

picture\_small :: [MString](Model-AccountProfile.html#t:MString)  
 

picture\_medium :: [MString](Model-AccountProfile.html#t:MString)  
 

picture\_large :: [MString](Model-AccountProfile.html#t:MString)  
 

level :: [MInteger](Model-AccountProfile.html#t:MInteger)  
 

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
 

till :: Integer  
 

city\_id :: Integer  
 

city\_name :: String  
 

continent\_id :: Integer  
 

continent\_name :: String  
 

skill\_unused :: Integer  
 

busy\_subject\_id :: Integer  
 

busy\_type :: String  
 

busy\_timeleft :: Integer  
 

free\_car :: Bool  
 

Instances

||
|Eq [AccountProfile](Model-AccountProfile.html#t:AccountProfile)| |
|Show [AccountProfile](Model-AccountProfile.html#t:AccountProfile)| |
|ToJSON [AccountProfile](Model-AccountProfile.html#t:AccountProfile)| |
|FromJSON [AccountProfile](Model-AccountProfile.html#t:AccountProfile)| |
|Default [AccountProfile](Model-AccountProfile.html#t:AccountProfile)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [AccountProfile](Model-AccountProfile.html#t:AccountProfile)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [AccountProfile](Model-AccountProfile.html#t:AccountProfile)| |
|[Mapable](Model-General.html#t:Mapable) [AccountProfile](Model-AccountProfile.html#t:AccountProfile)| |
|[ToAccountProfileMin](Model-AccountProfileMin.html#t:ToAccountProfileMin) [AccountProfile](Model-AccountProfile.html#t:AccountProfile)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [AccountProfile](Model-AccountProfile.html#t:AccountProfile)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
