% Data.Tools
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Data.Tools

Synopsis

-   data [CheckException](#t:CheckException)
    -   = [CE](#v:CE) [(String, [String])]
    -   | [CF](#v:CF) String

-   newtype [CFilter](#t:CFilter) v = [CFilter](#v:CFilter) {
    -   [runCFilter](#v:runCFilter) :: v -\> Maybe [String]

    }
-   [mkCFilter](#v:mkCFilter) :: (v -\> Bool) -\> String -\>
    [CFilter](Data-Tools.html#t:CFilter) v
-   [cfmap](#v:cfmap) :: (v' -\> v) -\>
    [CFilter](Data-Tools.html#t:CFilter) v -\>
    [CFilter](Data-Tools.html#t:CFilter) v'
-   [must](#v:must) :: (MonadCatchIO m, Eq k) =\> [(k, v)] -\> [k] -\> m
    ()
-   [cfilter](#v:cfilter) :: ([StringLike](Data-Tools.html#t:StringLike)
    v, Eq k, [StringLike](Data-Tools.html#t:StringLike) k, MonadCatchIO
    m) =\> [(k, v)] -\> [(k, [CFilter](Data-Tools.html#t:CFilter) v)]
    -\> m ()
-   [scfilter](#v:scfilter) :: (Show k, Show v,
    [StringLike](Data-Tools.html#t:StringLike) v, Eq k,
    [StringLike](Data-Tools.html#t:StringLike) k, MonadCatchIO m) =\>
    HashMap k v -\> [(k, [CFilter](Data-Tools.html#t:CFilter) v)] -\> m
    ()
-   [andcf](#v:andcf) :: [CFilter](Data-Tools.html#t:CFilter) v -\>
    [CFilter](Data-Tools.html#t:CFilter) v -\>
    [CFilter](Data-Tools.html#t:CFilter) v
-   [orcf](#v:orcf) :: [CFilter](Data-Tools.html#t:CFilter) v -\>
    [CFilter](Data-Tools.html#t:CFilter) v -\>
    [CFilter](Data-Tools.html#t:CFilter) v
-   [cfilterPure](#v:cfilterPure) :: Eq k =\> [(k, v)] -\> [(k,
    [CFilter](Data-Tools.html#t:CFilter) v)] -\> [(k, [String])]
-   class IsString s =\> [StringLike](#t:StringLike) s where
    -   [toString](#v:toString) :: s -\> String
    -   [readS](#v:readS) :: Read a =\> s -\> Maybe a

-   [mkCRegex](#v:mkCRegex) ::
    [StringLike](Data-Tools.html#t:StringLike) s =\> String -\> String
    -\> [CFilter](Data-Tools.html#t:CFilter) s
-   [minl](#v:minl) :: [StringLike](Data-Tools.html#t:StringLike) s =\>
    Int -\> [CFilter](Data-Tools.html#t:CFilter) s
-   [maxl](#v:maxl) :: [StringLike](Data-Tools.html#t:StringLike) s =\>
    Int -\> [CFilter](Data-Tools.html#t:CFilter) s
-   [email](#v:email) :: [StringLike](Data-Tools.html#t:StringLike) s
    =\> [CFilter](Data-Tools.html#t:CFilter) s
-   [isNumber](#v:isNumber) ::
    [StringLike](Data-Tools.html#t:StringLike) s =\>
    [CFilter](Data-Tools.html#t:CFilter) s
-   [natural](#v:natural) :: [StringLike](Data-Tools.html#t:StringLike)
    s =\> [CFilter](Data-Tools.html#t:CFilter) s
-   [between](#v:between) :: [StringLike](Data-Tools.html#t:StringLike)
    s =\> (Double, Double) -\> [CFilter](Data-Tools.html#t:CFilter) s
-   [longitude](#v:longitude) ::
    [StringLike](Data-Tools.html#t:StringLike) s =\>
    [CFilter](Data-Tools.html#t:CFilter) s
-   [latitude](#v:latitude) ::
    [StringLike](Data-Tools.html#t:StringLike) s =\>
    [CFilter](Data-Tools.html#t:CFilter) s
-   [strength](#v:strength) :: Functor m =\> (a, m b) -\> m (a, b)
-   [zipKeyWith](#v:zipKeyWith) :: Eq k =\> (k -\> a -\> b -\> c) -\>
    [(k, a)] -\> [(k, b)] -\> [c]
-   [whenM](#v:whenM) :: Monad m =\> m Bool -\> m a -\> m ()
-   [encWith](#v:encWith) :: a -\> [a] -\> [a]
-   [enclose](#v:enclose) :: [a] -\> [a] -\> [a]
-   [join](#v:join) :: [a] -\> [[a]] -\> [a]
-   [alternate](#v:alternate) :: [a] -\> [a] -\> [a]
-   [lfilter](#v:lfilter) :: Eq k =\> [k] -\> [(k, v)] -\> [(k, v)]
-   [lnub](#v:lnub) :: Eq k =\> [(k, v)] -\> [(k, v)]
-   [ladd](#v:ladd) :: Eq k =\> [(k, v)] -\> [(k, v)] -\> [(k, v)]
-   [sallowed](#v:sallowed) :: (Hashable k, Eq k) =\> [k] -\> HashMap k
    v -\> HashMap k v
-   [smust](#v:smust) :: (Show k, MonadCatchIO m, Eq k) =\> [k] -\>
    HashMap k v -\> m ()
-   [scheck](#v:scheck) :: (Show k, Hashable k, Eq k, MonadCatchIO m)
    =\> [k] -\> HashMap k v -\> m (HashMap k v)
-   [assert](#v:assert) :: (Error e, MonadError e m) =\> Bool -\> String
    -\> m ()
-   [randomPick](#v:randomPick) :: [a] -\> IO a
-   [randomPick'](#v:randomPick-39-) :: [a] -\> IO (a, [a])
-   [showTable](#v:showTable) :: Show a =\> [[a]] -\> String
-   [showTable'](#v:showTable-39-) :: [[String]] -\> String
-   [showTableWithHeader](#v:showTableWithHeader) :: (Show a, Show b)
    =\> [a] -\> [[b]] -\> String
-   [showTableWithHeader'](#v:showTableWithHeader-39-) :: [String] -\>
    [[String]] -\> String
-   [renderTable](#v:renderTable) :: [[Box]] -\> String

Documentation
=============

data CheckException

CheckException signals a problem with user data verification

Constructors

  ------------------------- ---
  CE [(String, [String])]    
  CF String                  
  ------------------------- ---

Instances

  -------------------------------------------------------------- ---
  Show [CheckException](Data-Tools.html#t:CheckException)         
  Typeable [CheckException](Data-Tools.html#t:CheckException)     
  Exception [CheckException](Data-Tools.html#t:CheckException)    
  -------------------------------------------------------------- ---

newtype CFilter v

A CFilter is a composable (by monoidic) user data verifier.

Constructors

CFilter

 

Fields

runCFilter :: v -\> Maybe [String]
:    

Instances

Monoid ([CFilter](Data-Tools.html#t:CFilter) v)

Monoid instance for CFilter, to allow composable filters. | mappend is
andcf, both filters must pass

mkCFilter :: (v -\> Bool) -\> String -\>
[CFilter](Data-Tools.html#t:CFilter) v

Create a new filter with a error message

cfmap :: (v' -\> v) -\> [CFilter](Data-Tools.html#t:CFilter) v -\>
[CFilter](Data-Tools.html#t:CFilter) v'

Map the input type of the CFilter

must :: (MonadCatchIO m, Eq k) =\> [(k, v)] -\> [k] -\> m ()

A list must have certain keys

cfilter :: ([StringLike](Data-Tools.html#t:StringLike) v, Eq k,
[StringLike](Data-Tools.html#t:StringLike) k, MonadCatchIO m) =\> [(k,
v)] -\> [(k, [CFilter](Data-Tools.html#t:CFilter) v)] -\> m ()

Non pure version of cfilterPure, throws CheckException

scfilter :: (Show k, Show v, [StringLike](Data-Tools.html#t:StringLike)
v, Eq k, [StringLike](Data-Tools.html#t:StringLike) k, MonadCatchIO m)
=\> HashMap k v -\> [(k, [CFilter](Data-Tools.html#t:CFilter) v)] -\> m
()

andcf :: [CFilter](Data-Tools.html#t:CFilter) v -\>
[CFilter](Data-Tools.html#t:CFilter) v -\>
[CFilter](Data-Tools.html#t:CFilter) v

andcf composes two CFilters. Both should pass

orcf :: [CFilter](Data-Tools.html#t:CFilter) v -\>
[CFilter](Data-Tools.html#t:CFilter) v -\>
[CFilter](Data-Tools.html#t:CFilter) v

orcf composes two CFilters. At least one should pass

cfilterPure :: Eq k =\> [(k, v)] -\> [(k,
[CFilter](Data-Tools.html#t:CFilter) v)] -\> [(k, [String])]

Evaluate a list to a list of key-error string pairs specified by the
provided CFilters

class IsString s =\> StringLike s where

Many types are isomorph to Strings

Methods

toString :: s -\> String

readS :: Read a =\> s -\> Maybe a

Instances

  -------------------------------------------------------------------------------------------- ---
  [StringLike](Data-Tools.html#t:StringLike) String                                             
  [StringLike](Data-Tools.html#t:StringLike) ByteString                                         
  [StringLike](Data-Tools.html#t:StringLike) Text                                               
  [StringLike](Data-Tools.html#t:StringLike) ByteString                                         
  [StringLike](Data-Tools.html#t:StringLike) [SqlValue](Data-SqlTransaction.html#t:SqlValue)    
  [StringLike](Data-Tools.html#t:StringLike) [InRule](Data-InRules.html#t:InRule)               
  -------------------------------------------------------------------------------------------- ---

mkCRegex :: [StringLike](Data-Tools.html#t:StringLike) s =\> String -\>
String -\> [CFilter](Data-Tools.html#t:CFilter) s

Create a CFilter from a regex. First is the regex. Second is the error
message.

minl :: [StringLike](Data-Tools.html#t:StringLike) s =\> Int -\>
[CFilter](Data-Tools.html#t:CFilter) s

An empty CFilter

maxl :: [StringLike](Data-Tools.html#t:StringLike) s =\> Int -\>
[CFilter](Data-Tools.html#t:CFilter) s

An empty CFilter

email :: [StringLike](Data-Tools.html#t:StringLike) s =\>
[CFilter](Data-Tools.html#t:CFilter) s

An email CFilter

isNumber :: [StringLike](Data-Tools.html#t:StringLike) s =\>
[CFilter](Data-Tools.html#t:CFilter) s

A number format CFilter (Double)

natural :: [StringLike](Data-Tools.html#t:StringLike) s =\>
[CFilter](Data-Tools.html#t:CFilter) s

A integer format CFilter (i \> 0)

between :: [StringLike](Data-Tools.html#t:StringLike) s =\> (Double,
Double) -\> [CFilter](Data-Tools.html#t:CFilter) s

A number format CFilter. Test if value is between the borders.

longitude :: [StringLike](Data-Tools.html#t:StringLike) s =\>
[CFilter](Data-Tools.html#t:CFilter) s

Check if the number is a valid longitude (-180, 180)

latitude :: [StringLike](Data-Tools.html#t:StringLike) s =\>
[CFilter](Data-Tools.html#t:CFilter) s

Check if the number is a valid latitude (-90,90)

strength :: Functor m =\> (a, m b) -\> m (a, b)

Haskell functors are strong functors. | Strong functors have the
following property:

zipKeyWith :: Eq k =\> (k -\> a -\> b -\> c) -\> [(k, a)] -\> [(k, b)]
-\> [c]

ZipKeyWith zips two key-value lists together with a helper function if
the keys matches

whenM :: Monad m =\> m Bool -\> m a -\> m ()

encWith :: a -\> [a] -\> [a]

enclose :: [a] -\> [a] -\> [a]

join :: [a] -\> [[a]] -\> [a]

alternate :: [a] -\> [a] -\> [a]

lfilter :: Eq k =\> [k] -\> [(k, v)] -\> [(k, v)]

lnub :: Eq k =\> [(k, v)] -\> [(k, v)]

ladd :: Eq k =\> [(k, v)] -\> [(k, v)] -\> [(k, v)]

sallowed :: (Hashable k, Eq k) =\> [k] -\> HashMap k v -\> HashMap k v

smust :: (Show k, MonadCatchIO m, Eq k) =\> [k] -\> HashMap k v -\> m ()

scheck :: (Show k, Hashable k, Eq k, MonadCatchIO m) =\> [k] -\> HashMap
k v -\> m (HashMap k v)

assert :: (Error e, MonadError e m) =\> Bool -\> String -\> m ()

randomPick :: [a] -\> IO a

randomPick' :: [a] -\> IO (a, [a])

showTable :: Show a =\> [[a]] -\> String

showTable' :: [[String]] -\> String

showTableWithHeader :: (Show a, Show b) =\> [a] -\> [[b]] -\> String

showTableWithHeader' :: [String] -\> [[String]] -\> String

renderTable :: [[Box]] -\> String

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
