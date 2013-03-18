{-# LANGUAGE OverloadedStrings, FlexibleInstances, OverlappingInstances #-}

-- TODO
-- * Order
-- * non-recursive Relation structure

module Data.View (
) where

import           Prelude hiding (and, or, null, take, drop)
import qualified Data.HashMap.Strict as HM
import qualified Data.List as L
import           Data.Maybe
import           Data.SqlTransaction
import           Database.HDBC
import           Database.HDBC.PostgreSQL
import           Data.Tools hiding (join)
import           Control.Applicative
import           Control.Monad hiding (join)
import           Control.Monad.State hiding (join)
import           Debug.Trace

{-
 - Testing
 -}

dbconn ::  IO Connection
dbconn = connectPostgreSQL "host=192.168.4.9 port=5432 dbname=postgres user=postgres password=wetwetwet" 

doSql :: SqlTransaction Connection a -> IO a
doSql t = dbconn >>= flip (runSqlTransaction t error) undefined

r :: RelationM
r = raw "select 1 as e, 2 as f, ? :: integer as c, ? :: integer as d" [SqlInteger 3, SqlInteger 4] ["e", "f", "c", "d"] -- e f c d / 1 2 3 4

r' :: RelationM
r' = raw "select 5 as g, 6 as h, 7 as i, 8 as j" [] ["g", "h", "i", "j"] -- g h i j / 5 6 7 8

-- r1 r -> a b c d / 1 2 3 4
t1 :: RelationM
t1 = rename [("e", "a"), ("f", "b")]

-- t2 r -> b a / 2 1
t2 :: RelationM
t2 = t1 >> project ["b", "a"]

-- t3 r -> b a / 2 1 / 6 5 
t3 :: RelationM
t3 = unite r' >> t2

-- t4 r -> b a / 6 5
t4 :: RelationM
t4 = t3 >> select ("b" |>* SqlInteger 4)

account :: RelationM
account = view "account" ["id", "email", "password", "nickname", "respect", "level"]

garage :: RelationM
garage = view "garage" ["id", "account_id"]

cars :: RelationM
cars = view "car_in_garage" ["garage_id", "manufacturer_name", "name"]

testBasic :: RelationM
testBasic = do
        account
        select ("level" |>* SqlInteger 10) -- make selection
        project ["id", "nickname", "level", "respect"] -- get relevant columns
        rename [("id", "what"), ("nickname", "who"), ("level", "where"), ("respect", "how")] -- name columns

testJoin :: RelationM
testJoin = do
        account >> rename [("id", "user_account_id")]
        join ("user_account_id" |==| "garage_account_id") $ garage >> rename [("id", "user_garage_id"), ("account_id", "garage_account_id")]
        join ("user_garage_id" |==| "car_garage_id") $ cars >> rename [("garage_id", "car_garage_id")]
        select ("level" |>* SqlInteger 10 <||> "nickname" |%%* "pikachu")
        projectAs [("nickname", "name"), ("level", "level"), ("manufacturer_name", "mark"), ("name", "model")]
 

{-
 - Data
 -}

-- key: column or attribute name
type Key = String
type Schema = [Key] -- note that attribute type is always SqlValue

-- result with schema and lists
type Row = [SqlValue]
type Result = (Schema, [Row])

instance Show Result where show (s, rs) = showTableWithHeader' s $ map (map show) rs

-- associative result as list of hashmaps
type RowAssoc = HM.HashMap Key SqlValue
type ResultAssoc = [RowAssoc]

-- sql query string
type Sql = String
type Query = (Sql, [SqlValue])

-- convert to sql and list of values
class ToSql a where sql :: a -> Sql
class ToValues a where values :: a -> [SqlValue]


-- Relation constructors
data Relation = Relation Schema Query
              | Projection Schema Relation
              | Selection Condition Relation
              | Union Relation Relation
              | Intersection Relation Relation
              | SetDifference Relation Relation
              | CrossProduct Relation Relation
              | Rename Key Key Relation
              | Join Condition Relation Relation
              | Take Integer Relation
              | Drop Integer Relation
        deriving (Show)

type RelationM = State Relation ()


-- Condition constructors
data Condition = Always
               | Never
               | Not Condition
               | And Condition Condition
               | Or Condition Condition
               | As Query
               | Eq Var Var
               | Gt Var Var
               | Gte Var Var
               | Like Var Var
               | Ilike Var Var
               | Null Var

        deriving (Show)

-- Condition variable: either a column name, an input variable or a query
data Var = VarColumn String | VarInput SqlValue
        deriving (Show)

{-
 - Relation
 -}

rempty :: Relation
rempty = Relation ["null"] ("select null as null", [])

{-
 - RelationM
 -}

-- Relation from explicit selection
raw :: Sql -> [SqlValue] -> Schema -> RelationM
raw s xs ks = put $ Relation ks (s, xs)

-- Relation from database table by name and explicit list of fields
table :: String -> Schema -> RelationM
table t ks = raw (concat ["select * from ", quotes t]) [] ks

-- Relation from database view by name
view :: String -> Schema -> RelationM
view = table

-- identity
identity :: RelationM
identity = modify id

-- projection: map the relation to a specified schema. any keys not in the original relation will be pupulated with null values.
project :: Schema -> RelationM
project s = modify (Projection s)

-- project and rename
projectAs :: [(Key, Key)] -> RelationM
projectAs ns = rename ns >> project (map snd ns)

-- selection: return a new relation with the same schema as the original but only those rows that match the specified condition.
-- note that only one condition is ever needed; multiple conditions must be combined using combinators.
select :: Condition -> RelationM
select c = modify (Selection c)

-- union: combine two relations that have the same schema; create relation that contains all rows from both
unite :: RelationM -> RelationM
unite m = modify (flip Union (exec m))

-- intersection: combine two relations that have the same schema; create relation that contains rows found in both relations
intersect :: RelationM -> RelationM
intersect m = modify (flip Intersection (exec m))

-- set-difference: combine two relations that have the same schema; create relation that contains rows from the first not found in the second
diff :: RelationM -> RelationM
diff m = modify (flip SetDifference (exec m))

-- cartesian cross product: combine each row of one relation with each row of another
-- note that key conflicts are possible here. use implicit renaming? require relation identifier to use as prefix? discard conflicting attributes?
cross :: RelationM -> RelationM
cross m = modify (flip CrossProduct (exec m))

-- rename: rename first key to second key. overwrite on conflict 
rename :: [(Key, Key)] -> RelationM
rename ns = foldM_ (\_ (s, t) -> r s t) () (reverse ns)
    where
        r :: Key -> Key -> RelationM
        r k1 k2 = modify (Rename k1 k2)

-- join: a selection on a cross product
join :: Condition -> RelationM -> RelationM
join c m = modify (flip (Join c) (exec m))

-- take a number of records (limit)
take :: Integer -> RelationM
take n = modify (Take n)

-- drop a number of records (offset)
drop :: Integer -> RelationM
drop n = modify (Drop n)

{-
 - Condition
 -}

-- combinations
(<||>) :: Condition -> Condition -> Condition
(<||>) = Or
infixl 3 <||>

(<&&>) :: Condition -> Condition -> Condition
(<&&>) = And
infixl 2 <&&>

-- folds
and :: [Condition] -> Condition
and xs = foldr And Always xs

or :: [Condition] -> Condition
or xs = foldr Or Never xs

-- explicit
as :: Sql -> [SqlValue] -> Condition
as s xs = As (s, xs)

-- unary
null :: String -> Condition
null = Null . VarColumn

notnull :: String -> Condition
notnull = Not . Null . VarColumn

-- Condition construction 
op :: (Var -> Var -> Condition) -> (a -> Var) -> (b -> Var) -> (a -> b -> Condition)
op f g h = (\a b -> f (g a) (h b))

-- binary
(|==|) :: String -> String -> Condition
(|==|) = op Eq VarColumn VarColumn
infixl 4 |==|

(|>|) :: String -> String -> Condition
(|>|) = op Gt VarColumn VarColumn
infixl 4 |>|

(|>=|) :: String -> String -> Condition
(|>=|) = op Gte VarColumn VarColumn
infixl 4 |>=|

(|<>|) :: String -> String -> Condition
(|<>|) a b = Not (a |==| b)
infixl 4 |<>|

(|<|) :: String -> String -> Condition
(|<|) a b = Not (a |>=| b)
infixl 4 |<|

(|<=|) :: String -> String -> Condition
(|<=|) a b = Not (a |>| b)
infixl 4 |<=|

(|%|) :: String -> String -> Condition
(|%|) = op Like VarColumn VarColumn
infixl 4 |%|

(|%%|) :: String -> String -> Condition
(|%%|) = op Ilike VarColumn VarColumn
infixl 4 |%%|

(|==*) :: String -> SqlValue -> Condition
(|==*) = op Eq VarColumn VarInput
infixl 4 |==*

(|>*) :: String -> SqlValue -> Condition
(|>*) = op Gt VarColumn VarInput
infixl 4 |>*

(|>=*) :: String -> SqlValue -> Condition
(|>=*) = op Gte VarColumn VarInput
infixl 4 |>=*

(|<>*) :: String -> SqlValue -> Condition
(|<>*) a b = Not (a |==* b)
infixl 4 |<>*

(|<*) :: String -> SqlValue -> Condition
(|<*) a b = Not (a |>=* b)
infixl 4 |<*

(|<=*) :: String -> SqlValue -> Condition
(|<=*) a b = Not (a |>* b)
infixl 4 |<=*

(|%*) :: String -> SqlValue -> Condition
(|%*) = op Like VarColumn VarInput
infixl 4 |%*

(|%%*) :: String -> SqlValue -> Condition
(|%%*) = op Ilike VarColumn VarInput
infixl 4 |%%*

(*==|) :: SqlValue -> String -> Condition
(*==|) = op Eq VarInput VarColumn
infixl 4 *==|

(*>|) :: SqlValue -> String -> Condition
(*>|) = op Gt VarInput VarColumn
infixl 4 *>|

(*>=|) :: SqlValue -> String -> Condition
(*>=|) = op Gte VarInput VarColumn
infixl 4 *>=|

(*<>|) :: SqlValue -> String -> Condition
(*<>|) a b = Not (a *==| b)
infixl 4 *<>|

(*<|) :: SqlValue -> String -> Condition
(*<|) a b = Not (a *>=| b)
infixl 4 *<|

(*<=|) :: SqlValue -> String -> Condition
(*<=|) a b = Not (a *>| b)
infixl 4 *<=|

(*%|) :: SqlValue -> String -> Condition
(*%|) = op Like VarInput VarColumn
infixl 4 *%|

(*%%|) :: SqlValue -> String -> Condition
(*%%|) = op Ilike VarInput VarColumn
infixl 4 *%%|

(*==*) :: SqlValue -> SqlValue -> Condition
(*==*) = op Eq VarInput VarInput
infixl 4 *==*

(*>*) :: SqlValue -> SqlValue -> Condition
(*>*) = op Gt VarInput VarInput
infixl 4 *>*

(*>=*) :: SqlValue -> SqlValue -> Condition
(*>=*) = op Gte VarInput VarInput
infixl 4 *>=*

(*<>*) :: SqlValue -> SqlValue -> Condition
(*<>*) a b = Not (a *==* b)
infixl 4 *<>*

(*<*) :: SqlValue -> SqlValue -> Condition
(*<*) a b = Not (a *>=* b)
infixl 4 *<*

(*<=*) :: SqlValue -> SqlValue -> Condition
(*<=*) a b = Not (a *>* b)
infixl 4 *<=*

(*%*) :: SqlValue -> SqlValue -> Condition
(*%*) = op Like VarInput VarInput
infixl 4 *%*

(*%%*) :: SqlValue -> SqlValue -> Condition
(*%%*) = op Ilike VarInput VarInput
infixl 4 *%%*

{-
 - Retrieval
 -}

exec :: RelationM -> Relation
exec = flip execState rempty

query :: Relation -> Query 
query r = trace (sql r) $ (sql r, values r)

schema :: Relation -> Schema
schema (Relation s _) = s
schema (Projection s _) = s
schema (Selection _ r) = schema r
schema (Union r _) = schema r
schema (Intersection r _) = schema r
schema (SetDifference r _) = schema r
schema (CrossProduct r1 r2) = concat [schema r1, schema r2]
schema (Rename k1 k2 r) = map (\k -> case k == k1 of { True -> k2; False -> k }) $ schema r
schema (Join _ r1 r2) = concat [schema r1, schema r2]
schema (Take _ r) = schema r
schema (Drop _ r) = schema r

runQuery :: Query -> SqlTransaction Connection ResultAssoc
runQuery (q, vs) = sqlGetAllAssoc q vs

relationTransaction :: Relation -> SqlTransaction Connection Result
relationTransaction r = fromAssoc (schema r) <$> relationTransactionAssoc r

-- earn the Java Badge of Honour
relationTransactionAssoc :: Relation -> SqlTransaction Connection ResultAssoc
relationTransactionAssoc = runQuery . query

getResult :: RelationM -> SqlTransaction Connection Result
getResult = relationTransaction . exec

getAssoc :: RelationM -> SqlTransaction Connection ResultAssoc
getAssoc = relationTransactionAssoc . exec

instance ToSql Relation where
        
        -- select schema with zero rows and union with raw selection, the labels of which are discarded. note: number of columns must match number of keys.
--        sql (Relation ks q) = concat ["(select ", commas $ map (("null as " ++) . quotes) ks, " where false) union (", sql q, ")"]
        sql (Relation ks q) = concat ["select ", commas $ map quotes ks, " from (", sql q, ") x"]
        
        -- select specific columns from relation
        sql (Projection ks q) = concat ["select ", commas $ map quotes ks, " from (", sql q, ") x"]
        
        -- select specific rows from relation
        sql (Selection c r) = concat ["select * from (", sql r, ") x where (", sql c, ")"]
        
        sql (Rename k1 k2 r) = concat ["select ", commas $ map m $ schema r, " from (", sql r, ") x"]
                where m k = case k == k1 of { True -> concat [quotes k, " as ", quotes k2]; False -> quotes k }

        sql (Join c r1 r2) = concat ["select x.*, y.* from (", sql r1, ") x join (", sql r2, ") y on ", sql c]
        sql (CrossProduct r1 r2) = sql (Join Always r1 r2)

        sql (Union r1 r2) = concat ["(", sql r1, ") union (", sql r2, ")"]
        sql (Intersection r1 r2) = concat ["(", sql r1, ") intersect (", sql r2, ")"]
        sql (SetDifference r1 r2) = concat ["(", sql r1, ") except (", sql r2, ")"]

        sql (Take x r) = concat ["select * from (", sql r, ") x limit ?"]
        sql (Drop x r) = concat ["select * from (", sql r, ") x offset ?"]

instance ToValues Relation where
        values (Relation _ q) = values q
        values (Projection _ r) = values r
        values (Selection c r) = concat [values r, values c]
        values (Union r1 r2) = concat [values r1, values r2]
        values (Intersection r1 r2) = concat [values r1, values r2]
        values (SetDifference r1 r2) = concat [values r1, values r2]
        values (CrossProduct r1 r2) = concat [values r1, values r2]
        values (Rename _ _ r) = values r
        values (Join c r1 r2) = concat [values r1, values r2, values c]
        values (Take x r) = concat [values r, [SqlInteger x]]
        values (Drop x r) = concat [values r, [SqlInteger x]]

instance ToSql Query where
        sql (q, _) = q

instance ToValues Query where
        values (_, vs) = vs

instance ToSql Condition where
        sql Always = "true"
        sql Never = "false"
        sql (Not c) = concat ["not (", sql c,")"]
        sql (And c d) = concat ["(", sql c, ") and (", sql d, ")"]
        sql (Or c d) = concat ["(", sql c, ") or (", sql d, ")"]
        sql (As q) = sql q
        sql (Eq a b) = concat [sql a, " = ", sql b]
        sql (Gt a b) = concat [sql a, " > ", sql b]
        sql (Gte a b) = concat [sql a, " >= ", sql b]
        sql (Like a b) = concat [sql a, " like ", sql b]
        sql (Ilike a b) = concat [sql a, " ilike ", sql b]
        sql (Null a) = concat [sql a, " is null"]

instance ToValues Condition where
        values Always = []
        values Never = []
        values (Not c) = values c
        values (And c d) = concat [values c, values d]
        values (Or c d) = concat [values c, values d]
        values (As q) = values q
        values (Eq a b) = concat [values a, values b]
        values (Gt a b) = concat [values a, values b]
        values (Gte a b) = concat [values a, values b]
        values (Like a b) = concat [values a, values b]
        values (Ilike a b) = concat [values a, values b]
        values (Null a) = values a

instance ToSql Var where
        sql (VarColumn k) = quotes k
        sql (VarInput x) = "?"

instance ToValues Var where
        values (VarColumn _) = []
        values (VarInput x) = [x]



{-
 - Conversion
 -}

toAssoc :: Result -> ResultAssoc
toAssoc (s, rs) = map (rowToAssoc s) rs

rowToAssoc :: Schema -> Row -> RowAssoc
rowToAssoc ks vs = foldr (\(k, v) m -> HM.insert k v m) HM.empty $ zip ks vs

fromAssoc :: Schema -> ResultAssoc -> Result
fromAssoc s ms = (s, map (rowFromAssoc s) ms)

rowFromAssoc :: Schema -> RowAssoc -> Row
rowFromAssoc ks m = foldr (\k xs -> (maybe SqlNull id $ HM.lookup k m) : xs) [] ks


{-
 - Helpers
 -}

commas :: [String] -> String
commas ss = L.intercalate ", " ss

quotes :: String -> String
quotes s = L.concat ["\"", s, "\""]


