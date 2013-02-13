module Data.SortOrder where 

import Text.Parsec.String
import Text.Parsec.Prim hiding (many, (<|>))
import Text.Parsec.Combinator
import Text.Parsec.Char
import Control.Applicative

{-- Sortorder grammar: 
 -  start = stm
 -  stm = orderby id dir (, id dir)*
 -  id = [a-zA-Z0-9_]+
 -  dir = asc | desc 
 ---}

data SortOrder = OrderBy String Dir 
               | And SortOrder SortOrder 
               | Valid [String] 
        deriving Show 

data Dir = Asc | Desc 
    deriving Show 


orderby = OrderBy 

desc :: SortOrder 
desc = Desc

asc :: SortOrder 
asc = Asc 

startp :: Parser [SortOrder]
startp = stmp 

stmp :: Parser [SortOrder]
stmp = string "orderby" *> (OrderBy <$> (id <* spaces) <*> dir) `sepBy1` char ','
idp = many1 $ oneOf "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
dir = (string "asc" *> pure Asc) <|> (string "desc" *> pure Desc)


