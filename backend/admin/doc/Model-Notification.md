-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Notification

Documentation
=============

type MInteger = Maybe Integer

type MString = Maybe String

data Notification

Constructors

Notification

 

Fields

id :: [Id](Model-General.html#t:Id)  
 

name :: String  
 

type :: [MString](Model-Notification.html#t:MString)  
 

language :: Integer  
 

body :: String  
 

title :: String  
 

Instances

||
|Eq [Notification](Model-Notification.html#t:Notification)| |
|Show [Notification](Model-Notification.html#t:Notification)| |
|ToJSON [Notification](Model-Notification.html#t:Notification)| |
|FromJSON [Notification](Model-Notification.html#t:Notification)| |
|Default [Notification](Model-Notification.html#t:Notification)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [Notification](Model-Notification.html#t:Notification)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [Notification](Model-Notification.html#t:Notification)| |
|[Mapable](Model-General.html#t:Mapable) [Notification](Model-Notification.html#t:Notification)| |
|[Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Notification](Model-Notification.html#t:Notification)| |

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
