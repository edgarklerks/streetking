============
ImageSnapLet
============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

ImageSnapLet

Documentation
=============

data ImageConfig

Constructors

IC

 

Fields

\_dumpdir :: String
     
\_servdir :: String
     
\_allowedTypes :: [String]
     
\_magicctx :: Magic
     

Instances

+----------------------------------------------------------+-----+
| Show `ImageConfig <ImageSnapLet.html#t:ImageConfig>`__   |     |
+----------------------------------------------------------+-----+

dumpdir :: Lens' `ImageConfig <ImageSnapLet.html#t:ImageConfig>`__
String

servdir :: Lens' `ImageConfig <ImageSnapLet.html#t:ImageConfig>`__
String

allowedTypes :: Lens' `ImageConfig <ImageSnapLet.html#t:ImageConfig>`__
[String]

uploadImage :: (MonadState
`ImageConfig <ImageSnapLet.html#t:ImageConfig>`__ m, MonadSnap m) =>
(String -> m ()) -> (String -> FilePath -> String -> m ()) -> m ()

serveImage :: (MonadState
`ImageConfig <ImageSnapLet.html#t:ImageConfig>`__ m, MonadSnap m) =>
([Char] -> m ()) -> m FilePath -> m ()

initImage :: FilePath -> SnapletInit b
`ImageConfig <ImageSnapLet.html#t:ImageConfig>`__

getServDir :: MonadState
`ImageConfig <ImageSnapLet.html#t:ImageConfig>`__ m => m String

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
