=========
Lua.Monad
=========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Lua.Monad

Synopsis

-  `runLua <#v:runLua>`__ :: `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ a
   -> IO (Either String a)
-  `runLuaMonad <#v:runLuaMonad>`__ ::
   `LuaState <Lua-Prim.html#t:LuaState>`__ ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ a -> IO (Either String a)
-  `runLuaMonad' <#v:runLuaMonad-39->`__ ::
   `LuaState <Lua-Prim.html#t:LuaState>`__ ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ a -> IO (Either String a)
-  `loadLib <#v:loadLib>`__ :: FilePath ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ ()
-  `eval <#v:eval>`__ :: String ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ Int
-  data `LuaValue <#t:LuaValue>`__

   -  = `LuaObj <#v:LuaObj>`__
      [(`LuaValue <Lua-Monad.html#t:LuaValue>`__,
      `LuaValue <Lua-Monad.html#t:LuaValue>`__)]
   -  \| `LuaNum <#v:LuaNum>`__ !Double
   -  \| `LuaString <#v:LuaString>`__ !String
   -  \| `LuaBool <#v:LuaBool>`__ !Bool
   -  \| `LuaNil <#v:LuaNil>`__
   -  \| `LuaNone <#v:LuaNone>`__
   -  \| `LuaError <#v:LuaError>`__ !String

-  newtype `LuaMonad <#t:LuaMonad>`__ a = `LR <#v:LR>`__ {

   -  `unLR <#v:unLR>`__ :: ReaderT
      `LuaState <Lua-Prim.html#t:LuaState>`__ (ErrorT String IO) a

   }
-  `registerhsfunction <#v:registerhsfunction>`__ :: LuaImport a =>
   String -> a -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ ()
-  `loadLuaValue <#v:loadLuaValue>`__ :: String ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ (Maybe
   `LuaValue <Lua-Monad.html#t:LuaValue>`__)
-  `saveLuaValue <#v:saveLuaValue>`__ :: String ->
   `LuaValue <Lua-Monad.html#t:LuaValue>`__ ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ ()
-  `getValue <#v:getValue>`__ :: StackValue a => String ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ a
-  `getInt <#v:getInt>`__ :: String ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ Int
-  `getString <#v:getString>`__ :: String ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ String
-  `getBool <#v:getBool>`__ :: String ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ Bool
-  `getLuaValue <#v:getLuaValue>`__ :: String ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__
   `LuaValue <Lua-Monad.html#t:LuaValue>`__
-  `getDouble <#v:getDouble>`__ :: String ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ Double
-  `getType <#v:getType>`__ :: String ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__
   `LuaType <Lua-Prim.html#t:LuaType>`__
-  `valToLua <#v:valToLua>`__ :: String ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__
   `LuaValue <Lua-Monad.html#t:LuaValue>`__
-  `tableToLua <#v:tableToLua>`__ :: String ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__
   `LuaValue <Lua-Monad.html#t:LuaValue>`__
-  `pushLuaValue <#v:pushLuaValue>`__ ::
   `LuaValue <Lua-Monad.html#t:LuaValue>`__ ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ ()
-  `loadIntoTable <#v:loadIntoTable>`__ :: LuaState ->
   (`LuaValue <Lua-Monad.html#t:LuaValue>`__,
   `LuaValue <Lua-Monad.html#t:LuaValue>`__) -> IO ()
-  `push <#v:push>`__ :: StackValue a => a ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ ()
-  `peek <#v:peek>`__ :: StackValue a => Int ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ a
-  `pop <#v:pop>`__ :: Int -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__
   ()
-  `loadfile <#v:loadfile>`__ :: String ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ Int
-  `call <#v:call>`__ :: Int -> Int ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ Int
-  `tostring <#v:tostring>`__ :: Int ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ String
-  `pushnil <#v:pushnil>`__ :: `LuaMonad <Lua-Monad.html#t:LuaMonad>`__
   ()
-  `ltype <#v:ltype>`__ :: Int ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__
   `LuaType <Lua-Prim.html#t:LuaType>`__
