-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.ConversionInstances

Description

Instances for conversions Edgar - added gzip to the object encode / decoding instances

Synopsis

-   [double2Float](#v:double2Float) :: Double -\> Float
-   [float2Double](#v:float2Double) :: Float -\> Double
-   [convFromSql](#v:convFromSql) :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> [InRule](Data-InRules.html#t:InRule)
-   [convSql](#v:convSql) :: [InRule](Data-InRules.html#t:InRule) -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue)
-   [put8](#v:put8) :: Word8 -\> Put
-   [toWord64](#v:toWord64) :: Int -\> Word64
-   [put8b](#v:put8b) :: Word8 -\> Put
-   [serializeHashMapb](#v:serializeHashMapb) :: (Binary t1, Binary t) =\> HashMap t t1 -\> PutM ()
-   [serializeHashMap](#v:serializeHashMap) :: (Serialize t1, Serialize t) =\> HashMap t t1 -\> PutM ()

Documentation
=============

double2Float :: Double -\> Float

float2Double :: Float -\> Double

convFromSql :: [SqlValue](Data-SqlTransaction.html#t:SqlValue) -\> [InRule](Data-InRules.html#t:InRule)

Convert an sql value to a InRule and decode a binary blob The pipeline looks like this:

     decode :: (SqlValue -> Either error B.ByteString)
     S.decode :: (B.ByteString -> Either error InRule)

base64 | / decode | binary gzip data |/ quicklz | serialized data / `decode` | |/ InRule

Convert an SqlValue to a InRule

convSql :: [InRule](Data-InRules.html#t:InRule) -\> [SqlValue](Data-SqlTransaction.html#t:SqlValue)

Convert a InRule to a SqlValu

put8 :: Word8 -\> Put

Put a word in a `Put` monad

toWord64 :: Int -\> Word64

Change a integer into a Word64

put8b :: Word8 -\> Put

Put a word in a `Put` monad

serializeHashMapb :: (Binary t1, Binary t) =\> HashMap t t1 -\> PutM ()

serializeHashMap :: (Serialize t1, Serialize t) =\> HashMap t t1 -\> PutM ()

Serialize a hashmap, internal helper function

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
