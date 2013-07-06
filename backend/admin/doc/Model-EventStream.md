% Model.EventStream
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.EventStream

Documentation
=============

type Stream = Maybe [[Event](Data-Event.html#t:Event)]

data EventStream

Constructors

EventStream

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
account\_id :: [Id](Model-General.html#t:Id)
:    
rule\_id :: [Id](Model-General.html#t:Id)
:    
stream :: [Stream](Model-EventStream.html#t:Stream)
:    
active :: Bool
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [EventStream](Model-EventStream.html#t:EventStream)                                                                                               
  Show [EventStream](Model-EventStream.html#t:EventStream)                                                                                             
  ToJSON [EventStream](Model-EventStream.html#t:EventStream)                                                                                           
  FromJSON [EventStream](Model-EventStream.html#t:EventStream)                                                                                         
  Default [EventStream](Model-EventStream.html#t:EventStream)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [EventStream](Model-EventStream.html#t:EventStream)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [EventStream](Model-EventStream.html#t:EventStream)                                                         
  [Mapable](Model-General.html#t:Mapable) [EventStream](Model-EventStream.html#t:EventStream)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [EventStream](Model-EventStream.html#t:EventStream)    
  --------------------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

getEventStream :: Convertible a
[SqlValue](Data-SqlTransaction.html#t:SqlValue) =\> a -\> IO
[[EventStream](Model-EventStream.html#t:EventStream)]

emitEvent :: Integer -\> [Event](Data-Event.html#t:Event) -\>
[SqlTransaction](Data-SqlTransaction.html#t:SqlTransaction)
[Connection](Data-SqlTransaction.html#t:Connection) ()

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