-  `getglobal <#v:getglobal>`__ :: String ->
   `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ ()
-  `next <#v:next>`__ :: Int -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__
   Bool
-  `newstate <#v:newstate>`__ :: IO LuaState

Documentation
=============

runLua :: `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ a -> IO (Either
String a)

Evaluate a Lua monad in the IO monad

runLuaMonad :: `LuaState <Lua-Prim.html#t:LuaState>`__ ->
`LuaMonad <Lua-Monad.html#t:LuaMonad>`__ a -> IO (Either String a)

Run the lua monad with closing the state

runLuaMonad' :: `LuaState <Lua-Prim.html#t:LuaState>`__ ->
`LuaMonad <Lua-Monad.html#t:LuaMonad>`__ a -> IO (Either String a)

Run the Lua monad without closing the state

loadLib :: FilePath -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ ()

Load a library into the interpreter

eval :: String -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ Int

Evaluate some lua code

data LuaValue

Constructors

+-------------------------------------------------------------------------------------------------+-----+
| LuaObj [(`LuaValue <Lua-Monad.html#t:LuaValue>`__, `LuaValue <Lua-Monad.html#t:LuaValue>`__)]   |     |
+-------------------------------------------------------------------------------------------------+-----+
| LuaNum !Double                                                                                  |     |
+-------------------------------------------------------------------------------------------------+-----+
| LuaString !String                                                                               |     |
+-------------------------------------------------------------------------------------------------+-----+
| LuaBool !Bool                                                                                   |     |
+-------------------------------------------------------------------------------------------------+-----+
| LuaNil                                                                                          |     |
+-------------------------------------------------------------------------------------------------+-----+
| LuaNone                                                                                         |     |
+-------------------------------------------------------------------------------------------------+-----+
| LuaError !String                                                                                |     |
+-------------------------------------------------------------------------------------------------+-----+

Instances

+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `LuaValue <Lua-Monad.html#t:LuaValue>`__                                                                                                  |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Data `LuaValue <Lua-Monad.html#t:LuaValue>`__                                                                                                |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Num `LuaValue <Lua-Monad.html#t:LuaValue>`__                                                                                                 |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Ord `LuaValue <Lua-Monad.html#t:LuaValue>`__                                                                                                 |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Read `LuaValue <Lua-Monad.html#t:LuaValue>`__                                                                                                |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `LuaValue <Lua-Monad.html#t:LuaValue>`__                                                                                                |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Typeable `LuaValue <Lua-Monad.html#t:LuaValue>`__                                                                                            |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| IsString `LuaValue <Lua-Monad.html#t:LuaValue>`__                                                                                            |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| StackValue `LuaValue <Lua-Monad.html#t:LuaValue>`__                                                                                          |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible Double `LuaValue <Lua-Monad.html#t:LuaValue>`__                                                                                  |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible Integer `LuaValue <Lua-Monad.html#t:LuaValue>`__                                                                                 |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible Rational `LuaValue <Lua-Monad.html#t:LuaValue>`__                                                                                |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible String `LuaValue <Lua-Monad.html#t:LuaValue>`__                                                                                  |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible `LuaValue <Lua-Monad.html#t:LuaValue>`__ Double                                                                                  |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible `LuaValue <Lua-Monad.html#t:LuaValue>`__ Integer                                                                                 |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible `LuaValue <Lua-Monad.html#t:LuaValue>`__ Rational                                                                                |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible `LuaValue <Lua-Monad.html#t:LuaValue>`__ String                                                                                  |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible `LuaValue <Lua-Monad.html#t:LuaValue>`__ `LuaValue <Lua-Monad.html#t:LuaValue>`__                                                |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| (Typeable a, Convertible `LuaValue <Lua-Monad.html#t:LuaValue>`__ a) => Convertible `LuaValue <Lua-Monad.html#t:LuaValue>`__ [(String, a)]   |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+
| (Typeable a, Convertible a `LuaValue <Lua-Monad.html#t:LuaValue>`__) => Convertible [(String, a)] `LuaValue <Lua-Monad.html#t:LuaValue>`__   |     |
+----------------------------------------------------------------------------------------------------------------------------------------------+-----+

