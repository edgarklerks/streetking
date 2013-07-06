% Lua.Prim
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Lua.Prim

Synopsis

-   type [LuaState](#t:LuaState) = LuaState
-   type [LuaType](#t:LuaType) = LTYPE
-   data [LuaValue](#t:LuaValue)
    -   = [LuaObj](#v:LuaObj) [([LuaValue](Lua-Prim.html#t:LuaValue),
        [LuaValue](Lua-Prim.html#t:LuaValue))]
    -   | [LuaNum](#v:LuaNum) !Double
    -   | [LuaString](#v:LuaString) !String
    -   | [LuaBool](#v:LuaBool) !Bool
    -   | [LuaNil](#v:LuaNil)
    -   | [LuaNone](#v:LuaNone)
    -   | [LuaError](#v:LuaError) !String

-   newtype [LuaMonad](#t:LuaMonad) a = [LR](#v:LR) {
    -   [unLR](#v:unLR) :: ReaderT [LuaState](Lua-Prim.html#t:LuaState)
        (ErrorT String IO) a

    }
-   [runLuaMonad'](#v:runLuaMonad-39-) ::
    [LuaState](Lua-Prim.html#t:LuaState) -\>
    [LuaMonad](Lua-Prim.html#t:LuaMonad) a -\> IO (Either String a)
-   [loadIntoTable](#v:loadIntoTable) :: LuaState -\>
    ([LuaValue](Lua-Prim.html#t:LuaValue),
    [LuaValue](Lua-Prim.html#t:LuaValue)) -\> IO ()
-   [setTable](#v:setTable) :: LuaState -\>
    [LuaValue](Lua-Prim.html#t:LuaValue) -\>
    [LuaValue](Lua-Prim.html#t:LuaValue) -\> Int -\> IO ()
-   [loopTable](#v:loopTable) :: [LuaMonad](Lua-Prim.html#t:LuaMonad)
    [([LuaValue](Lua-Prim.html#t:LuaValue),
    [LuaValue](Lua-Prim.html#t:LuaValue))]
-   [\_valToLua](#v:_valToLua) :: Int -\>
    [LuaMonad](Lua-Prim.html#t:LuaMonad)
    [LuaValue](Lua-Prim.html#t:LuaValue)
-   [pop](#v:pop) :: Int -\> [LuaMonad](Lua-Prim.html#t:LuaMonad) ()
-   [peek](#v:peek) :: StackValue a =\> Int -\>
    [LuaMonad](Lua-Prim.html#t:LuaMonad) a
-   [ltype](#v:ltype) :: Int -\> [LuaMonad](Lua-Prim.html#t:LuaMonad)
    [LuaType](Lua-Prim.html#t:LuaType)
-   [getglobal](#v:getglobal) :: String -\>
    [LuaMonad](Lua-Prim.html#t:LuaMonad) ()
-   [pushnil](#v:pushnil) :: [LuaMonad](Lua-Prim.html#t:LuaMonad) ()
-   [newstate](#v:newstate) :: IO LuaState
-   [push](#v:push) :: StackValue a =\> a -\>
    [LuaMonad](Lua-Prim.html#t:LuaMonad) ()
-   [catchMaybe](#v:catchMaybe) :: MonadError String m =\> Maybe a -\>
    (a -\> m b) -\> String -\> m b
-   [getLuaValue](#v:getLuaValue) :: String -\>
    [LuaMonad](Lua-Prim.html#t:LuaMonad)
    [LuaValue](Lua-Prim.html#t:LuaValue)
-   [peekGlobal](#v:peekGlobal) :: StackValue a =\> String -\>
    [LuaMonad](Lua-Prim.html#t:LuaMonad) (a,
    [LuaType](Lua-Prim.html#t:LuaType))
-   [getGlobal](#v:getGlobal) :: StackValue a =\> String -\>
    [LuaMonad](Lua-Prim.html#t:LuaMonad) (a,
    [LuaType](Lua-Prim.html#t:LuaType))
-   [getValue](#v:getValue) :: StackValue a =\> String -\>
    [LuaMonad](Lua-Prim.html#t:LuaMonad) a
-   [getInt](#v:getInt) :: String -\>
    [LuaMonad](Lua-Prim.html#t:LuaMonad) Int
-   [getDouble](#v:getDouble) :: String -\>
    [LuaMonad](Lua-Prim.html#t:LuaMonad) Double
-   [getBool](#v:getBool) :: String -\>
    [LuaMonad](Lua-Prim.html#t:LuaMonad) Bool
-   [getString](#v:getString) :: String -\>
    [LuaMonad](Lua-Prim.html#t:LuaMonad) String
-   [getType](#v:getType) :: String -\>
    [LuaMonad](Lua-Prim.html#t:LuaMonad)
    [LuaType](Lua-Prim.html#t:LuaType)
-   [next](#v:next) :: Int -\> [LuaMonad](Lua-Prim.html#t:LuaMonad) Bool
-   [peekLuaValue](#v:peekLuaValue) :: Int -\>
    [LuaMonad](Lua-Prim.html#t:LuaMonad)
    [LuaValue](Lua-Prim.html#t:LuaValue)
-   [valToLua](#v:valToLua) :: String -\>
    [LuaMonad](Lua-Prim.html#t:LuaMonad)
    [LuaValue](Lua-Prim.html#t:LuaValue)
-   [tableToLua](#v:tableToLua) :: String -\>
    [LuaMonad](Lua-Prim.html#t:LuaMonad)
    [LuaValue](Lua-Prim.html#t:LuaValue)

Documentation
=============

type LuaState = LuaState

type LuaType = LTYPE

data LuaValue

Constructors

  --------------------------------------------------------------------------------------- ---
  LuaObj [([LuaValue](Lua-Prim.html#t:LuaValue), [LuaValue](Lua-Prim.html#t:LuaValue))]    
  LuaNum !Double                                                                           
  LuaString !String                                                                        
  LuaBool !Bool                                                                            
  LuaNil                                                                                   
  LuaNone                                                                                  
  LuaError !String                                                                         
  --------------------------------------------------------------------------------------- ---

Instances

  ------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [LuaValue](Lua-Prim.html#t:LuaValue)                                                                                                
  Data [LuaValue](Lua-Prim.html#t:LuaValue)                                                                                              
  Num [LuaValue](Lua-Prim.html#t:LuaValue)                                                                                               
  Ord [LuaValue](Lua-Prim.html#t:LuaValue)                                                                                               
  Read [LuaValue](Lua-Prim.html#t:LuaValue)                                                                                              
  Show [LuaValue](Lua-Prim.html#t:LuaValue)                                                                                              
  Typeable [LuaValue](Lua-Prim.html#t:LuaValue)                                                                                          
  IsString [LuaValue](Lua-Prim.html#t:LuaValue)                                                                                          
  StackValue [LuaValue](Lua-Prim.html#t:LuaValue)                                                                                        
  Convertible Double [LuaValue](Lua-Prim.html#t:LuaValue)                                                                                
  Convertible Integer [LuaValue](Lua-Prim.html#t:LuaValue)                                                                               
  Convertible Rational [LuaValue](Lua-Prim.html#t:LuaValue)                                                                              
  Convertible String [LuaValue](Lua-Prim.html#t:LuaValue)                                                                                
  Convertible [LuaValue](Lua-Prim.html#t:LuaValue) Double                                                                                
  Convertible [LuaValue](Lua-Prim.html#t:LuaValue) Integer                                                                               
  Convertible [LuaValue](Lua-Prim.html#t:LuaValue) Rational                                                                              
  Convertible [LuaValue](Lua-Prim.html#t:LuaValue) String                                                                                
  Convertible [LuaValue](Lua-Prim.html#t:LuaValue) [LuaValue](Lua-Prim.html#t:LuaValue)                                                  
  (Typeable a, Convertible [LuaValue](Lua-Prim.html#t:LuaValue) a) =\> Convertible [LuaValue](Lua-Prim.html#t:LuaValue) [(String, a)]    
  (Typeable a, Convertible a [LuaValue](Lua-Prim.html#t:LuaValue)) =\> Convertible [(String, a)] [LuaValue](Lua-Prim.html#t:LuaValue)    
  ------------------------------------------------------------------------------------------------------------------------------------- ---

newtype LuaMonad a

The lua monad keeps the current LuaState and offers error handling
through `ErrorT`. It also has access to the IO Monad

Constructors

LR

 

Fields

unLR :: ReaderT [LuaState](Lua-Prim.html#t:LuaState) (ErrorT String IO) a
:    

Instances

  --------------------------------------------------------------------------------------- ---
  Monad [LuaMonad](Lua-Prim.html#t:LuaMonad)                                               
  Functor [LuaMonad](Lua-Prim.html#t:LuaMonad)                                             
  Applicative [LuaMonad](Lua-Prim.html#t:LuaMonad)                                         
  MonadIO [LuaMonad](Lua-Prim.html#t:LuaMonad)                                             
  MonadReader [LuaState](Lua-Prim.html#t:LuaState) [LuaMonad](Lua-Prim.html#t:LuaMonad)    
  MonadError String [LuaMonad](Lua-Prim.html#t:LuaMonad)                                   
  --------------------------------------------------------------------------------------- ---

runLuaMonad' :: [LuaState](Lua-Prim.html#t:LuaState) -\>
[LuaMonad](Lua-Prim.html#t:LuaMonad) a -\> IO (Either String a)

Run the Lua monad without closing the state

loadIntoTable :: LuaState -\> ([LuaValue](Lua-Prim.html#t:LuaValue),
[LuaValue](Lua-Prim.html#t:LuaValue)) -\> IO ()

Load a key value pair into a table

setTable :: LuaState -\> [LuaValue](Lua-Prim.html#t:LuaValue) -\>
[LuaValue](Lua-Prim.html#t:LuaValue) -\> Int -\> IO ()

Set a key value to a specific table

loopTable :: [LuaMonad](Lua-Prim.html#t:LuaMonad)
[([LuaValue](Lua-Prim.html#t:LuaValue),
[LuaValue](Lua-Prim.html#t:LuaValue))]

Retrieve the table as key value pairs

\_valToLua :: Int -\> [LuaMonad](Lua-Prim.html#t:LuaMonad)
[LuaValue](Lua-Prim.html#t:LuaValue)

Get some value from the stack

pop :: Int -\> [LuaMonad](Lua-Prim.html#t:LuaMonad) ()

Pop nth item of the stack

peek :: StackValue a =\> Int -\> [LuaMonad](Lua-Prim.html#t:LuaMonad) a

Peek nth item of the stack

ltype :: Int -\> [LuaMonad](Lua-Prim.html#t:LuaMonad)
[LuaType](Lua-Prim.html#t:LuaType)

Get the type of the value on the stack

getglobal :: String -\> [LuaMonad](Lua-Prim.html#t:LuaMonad) ()

Retrieve a global by name

pushnil :: [LuaMonad](Lua-Prim.html#t:LuaMonad) ()

Push nil on the stack

newstate :: IO LuaState

Create a new state

push :: StackValue a =\> a -\> [LuaMonad](Lua-Prim.html#t:LuaMonad) ()

Push a value on the stack

catchMaybe :: MonadError String m =\> Maybe a -\> (a -\> m b) -\> String
-\> m b

getLuaValue :: String -\> [LuaMonad](Lua-Prim.html#t:LuaMonad)
[LuaValue](Lua-Prim.html#t:LuaValue)

Get a global value by name

peekGlobal :: StackValue a =\> String -\>
[LuaMonad](Lua-Prim.html#t:LuaMonad) (a,
[LuaType](Lua-Prim.html#t:LuaType))

Get a global value by name as haskell type, keep it on the top of the
stack

getGlobal :: StackValue a =\> String -\>
[LuaMonad](Lua-Prim.html#t:LuaMonad) (a,
[LuaType](Lua-Prim.html#t:LuaType))

Get a global by name and pop it from the stack

getValue :: StackValue a =\> String -\>
[LuaMonad](Lua-Prim.html#t:LuaMonad) a

Get the haskell value by name and pop it of the stack, omit type

getInt :: String -\> [LuaMonad](Lua-Prim.html#t:LuaMonad) Int

Get the int by name and pop it of the stack, omit type

getDouble :: String -\> [LuaMonad](Lua-Prim.html#t:LuaMonad) Double

Get the double by name and pop it of the stack, omit type

getBool :: String -\> [LuaMonad](Lua-Prim.html#t:LuaMonad) Bool

Get the boolean by name and pop it of the stack, omit type

getString :: String -\> [LuaMonad](Lua-Prim.html#t:LuaMonad) String

Get the string by name and pop it of the stack, omit type

getType :: String -\> [LuaMonad](Lua-Prim.html#t:LuaMonad)
[LuaType](Lua-Prim.html#t:LuaType)

Get the type of a variable by name

next :: Int -\> [LuaMonad](Lua-Prim.html#t:LuaMonad) Bool

peekLuaValue :: Int -\> [LuaMonad](Lua-Prim.html#t:LuaMonad)
[LuaValue](Lua-Prim.html#t:LuaValue)

Peek what value is at the nth place of the stack

valToLua :: String -\> [LuaMonad](Lua-Prim.html#t:LuaMonad)
[LuaValue](Lua-Prim.html#t:LuaValue)

Retrieve a value from the stack by name

tableToLua :: String -\> [LuaMonad](Lua-Prim.html#t:LuaMonad)
[LuaValue](Lua-Prim.html#t:LuaValue)

Retrieve a table by name from the stack

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
