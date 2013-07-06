% Data.Event
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.Event

Description

Event expression matcher primitives

Documentation
=============

data Symbol where

Constructors

  --------------------------------------------------------------------------------------------------------- ---
  TournamentI :: Maybe Integer -\> Maybe Integer -\> Maybe Integer -\> [Symbol](Data-Event.html#t:Symbol)    
  LevelI :: Integer -\> [Symbol](Data-Event.html#t:Symbol)                                                   
  RaceI :: Maybe Integer -\> Maybe Integer -\> [Symbol](Data-Event.html#t:Symbol)                            
  PracticeI :: Maybe Integer -\> [Symbol](Data-Event.html#t:Symbol)                                          
  --------------------------------------------------------------------------------------------------------- ---

Instances

Show [Symbol](Data-Event.html#t:Symbol)

 

[Evaluate](Data-Decider.html#t:Evaluate)
[Event](Data-Event.html#t:Event) [Symbol](Data-Event.html#t:Symbol)

Matcher for tournament types

matchEvent :: [Expr](Data-Decider.html#t:Expr) g
[Symbol](Data-Event.html#t:Symbol) -\>
[[Event](Data-Event.html#t:Event)] -\>
([[Event](Data-Event.html#t:Event)], Bool)

eventDecider :: [Expr](Data-Decider.html#t:Expr) g
[Symbol](Data-Event.html#t:Symbol) -\>
[Decider](Data-Decider.html#t:Decider) [Event](Data-Event.html#t:Event)

data Event where

Constructors

  --------------------------------------------------------------------------------------- ---
  Tournament :: Integer -\> Integer -\> Integer -\> [Event](Data-Event.html#t:Event)       
  PracticeRace :: Integer -\> Integer -\> [Event](Data-Event.html#t:Event)                 
  ChallengeRace :: Integer -\> Integer -\> Integer -\> [Event](Data-Event.html#t:Event)    
  Level :: Integer -\> [Event](Data-Event.html#t:Event)                                    
  --------------------------------------------------------------------------------------- ---

Instances

Eq [Event](Data-Event.html#t:Event)

 

Show [Event](Data-Event.html#t:Event)

 

ToJSON [Event](Data-Event.html#t:Event)

 

FromJSON [Event](Data-Event.html#t:Event)

 

[FromInRule](Data-InRules.html#t:FromInRule)
[Event](Data-Event.html#t:Event)

 

[ToInRule](Data-InRules.html#t:ToInRule)
[Event](Data-Event.html#t:Event)

 

[Evaluate](Data-Decider.html#t:Evaluate)
[Event](Data-Event.html#t:Event) [Symbol](Data-Event.html#t:Symbol)

Matcher for tournament types

toInt :: Value -\> Integer

cmp :: Eq a =\> Maybe a -\> a -\> Bool

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
