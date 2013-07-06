-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

ProxyExtendableSnapletConduit

Documentation
=============

initProxy :: [Cycle](Data-ExternalLog.html#t:Cycle) -\> FilePath -\> SnapletInit b [ProxySnaplet](ProxyExtendableSnapletConduit.html#t:ProxySnaplet)

runProxy :: ([proxyTransform :: ByteString -\> ByteString], MonadState [ProxySnaplet](ProxyExtendableSnapletConduit.html#t:ProxySnaplet) m, MonadSnap m) =\> [QueryItem] -\> m ()

data ProxySnaplet

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
