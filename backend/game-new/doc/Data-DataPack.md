-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.DataPack

Documentation
=============

data Data

Instances

||
|Eq [Data](Data-DataPack.html#t:Data)| |
|Show [Data](Data-DataPack.html#t:Data)| |
|ToJSON [Data](Data-DataPack.html#t:Data)| |
|FromJSON [Data](Data-DataPack.html#t:Data)| |
|Default [Data](Data-DataPack.html#t:Data)| |
|[FromInRule](Data-InRules.html#t:FromInRule) [Data](Data-DataPack.html#t:Data)| |
|[ToInRule](Data-InRules.html#t:ToInRule) [Data](Data-DataPack.html#t:Data)| |

emptyData :: [Data](Data-DataPack.html#t:Data)

type Pack = ByteString

emptyData :: [Data](Data-DataPack.html#t:Data)

setField :: forall a. ToJSON a =\> (Key, a) -\> [Data](Data-DataPack.html#t:Data) -\> [Data](Data-DataPack.html#t:Data)

(.\>) :: forall a. ToJSON a =\> (Key, a) -\> [Data](Data-DataPack.html#t:Data) -\> [Data](Data-DataPack.html#t:Data)

(.\<) :: forall a. FromJSON a =\> Key -\> [Data](Data-DataPack.html#t:Data) -\> Maybe a

getField :: forall a. FromJSON a =\> Key -\> [Data](Data-DataPack.html#t:Data) -\> Maybe a

getFieldWithDefault :: forall a. FromJSON a =\> a -\> Key -\> [Data](Data-DataPack.html#t:Data) -\> a

getFieldForced :: forall a. FromJSON a =\> Key -\> [Data](Data-DataPack.html#t:Data) -\> a

(.\<\<) :: forall a. FromJSON a =\> Key -\> [Data](Data-DataPack.html#t:Data) -\> a

packData :: forall a. ToJSON a =\> a -\> [Pack](Data-DataPack.html#t:Pack)

unpackData :: forall a. FromJSON a =\> [Pack](Data-DataPack.html#t:Pack) -\> Maybe a

data DataM s a

Instances

||
|Monad ([DataM](Data-DataPack.html#t:DataM) s)| |

set :: forall a. ToJSON a =\> Key -\> a -\> [DataM](Data-DataPack.html#t:DataM) [Data](Data-DataPack.html#t:Data) ()

get :: forall a. FromJSON a =\> Key -\> [DataM](Data-DataPack.html#t:DataM) [Data](Data-DataPack.html#t:Data) a

readData :: [Data](Data-DataPack.html#t:Data) -\> [DataM](Data-DataPack.html#t:DataM) [Data](Data-DataPack.html#t:Data) a -\> a

withData :: [Data](Data-DataPack.html#t:Data) -\> [DataM](Data-DataPack.html#t:DataM) [Data](Data-DataPack.html#t:Data) () -\> [Data](Data-DataPack.html#t:Data)

mkData :: [DataM](Data-DataPack.html#t:DataM) [Data](Data-DataPack.html#t:Data) () -\> [Data](Data-DataPack.html#t:Data)

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
