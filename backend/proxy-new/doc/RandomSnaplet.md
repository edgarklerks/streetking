-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

RandomSnaplet

Documentation
=============

data RandomConfig

class HasRandom b where

Methods

randomLens :: SnapletLens (Snaplet b) (Snaplet [RandomConfig](RandomSnaplet.html#t:RandomConfig))

class Variate a where

Methods

uniform :: PrimMonad m =\> Gen (PrimState m) -\> m a

uniformR :: PrimMonad m =\> (a, a) -\> Gen (PrimState m) -\> m a

Instances

||
|[Variate](RandomSnaplet.html#t:Variate) Bool| |
|[Variate](RandomSnaplet.html#t:Variate) Double| |
|[Variate](RandomSnaplet.html#t:Variate) Float| |
|[Variate](RandomSnaplet.html#t:Variate) Int| |
|[Variate](RandomSnaplet.html#t:Variate) Int8| |
|[Variate](RandomSnaplet.html#t:Variate) Int16| |
|[Variate](RandomSnaplet.html#t:Variate) Int32| |
|[Variate](RandomSnaplet.html#t:Variate) Int64| |
|[Variate](RandomSnaplet.html#t:Variate) Word| |
|[Variate](RandomSnaplet.html#t:Variate) Word8| |
|[Variate](RandomSnaplet.html#t:Variate) Word16| |
|[Variate](RandomSnaplet.html#t:Variate) Word32| |
|[Variate](RandomSnaplet.html#t:Variate) Word64| |
|[Variate](RandomSnaplet.html#t:Variate) (Base64 L64)| |
|[Variate](RandomSnaplet.html#t:Variate) (Base64 L32)| |
|[Variate](RandomSnaplet.html#t:Variate) (Base64 L16)| |
|[Variate](RandomSnaplet.html#t:Variate) (Base64 L8)| |
|([Variate](RandomSnaplet.html#t:Variate) a, [Variate](RandomSnaplet.html#t:Variate) b) =\> [Variate](RandomSnaplet.html#t:Variate) (a, b)| |
|([Variate](RandomSnaplet.html#t:Variate) a, [Variate](RandomSnaplet.html#t:Variate) b, [Variate](RandomSnaplet.html#t:Variate) c) =\> [Variate](RandomSnaplet.html#t:Variate) (a, b, c)| |
|([Variate](RandomSnaplet.html#t:Variate) a, [Variate](RandomSnaplet.html#t:Variate) b, [Variate](RandomSnaplet.html#t:Variate) c, [Variate](RandomSnaplet.html#t:Variate) d) =\> [Variate](RandomSnaplet.html#t:Variate) (a, b, c, d)| |

getUniform :: (MonadState [RandomConfig](RandomSnaplet.html#t:RandomConfig) m, MonadIO m, [Variate](RandomSnaplet.html#t:Variate) a) =\> m a

getUniformR :: (MonadState [RandomConfig](RandomSnaplet.html#t:RandomConfig) m, MonadIO m, [Variate](RandomSnaplet.html#t:Variate) a) =\> (a, a) -\> m a

getUniqueKey :: (MonadState [RandomConfig](RandomSnaplet.html#t:RandomConfig) m, MonadIO m) =\> m ByteString

initRandomSnaplet :: [Variate](RandomSnaplet.html#t:Variate) (Base64 a) =\> a -\> SnapletInit b [RandomConfig](RandomSnaplet.html#t:RandomConfig)

l8 :: L8

l16 :: L16

l32 :: L32

l64 :: L64

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
