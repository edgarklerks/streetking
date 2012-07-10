module Cell where 

import Data.Binary 
import Vector 
import Control.Applicative

data Cell = Cell {
        begin :: Vector Double,
        end :: Vector Double,
        curvature :: Maybe Double,
        radius :: Maybe Double,
        arclength :: Double 
    }

instance Binary Cell where 
    put (Cell a b c d e) = put a >> put b >> put c >> put d >> put e
    get = Cell <$> get <*> get <*> get <*> get <*> get



