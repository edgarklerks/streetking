% Model.Config
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.Config

Documentation
=============

data Config

Constructors

Config

 

Fields

key :: String
:    
value :: String
:    

Instances

  ------------------------------------------------------------------------------------------------------------------------------------ ---
  Eq [Config](Model-Config.html#t:Config)                                                                                               
  Show [Config](Model-Config.html#t:Config)                                                                                             
  ToJSON [Config](Model-Config.html#t:Config)                                                                                           
  FromJSON [Config](Model-Config.html#t:Config)                                                                                         
  Default [Config](Model-Config.html#t:Config)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [Config](Model-Config.html#t:Config)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [Config](Model-Config.html#t:Config)                                                         
  [Mapable](Model-General.html#t:Mapable) [Config](Model-Config.html#t:Config)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [Config](Model-Config.html#t:Config)    
  ------------------------------------------------------------------------------------------------------------------------------------ ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

getKey :: Read a =\> String -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) a

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
