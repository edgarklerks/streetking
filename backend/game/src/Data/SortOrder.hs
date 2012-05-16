module Data.SortOrder where 

import Text.Parsec.String
import Text.Parsec.Prim hiding (many, (<|>))
import Text.Parsec.Combinator
import Text.Parsec.Char
import Control.Applicative
import Data.Database
import Control.Monad

{-- Sortorder grammar: 
 -  start = stm
 -  stm = orderby id dir (, id dir)*
 -  id = [a-zA-Z0-9_]+
 -  dir = asc | desc 
 ---}

data SortOrder = OrderBy String Dir 
               | Col [SortOrder] 
        deriving Show 

data Dir = Asc | Desc 
    deriving Show 

{-- Evaluator --}

-- Order = Order [String, []] Bool 
-- True -> Asc 
-- False -> Desc 
--
rtp Asc = True 
rtp Desc = False 

sortOrder :: SortOrder -> [String] -> Either String Orders 
sortOrder (OrderBy x y) vs | x `elem` vs = return $ [Order (x, []) (rtp y)]
                           | otherwise = Left $ "Not a valid field: " ++ x
sortOrder (Col xs) vs = foldM check [] xs 
    where 
        check z (OrderBy x y) | x `elem` vs = return $ (Order (x,[]) (rtp y)) : z
                              | otherwise = Left $ "Not a valid field: " ++ x
        check z t@(Col xs) = (++z) <$> sortOrder t vs  
                    

{-- combinators --}
orderby :: String -> Dir -> SortOrder  
orderby = OrderBy 

desc :: Dir 
desc = Desc

asc :: Dir 
asc = Asc 


{-- Parser --}

getSortOrder :: String -> Either String SortOrder
getSortOrder x = case parse startp "" x of 
                        Left e -> Left (show e)
                        Right a -> Right a

startp :: Parser SortOrder
startp = Col <$> stmp 
stmp :: Parser [SortOrder]
stmp = string "orderby" *> spaces *> (OrderBy <$> (idp <* spaces) <*> dirp) `sepBy1` (char ',' *> spaces) <|> pure []
idp = many1 $ oneOf "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
dirp = (string "asc" *> pure Asc) <|> (string "desc" *> pure Desc)


