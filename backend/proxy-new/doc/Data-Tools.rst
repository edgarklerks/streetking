==========
Data.Tools
==========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Data.Tools

Synopsis

-  data `CheckException <#t:CheckException>`__

   -  = `CE <#v:CE>`__ [(String, [String])]
   -  \| `CF <#v:CF>`__ String

-  newtype `CFilter <#t:CFilter>`__ v = `CFilter <#v:CFilter>`__ {

   -  `runCFilter <#v:runCFilter>`__ :: v -> Maybe [String]

   }
-  `mkCFilter <#v:mkCFilter>`__ :: (v -> Bool) -> String ->
   `CFilter <Data-Tools.html#t:CFilter>`__ v
-  `cfmap <#v:cfmap>`__ :: (v' -> v) ->
   `CFilter <Data-Tools.html#t:CFilter>`__ v ->
   `CFilter <Data-Tools.html#t:CFilter>`__ v'
-  `must <#v:must>`__ :: (MonadCatchIO m, Eq k) => [(k, v)] -> [k] -> m
   ()
-  `cfilter <#v:cfilter>`__ ::
   (`StringLike <Data-Tools.html#t:StringLike>`__ v, Eq k,
   `StringLike <Data-Tools.html#t:StringLike>`__ k, MonadCatchIO m) =>
   [(k, v)] -> [(k, `CFilter <Data-Tools.html#t:CFilter>`__ v)] -> m ()
-  `scfilter <#v:scfilter>`__ :: (Show k, Show v,
   `StringLike <Data-Tools.html#t:StringLike>`__ v, Eq k,
   `StringLike <Data-Tools.html#t:StringLike>`__ k, MonadCatchIO m) =>
   HashMap k v -> [(k, `CFilter <Data-Tools.html#t:CFilter>`__ v)] -> m
   ()
-  `andcf <#v:andcf>`__ :: `CFilter <Data-Tools.html#t:CFilter>`__ v ->
   `CFilter <Data-Tools.html#t:CFilter>`__ v ->
   `CFilter <Data-Tools.html#t:CFilter>`__ v
-  `orcf <#v:orcf>`__ :: `CFilter <Data-Tools.html#t:CFilter>`__ v ->
   `CFilter <Data-Tools.html#t:CFilter>`__ v ->
   `CFilter <Data-Tools.html#t:CFilter>`__ v
-  `cfilterPure <#v:cfilterPure>`__ :: Eq k => [(k, v)] -> [(k,
   `CFilter <Data-Tools.html#t:CFilter>`__ v)] -> [(k, [String])]
-  class IsString s => `StringLike <#t:StringLike>`__ s where

   -  `toString <#v:toString>`__ :: s -> String
   -  `readS <#v:readS>`__ :: Read a => s -> Maybe a

-  `mkCRegex <#v:mkCRegex>`__ ::
   `StringLike <Data-Tools.html#t:StringLike>`__ s => String -> String
   -> `CFilter <Data-Tools.html#t:CFilter>`__ s
-  `minl <#v:minl>`__ :: `StringLike <Data-Tools.html#t:StringLike>`__ s
   => Int -> `CFilter <Data-Tools.html#t:CFilter>`__ s
-  `maxl <#v:maxl>`__ :: `StringLike <Data-Tools.html#t:StringLike>`__ s
   => Int -> `CFilter <Data-Tools.html#t:CFilter>`__ s
-  `email <#v:email>`__ :: `StringLike <Data-Tools.html#t:StringLike>`__
   s => `CFilter <Data-Tools.html#t:CFilter>`__ s
-  `isNumber <#v:isNumber>`__ ::
   `StringLike <Data-Tools.html#t:StringLike>`__ s =>
   `CFilter <Data-Tools.html#t:CFilter>`__ s
-  `natural <#v:natural>`__ ::
   `StringLike <Data-Tools.html#t:StringLike>`__ s =>
   `CFilter <Data-Tools.html#t:CFilter>`__ s
-  `between <#v:between>`__ ::
   `StringLike <Data-Tools.html#t:StringLike>`__ s => (Double, Double)
   -> `CFilter <Data-Tools.html#t:CFilter>`__ s
-  `longitude <#v:longitude>`__ ::
   `StringLike <Data-Tools.html#t:StringLike>`__ s =>
   `CFilter <Data-Tools.html#t:CFilter>`__ s
-  `latitude <#v:latitude>`__ ::
   `StringLike <Data-Tools.html#t:StringLike>`__ s =>
   `CFilter <Data-Tools.html#t:CFilter>`__ s
-  `strength <#v:strength>`__ :: Functor m => (a, m b) -> m (a, b)
-  `zipKeyWith <#v:zipKeyWith>`__ :: Eq k => (k -> a -> b -> c) -> [(k,
   a)] -> [(k, b)] -> [c]
-  `whenM <#v:whenM>`__ :: Monad m => m Bool -> m a -> m ()
-  `encWith <#v:encWith>`__ :: a -> [a] -> [a]
-  `enclose <#v:enclose>`__ :: [a] -> [a] -> [a]
-  `join <#v:join>`__ :: [a] -> [[a]] -> [a]
-  `alternate <#v:alternate>`__ :: [a] -> [a] -> [a]
-  `lfilter <#v:lfilter>`__ :: Eq k => [k] -> [(k, v)] -> [(k, v)]
-  `lnub <#v:lnub>`__ :: Eq k => [(k, v)] -> [(k, v)]
-  `ladd <#v:ladd>`__ :: Eq k => [(k, v)] -> [(k, v)] -> [(k, v)]
-  `sallowed <#v:sallowed>`__ :: (Hashable k, Eq k) => [k] -> HashMap k
   v -> HashMap k v
-  `smust <#v:smust>`__ :: (Show k, MonadCatchIO m, Eq k) => [k] ->
   HashMap k v -> m ()
-  `scheck <#v:scheck>`__ :: (Show k, Hashable k, Eq k, MonadCatchIO m)
   => [k] -> HashMap k v -> m (HashMap k v)
-  `assert <#v:assert>`__ :: (Error e, MonadError e m) => Bool -> String
   -> m ()
-  `randomPick <#v:randomPick>`__ :: [a] -> IO a
-  `randomPick' <#v:randomPick-39->`__ :: [a] -> IO (a, [a])
-  `showTable <#v:showTable>`__ :: Show a => [[a]] -> String
-  `showTable' <#v:showTable-39->`__ :: [[String]] -> String
-  `showTableWithHeader <#v:showTableWithHeader>`__ :: (Show a, Show b)
   => [a] -> [[b]] -> String
-  `showTableWithHeader' <#v:showTableWithHeader-39->`__ :: [String] ->
   [[String]] -> String
-  `renderTable <#v:renderTable>`__ :: [[Box]] -> String

Documentation
=============

data CheckException

CheckException signals a problem with user data verification

Constructors

+---------------------------+-----+
| CE [(String, [String])]   |     |
+---------------------------+-----+
| CF String                 |     |
+---------------------------+-----+

Instances

+-------------------------------------------------------------------+-----+
| Show `CheckException <Data-Tools.html#t:CheckException>`__        |     |
+-------------------------------------------------------------------+-----+
| Typeable `CheckException <Data-Tools.html#t:CheckException>`__    |     |
+-------------------------------------------------------------------+-----+
| Exception `CheckException <Data-Tools.html#t:CheckException>`__   |     |
+-------------------------------------------------------------------+-----+

newtype CFilter v

A CFilter is a composable (by monoidic) user data verifier.

Constructors

CFilter

 

Fields

runCFilter :: v -> Maybe [String]
     

Instances

Monoid (`CFilter <Data-Tools.html#t:CFilter>`__ v)

Monoid instance for CFilter, to allow composable filters. \| mappend is
andcf, both filters must pass

mkCFilter :: (v -> Bool) -> String ->
`CFilter <Data-Tools.html#t:CFilter>`__ v

Create a new filter with a error message

cfmap :: (v' -> v) -> `CFilter <Data-Tools.html#t:CFilter>`__ v ->
`CFilter <Data-Tools.html#t:CFilter>`__ v'

Map the input type of the CFilter

must :: (MonadCatchIO m, Eq k) => [(k, v)] -> [k] -> m ()

A list must have certain keys

cfilter :: (`StringLike <Data-Tools.html#t:StringLike>`__ v, Eq k,
`StringLike <Data-Tools.html#t:StringLike>`__ k, MonadCatchIO m) => [(k,
v)] -> [(k, `CFilter <Data-Tools.html#t:CFilter>`__ v)] -> m ()

Non pure version of cfilterPure, throws CheckException

scfilter :: (Show k, Show v,
`StringLike <Data-Tools.html#t:StringLike>`__ v, Eq k,
`StringLike <Data-Tools.html#t:StringLike>`__ k, MonadCatchIO m) =>
HashMap k v -> [(k, `CFilter <Data-Tools.html#t:CFilter>`__ v)] -> m ()

andcf :: `CFilter <Data-Tools.html#t:CFilter>`__ v ->
`CFilter <Data-Tools.html#t:CFilter>`__ v ->
`CFilter <Data-Tools.html#t:CFilter>`__ v

andcf composes two CFilters. Both should pass

orcf :: `CFilter <Data-Tools.html#t:CFilter>`__ v ->
`CFilter <Data-Tools.html#t:CFilter>`__ v ->
`CFilter <Data-Tools.html#t:CFilter>`__ v

orcf composes two CFilters. At least one should pass

cfilterPure :: Eq k => [(k, v)] -> [(k,
`CFilter <Data-Tools.html#t:CFilter>`__ v)] -> [(k, [String])]

Evaluate a list to a list of key-error string pairs specified by the
provided CFilters

class IsString s => StringLike s where

Many types are isomorph to Strings

Methods

toString :: s -> String

readS :: Read a => s -> Maybe a

Instances

+----------------------------------------------------------------------------------------------------+-----+
| `StringLike <Data-Tools.html#t:StringLike>`__ String                                               |     |
+----------------------------------------------------------------------------------------------------+-----+
| `StringLike <Data-Tools.html#t:StringLike>`__ `SqlValue <Data-SqlTransaction.html#t:SqlValue>`__   |     |
+----------------------------------------------------------------------------------------------------+-----+
| `StringLike <Data-Tools.html#t:StringLike>`__ ByteString                                           |     |
+----------------------------------------------------------------------------------------------------+-----+
| `StringLike <Data-Tools.html#t:StringLike>`__ ByteString                                           |     |
+----------------------------------------------------------------------------------------------------+-----+
| `StringLike <Data-Tools.html#t:StringLike>`__ Text                                                 |     |
+----------------------------------------------------------------------------------------------------+-----+
| `StringLike <Data-Tools.html#t:StringLike>`__ `InRule <Data-InRules.html#t:InRule>`__              |     |
+----------------------------------------------------------------------------------------------------+-----+

mkCRegex :: `StringLike <Data-Tools.html#t:StringLike>`__ s => String ->
String -> `CFilter <Data-Tools.html#t:CFilter>`__ s

Create a CFilter from a regex. First is the regex. Second is the error
message.

minl :: `StringLike <Data-Tools.html#t:StringLike>`__ s => Int ->
`CFilter <Data-Tools.html#t:CFilter>`__ s

An empty CFilter

maxl :: `StringLike <Data-Tools.html#t:StringLike>`__ s => Int ->
`CFilter <Data-Tools.html#t:CFilter>`__ s

An empty CFilter

email :: `StringLike <Data-Tools.html#t:StringLike>`__ s =>
`CFilter <Data-Tools.html#t:CFilter>`__ s

An email CFilter

isNumber :: `StringLike <Data-Tools.html#t:StringLike>`__ s =>
`CFilter <Data-Tools.html#t:CFilter>`__ s

A number format CFilter (Double)

natural :: `StringLike <Data-Tools.html#t:StringLike>`__ s =>
`CFilter <Data-Tools.html#t:CFilter>`__ s

A integer format CFilter (i > 0)

between :: `StringLike <Data-Tools.html#t:StringLike>`__ s => (Double,
Double) -> `CFilter <Data-Tools.html#t:CFilter>`__ s

A number format CFilter. Test if value is between the borders.

longitude :: `StringLike <Data-Tools.html#t:StringLike>`__ s =>
`CFilter <Data-Tools.html#t:CFilter>`__ s

Check if the number is a valid longitude (-180, 180)

latitude :: `StringLike <Data-Tools.html#t:StringLike>`__ s =>
`CFilter <Data-Tools.html#t:CFilter>`__ s

Check if the number is a valid latitude (-90,90)

strength :: Functor m => (a, m b) -> m (a, b)

Haskell functors are strong functors. \| Strong functors have the
following property:

zipKeyWith :: Eq k => (k -> a -> b -> c) -> [(k, a)] -> [(k, b)] -> [c]

ZipKeyWith zips two key-value lists together with a helper function if
the keys matches

whenM :: Monad m => m Bool -> m a -> m ()

encWith :: a -> [a] -> [a]

enclose :: [a] -> [a] -> [a]

join :: [a] -> [[a]] -> [a]

alternate :: [a] -> [a] -> [a]

lfilter :: Eq k => [k] -> [(k, v)] -> [(k, v)]

lnub :: Eq k => [(k, v)] -> [(k, v)]

ladd :: Eq k => [(k, v)] -> [(k, v)] -> [(k, v)]

sallowed :: (Hashable k, Eq k) => [k] -> HashMap k v -> HashMap k v

smust :: (Show k, MonadCatchIO m, Eq k) => [k] -> HashMap k v -> m ()

scheck :: (Show k, Hashable k, Eq k, MonadCatchIO m) => [k] -> HashMap k
v -> m (HashMap k v)

assert :: (Error e, MonadError e m) => Bool -> String -> m ()

randomPick :: [a] -> IO a

randomPick' :: [a] -> IO (a, [a])

showTable :: Show a => [[a]] -> String

showTable' :: [[String]] -> String

showTableWithHeader :: (Show a, Show b) => [a] -> [[b]] -> String

showTableWithHeader' :: [String] -> [[String]] -> String

renderTable :: [[Box]] -> String

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
