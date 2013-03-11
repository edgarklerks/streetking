module Main where

import Control.Monad 
import Control.Monad.State 




counter :: State Int Int 
counter = do 
        x <- get 
        put (x + 1)
        return (x + 1)

test = forM [1..10] $ \_ -> counter 
