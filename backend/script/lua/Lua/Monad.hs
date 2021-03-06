module Lua.Monad 
(
    -- | function to evaluate the lua monad with a fresh lua state 
    runLua,
    -- | function to evaluate the lua monad with a existing lua state 
    runLuaMonad,
    runLuaMonad', 
    -- | Loading external files 
    loadLib,
    -- | evaluation of a lua program 
    eval,
    -- | communication between haskell <-> lua, high level
    LuaValue(..),
    -- | Monad, which encapsulates the communication with the Lua
    -- | interpreter
    LuaMonad(..),
    -- | register a haskell function in lua world 
    registerhsfunction,
    -- | load a lua value by name 
    loadLuaValue,
    -- | save a lua value by name 
    saveLuaValue,
    -- | Get a lua stack value by name and it's  lua type  
    getValue,
    -- | get an int by name 
    getInt,
    -- | get a string by name 
    getString,
    -- | get a boolean by name 
    getBool,
    -- | get a lua value by name 
    getLuaValue,
    -- | get a double by name 
    getDouble,
    -- | get the type by name 
    getType,
    -- | Low level, retrieve a value by name to haskell as a LuaValue  
    valToLua,
    -- | Low level, get a Table as LuaValue by name   
    tableToLua,
    -- | Push a lua value on the register
    pushLuaValue,
    -- | load a LuaValue into a specific sloth of a table
    loadIntoTable,
    -- stack manipulation 
    -- | Push an element
    push,
    -- | Peek at an element.
    peek,
    -- | Pop an element 
    pop,
    -- Various overloaded lowlevel primitives, mostly used for efficiency
    -- | Load a file into the lua interpreter. This should be valid lua.
    loadfile,
    -- | Call a function in the register
    call,
    tostring,
    pushnil,
    ltype,
    getglobal,
    next,
    newstate

) where
import qualified Scripting.Lua as Lua

import Control.Monad.Reader
import Control.Monad.Error
import Control.Monad
import Control.Applicative
import Data.Convertible
import Data.Maybe
import Data.List
import qualified Data.Map as M
import Lua.Instances
import Lua.Prim
import Data.Monoid
import Data.ByteString.Char8

runLuaMonad :: LuaState -> LuaMonad a -> IO (Either String a)
runLuaMonad ls x =  (runErrorT .  (`runReaderT` ls) .  unLR) x <* Lua.close ls

-- | Evaluate a lua 
runLua :: LuaMonad a -> IO (Either String a)
runLua a =  do  x <- Lua.newstate
                Lua.openlibs x 
                runLuaMonad x a
 
       

eval :: String -> LuaMonad Int 
eval xs = ask >>= liftIO . flip (`Lua.loadstring` xs) mempty >> call 0 0

loadLib :: FilePath -> LuaMonad ()
loadLib f = do 
{--        let evl = "dofile('" ++ f ++"')"
        liftIO $ print evl
        x <- eval evl
        if(x > 0) then tostring (-1) >>= \c -> throwError $ "error " ++ (show x ++ c)
                  else return ()
--}
        x <- loadfile f
        if x > 0 then throwError . mappend ("Cannot load file: " ++ (show x) ++ "because of ") =<< tostring(-1) else do 
            t <- call 0 0
            if (t > 0) then throwError . mappend ("Cannot run chunk: " ++ (show t)) =<< tostring (-1) else pure ()

bracket :: (String -> b) -> (a -> b) -> Either String a -> b
bracket f _ (Left x)  =  f x
bracket _ g  (Right x)  = g x

testLib ::  IO () 
testLib =  bracket print print =<<  runLua (loadLib "Modules/test.lua" *>  vari)
        where vari = peekGlobal "i" :: LuaMonad (Int, LuaType )


{-- Overloaded functions --}

loadfile :: String -> LuaMonad Int
loadfile x = ask >>= liftIO . flip Lua.loadfile x

call :: Int -> Int  -> LuaMonad Int
call a b  = ask >>= liftIO . flip (`Lua.call` a) b

tostring :: Int -> LuaMonad String 
tostring x = ask >>= liftIO . (flip Lua.tostring x)

openlibs :: LuaMonad ()
openlibs = ask >>= liftIO . Lua.openlibs 

registerhsfunction :: (Lua.LuaImport a) => String -> a -> LuaMonad ()
registerhsfunction xs a = ask >>= liftIO . flip (`Lua.registerhsfunction` xs) a


{-- Helper functions --}

loadLuaValue :: String -> LuaMonad (Maybe LuaValue)
loadLuaValue x = ask >>= \c -> (liftIO . flip Lua.getglobal x) c *>  liftIO   (Lua.peek c (-1))

pushLuaValue :: LuaValue -> LuaMonad ()
pushLuaValue x = ask >>= liftIO . flip Lua.push x

saveLuaValue :: String -> LuaValue -> LuaMonad ()
saveLuaValue x y = ask >>= \c -> (liftIO . flip Lua.push y) c *> liftIO ( Lua.setglobal c x)

tosstring :: (Lua.StackValue a, Show a) => a -> String
tosstring = show
