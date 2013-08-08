=======================
Config.ConfigFileParser
=======================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

Safe-Infered

Config.ConfigFileParser

Documentation
=============

readConfig :: FilePath -> IO
`Sections <Config-ConfigFileParser.html#t:Sections>`__

lookupConfig :: String ->
`Sections <Config-ConfigFileParser.html#t:Sections>`__ -> Maybe
[`Config <Config-ConfigFileParser.html#t:Config>`__\ ]

lookupVar :: String ->
[`Config <Config-ConfigFileParser.html#t:Config>`__\ ] -> Maybe
`Config <Config-ConfigFileParser.html#t:Config>`__

data Config

Constructors

+-----------------------------------------------------------------+-----+
| Var String `Config <Config-ConfigFileParser.html#t:Config>`__   |     |
+-----------------------------------------------------------------+-----+
| IntegerC Integer                                                |     |
+-----------------------------------------------------------------+-----+
| StringC String                                                  |     |
+-----------------------------------------------------------------+-----+
| BoolC Bool                                                      |     |
+-----------------------------------------------------------------+-----+
| FloatC Float                                                    |     |
+-----------------------------------------------------------------+-----+
| ArrayC [`Config <Config-ConfigFileParser.html#t:Config>`__\ ]   |     |
+-----------------------------------------------------------------+-----+

Instances

+-----------------------------------------------------------+-----+
| Show `Config <Config-ConfigFileParser.html#t:Config>`__   |     |
+-----------------------------------------------------------+-----+

type Sections = [`Section <Config-ConfigFileParser.html#t:Section>`__\ ]

type Section = (String,
[`Config <Config-ConfigFileParser.html#t:Config>`__\ ])

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
