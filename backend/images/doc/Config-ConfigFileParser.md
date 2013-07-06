% Config.ConfigFileParser
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

Safe-Infered

Config.ConfigFileParser

Documentation
=============

readConfig :: FilePath -\> IO
[Sections](Config-ConfigFileParser.html#t:Sections)

lookupConfig :: String -\>
[Sections](Config-ConfigFileParser.html#t:Sections) -\> Maybe
[[Config](Config-ConfigFileParser.html#t:Config)]

lookupVar :: String -\>
[[Config](Config-ConfigFileParser.html#t:Config)] -\> Maybe
[Config](Config-ConfigFileParser.html#t:Config)

data Config

Constructors

  ------------------------------------------------------------ ---
  Var String [Config](Config-ConfigFileParser.html#t:Config)    
  IntegerC Integer                                              
  StringC String                                                
  BoolC Bool                                                    
  FloatC Float                                                  
  ArrayC [[Config](Config-ConfigFileParser.html#t:Config)]      
  ------------------------------------------------------------ ---

Instances

  ------------------------------------------------------ ---
  Show [Config](Config-ConfigFileParser.html#t:Config)    
  ------------------------------------------------------ ---

type Sections = [[Section](Config-ConfigFileParser.html#t:Section)]

type Section = (String,
[[Config](Config-ConfigFileParser.html#t:Config)])

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
