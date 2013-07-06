% Data.ConduitTransformer
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.ConduitTransformer

Documentation
=============

conduitToEnumeratorSource :: Source IO a -\> IO (Enumerator a IO ())

enumeratorToConduitSource :: Show a =\> Enumerator a IO () -\> IO
(Source IO a)

tqueueSink :: MonadIO m =\> TQueue (Maybe [a]) -\> Sink a m ()

tqueueSource :: (MonadIO m, Show a) =\> TQueue (Maybe [a]) -\> Source m
a

tqueueEnumerator :: TQueue (Maybe [a]) -\> Enumerator a IO b

tqueueIterator :: TQueue (Maybe [a]) -\> Iteratee a IO ()

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
