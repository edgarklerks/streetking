module Data.Noodle(
    runSnippet
) where 

import Language.Haskell.Interpreter
import Control.Monad.CatchIO as C
import Control.Monad.Trans
import Data.Typeable


runSnippet :: (Typeable a, MonadCatchIO m, Functor m) => String -> [(String, String)] -> a -> m a 
runSnippet x args a = do 
    let marshall xs = foldr step "" xs 
                where step (x,t) z = ("(read \"" ++ x ++ "\" :: "++ t ++ ")" ) ++ z 
    let y = "init "++ marshall args ++" \n" ++ x;
    c <- runInterpreter (interpret y a)
    case c of 
        Left e -> C.throw e 
        Right a -> return a
