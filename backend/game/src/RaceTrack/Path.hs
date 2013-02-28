module Path where 

import Data.Array.Base 
import Data.Array.IArray 

import Vector 

data Path = Path {
        start :: Vector Double,
        path :: Array Int (Vector Double)
    } deriving Show 
