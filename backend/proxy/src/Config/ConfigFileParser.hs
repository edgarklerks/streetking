module Config.ConfigFileParser where
import System.IO
import Data.Map
import Text.Parsec hiding ((<|>),many)
import Text.Parsec.Char
import qualified Text.Parsec.Prim hiding ((<|>),many)
import Text.Parsec.String
import Text.Parsec.Token
import Text.Parsec.Combinator
import Control.Applicative hiding (empty)
import Control.Monad
import Data.List

data Config = Var String Config  
            | IntegerC Integer 
            | StringC String
            | BoolC Bool
            | FloatC Float
        deriving Show

type Section = (String, [Config])

type Sections = [Section]

readConfig :: FilePath -> IO Sections
readConfig filePath = do result <- parseFromFile fileParser filePath
                         case result of
                            Left err  -> error . show $ err
                            Right xs  -> return xs
-- lookup :: Ord k => k -> [(k, a)] -> Maybe a 
lookupConfig :: String -> Sections -> Maybe [Config]
lookupConfig sectionName configData = Data.List.lookup sectionName configData

-- "ip" `from` "server"

-- from :: String -> String -> Sections -> Maybe Config
-- from = do x <- ...                                      
                                      
lookupVar :: String -> [Config] -> Maybe Config
lookupVar keyword configs = case (find (equalTo keyword) configs) of
                              Just (Var a b) -> Just b
                              Nothing -> Nothing

equalTo :: String -> Config -> Bool
equalTo keyword (Var string configPair) = keyword == string

main :: IO ( )
main = do x <- readFile "config.conf"
          case (parse fileParser "" x) of
             Left err  -> print err
             Right xs  -> print xs
          parsedResults <- readConfig "config.conf"
          let configList = lookupConfig "sectie2" parsedResults
          case configList >>= lookupVar "variabele24" of
            Just xs  -> print xs
            Nothing -> print "fout" 

sectionHeadParser :: Parser String
sectionHeadParser = between (char '[') (char ']') (many1 alphaNum)

keywordParser :: Parser String
keywordParser = fmap (:) letter <*> many (alphaNum <|> oneOf "-") <* (many space) <* string "="

valueParser :: Parser Config
valueParser =  stringParser <|> floatParser <|> integerParser <|> booleanParser

stringParser :: Parser Config
stringParser = try (between (char '"') (char '"') (many stm)) >>= return.StringC
    where stm = oneOf $ ['a'..'z'] ++ ['A' .. 'Z'] ++ ['0' .. '9'] ++ "/!@#$%^&*()-_~`'.,><=:"

integerParser :: Parser Config
integerParser = try (fmap (++) (many (char '-')) <*> many1 digit) >>= return.IntegerC . read

floatParser :: Parser Config
floatParser = try (fmap (++) (many (char '-')) <*> (fmap (++) (many1 digit) <*> (fmap (:) (char '.') <*> many1 digit))) >>= return.FloatC . read

booleanParser :: Parser Config
booleanParser = try ( try (string "True") <|> try (string "False")) >>= return.BoolC . read

keywordValueParser :: Parser Config
keywordValueParser = Var <$> (keywordParser <* space) <*> valueParser 

sectionContentsParser :: Parser [Config]
sectionContentsParser = sepEndBy (keywordValueParser) (many space)

sectionParser :: Parser (String, [Config])
sectionParser = fmap (,) (sectionHeadParser <* (many space)) <*> (sectionContentsParser)

fileParser :: Parser [(String, [Config])]
fileParser = sectionParser `sepBy`  (many space)
