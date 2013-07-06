-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.MemTimeState

Synopsis

-   data [MemState](#t:MemState)
-   data [Query](#t:Query) where
    -   [Insert](#v:Insert) :: Key -\> Value -\> [Query](Data-MemTimeState.html#t:Query)
    -   [Delete](#v:Delete) :: Key -\> [Query](Data-MemTimeState.html#t:Query)
    -   [Query](#v:Query) :: Key -\> [Query](Data-MemTimeState.html#t:Query)
    -   [DumpState](#v:DumpState) :: [Query](Data-MemTimeState.html#t:Query)

-   data [Result](#t:Result) where
    -   [Value](#v:Value) :: ByteString -\> [Result](Data-MemTimeState.html#t:Result)
    -   [NotFound](#v:NotFound) :: [Result](Data-MemTimeState.html#t:Result)
    -   [Empty](#v:Empty) :: [Result](Data-MemTimeState.html#t:Result)
    -   [Except](#v:Except) :: String -\> [Result](Data-MemTimeState.html#t:Result)
    -   [KeyVal](#v:KeyVal) :: ByteString -\> ByteString -\> [Result](Data-MemTimeState.html#t:Result)

-   type [QueryChan](#t:QueryChan) = TQueue ([Query](Data-MemTimeState.html#t:Query), Unique [Result](Data-MemTimeState.html#t:Result))
-   [runQuery](#v:runQuery) :: [QueryChan](Data-MemTimeState.html#t:QueryChan) -\> [Query](Data-MemTimeState.html#t:Query) -\> IO [Result](Data-MemTimeState.html#t:Result)
-   [newMemState](#v:newMemState) :: Time -\> Time -\> FilePath -\> IO [MemState](Data-MemTimeState.html#t:MemState)
-   [queryManager](#v:queryManager) :: FilePath -\> [MemState](Data-MemTimeState.html#t:MemState) -\> [QueryChan](Data-MemTimeState.html#t:QueryChan) -\> IO ()

Documentation
=============

data MemState

The Map is a mapping from a bytestring key to the internal used key. | MemMap contains the binary data, indexed by the internal key | TimeMap contains the internal keys index by time

data Query where

Constructors

||
|Insert :: Key -\> Value -\> [Query](Data-MemTimeState.html#t:Query)| |
|Delete :: Key -\> [Query](Data-MemTimeState.html#t:Query)| |
|Query :: Key -\> [Query](Data-MemTimeState.html#t:Query)| |
|DumpState :: [Query](Data-MemTimeState.html#t:Query)| |

Instances

||
|Eq [Query](Data-MemTimeState.html#t:Query)| |
|Show [Query](Data-MemTimeState.html#t:Query)| |
|Arbitrary [Query](Data-MemTimeState.html#t:Query)| |
|Serialize [Query](Data-MemTimeState.html#t:Query)| |

data Result where

Constructors

||
|Value :: ByteString -\> [Result](Data-MemTimeState.html#t:Result)| |
|NotFound :: [Result](Data-MemTimeState.html#t:Result)| |
|Empty :: [Result](Data-MemTimeState.html#t:Result)| |
|Except :: String -\> [Result](Data-MemTimeState.html#t:Result)| |
|KeyVal :: ByteString -\> ByteString -\> [Result](Data-MemTimeState.html#t:Result)| |

Instances

||
|Eq [Result](Data-MemTimeState.html#t:Result)| |
|Show [Result](Data-MemTimeState.html#t:Result)| |
|Arbitrary [Result](Data-MemTimeState.html#t:Result)| |
|Serialize [Result](Data-MemTimeState.html#t:Result)| |

type QueryChan = TQueue ([Query](Data-MemTimeState.html#t:Query), Unique [Result](Data-MemTimeState.html#t:Result))

runQuery :: [QueryChan](Data-MemTimeState.html#t:QueryChan) -\> [Query](Data-MemTimeState.html#t:Query) -\> IO [Result](Data-MemTimeState.html#t:Result)

newMemState :: Time -\> Time -\> FilePath -\> IO [MemState](Data-MemTimeState.html#t:MemState)

queryManager :: FilePath -\> [MemState](Data-MemTimeState.html#t:MemState) -\> [QueryChan](Data-MemTimeState.html#t:QueryChan) -\> IO ()

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
