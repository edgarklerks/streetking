% ImageSnapLet
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

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
:    
\_servdir :: String
:    
\_allowedTypes :: [String]
:    
\_magicctx :: Magic
:    

Instances

  ----------------------------------------------------- ---
  Show [ImageConfig](ImageSnapLet.html#t:ImageConfig)    
  ----------------------------------------------------- ---

dumpdir :: Lens' [ImageConfig](ImageSnapLet.html#t:ImageConfig) String

servdir :: Lens' [ImageConfig](ImageSnapLet.html#t:ImageConfig) String

allowedTypes :: Lens' [ImageConfig](ImageSnapLet.html#t:ImageConfig)
[String]

uploadImage :: (MonadState
[ImageConfig](ImageSnapLet.html#t:ImageConfig) m, MonadSnap m) =\>
(String -\> m ()) -\> (String -\> FilePath -\> String -\> m ()) -\> m ()

serveImage :: (MonadState [ImageConfig](ImageSnapLet.html#t:ImageConfig)
m, MonadSnap m) =\> ([Char] -\> m ()) -\> m FilePath -\> m ()

initImage :: FilePath -\> SnapletInit b
[ImageConfig](ImageSnapLet.html#t:ImageConfig)

getServDir :: MonadState [ImageConfig](ImageSnapLet.html#t:ImageConfig)
m =\> m String

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
