{-# LANGUAGE FlexibleInstances #-}

module Data.Database where

import Data.List
import qualified Data.HashMap.Strict as M
import Data.Tools
import Data.SqlTransaction
import Database.HDBC
import Database.HDBC.PostgreSQL 

-- TODO:
-- table free selection (ie. select now() as "date")
-- -> have NullTable
-- multiple table selection
-- -> Tables is a list
-- -> constraints, selections each refer to specific table

{-
 -  Testing
 -}

dbconn ::  IO Connection
dbconn = connectPostgreSQL "host=192.168.1.66 port=5432 dbname=deosx user=graffiti password=wetwetwet"

doSql :: SqlTransaction Connection a -> IO a
doSql t = dbconn >>= (runSqlTransaction t error)

{-
 - *** Base ***
 -}

type Sql = String
type Value = SqlValue
type Values = [SqlValue]

class Expression a where
    sql :: a -> Sql
    values :: a -> Values

type Pair = (Sql, Values)

instance Expression Pair where
    sql (s, _) = s
    values (_, v) = v

(.*) :: Sql -> Values -> Pair
(.*) s v = (s, v)
infixl 4 .*

pair :: (Expression a) => a -> Pair
pair e = (sql e) .* (values e)

class Expressable a where   
    express :: a -> Pair

instance Expressable Sql where
    express s = (s, [])

instance Expressable Value where
    express v = ("", [v])

instance Expressable Values where
    express vs = ("", vs)

{-
 - *** Components ***
 -}

{- Table -}

type Table = Pair

table :: Sql -> Table
table t = express $ concat ["\"", t, "\""]

{- Selection -}

type Selections = [Selection]

instance Expression Selections where
    sql [] = "null"
    sql xs = concat $ intersperse ", " $ map sql xs
    values xs = concat $ map values xs

type Selection = Pair

column :: Sql -> Selection
column t = express $ concat ["\"", t, "\""]

selectAll :: Selection
selectAll = express "*"

{- Assignment -}

data Assignments = Inserts [Assignment] | Updates [Assignment] deriving Show

instance Expression Assignments where
    sql (Inserts fs@(_:_)) = concat ["(", fq, ") values (", fl, ")"]
        where
            fq = concat $ intersperse ", " $ map sql fs
            fl = concat $ intersperse ", " $ map def fs
    sql (Updates fs@(_:_)) = concat $ intersperse ", " $ map (\f -> concat [sql f, " = ", def f]) fs
    sql _ = ""
    values (Inserts fs) = concat $ map values fs
    values (Updates fs) = concat $ map values fs

-- TODO: combine Assign and Default to Assign Sql Pair, or (Expression x) => Assign Sql x

data Assignment = Assign Sql Value | Default Sql Sql deriving Show

(.->) :: Sql -> Value -> Assignment
(.->) = Assign
infixl 4 .->

(.#>) :: Sql -> Sql -> Assignment
(.#>) = Default
infixl 4 .#>

def :: Assignment -> Sql
def (Default _ s) = s
def _ = "?"

instance Expression Assignment where
    sql (Assign q _) = concat ["\"", q, "\""]
    sql (Default q _) = concat ["\"", q, "\""]
    values (Assign _ v) = [v]
    values (Default _ _) = []

{- Constraint -}

type Constraints = [Constraint]

instance Expression Constraints where
    sql [] = "true"
    sql xs = concat $ intersperse " and " $ map sql xs
    values xs = concat $ map values xs

data Constraint = Constraint ConOp Selection Value deriving Show

instance Expression Constraint where
    sql (Constraint o s _) = concat ["( ", sql s, " ", sql o, " ?)"]
    values (Constraint o s v) = concat [values s, [enc o v]]
        where
            enc OpContains x = toSql $ encWith '%' $ (fromSql x :: Sql)
            enc OpIContains x = toSql $ encWith '%' $ (fromSql x :: Sql)
            enc _ x = x

data ConOp = OpLT | OpLTE | OpGT | OpGTE | OpEQ | OpContains | OpIContains deriving Show

cLT :: Selection -> Value -> Constraint
cLT = Constraint OpLT

cLTE :: Selection -> Value -> Constraint
cLTE = Constraint OpLTE

cGT :: Selection -> Value -> Constraint
cGT = Constraint OpGT

cGTE :: Selection -> Value -> Constraint
cGTE = Constraint OpGTE

cEQ :: Selection -> Value -> Constraint
cEQ = Constraint OpEQ

cIn :: Selection -> Value -> Constraint
cIn = Constraint OpContains

cIni :: Selection -> Value -> Constraint
cIni = Constraint OpIContains

(|<) :: Sql -> Value -> Constraint
(|<) a b = cLT (column a) b
infixl 4 |<

(|<=) :: Sql -> Value -> Constraint
(|<=) a b = cLTE (column a) b
infixl 4 |<=

(|>) :: Sql -> Value -> Constraint
(|>) a b = cGT (column a) b
infixl 4 |>

(|>=) :: Sql -> Value -> Constraint
(|>=) a b = cGTE (column a) b
infixl 4 |>=

(|==) :: Sql -> Value -> Constraint
(|==) a b = cEQ (column a) b
infixl 4 |==

(|%) :: Sql -> Value -> Constraint
(|%) a b = cIn (column a) b
infixl 4 |%

(|%%) :: Sql -> Value -> Constraint
(|%%) a b = cIni (column a) b
infixl 4 |%%

instance Expression ConOp where
    sql OpLT = "<"
    sql OpLTE = "<="
    sql OpGT = ">"
    sql OpGTE = ">="
    sql OpEQ = "="
    sql OpContains = "like"
    sql OpIContains = "ilike"
    values _ = []

{- Order -}

type Orders = [Order]

instance Expression Orders where
    sql [] = "true"
    sql xs = concat $ intersperse ", " $ map sql xs
    values xs = concat $ map values xs

data Order = Order Selection Direction deriving Show

instance Expression Order where
    sql (Order s b) = concat [sql s, " ", sql b]
    values (Order s _) = values s

type Direction = Bool

instance Expression Direction where
    sql True = "asc"
    sql _ = "desc"
    values _ = []

{- Limit -}

data Limit = Limit Value | NullLimit deriving Show

instance Expression Limit where
    sql (Limit _) = "limit ?"
    sql _ = ""
    values (Limit a) = [a]
    values _ = []

{- Offset -}

data Offset = Offset Value | NullOffset deriving Show

instance Expression Offset where
    sql (Offset _) = "offset ?"
    sql _ = ""
    values (Offset a) = [a]
    values _ = []

{-
 - *** Queries ***
 -}

data Select = Select Table Selections Constraints Orders Limit Offset

instance Expression Select where
    sql (Select tbl sel con ord lim ofs) = concat $ intersperse " " $ [
            "select", sql sel,
            "from", sql tbl,
            "where", sql con,
            "order by", sql ord, "nulls last",
            sql lim,
            sql ofs,
            ";"
        ]
    values (Select tbl sel con ord lim ofs) = concat $ [
            values sel,
            values tbl,
            values con,
            values ord,
            values lim,
            values ofs
        ]

data Insert = Insert Table Assignments

instance Expression Insert where
    sql (Insert tbl ass) = concat $ intersperse " " $ ["insert into", sql tbl, sql ass, "returning lastval();"]
    values (Insert tbl ass) = concat $ [values tbl, values ass]

data Update = Update Table Assignments Constraints

instance Expression Update where
    sql (Update tbl ass con) = concat $ intersperse " " $ ["update", sql tbl, "set", sql ass, "where", sql con]
    values (Update tbl ass con) = concat $ [values tbl, values ass, values con]

{-
 - *** Functions ***
 -}

-- constraints: provide map of optional arguments and a dictionary of operators to use for each one
constraints :: [(Sql, Selection -> Value -> Constraint)] -> [(Sql, Value)] -> Constraints
constraints ls m = foldr step [] ls
    where
        step (k, f) xs = case (lookup k m) of
            Just v -> (f (column k) v) : xs
            _ -> xs

-- assigns: provide list of allowed fields, default values, and a list of optional arguments
assigns :: [(Sql, Sql)] -> [(Sql, Value)] -> [Assignment]
assigns ds ls = concat [map (uncurry (.#>)) ds, map (uncurry (.->)) ls]

inserts :: [(Sql, Sql)] -> [(Sql, Value)] -> Assignments
inserts ds ls = Inserts $ assigns ds ls

updates :: [(Sql, Sql)] -> [(Sql, Value)] -> Assignments
updates ds ls = Updates $ assigns ds ls

-- orders: provide map of optional arguments. if found, sort_field and sort_invert is used to generate orderings
orders :: [(Sql, Value)] -> Orders
orders m = ord $ lookup "sort_field" m
    where
        ord (Just v) = [Order (column ((fromSql v) :: Sql)) $ bl $ lookup "sort_invert" m]
        ord Nothing = []
        bl (Just v) =  (fromSql v) `elem` ["true", "True", "1"]
        bl Nothing = False

-- limit: provide map of optional arguments. if found, limit is used to generate limit
limit :: [(Sql, Value)] -> Limit
limit m = case (lookup "limit" m) of
    Just v -> Limit v
    _ -> NullLimit

-- offset: provide map of optional arguments. if found, offset is used to generate offset
offset :: [(Sql, Value)] -> Offset
offset m = case (lookup "offset" m) of
    Just v -> Offset v
    _ -> NullOffset

-- transaction: provide query function and an expression, generates transaction
transaction :: (Expression x) => (Sql -> Values -> SqlTransaction Connection t) -> x -> SqlTransaction Connection t
transaction f x = f (sql x) (values x)

-- select: quick select. table name; [(field name, constraint constructor)]; map of optional arguments
select :: Sql -> [(Sql, Selection -> Value -> Constraint)] -> [(Sql, Value)] -> SqlTransaction Connection [M.HashMap Sql Value]
select t c ls = transaction sqlGetAllAssoc $ Select tbl sel con ord lim ofs
    where
        tbl = table t
        sel = [selectAll]
        con = constraints c ls
        ord = orders ls
        lim = limit ls
        ofs = offset ls

-- insert: quick insert. table name; defaults; fields names; map of optional arguments
insert :: Sql -> [(Sql, Sql)] -> [(Sql, Value)] -> SqlTransaction Connection Value
insert t d ls = transaction sqlGetOne $ Insert tbl ass
    where
        tbl = table t
        ass = inserts d ls

-- update: quick update. table name; [(Sql, Selection -> Value -> Constraint)]; constraint arguments; default assigns; assignment arguments
update :: Sql -> Constraints -> [(Sql, Sql)] -> [(Sql, Value)] -> SqlTransaction Connection ()
update t con d a = transaction sqlExecute $ Update tbl ass con
    where
        tbl = table t
        ass = updates d a


{-
 - *** Utility ***
 -}

-- geometry: convert geo coordinates to a geometry. this requires a query.
geometry :: SqlValue -> SqlValue -> SqlTransaction Connection SqlValue
geometry lat lng = sqlGetOne "select ST_MakePoint(?, ?) as \"geometry\"" [lng, lat]


