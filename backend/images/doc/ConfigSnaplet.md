-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

ConfigSnaplet

Documentation
=============

initConfig :: FilePath -\> SnapletInit b [ConfigSnaplet](ConfigSnaplet.html#t:ConfigSnaplet)

lookupConfig :: MonadState [ConfigSnaplet](ConfigSnaplet.html#t:ConfigSnaplet) m =\> String -\> m (Maybe [[Config](ConfigSnaplet.html#t:Config)])

lookupVar :: Monad m =\> String -\> [[Config](ConfigSnaplet.html#t:Config)] -\> m (Maybe [Config](ConfigSnaplet.html#t:Config))

lookupVal :: MonadState [ConfigSnaplet](ConfigSnaplet.html#t:ConfigSnaplet) m =\> String -\> String -\> m (Maybe [Config](ConfigSnaplet.html#t:Config))

data Config

Constructors

||
|Var String [Config](ConfigSnaplet.html#t:Config)| |
|IntegerC Integer| |
|StringC String| |
|BoolC Bool| |
|FloatC Float| |
|ArrayC [[Config](ConfigSnaplet.html#t:Config)]| |

Instances

||
|Show [Config](ConfigSnaplet.html#t:Config)| |

type Sections = [[Section](ConfigSnaplet.html#t:Section)]

type Section = (String, [[Config](ConfigSnaplet.html#t:Config)])

data ConfigSnaplet

Constructors

ConfigSnaplet

 

Fields

\_configDir :: String  
 

\_configData :: [Sections](ConfigSnaplet.html#t:Sections)  
 

Instances

||
|Show [ConfigSnaplet](ConfigSnaplet.html#t:ConfigSnaplet)| |

configDir :: Lens' [ConfigSnaplet](ConfigSnaplet.html#t:ConfigSnaplet) String

configData :: Lens' [ConfigSnaplet](ConfigSnaplet.html#t:ConfigSnaplet) [Sections](ConfigSnaplet.html#t:Sections)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
