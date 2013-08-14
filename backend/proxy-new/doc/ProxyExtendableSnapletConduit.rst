=============================
ProxyExtendableSnapletConduit
=============================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

ProxyExtendableSnapletConduit

Documentation
=============

initProxy :: `Cycle <Data-ExternalLog.html#t:Cycle>`__ -> FilePath ->
SnapletInit b
`ProxySnaplet <ProxyExtendableSnapletConduit.html#t:ProxySnaplet>`__

runProxy :: ([proxyTransform :: ByteString -> ByteString], MonadState
`ProxySnaplet <ProxyExtendableSnapletConduit.html#t:ProxySnaplet>`__ m,
MonadSnap m) => [QueryItem] -> m ()

data ProxySnaplet

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
