========
Lua.Prim
========

-  `Contents <index.html>`__
-  `Index <doc-index.html>`__

 

Safe Haskell

None

Lua.Prim

Synopsis

-  type `LuaState <#t:LuaState>`__ = LuaState
-  type `LuaType <#t:LuaType>`__ = LTYPE
-  data `LuaValue <#t:LuaValue>`__

   -  = `LuaObj <#v:LuaObj>`__
      [(`LuaValue <Lua-Prim.html#t:LuaValue>`__,
      `LuaValue <Lua-Prim.html#t:LuaValue>`__)]
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
-  `runLuaMonad' <#v:runLuaMonad-39->`__ ::
   `LuaState <Lua-Prim.html#t:LuaState>`__ ->
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ a -> IO (Either String a)
-  `loadIntoTable <#v:loadIntoTable>`__ :: LuaState ->
   (`LuaValue <Lua-Prim.html#t:LuaValue>`__,
   `LuaValue <Lua-Prim.html#t:LuaValue>`__) -> IO ()
-  `setTable <#v:setTable>`__ :: LuaState ->
   `LuaValue <Lua-Prim.html#t:LuaValue>`__ ->
   `LuaValue <Lua-Prim.html#t:LuaValue>`__ -> Int -> IO ()
-  `loopTable <#v:loopTable>`__ ::
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__
   [(`LuaValue <Lua-Prim.html#t:LuaValue>`__,
   `LuaValue <Lua-Prim.html#t:LuaValue>`__)]
-  `\_valToLua <#v:_valToLua>`__ :: Int ->
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__
   `LuaValue <Lua-Prim.html#t:LuaValue>`__
-  `pop <#v:pop>`__ :: Int -> `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ ()
-  `peek <#v:peek>`__ :: StackValue a => Int ->
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ a
-  `ltype <#v:ltype>`__ :: Int ->
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__
   `LuaType <Lua-Prim.html#t:LuaType>`__
-  `getglobal <#v:getglobal>`__ :: String ->
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ ()
-  `pushnil <#v:pushnil>`__ :: `LuaMonad <Lua-Prim.html#t:LuaMonad>`__
   ()
-  `newstate <#v:newstate>`__ :: IO LuaState
-  `push <#v:push>`__ :: StackValue a => a ->
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ ()
-  `catchMaybe <#v:catchMaybe>`__ :: MonadError String m => Maybe a ->
   (a -> m b) -> String -> m b
-  `getLuaValue <#v:getLuaValue>`__ :: String ->
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__
   `LuaValue <Lua-Prim.html#t:LuaValue>`__
-  `peekGlobal <#v:peekGlobal>`__ :: StackValue a => String ->
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ (a,
   `LuaType <Lua-Prim.html#t:LuaType>`__)
-  `getGlobal <#v:getGlobal>`__ :: StackValue a => String ->
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ (a,
   `LuaType <Lua-Prim.html#t:LuaType>`__)
-  `getValue <#v:getValue>`__ :: StackValue a => String ->
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ a
-  `getInt <#v:getInt>`__ :: String ->
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ Int
-  `getDouble <#v:getDouble>`__ :: String ->
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ Double
-  `getBool <#v:getBool>`__ :: String ->
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ Bool
-  `getString <#v:getString>`__ :: String ->
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ String
-  `getType <#v:getType>`__ :: String ->
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__
   `LuaType <Lua-Prim.html#t:LuaType>`__
-  `next <#v:next>`__ :: Int -> `LuaMonad <Lua-Prim.html#t:LuaMonad>`__
   Bool
-  `peekLuaValue <#v:peekLuaValue>`__ :: Int ->
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__
   `LuaValue <Lua-Prim.html#t:LuaValue>`__
-  `valToLua <#v:valToLua>`__ :: String ->
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__
   `LuaValue <Lua-Prim.html#t:LuaValue>`__
-  `tableToLua <#v:tableToLua>`__ :: String ->
   `LuaMonad <Lua-Prim.html#t:LuaMonad>`__
   `LuaValue <Lua-Prim.html#t:LuaValue>`__

Documentation
=============

type LuaState = LuaState

type LuaType = LTYPE

data LuaValue

Constructors

