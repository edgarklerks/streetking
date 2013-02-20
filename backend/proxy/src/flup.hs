module Main where


newtype B = B Int
    deriving (Show, Eq)

instance Num B where
    (-) 0 b = error "Donotdo"
    (-) (B a) (B b) = B $ a - b
    fromInteger = B . fromInteger


