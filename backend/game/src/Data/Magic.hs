module Data.Magic (
    FileType(..),
    magicIO,
    magicIO2
)
where

import Control.Applicative hiding (empty)
import Data.Char
import Magic.Data
import Magic.Init
import Magic.Operations
import Magic.Types
import Text.Parsec hiding ((<|>),many)
import Text.Parsec.Char
import qualified Text.Parsec.Prim hiding ((<|>),many)
import Text.Parsec.String
import Text.Parsec.Token
import Text.Parsec.Combinator
 
data FileType = FTC FileType String 
              | Image String
              | Audio String
              | Video String
              | Other String
              deriving (Show, Read)
              
magicIO :: FilePath -> IO FileType
magicIO filePath = do 
        magicObject <- magicOpen [MagicMime]
        magicLoadDefault magicObject
        mimeType <- magicFile magicObject filePath
        print ("mimetype = " ++ mimeType)
        let fileType = string2FileType mimeType
        print fileType
        return fileType

magicIO2 :: String -> IO FileType
magicIO2 fileContents = do 
         magicObject <- magicOpen [MagicMime]
         magicLoadDefault magicObject
         mimeType <- magicString magicObject fileContents
         print ("mimetype = " ++ mimeType)
         let fileType = string2FileType mimeType
         print fileType
         return fileType        

string2FileType :: String -> FileType
string2FileType string = case (parse mediaTypeParser "" (map toLower string)) of
                            Left err -> error . show $ err
                            Right fileType -> fileType
                          
fileType2String :: FileType -> String                           
fileType2String (FTC a b) = b

mediaTypeParser :: Parser FileType
mediaTypeParser = try ( imageParser <|> audioParser <|> videoParser)

imageParser :: Parser FileType
imageParser = try ( (++) <$> string "image/" <*> many1 alphaNum) >>= return . Image

audioParser :: Parser FileType
audioParser = try ( (++) <$> string "audio/" <*> many1 alphaNum) >>= return . Audio

videoParser :: Parser FileType
videoParser = try ( (++) <$> string "video/" <*> many1 alphaNum) >>= return . Video

         
