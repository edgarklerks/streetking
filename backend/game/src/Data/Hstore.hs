{-# LANGUAGE MultiParamTypeClasses #-}
module Data.Hstore (
        parseHStore,
        HStore(..),
        ppHStore 
    ) where 

import qualified Data.HashMap.Strict as S
import Text.Parsec.String
import Text.Parsec.Combinator
import Text.Parsec.Char
import Text.Parsec.Prim hiding (many, (<|>))
import Control.Applicative
import Database.HDBC
import qualified Data.Foldable as F
import Data.List 
import Data.Convertible
import Data.Default
import Data.Aeson 

newtype HStore = HS {
    unHS ::S.HashMap String String 
    } deriving (Show, Eq)

ppHStore :: HStore -> String 
ppHStore xs = intercalate "," $ 
              do (k,v) <- S.toList (unHS xs) 
                 return $ '"' : (escapeString k ++ "\"=>" ++ ('"' : escapeString v ++ ['"'])) 
 
escapeString =  concatMap step 
    where 
        step '"' = "\\\""
        step x = [x]

parseHStore :: SqlValue -> HStore 
parseHStore xs =  HS $ case parse parseEntries "" (fromSql xs :: String) of 
                            Left e -> error (show e)
                            Right xs -> S.fromList xs 

parseEntries :: Parser [(String,String)]
parseEntries = parseEntry `sepBy` (char ',' <* spaces)

parseEntry :: Parser (String, String)
parseEntry = (,) <$> (parseKey <* string "=>") <*> parseValue 


parseKey :: Parser String 
parseKey = parseString <|> (many $ oneOf "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_.")


parseValue :: Parser String 
parseValue = parseString <|> parseInt <|> parseNull 

parseNull :: Parser String 
parseNull = string "NULL" *> pure ""

parseInt :: Parser String 
parseInt = many (parseNumber <|> parseSymbol)

parseSymbol :: Parser Char
parseSymbol = oneOf "-."

parseNumber :: Parser Char 
parseNumber = oneOf "0123456789"

parseString :: Parser String 
parseString = char '"' *> many charp <* char '"'

charp :: Parser Char  
charp = esccharp <|> uncharp

esccharp :: Parser Char
esccharp =  char '\\'  *> charp 

uncharp :: Parser Char 
uncharp = noneOf "\"" 




instance Default Bool where 
        def = False

instance Convertible SqlValue HStore where 
        safeConvert = Right . parseHStore  

instance Convertible HStore SqlValue where 
        safeConvert = Right .SqlString .  show . toJSON  . unHS . ppHStore 

instance Default HStore where 
    def = HS $ S.empty
