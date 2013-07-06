% Lua.Monad
% 
% 

-   [Contents](index.html)
-   [Index](doc-index.html)

 

Safe Haskell

None

Lua.Monad

Synopsis

-   [runLua](#v:runLua) :: [LuaMonad](Lua-Monad.html#t:LuaMonad) a -\>
    IO (Either String a)
-   [runLuaMonad](#v:runLuaMonad) ::
    [LuaState](Lua-Prim.html#t:LuaState) -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad) a -\> IO (Either String a)
-   [runLuaMonad'](#v:runLuaMonad-39-) ::
    [LuaState](Lua-Prim.html#t:LuaState) -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad) a -\> IO (Either String a)
-   [loadLib](#v:loadLib) :: FilePath -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad) ()
-   [eval](#v:eval) :: String -\> [LuaMonad](Lua-Monad.html#t:LuaMonad)
    Int
-   data [LuaValue](#t:LuaValue)
    -   = [LuaObj](#v:LuaObj) [([LuaValue](Lua-Monad.html#t:LuaValue),
        [LuaValue](Lua-Monad.html#t:LuaValue))]
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
-   [registerhsfunction](#v:registerhsfunction) :: LuaImport a =\>
    String -\> a -\> [LuaMonad](Lua-Monad.html#t:LuaMonad) ()
-   [loadLuaValue](#v:loadLuaValue) :: String -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad) (Maybe
    [LuaValue](Lua-Monad.html#t:LuaValue))
-   [saveLuaValue](#v:saveLuaValue) :: String -\>
    [LuaValue](Lua-Monad.html#t:LuaValue) -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad) ()
-   [getValue](#v:getValue) :: StackValue a =\> String -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad) a
-   [getInt](#v:getInt) :: String -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad) Int
-   [getString](#v:getString) :: String -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad) String
-   [getBool](#v:getBool) :: String -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad) Bool
-   [getLuaValue](#v:getLuaValue) :: String -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad)
    [LuaValue](Lua-Monad.html#t:LuaValue)
-   [getDouble](#v:getDouble) :: String -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad) Double
-   [getType](#v:getType) :: String -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad)
    [LuaType](Lua-Prim.html#t:LuaType)
-   [valToLua](#v:valToLua) :: String -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad)
    [LuaValue](Lua-Monad.html#t:LuaValue)
-   [tableToLua](#v:tableToLua) :: String -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad)
    [LuaValue](Lua-Monad.html#t:LuaValue)
-   [pushLuaValue](#v:pushLuaValue) ::
    [LuaValue](Lua-Monad.html#t:LuaValue) -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad) ()
-   [loadIntoTable](#v:loadIntoTable) :: LuaState -\>
    ([LuaValue](Lua-Monad.html#t:LuaValue),
    [LuaValue](Lua-Monad.html#t:LuaValue)) -\> IO ()
-   [push](#v:push) :: StackValue a =\> a -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad) ()
-   [peek](#v:peek) :: StackValue a =\> Int -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad) a
-   [pop](#v:pop) :: Int -\> [LuaMonad](Lua-Monad.html#t:LuaMonad) ()
-   [loadfile](#v:loadfile) :: String -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad) Int
-   [call](#v:call) :: Int -\> Int -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad) Int
-   [tostring](#v:tostring) :: Int -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad) String
-   [pushnil](#v:pushnil) :: [LuaMonad](Lua-Monad.html#t:LuaMonad) ()
-   [ltype](#v:ltype) :: Int -\> [LuaMonad](Lua-Monad.html#t:LuaMonad)
    [LuaType](Lua-Prim.html#t:LuaType)
-   [getglobal](#v:getglobal) :: String -\>
    [LuaMonad](Lua-Monad.html#t:LuaMonad) ()
-   [next](#v:next) :: Int -\> [LuaMonad](Lua-Monad.html#t:LuaMonad)
    Bool
-   [newstate](#v:newstate) :: IO LuaState

Documentation
=============

runLua :: [LuaMonad](Lua-Monad.html#t:LuaMonad) a -\> IO (Either String
a)

Evaluate a Lua monad in the IO monad

runLuaMonad :: [LuaState](Lua-Prim.html#t:LuaState) -\>
[LuaMonad](Lua-Monad.html#t:LuaMonad) a -\> IO (Either String a)

Run the lua monad with closing the state

runLuaMonad' :: [LuaState](Lua-Prim.html#t:LuaState) -\>
[LuaMonad](Lua-Monad.html#t:LuaMonad) a -\> IO (Either String a)

Run the Lua monad without closing the state

loadLib :: FilePath -\> [LuaMonad](Lua-Monad.html#t:LuaMonad) ()

Load a library into the interpreter

eval :: String -\> [LuaMonad](Lua-Monad.html#t:LuaMonad) Int

Evaluate some lua code

data LuaValue

Constructors

  ----------------------------------------------------------------------------------------- ---
  LuaObj [([LuaValue](Lua-Monad.html#t:LuaValue), [LuaValue](Lua-Monad.html#t:LuaValue))]    
  LuaNum !Double                                                                             
  LuaString !String                                                                          
  LuaBool !Bool                                                                              
  LuaNil                                                                                     
  LuaNone                                                                                    
  LuaError !String                                                                           
  ----------------------------------------------------------------------------------------- ---

Instances

  --------------------------------------------------------------------------------------------------------------------------------------- ---
  Eq [LuaValue](Lua-Monad.html#t:LuaValue)                                                                                                 
  Data [LuaValue](Lua-Monad.html#t:LuaValue)                                                                                               
  Num [LuaValue](Lua-Monad.html#t:LuaValue)                                                                                                
  Ord [LuaValue](Lua-Monad.html#t:LuaValue)                                                                                                
  Read [LuaValue](Lua-Monad.html#t:LuaValue)                                                                                               
  Show [LuaValue](Lua-Monad.html#t:LuaValue)                                                                                               
  Typeable [LuaValue](Lua-Monad.html#t:LuaValue)                                                                                           
  IsString [LuaValue](Lua-Monad.html#t:LuaValue)                                                                                           
  StackValue [LuaValue](Lua-Monad.html#t:LuaValue)                                                                                         
  Convertible Double [LuaValue](Lua-Monad.html#t:LuaValue)                                                                                 
  Convertible Integer [LuaValue](Lua-Monad.html#t:LuaValue)                                                                                
  Convertible Rational [LuaValue](Lua-Monad.html#t:LuaValue)                                                                               
  Convertible String [LuaValue](Lua-Monad.html#t:LuaValue)                                                                                 
  Convertible [LuaValue](Lua-Monad.html#t:LuaValue) Double                                                                                 
  Convertible [LuaValue](Lua-Monad.html#t:LuaValue) Integer                                                                                
  Convertible [LuaValue](Lua-Monad.html#t:LuaValue) Rational                                                                               
  Convertible [LuaValue](Lua-Monad.html#t:LuaValue) String                                                                                 
  Convertible [LuaValue](Lua-Monad.html#t:LuaValue) [LuaValue](Lua-Monad.html#t:LuaValue)                                                  
  (Typeable a, Convertible [LuaValue](Lua-Monad.html#t:LuaValue) a) =\> Convertible [LuaValue](Lua-Monad.html#t:LuaValue) [(String, a)]    
  (Typeable a, Convertible a [LuaValue](Lua-Monad.html#t:LuaValue)) =\> Convertible [(String, a)] [LuaValue](Lua-Monad.html#t:LuaValue)    
  --------------------------------------------------------------------------------------------------------------------------------------- ---

newtype LuaMonad a

The lua monad keeps the current LuaState and offers error handling
through `ErrorT`. It also has access to the IO Monad

Constructors

LR

 

Fields

unLR :: ReaderT [LuaState](Lua-Prim.html#t:LuaState) (ErrorT String IO) a
:    

Instances

  ---------------------------------------------------------------------------------------- ---
  Monad [LuaMonad](Lua-Monad.html#t:LuaMonad)                                               
  Functor [LuaMonad](Lua-Monad.html#t:LuaMonad)                                             
  Applicative [LuaMonad](Lua-Monad.html#t:LuaMonad)                                         
  MonadIO [LuaMonad](Lua-Monad.html#t:LuaMonad)                                             
  MonadReader [LuaState](Lua-Prim.html#t:LuaState) [LuaMonad](Lua-Monad.html#t:LuaMonad)    
  MonadError String [LuaMonad](Lua-Monad.html#t:LuaMonad)                                   
  ---------------------------------------------------------------------------------------- ---

registerhsfunction :: LuaImport a =\> String -\> a -\>
[LuaMonad](Lua-Monad.html#t:LuaMonad) ()

Register a haskell function in lua

loadLuaValue :: String -\> [LuaMonad](Lua-Monad.html#t:LuaMonad) (Maybe
[LuaValue](Lua-Monad.html#t:LuaValue))

Get global variable value

saveLuaValue :: String -\> [LuaValue](Lua-Monad.html#t:LuaValue) -\>
[LuaMonad](Lua-Monad.html#t:LuaMonad) ()

Save global variable value

getValue :: StackValue a =\> String -\>
[LuaMonad](Lua-Monad.html#t:LuaMonad) a

Get the haskell value by name and pop it of the stack, omit type

getInt :: String -\> [LuaMonad](Lua-Monad.html#t:LuaMonad) Int

Get the int by name and pop it of the stack, omit type

getString :: String -\> [LuaMonad](Lua-Monad.html#t:LuaMonad) String

Get the string by name and pop it of the stack, omit type

getBool :: String -\> [LuaMonad](Lua-Monad.html#t:LuaMonad) Bool

Get the boolean by name and pop it of the stack, omit type

getLuaValue :: String -\> [LuaMonad](Lua-Monad.html#t:LuaMonad)
[LuaValue](Lua-Monad.html#t:LuaValue)

Get a global value by name

getDouble :: String -\> [LuaMonad](Lua-Monad.html#t:LuaMonad) Double

Get the double by name and pop it of the stack, omit type

getType :: String -\> [LuaMonad](Lua-Monad.html#t:LuaMonad)
[LuaType](Lua-Prim.html#t:LuaType)

Get the type of a variable by name

valToLua :: String -\> [LuaMonad](Lua-Monad.html#t:LuaMonad)
[LuaValue](Lua-Monad.html#t:LuaValue)

Retrieve a value from the stack by name

tableToLua :: String -\> [LuaMonad](Lua-Monad.html#t:LuaMonad)
[LuaValue](Lua-Monad.html#t:LuaValue)

Retrieve a table by name from the stack

pushLuaValue :: [LuaValue](Lua-Monad.html#t:LuaValue) -\>
[LuaMonad](Lua-Monad.html#t:LuaMonad) ()

Push value on stack

loadIntoTable :: LuaState -\> ([LuaValue](Lua-Monad.html#t:LuaValue),
[LuaValue](Lua-Monad.html#t:LuaValue)) -\> IO ()

Load a key value pair into a table

push :: StackValue a =\> a -\> [LuaMonad](Lua-Monad.html#t:LuaMonad) ()

Push a value on the stack

peek :: StackValue a =\> Int -\> [LuaMonad](Lua-Monad.html#t:LuaMonad) a

Peek nth item of the stack

pop :: Int -\> [LuaMonad](Lua-Monad.html#t:LuaMonad) ()

Pop nth item of the stack

loadfile :: String -\> [LuaMonad](Lua-Monad.html#t:LuaMonad) Int

Load a file into lua

call :: Int -\> Int -\> [LuaMonad](Lua-Monad.html#t:LuaMonad) Int

call a function

tostring :: Int -\> [LuaMonad](Lua-Monad.html#t:LuaMonad) String

Convert to string

pushnil :: [LuaMonad](Lua-Monad.html#t:LuaMonad) ()

Push nil on the stack

ltype :: Int -\> [LuaMonad](Lua-Monad.html#t:LuaMonad)
[LuaType](Lua-Prim.html#t:LuaType)

Get the type of the value on the stack

getglobal :: String -\> [LuaMonad](Lua-Monad.html#t:LuaMonad) ()

Retrieve a global by name

next :: Int -\> [LuaMonad](Lua-Monad.html#t:LuaMonad) Bool

newstate :: IO LuaState

Create a new state

Produced by [Haddock](http://www.haskell.org/haddock/) version 2.11.0
