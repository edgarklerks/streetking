module Cell where 

import Data.Binary 
import Vector 
import Control.Applicative
import Data.Semigroup  
import Data.Maybe

data Cell = Cell {
        begin :: Vector Double,
        end :: Vector Double,
        path :: [Vector Double],
        curvature :: Maybe Double,
        radius :: Maybe Double,
        arclength :: Double 
    }


instance Binary Cell where 
    put (Cell a b c d e f) = put a >> put b >> put c >> put d >> put e >> put f 
    get = Cell <$> get <*> get <*> get <*> get <*> get <*> get 


instance Semigroup Cell where 
    (<>) 
        (Cell ba ea aas ca ra aa)
        (Cell bb eb bbs cb rb ab) =
        (Cell ba eb (aas <> bbs) (Just $ ca' + cb') (Just $ ra' + rb') (ab + aa)) 
            where ra' = fromMaybe 0 ra * rata
                  rb' = fromMaybe 0 rb * ratb 
                  rata = aa / (ab + aa)
                  ratb = ab / (ab + aa)
                  ca' = fromMaybe 0 ca * rata
                  cb' = fromMaybe 0 cb * ratb

