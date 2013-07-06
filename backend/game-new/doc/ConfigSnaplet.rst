=============
ConfigSnaplet
=============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

ConfigSnaplet

Documentation
=============

initConfig :: FilePath -> SnapletInit b
`ConfigSnaplet <ConfigSnaplet.html#t:ConfigSnaplet>`__

lookupConfig :: MonadState
`ConfigSnaplet <ConfigSnaplet.html#t:ConfigSnaplet>`__ m => String -> m
(Maybe [`Config <ConfigSnaplet.html#t:Config>`__\ ])

lookupVar :: Monad m => String ->
[`Config <ConfigSnaplet.html#t:Config>`__\ ] -> m (Maybe
`Config <ConfigSnaplet.html#t:Config>`__)

lookupVal :: MonadState
`ConfigSnaplet <ConfigSnaplet.html#t:ConfigSnaplet>`__ m => String ->
String -> m (Maybe `Config <ConfigSnaplet.html#t:Config>`__)

data Config

Constructors

+-------------------------------------------------------+-----+
| Var String `Config <ConfigSnaplet.html#t:Config>`__   |     |
+-------------------------------------------------------+-----+
| IntegerC Integer                                      |     |
+-------------------------------------------------------+-----+
| StringC String                                        |     |
+-------------------------------------------------------+-----+
| BoolC Bool                                            |     |
+-------------------------------------------------------+-----+
| FloatC Float                                          |     |
+-------------------------------------------------------+-----+
| ArrayC [`Config <ConfigSnaplet.html#t:Config>`__\ ]   |     |
+-------------------------------------------------------+-----+

Instances

+-------------------------------------------------+-----+
| Show `Config <ConfigSnaplet.html#t:Config>`__   |     |
+-------------------------------------------------+-----+

type Sections = [`Section <ConfigSnaplet.html#t:Section>`__\ ]

type Section = (String, [`Config <ConfigSnaplet.html#t:Config>`__\ ])

data ConfigSnaplet

Constructors

ConfigSnaplet

 

Fields

\_configDir :: String
     
\_configData :: `Sections <ConfigSnaplet.html#t:Sections>`__
     

Instances

+---------------------------------------------------------------+-----+
| Show `ConfigSnaplet <ConfigSnaplet.html#t:ConfigSnaplet>`__   |     |
+---------------------------------------------------------------+-----+

configDir :: Lens'
`ConfigSnaplet <ConfigSnaplet.html#t:ConfigSnaplet>`__ String

configData :: Lens'
`ConfigSnaplet <ConfigSnaplet.html#t:ConfigSnaplet>`__
`Sections <ConfigSnaplet.html#t:Sections>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
