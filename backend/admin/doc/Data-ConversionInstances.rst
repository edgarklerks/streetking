========================
Data.ConversionInstances
========================

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.ConversionInstances

Documentation
=============

double2Float :: Double -> Float

float2Double :: Float -> Double

convFromSql :: `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__ ->
`InRule <Data-InRules.html#t:InRule>`__

convSql :: `InRule <Data-InRules.html#t:InRule>`__ ->
`SqlValue <Data-SqlTransaction.html#t:SqlValue>`__

put8 :: Word8 -> Put

toWord64 :: Int -> Word64

put8b :: Word8 -> Put

serializeHashMapb :: (Binary t1, Binary t) => HashMap t t1 -> PutM ()

serializeHashMap :: (Serialize t1, Serialize t) => HashMap t t1 -> PutM
()

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
