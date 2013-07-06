% Model.PreLetter
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Model.PreLetter

Documentation
=============

type MInteger = Maybe Integer

type BString = Maybe ByteString

type MString = Maybe String

data PreLetter

Constructors

PreLetter

 

Fields

id :: [Id](Model-General.html#t:Id)
:    
ttl :: [MInteger](Model-PreLetter.html#t:MInteger)
:    
message :: String
:    
title :: String
:    
sendat :: Integer
:    
to :: Integer
:    
from :: [MInteger](Model-PreLetter.html#t:MInteger)
:    
read :: Bool
:    
archive :: Bool
:    
data :: [BString](Model-PreLetter.html#t:BString)
:    
type :: [MString](Model-PreLetter.html#t:MString)
:    

Instances

  --------------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [PreLetter](Model-PreLetter.html#t:PreLetter)                                                                                               
  Show [PreLetter](Model-PreLetter.html#t:PreLetter)                                                                                             
  ToJSON [PreLetter](Model-PreLetter.html#t:PreLetter)                                                                                           
  FromJSON [PreLetter](Model-PreLetter.html#t:PreLetter)                                                                                         
  Default [PreLetter](Model-PreLetter.html#t:PreLetter)                                                                                          
  [FromInRule](Data-InRules.html#t:FromInRule) [PreLetter](Model-PreLetter.html#t:PreLetter)                                                     
  [ToInRule](Data-InRules.html#t:ToInRule) [PreLetter](Model-PreLetter.html#t:PreLetter)                                                         
  [Mapable](Model-General.html#t:Mapable) [PreLetter](Model-PreLetter.html#t:PreLetter)                                                          
  [Database](Model-General.html#t:Database) [Connection](Data-SqlTransaction.html#t:Connection) [PreLetter](Model-PreLetter.html#t:PreLetter)    
  --------------------------------------------------------------------------------------------------------------------------------------------- ---

relation :: [RelationM](Data-Relation.html#t:RelationM)

schema :: [[Char]]

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
