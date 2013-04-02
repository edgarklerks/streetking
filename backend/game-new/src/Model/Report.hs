{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TemplateHaskell, OverloadedStrings #-}
module Model.Report where 

import           Data.SqlTransaction
import           Database.HDBC
import           Data.Convertible
import           Data.Conversion
import           Model.General
import           Data.Database 
import           Control.Monad
import qualified Data.Aeson as AS
import qualified Data.InRules as IR
import           Data.DataPack
import           Data.Attoparsec.Number
import           Data.Default
import           Data.String
import           Data.Char

import           Control.Applicative
import qualified Data.Map as M
import           Model.TH
import           Prelude hiding (id)
import qualified Data.Relation as Rel
import qualified Data.ByteString.Char8 as C

data Type =
      Race
    | Shopper
    | Personnel
    | Garage
      deriving (Eq, Enum, Show)

-- tenmplate this?
instance IsString Type where
   fromString s = case map toLower s of
        "race" -> Race
        "shopper" -> Shopper 
        "personnel" -> Personnel
        "garage" -> Garage 
        otherwise -> error "String is not a Report Type"

instance IR.ToInRule Type where
    toInRule t = IR.toInRule $ toInteger $ fromEnum t 
instance IR.FromInRule Type where
    fromInRule (IR.InInteger i) = toEnum $ fromInteger $ i
    fromInRule _ = error "FromInRule: Enum: not an Integer"

instance AS.ToJSON Type where
    toJSON a = AS.toJSON $ fromEnum a
instance AS.FromJSON Type where 
    parseJSON (AS.Number (I n)) = return $ toEnum $ fromInteger n
    parseJSON _ = fail "parseJSON: Enum: not an Integer"

instance Default Type where
    def = toEnum 0

$(genAll "Report" "report" [
        ("id", ''Id),
        ("account_id", ''Integer),
        ("time", ''Integer),
        ("type", ''Type),
        ("data", ''Data)
    ])

report :: Type -> Integer -> Integer -> Data -> SqlTransaction Connection Integer 
report typ uid tim dta = save $ (def :: Report) { account_id = uid, time = tim, Model.Report.type = typ, Model.Report.data = dta }