+-----------------------------------------------------------------------------------------------+-----+
| LuaObj [(`LuaValue <Lua-Prim.html#t:LuaValue>`__, `LuaValue <Lua-Prim.html#t:LuaValue>`__)]   |     |
+-----------------------------------------------------------------------------------------------+-----+
| LuaNum !Double                                                                                |     |
+-----------------------------------------------------------------------------------------------+-----+
| LuaString !String                                                                             |     |
+-----------------------------------------------------------------------------------------------+-----+
| LuaBool !Bool                                                                                 |     |
+-----------------------------------------------------------------------------------------------+-----+
| LuaNil                                                                                        |     |
+-----------------------------------------------------------------------------------------------+-----+
| LuaNone                                                                                       |     |
+-----------------------------------------------------------------------------------------------+-----+
| LuaError !String                                                                              |     |
+-----------------------------------------------------------------------------------------------+-----+

Instances

+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Eq `LuaValue <Lua-Prim.html#t:LuaValue>`__                                                                                                 |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Data `LuaValue <Lua-Prim.html#t:LuaValue>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Num `LuaValue <Lua-Prim.html#t:LuaValue>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Ord `LuaValue <Lua-Prim.html#t:LuaValue>`__                                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Read `LuaValue <Lua-Prim.html#t:LuaValue>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Show `LuaValue <Lua-Prim.html#t:LuaValue>`__                                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Typeable `LuaValue <Lua-Prim.html#t:LuaValue>`__                                                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| IsString `LuaValue <Lua-Prim.html#t:LuaValue>`__                                                                                           |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| StackValue `LuaValue <Lua-Prim.html#t:LuaValue>`__                                                                                         |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible Double `LuaValue <Lua-Prim.html#t:LuaValue>`__                                                                                 |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible Integer `LuaValue <Lua-Prim.html#t:LuaValue>`__                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible Rational `LuaValue <Lua-Prim.html#t:LuaValue>`__                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible String `LuaValue <Lua-Prim.html#t:LuaValue>`__                                                                                 |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible `LuaValue <Lua-Prim.html#t:LuaValue>`__ Double                                                                                 |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible `LuaValue <Lua-Prim.html#t:LuaValue>`__ Integer                                                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible `LuaValue <Lua-Prim.html#t:LuaValue>`__ Rational                                                                               |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible `LuaValue <Lua-Prim.html#t:LuaValue>`__ String                                                                                 |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| Convertible `LuaValue <Lua-Prim.html#t:LuaValue>`__ `LuaValue <Lua-Prim.html#t:LuaValue>`__                                                |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| (Typeable a, Convertible `LuaValue <Lua-Prim.html#t:LuaValue>`__ a) => Convertible `LuaValue <Lua-Prim.html#t:LuaValue>`__ [(String, a)]   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+
| (Typeable a, Convertible a `LuaValue <Lua-Prim.html#t:LuaValue>`__) => Convertible [(String, a)] `LuaValue <Lua-Prim.html#t:LuaValue>`__   |     |
+--------------------------------------------------------------------------------------------------------------------------------------------+-----+

newtype LuaMonad a

The lua monad keeps the current LuaState and offers error handling
through ``ErrorT``. It also has access to the IO Monad

Constructors

LR

 

Fields

unLR :: ReaderT `LuaState <Lua-Prim.html#t:LuaState>`__ (ErrorT String
IO) a
     

Instances

+-----------------------------------------------------------------------------------------------+-----+
| Monad `LuaMonad <Lua-Prim.html#t:LuaMonad>`__                                                 |     |
+-----------------------------------------------------------------------------------------------+-----+
| Functor `LuaMonad <Lua-Prim.html#t:LuaMonad>`__                                               |     |
+-----------------------------------------------------------------------------------------------+-----+
| Applicative `LuaMonad <Lua-Prim.html#t:LuaMonad>`__                                           |     |
+-----------------------------------------------------------------------------------------------+-----+
| MonadIO `LuaMonad <Lua-Prim.html#t:LuaMonad>`__                                               |     |
+-----------------------------------------------------------------------------------------------+-----+
| MonadReader `LuaState <Lua-Prim.html#t:LuaState>`__ `LuaMonad <Lua-Prim.html#t:LuaMonad>`__   |     |
+-----------------------------------------------------------------------------------------------+-----+
| MonadError String `LuaMonad <Lua-Prim.html#t:LuaMonad>`__                                     |     |
+-----------------------------------------------------------------------------------------------+-----+

