{-# LANGUAGE GeneralizedNewtypeDeriving, BangPatterns, DeriveDataTypeable, FlexibleContexts #-}
module Lua.Prim where
import qualified Scripting.Lua as Lua
import Control.Monad.Trans
import Control.Monad.Error
import Control.Monad.Reader
import Control.Monad
import Control.Applicative
import Data.Typeable
import Data.Data
import Data.Monoid
import Control.Arrow ((&&&))

type LuaState = Lua.LuaState
type LuaType = Lua.LTYPE

data LuaValue = LuaObj [(LuaValue, LuaValue)]
              | LuaNum !Double
              | LuaString !String
              | LuaBool !Bool
              | LuaNil  
              | LuaNone 
              | LuaError !String
    deriving (Show, Read, Typeable, Eq, Data, Ord)

-- | The lua monad keeps the current LuaState and offers error handling
--   through 'Control.Monad.Error.ErrorT'. It also has access to the IO
--   Monad 
newtype LuaMonad a = LR {
        unLR :: ReaderT LuaState (ErrorT String IO) a
    } deriving (Functor, Monad, Applicative, MonadReader LuaState, MonadError String, MonadIO)

-- | Run the Lua monad without closing the state 
runLuaMonad' :: LuaState -> LuaMonad a -> IO (Either String a)
runLuaMonad' ls = runErrorT . flip runReaderT ls . unLR  


instance Lua.StackValue LuaValue where
        peek p x = do
                    v <- runLuaMonad' p . peekLuaValue $ x
                    case v of
                        Right x -> return . Just $ x
                        Left x -> return Nothing
        valuetype a = Lua.TTABLE
        push p (LuaString s) = Lua.push p s
        push p (LuaNum x) =  Lua.push p x
        push p (LuaBool n) = Lua.push p n
        push p (LuaNil) = Lua.pushnil p
        push p (LuaNone) = Lua.pushnil p
        push p (LuaObj xs) = Lua.newtable p *> forM_ xs (loadIntoTable p) 

-- | Load a key value pair into a table 
loadIntoTable :: Lua.LuaState -> (LuaValue, LuaValue) -> IO ()
loadIntoTable p (x@(LuaNum _), y) = setTable p x y (-3) 
loadIntoTable p (x@(LuaString _), y) = setTable p x y (-3) 
loadIntoTable p _ = error "can only load num or string into a table"

-- | Set a key value to a specific table 
setTable :: Lua.LuaState -> LuaValue -> LuaValue -> Int -> IO ()
setTable p x y i = Lua.push p x *> Lua.push p y *> Lua.settable p i

-- | Retrieve the table as key value pairs 
loopTable :: LuaMonad  [(LuaValue, LuaValue)]
loopTable = do 
        t <- next $ -2
        if t then (,) <$> _valToLua (-2) <*> _valToLua (-1) >>= \n -> (n:) <$> (pop 1 *> loopTable) else pure mempty 

-- | Get some value from the stack 
_valToLua :: Int -> LuaMonad LuaValue
_valToLua i = do 
            t <- ltype i 
            case t of 
                Lua.TNUMBER ->  LuaNum <$> peek i
                Lua.TSTRING -> LuaString <$> peek i
                Lua.TNONE -> pure LuaNone
                Lua.TNIL -> pure LuaNil
                Lua.TBOOLEAN -> LuaBool <$> peek i
                Lua.TTABLE -> LuaObj <$> (pushnil *>  loopTable)
                _ -> pure . LuaError $ "Unsupported type"


-- | Pop nth item of the stack 
pop :: Int -> LuaMonad ()
pop x = ask >>= liftIO  . flip Lua.pop x

-- | Peek nth item of the stack 
peek :: (Lua.StackValue a) => Int -> LuaMonad a
peek i = ask >>=  liftIO . flip  Lua.peek i >>= \n -> catchMaybe n pure . mappend "Error on stack: " . show $  i

-- | Get the type of the value on the stack 
ltype :: Int -> LuaMonad LuaType
ltype x = ask >>= \c -> liftIO $ Lua.ltype c x 

-- | Retrieve a global by name   
getglobal :: String -> LuaMonad ()
getglobal x  = ask >>= liftIO . flip Lua.getglobal x 

-- | Push nil on the stack 
pushnil :: LuaMonad ()
pushnil = ask >>= liftIO . Lua.pushnil

-- | Create a new state 
newstate :: IO Lua.LuaState
newstate = Lua.newstate

-- | Push a value on the stack 
push :: Lua.StackValue a => a -> LuaMonad ()
push a = ask >>= \c -> liftIO $ Lua.push c a

catchMaybe ::  (MonadError String m) => Maybe a -> (a -> m b) -> String -> m b
catchMaybe (Nothing) g f = throwError f
catchMaybe (Just x) g f = g x

-- | Get a global value by name 
getLuaValue :: String -> LuaMonad LuaValue
getLuaValue = getValue

-- | Get a global value by name as haskell type, keep it on the top of the
--   stack 
peekGlobal :: (Lua.StackValue a) => String -> LuaMonad (a, LuaType) 
peekGlobal s = getglobal s >> peek (-1) >>= pure.(id &&& Lua.valuetype) 

-- | Get a global by name and pop it from the stack 
getGlobal :: (Lua.StackValue a) => String -> LuaMonad (a, LuaType)
getGlobal s = peekGlobal s <* pop 1

-- | Get the haskell value by name and pop it of the stack, omit type 
getValue :: (Lua.StackValue a) => String -> LuaMonad a
getValue  = fmap fst . getGlobal 

-- | Get the int  by name and pop it of the stack, omit type 
getInt :: String -> LuaMonad Int
getInt = getValue

-- | Get the double  by name and pop it of the stack, omit type 
getDouble :: String -> LuaMonad Double 
getDouble = getValue

-- | Get the boolean  by name and pop it of the stack, omit type 
getBool :: String -> LuaMonad Bool
getBool = getValue

-- | Get the string  by name and pop it of the stack, omit type 
getString :: String -> LuaMonad String
getString = getValue



-- | Get the type of a variable by name 
getType :: String  -> LuaMonad LuaType
getType x = (getgb >>= ltp) <* pop 1
        where getgb = getglobal x *> ask
              ltp = liftIO. flip Lua.ltype (-1)


next :: Int -> LuaMonad Bool 
next x = ask >>= liftIO . flip Lua.next x 

-- | Peek what value is at the nth place of the stack 
peekLuaValue :: Int -> LuaMonad LuaValue
peekLuaValue n = do 
            t <- ltype n
            c <- ask
            case t of 
                Lua.TTABLE -> pushnil *> (LuaObj <$> loopTable)
                Lua.TNONE -> pure LuaNone
                Lua.TBOOLEAN -> LuaBool <$> peek n
                Lua.TLIGHTUSERDATA -> throwError "Not convertable"
                Lua.TNUMBER -> LuaNum  <$> peek n
                Lua.TSTRING -> LuaString <$> peek n
                Lua.TFUNCTION -> pure $ LuaError "Not convertable"
                Lua.TTHREAD -> pure $ LuaError "Not covertable"
                Lua.TNIL -> pure LuaNil




-- | Retrieve a value from the stack by name 
valToLua :: String -> LuaMonad LuaValue 
valToLua x = do 
            t <- getType x
--            liftIO $ print t
            case t of 
                Lua.TTABLE -> tableToLua x
                Lua.TNONE -> pure LuaNone
                Lua.TBOOLEAN -> LuaBool <$> getBool x
                Lua.TLIGHTUSERDATA -> throwError "Not convertable"
                Lua.TNUMBER -> LuaNum  <$> getDouble x
                Lua.TSTRING -> LuaString <$> getString x
                Lua.TFUNCTION -> pure $ LuaError "Not convertable"
                Lua.TTHREAD -> pure $ LuaError "Not covertable"
                Lua.TNIL -> pure LuaNil


-- | Retrieve a table by name from the stack 
tableToLua :: String -> LuaMonad LuaValue 
tableToLua x =  getglobal x *> pushnil *> (LuaObj <$> loopTable)


