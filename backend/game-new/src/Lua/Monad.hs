module Lua.Monad 
(
    runLua,
    runLuaMonad,
    runLuaMonad', 
    loadLib,
    eval,
    LuaValue(..),
    LuaMonad(..),
    registerhsfunction,
    loadLuaValue,
    saveLuaValue,
    getValue,
    getInt,
    getString,
    getBool,
    getLuaValue,
    getDouble,
    getType,
    valToLua,
    tableToLua,
    pushLuaValue,
    loadIntoTable,
    push,
    peek,
    pop,
    loadfile,
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

-- | Run the lua monad with closing the state 
runLuaMonad :: LuaState -> LuaMonad a -> IO (Either String a)
runLuaMonad ls x =  (runErrorT .  (`runReaderT` ls) .  unLR) x <* Lua.close ls

-- | Evaluate a Lua monad in the IO monad  
runLua :: LuaMonad a -> IO (Either String a)
runLua a =  do  x <- Lua.newstate
                Lua.openlibs x 
                runLuaMonad x a
 
       
-- | Evaluate some lua code 
eval :: String -> LuaMonad Int 
eval xs = ask >>= liftIO . flip (`Lua.loadstring` xs) mempty >> call 0 0

-- | Load a library into the interpreter 
loadLib :: FilePath -> LuaMonad ()
loadLib f = do 
        x <- loadfile f
        if x > 0 then throwError . mappend ("Cannot load file: " ++ (show x) ++ "because of ") =<< tostring(-1) else do 
            t <- call 0 0
            if (t > 0) then throwError . mappend ("Cannot run chunk: " ++ (show t)) =<< tostring (-1) else pure ()

-- | Bracket specially for either type (only used internally) 
bracket :: (String -> b) -> (a -> b) -> Either String a -> b
bracket f _ (Left x)  =  f x
bracket _ g  (Right x)  = g x

-- | Test library 
testLib ::  IO () 
testLib =  bracket print print =<<  runLua (loadLib "Modules/test.lua" *>  vari)
        where vari = peekGlobal "i" :: LuaMonad (Int, LuaType )


{-- Overloaded functions --}

-- | Load a file into lua 
loadfile :: String -> LuaMonad Int
loadfile x = ask >>= liftIO . flip Lua.loadfile x

-- | call a function 
call :: Int -> Int  -> LuaMonad Int
call a b  = ask >>= liftIO . flip (`Lua.call` a) b

-- | Convert to string 
tostring :: Int -> LuaMonad String 
tostring x = ask >>= liftIO . (flip Lua.tostring x)

openlibs :: LuaMonad ()
openlibs = ask >>= liftIO . Lua.openlibs 

-- | Register a haskell function in lua 
registerhsfunction :: (Lua.LuaImport a) => String -> a -> LuaMonad ()
registerhsfunction xs a = ask >>= liftIO . flip (`Lua.registerhsfunction` xs) a


{-- Helper functions --}

-- | Get global variable value 
loadLuaValue :: String -> LuaMonad (Maybe LuaValue)
loadLuaValue x = ask >>= \c -> (liftIO . flip Lua.getglobal x) c *>  liftIO   (Lua.peek c (-1))

-- | Push value on stack 
pushLuaValue :: LuaValue -> LuaMonad ()
pushLuaValue x = ask >>= liftIO . flip Lua.push x

-- | Save global variable value 
saveLuaValue :: String -> LuaValue -> LuaMonad ()
saveLuaValue x y = ask >>= \c -> (liftIO . flip Lua.push y) c *> liftIO ( Lua.setglobal c x)

-- | Change value to string 
tosstring :: (Lua.StackValue a, Show a) => a -> String
tosstring = show