runLuaMonad' :: `LuaState <Lua-Prim.html#t:LuaState>`__ ->
`LuaMonad <Lua-Prim.html#t:LuaMonad>`__ a -> IO (Either String a)

Run the Lua monad without closing the state

loadIntoTable :: LuaState -> (`LuaValue <Lua-Prim.html#t:LuaValue>`__,
`LuaValue <Lua-Prim.html#t:LuaValue>`__) -> IO ()

Load a key value pair into a table

setTable :: LuaState -> `LuaValue <Lua-Prim.html#t:LuaValue>`__ ->
`LuaValue <Lua-Prim.html#t:LuaValue>`__ -> Int -> IO ()

Set a key value to a specific table

loopTable :: `LuaMonad <Lua-Prim.html#t:LuaMonad>`__
[(`LuaValue <Lua-Prim.html#t:LuaValue>`__,
`LuaValue <Lua-Prim.html#t:LuaValue>`__)]

Retrieve the table as key value pairs

\_valToLua :: Int -> `LuaMonad <Lua-Prim.html#t:LuaMonad>`__
`LuaValue <Lua-Prim.html#t:LuaValue>`__

Get some value from the stack

pop :: Int -> `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ ()

Pop nth item of the stack

peek :: StackValue a => Int -> `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ a

Peek nth item of the stack

ltype :: Int -> `LuaMonad <Lua-Prim.html#t:LuaMonad>`__
`LuaType <Lua-Prim.html#t:LuaType>`__

Get the type of the value on the stack

getglobal :: String -> `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ ()

Retrieve a global by name

pushnil :: `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ ()

Push nil on the stack

newstate :: IO LuaState

Create a new state

push :: StackValue a => a -> `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ ()

Push a value on the stack

catchMaybe :: MonadError String m => Maybe a -> (a -> m b) -> String ->
m b

getLuaValue :: String -> `LuaMonad <Lua-Prim.html#t:LuaMonad>`__
`LuaValue <Lua-Prim.html#t:LuaValue>`__

Get a global value by name

peekGlobal :: StackValue a => String ->
`LuaMonad <Lua-Prim.html#t:LuaMonad>`__ (a,
`LuaType <Lua-Prim.html#t:LuaType>`__)

Get a global value by name as haskell type, keep it on the top of the
stack

getGlobal :: StackValue a => String ->
`LuaMonad <Lua-Prim.html#t:LuaMonad>`__ (a,
`LuaType <Lua-Prim.html#t:LuaType>`__)

Get a global by name and pop it from the stack

getValue :: StackValue a => String ->
`LuaMonad <Lua-Prim.html#t:LuaMonad>`__ a

Get the haskell value by name and pop it of the stack, omit type

getInt :: String -> `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ Int

Get the int by name and pop it of the stack, omit type

getDouble :: String -> `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ Double

Get the double by name and pop it of the stack, omit type

getBool :: String -> `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ Bool

Get the boolean by name and pop it of the stack, omit type

getString :: String -> `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ String

Get the string by name and pop it of the stack, omit type

getType :: String -> `LuaMonad <Lua-Prim.html#t:LuaMonad>`__
`LuaType <Lua-Prim.html#t:LuaType>`__

Get the type of a variable by name

next :: Int -> `LuaMonad <Lua-Prim.html#t:LuaMonad>`__ Bool

peekLuaValue :: Int -> `LuaMonad <Lua-Prim.html#t:LuaMonad>`__
`LuaValue <Lua-Prim.html#t:LuaValue>`__

Peek what value is at the nth place of the stack

valToLua :: String -> `LuaMonad <Lua-Prim.html#t:LuaMonad>`__
`LuaValue <Lua-Prim.html#t:LuaValue>`__

Retrieve a value from the stack by name

tableToLua :: String -> `LuaMonad <Lua-Prim.html#t:LuaMonad>`__
`LuaValue <Lua-Prim.html#t:LuaValue>`__

Retrieve a table by name from the stack

Produced by `Haddock <http://www.haskell.org/haddock/>`__ version 2.11.0
