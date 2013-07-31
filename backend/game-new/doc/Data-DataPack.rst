=============
Data.DataPack
=============

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.DataPack

Documentation
=============

data Data

Instances

+----------------------------------------------------------------------------------------+-----+
| Eq `Data <Data-DataPack.html#t:Data>`__                                                |     |
+----------------------------------------------------------------------------------------+-----+
| Show `Data <Data-DataPack.html#t:Data>`__                                              |     |
+----------------------------------------------------------------------------------------+-----+
| ToJSON `Data <Data-DataPack.html#t:Data>`__                                            |     |
+----------------------------------------------------------------------------------------+-----+
| FromJSON `Data <Data-DataPack.html#t:Data>`__                                          |     |
+----------------------------------------------------------------------------------------+-----+
| Default `Data <Data-DataPack.html#t:Data>`__                                           |     |
+----------------------------------------------------------------------------------------+-----+
| `FromInRule <Data-InRules.html#t:FromInRule>`__ `Data <Data-DataPack.html#t:Data>`__   |     |
+----------------------------------------------------------------------------------------+-----+
| `ToInRule <Data-InRules.html#t:ToInRule>`__ `Data <Data-DataPack.html#t:Data>`__       |     |
+----------------------------------------------------------------------------------------+-----+

emptyData :: `Data <Data-DataPack.html#t:Data>`__

type Pack = ByteString

emptyData :: `Data <Data-DataPack.html#t:Data>`__

setField :: forall a. ToJSON a => (Key, a) ->
`Data <Data-DataPack.html#t:Data>`__ ->
`Data <Data-DataPack.html#t:Data>`__

(.>) :: forall a. ToJSON a => (Key, a) ->
`Data <Data-DataPack.html#t:Data>`__ ->
`Data <Data-DataPack.html#t:Data>`__

(.<) :: forall a. FromJSON a => Key ->
`Data <Data-DataPack.html#t:Data>`__ -> Maybe a

getField :: forall a. FromJSON a => Key ->
`Data <Data-DataPack.html#t:Data>`__ -> Maybe a

getFieldWithDefault :: forall a. FromJSON a => a -> Key ->
`Data <Data-DataPack.html#t:Data>`__ -> a

getFieldForced :: forall a. FromJSON a => Key ->
`Data <Data-DataPack.html#t:Data>`__ -> a

(.<<) :: forall a. FromJSON a => Key ->
`Data <Data-DataPack.html#t:Data>`__ -> a

packData :: forall a. ToJSON a => a ->
`Pack <Data-DataPack.html#t:Pack>`__

unpackData :: forall a. FromJSON a =>
`Pack <Data-DataPack.html#t:Pack>`__ -> Maybe a

data DataM s a

Instances

+----------------------------------------------------+-----+
| Monad (`DataM <Data-DataPack.html#t:DataM>`__ s)   |     |
+----------------------------------------------------+-----+

set :: forall a. ToJSON a => Key -> a ->
`DataM <Data-DataPack.html#t:DataM>`__
`Data <Data-DataPack.html#t:Data>`__ ()

get :: forall a. FromJSON a => Key ->
`DataM <Data-DataPack.html#t:DataM>`__
`Data <Data-DataPack.html#t:Data>`__ a

readData :: `Data <Data-DataPack.html#t:Data>`__ ->
`DataM <Data-DataPack.html#t:DataM>`__
`Data <Data-DataPack.html#t:Data>`__ a -> a

withData :: `Data <Data-DataPack.html#t:Data>`__ ->
`DataM <Data-DataPack.html#t:DataM>`__
`Data <Data-DataPack.html#t:Data>`__ () ->
`Data <Data-DataPack.html#t:Data>`__

mkData :: `DataM <Data-DataPack.html#t:DataM>`__
`Data <Data-DataPack.html#t:Data>`__ () ->
`Data <Data-DataPack.html#t:Data>`__

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