newtype LuaMonad a

The lua monad keeps the current LuaState and offers error handling
through ``ErrorT``. It also has access to the IO Monad

Constructors

LR

 

Fields

unLR :: ReaderT `LuaState <Lua-Prim.html#t:LuaState>`__ (ErrorT String
IO) a
     

Instances

+------------------------------------------------------------------------------------------------+-----+
| Monad `LuaMonad <Lua-Monad.html#t:LuaMonad>`__                                                 |     |
+------------------------------------------------------------------------------------------------+-----+
| Functor `LuaMonad <Lua-Monad.html#t:LuaMonad>`__                                               |     |
+------------------------------------------------------------------------------------------------+-----+
| Applicative `LuaMonad <Lua-Monad.html#t:LuaMonad>`__                                           |     |
+------------------------------------------------------------------------------------------------+-----+
| MonadIO `LuaMonad <Lua-Monad.html#t:LuaMonad>`__                                               |     |
+------------------------------------------------------------------------------------------------+-----+
| MonadReader `LuaState <Lua-Prim.html#t:LuaState>`__ `LuaMonad <Lua-Monad.html#t:LuaMonad>`__   |     |
+------------------------------------------------------------------------------------------------+-----+
| MonadError String `LuaMonad <Lua-Monad.html#t:LuaMonad>`__                                     |     |
+------------------------------------------------------------------------------------------------+-----+

registerhsfunction :: LuaImport a => String -> a ->
`LuaMonad <Lua-Monad.html#t:LuaMonad>`__ ()

Register a haskell function in lua

loadLuaValue :: String -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__
(Maybe `LuaValue <Lua-Monad.html#t:LuaValue>`__)

Get global variable value

saveLuaValue :: String -> `LuaValue <Lua-Monad.html#t:LuaValue>`__ ->
`LuaMonad <Lua-Monad.html#t:LuaMonad>`__ ()

Save global variable value

getValue :: StackValue a => String ->
`LuaMonad <Lua-Monad.html#t:LuaMonad>`__ a

Get the haskell value by name and pop it of the stack, omit type

getInt :: String -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ Int

Get the int by name and pop it of the stack, omit type

getString :: String -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ String

Get the string by name and pop it of the stack, omit type

getBool :: String -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ Bool

Get the boolean by name and pop it of the stack, omit type

getLuaValue :: String -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__
`LuaValue <Lua-Monad.html#t:LuaValue>`__

Get a global value by name

getDouble :: String -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ Double

Get the double by name and pop it of the stack, omit type

getType :: String -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__
`LuaType <Lua-Prim.html#t:LuaType>`__

Get the type of a variable by name

valToLua :: String -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__
`LuaValue <Lua-Monad.html#t:LuaValue>`__

Retrieve a value from the stack by name

tableToLua :: String -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__
`LuaValue <Lua-Monad.html#t:LuaValue>`__

Retrieve a table by name from the stack

pushLuaValue :: `LuaValue <Lua-Monad.html#t:LuaValue>`__ ->
`LuaMonad <Lua-Monad.html#t:LuaMonad>`__ ()

Push value on stack

loadIntoTable :: LuaState -> (`LuaValue <Lua-Monad.html#t:LuaValue>`__,
`LuaValue <Lua-Monad.html#t:LuaValue>`__) -> IO ()

Load a key value pair into a table

push :: StackValue a => a -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ ()

Push a value on the stack

peek :: StackValue a => Int -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__
a

Peek nth item of the stack

pop :: Int -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ ()

Pop nth item of the stack

loadfile :: String -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ Int

Load a file into lua

call :: Int -> Int -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ Int

call a function

tostring :: Int -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ String

Convert to string

pushnil :: `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ ()

Push nil on the stack

ltype :: Int -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__
`LuaType <Lua-Prim.html#t:LuaType>`__

Get the type of the value on the stack

getglobal :: String -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ ()

Retrieve a global by name

next :: Int -> `LuaMonad <Lua-Monad.html#t:LuaMonad>`__ Bool

newstate :: IO LuaState

Create a new state

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
