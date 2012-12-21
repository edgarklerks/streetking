{-# LANGUAGE ViewPatterns #-}
module Model.GetViews where

import Database.HDBC
import Database.HDBC.PostgreSQL 
import Control.Monad.Trans 
import Control.DeepSeq
import Data.Maybe 
import qualified Data.Map as M 
import Text.PrettyPrint hiding ((<>))
import Control.Applicative
import Data.Monoid 
import Control.Monad 
import Data.List 
import qualified Data.Set as S 
import Database.HsSqlPpp.Ast hiding (Table, View)
import qualified Database.HsSqlPpp.Ast as A
import Database.HsSqlPpp.Parser 
import Control.Monad.Error 
import Data.Char 
import qualified Data.HashMap.Strict as HM 


getViewsDependenciesTANC :: Connection -> IO ()
getViewsDependenciesTANC c = do 
                   xs <- getViewsDependencies c
                   (fmap fst xs) `forM_` \x -> do
                           tv <- loadViewNC c x
                           putStrLn $ "---------------------"
                           putStrLn $ "table: " ++  x
                           -- nameAlias 
                           -- selectPart -- Is an internal stage  
                           -- tablePart 
                           let (a,b) = buildAliasMap tv 
                           printAliasMap b
                           putStrLn $ "---------------------"


printAliasMap :: AliasMap -> IO ()
printAliasMap x = putStrLn $ render $ 
            text "alias map: " $+$
            nest 5 (HM.foldrWithKey step mempty x)
    where step k v a = text k 
                            $+$  (foldr (\x z -> nest 5 (text x) $+$ z) a v)

type TName = String 
type TAlias = String 

-- (table, alias)
--
-- (alias, field)

type AliasMap = HM.HashMap TName [String]

filterAliasMap :: AliasMap -> AliasMap 
filterAliasMap = HM.filterWithKey (\k v -> blacklist k)

sortAliasMap :: AliasMap -> AliasMap 
sortAliasMap = fmap sortMostUnique  

sortMostUnique = sortBy func 
    where func a c = compare (toNum c) (toNum a) 
          
toNum a | a == "id" = 800 
        | "id" `isPrefixOf` a = 400 
        | "_id" `isInfixOf` a = 200 
        | "id" `isInfixOf` a  = 100
        | "name" == a = 75 
        | "name" `isInfixOf` a = 50 
        | otherwise = 1 
buildAliasMap :: TANC -> ([String], AliasMap)
buildAliasMap tnc = let (terrs, tps) = unzipEither $ unTP $ getTablePart tnc 
                        (serrs, sps) = unzipEither $ unSP $ getSelectPart tnc
                    in (terrs ++ serrs, sortAliasMap $ filterAliasMap $ tps `zipAlias` sps)

zipAlias :: [(String, String)] -> [(String, String)] -> AliasMap
zipAlias xs ys = foldr step mempty xs 
        where step (a,b) z = case withAll b ys id of  
                                    [] -> z 
                                    ns -> case HM.lookup a z of 
                                                    Just xs -> HM.insert a (ns ++ xs) z 
                                                    Nothing -> HM.insert a ns z 

withAll :: Eq b => b -> [(b, c)] -> (c -> d) -> [d] 
withAll b xs f = foldr step [] xs 
        where step (x,y) z | x == b = f y : z 
                           | otherwise = z 

unzipEither :: [Either a b] -> ([a], [b])
unzipEither xs = foldr step ([],[]) xs 
        where step (Left a) (ls,rs) = (a : ls, rs)
              step (Right b) (ls, rs) = (ls, b : rs)

newtype TableParts = TP {
            unTP :: [Either String (TName, TAlias)]
        } deriving Show 


newtype SelectParts = SP {
                unSP :: [Either String (TName, TAlias)]
        } deriving Show



getSelectPart :: TANC -> SelectParts 
getSelectPart (selectPart -> xs) = SP $ foldr step [] xs
        where step [x,y] z = Right (getStringNC x, getStringNC y) : z
              step x z = (Left $ show x) : z

getTablePart :: TANC -> TableParts 
getTablePart (tablePart -> x) = TP $ foldr step [] x
        where step ([x],[y]) z = Right (getStringNC x, getStringNC y) : z
              step ([x], []) z = Right (getStringNC x, getStringNC x) : z 
              step x z = Left (show x) : z 

getStringNC :: NameComponent -> String 
getStringNC (Nmc c) = c
getStringNC (QNmc c) = c
viewsToTables :: [M.Map String SqlValue] -> [(String, [String])]
viewsToTables = foldr step [] 
        where step xs z = let tbl = getTable xs
                              vw = getView xs
                          in insertInto vw tbl z 

tablesToViews :: [M.Map String SqlValue] -> [(String, [String])]
tablesToViews = foldr step [] 
        where step xs z = let tbl = getTable xs
                              vw = getView xs
                          in insertInto tbl vw z 


insertInto :: Eq a => a -> b -> [(a, [b])] -> [(a, [b])]
insertInto k v xs = worker xs 
    where worker ((k', xs):xss) | k == k' = (k', v:xs) : xss 
                                | otherwise = (k', xs) : worker xss 
          worker [] = [(k, [v])]



getView :: M.Map String SqlValue -> String 
getView xs = fromSql $ fromJust $ M.lookup "table_name" xs 


getTable :: M.Map String SqlValue -> String 
getTable xs = fromSql $ fromJust $ M.lookup "view_name" xs  


getTablesOfView :: Connection -> String -> IO [String]
getTablesOfView c ts = do 
                    xs <- quickQuery c "select table_name from information_schema.view_table_usage where view_name = ?" [toSql ts] 
                    ys <- mapM (follow c) (fromSql <$> join xs)
                    return $ concat ys 

follow :: Connection -> String -> IO [String]
follow c ts = do
        b <- isTable c ts 
        if b then return [ts] 
             else getTablesOfView c ts  

blacklist x =  x `notElem` [
                           "access",
                           "account_busy_type",
                           "application",
                           "car_model",
                           "challenge_accept",
                           "challenge_type",
                           "city",
                           "continent",
                           "country",
                           "dealer_item",
                           "diamond_transaction",
                           "garage",
                           "garage_report",
                           "manufacturer",
                           "market_place_part_type",
                           "menu",
                           "notifications",
                           "parameter_table",
                           "part_model",
                           "part_modifier",
                           "part_type",
                           "personnel",
                           "personnel_details", 
                           "personnel_report",
                           "personnel_task_type",
                           "race_rewards",
                           "race_types",
                           "races",
                           "report",
                           "report_type",
                           "reward_log",
                           "reward_log_events",
                           "shop_report",
                           "support",
                           "tournament_report",
                           "tournament_result",
                           "tournament_type",
                           "track_continent",
                           "track_details",
                           "track_section",
                           "transaction",
                           "travel_report"
                    ]
data Type = Table 
          | View 

instance Show Type where 
        show Table = "BASE TABLE"
        show View = "VIEW"

searchTables :: Connection -> Type -> IO [String]
searchTables c t = do xs <- quickQuery c "select table_name from information_schema.tables where table_type = ? and table_schema = 'public'  " [toSql $ show t]
                      return $ concat (fmap fromSql <$> xs)



getViewsDependencies :: Connection -> IO [(String, [String])] 
getViewsDependencies c = do 
        xs <- searchTables c View 
        ys <- forM (filter blacklist $ xs) $ \x -> do 
                xs <- follow c x
                return (x,nub $ filter blacklist $  xs)
        return $ removeIfZero $ ys 


getViews :: Connection -> String -> String -> IO [M.Map String SqlValue ]
getViews c ctg schm = do 

            stm <- prepare c "select * from information_schema.view_table_usage where view_catalog = ? and view_schema = ?"
            s <- execute stm [toSql ctg, toSql schm] 
            xs <- fetchAllRowsMap' stm
            return xs 


{-- Parsing assisted tools --}


data Ref = Ref {
        src_table :: String, 
        dst_table :: String, 
        src_column :: String,
        dst_column :: String 

    } deriving (Show)



parseViewQuery :: String -> QueryExpr 
parseViewQuery testview = case parseQueryExpr "" testview of
                                     Left e -> error (show e)

                                     Right a -> a 

loadView :: Connection -> String -> IO String 
loadView c ts = do
            xs <- quickQuery c "select view_definition from information_schema.views where table_name = ?" [toSql ts]
            case xs of 
                (a:xs) -> return $ toLower <$> (fromSql $ head a)
                _ -> error "No such view" 


loadViewNC c ts = do 
       def <- loadView c  ts
       return $ getNameComponents def


dumpRawTableRef  = print $ getTablesRef $ parseViewQuery testview 

{-- Accessors --}




getNameComponents (parseViewQuery -> x) = (getNameComponentsTable x <> getNameComponentsSelect x)


-- | Monoid, which collects namecomponent information through the AST
data TANC = TANC {
            selectPart :: [[NameComponent]],
            tablePart :: [([NameComponent],[NameComponent])],
            nameAlias :: [(Name, TableAlias)]
    } deriving Show 

unitSelectPart :: [[NameComponent]] -> TANC 
unitSelectPart xs = mempty {
                        selectPart = xs 
                    }
unitTablePart :: [([NameComponent], [NameComponent])] -> TANC 
unitTablePart xs = mempty {
                    tablePart = xs     
                }

unitNameAlias :: [(Name, TableAlias)] -> TANC 
unitNameAlias xs = mempty {
                    nameAlias = xs     
            }

instance Monoid TANC where 
        mempty = TANC {
                selectPart = [],
                tablePart = [],
                nameAlias = [] 
            }
        mappend (TANC x y z) (TANC x' y' z') = TANC (x <> x') (y <> y') (z <> z')

getNameComponentsSelect :: QueryExpr -> TANC  
getNameComponentsSelect b | isSelect b = let si = getSelectItemList b
                                         in unitSelectPart $ foldr step [] si 
            where step :: SelectItem -> [[NameComponent]] -> [[NameComponent]]
                  step (SelExp _ t) z = getNameComponentsFromScalarExpr t : z
                  step (SelectItem _ t xs) z = getNameComponentsFromScalarExpr t : ([xs] : z)
                  step _ z = z
getNameComponentsSelect (CombineQueryExpr _ _ _ _) =  mempty -- error (show x) -- mempty 
getNameComponentsSelect x =  error (show x) -- mempty 



getNameComponentsTable :: QueryExpr -> TANC  
getNameComponentsTable = unitTablePart . foldr step [] . getTablesRef  
            where step x z = let (TANC _ _ xs) = getTableRefTref x 
                             in foldr (\x z -> (getName $ fst x, getNameComponentsAlias $ snd x) : z) z xs 

getName :: Name -> [NameComponent]
getName (Name _ nc) = nc 

getNameComponentsAlias :: TableAlias -> [NameComponent]
getNameComponentsAlias (FullAlias _ nc xs) = nc : xs
getNameComponentsAlias (NoAlias _) = []
getNameComponentsAlias (TableAlias _ nc) = [nc]

getTableRefTref :: TableRef -> TANC  
getTableRefTref t@(isJoin -> True) = let l = getTableRefTref (getTableLeft t)
                                         c = getTableAlias t
                                         r = getTableRefTref (getTableRight t)
                                     in l <>  r
getTableRefTref t@(isTref -> True) = case t of 
                                        (Tref a nm ta) -> unitNameAlias  [(nm, ta)]    
getTableRefTref t@(isSubTref -> True) = mempty -- error $ render $ showSubTref t


getTableAlias :: TableRef -> TableAlias  
getTableAlias (JoinTref _ _ _ _ _ _ ta) = ta
getTableAlias _ = error "not a join tref"

-- | get the named components out of scalar expressions
getNameComponentsFromScalarExpr :: ScalarExpr -> [NameComponent]
getNameComponentsFromScalarExpr (Identifier _ c) = [c]
getNameComponentsFromScalarExpr (QIdentifier _ xs) = xs 
getNameComponentsFromScalarExpr (Cast _ xs _) = getNameComponentsFromScalarExpr xs -- error (render $ showScalarExpr x)
getNameComponentsFromScalarExpr (FunCall _ p se) = getName p ++ foldr (\x z -> getNameComponentsFromScalarExpr x ++ z) [] se
getNameComponentsFromScalarExpr (NumberLit _ _) = [] 
getNameComponentsFromScalarExpr (StringLit _ _) = [] 
getNameComponentsFromScalarExpr (Case _ _ _) = [] 
getNameComponentsFromScalarExpr (Star _) = []
-- TODO: Maybe important
getNameComponentsFromScalarExpr (ScalarSubQuery _ qe) = []

getNameComponentsFromScalarExpr x = error (show x)


getOnExpression :: TableRef -> OnExpr 
getOnExpression (JoinTref _ _ _ _ _ on _) = on

getTableLeft :: TableRef -> TableRef 
getTableLeft (JoinTref _ _ _ _ rn _ _) = rn
getTableLeft _ = error "not a join tref"

getTableRight :: TableRef -> TableRef 
getTableRight (JoinTref _ rn _ _ _ _ _) = rn
getTableRight _ = error "not a join tref"


getTablesRef :: QueryExpr -> TableRefList 
getTablesRef (Select _ _ _ tr _ _ _ _ _ _) = tr 
getTablesRef (CombineQueryExpr _ _ _ _) = [] 
getTablesRef x = error (show x) 

getSelectList :: QueryExpr -> SelectList 
getSelectList (Select _ _ sl _ _ _ _ _ _ _) = sl


getSelectItemList :: QueryExpr -> [SelectItem]
getSelectItemList = getDeep . getSelectList    
        where getDeep (SelectList _ x) = x 


{-- Predicates --}
isTable :: Connection -> String -> IO Bool 
isTable c nm = do 
        xs <- quickQuery c "select table_type from information_schema.tables where table_name = ?" [toSql nm]
        return $ fromSql (head . head $ xs) == "BASE TABLE"


isJoin :: TableRef -> Bool 
isJoin (JoinTref _ _ _ _ _ _ _) = True 
isJoin _ = False 

isSelect :: QueryExpr -> Bool 
isSelect (Select _ _ _ _ _ _ _ _ _ _) = True
isSelect _ = False 


isTref :: TableRef -> Bool 
isTref (Tref _ _ _) = True 
isTref _ = False 

isSubTref :: TableRef -> Bool 
isSubTref (SubTref _ _ _) = True 
isSubTref _ = False 

{-- Pretty printers --}
toTXT :: [(String, [String])] -> String  
toTXT xs = render $ vcat $ oneLine <$> xs  

oneLine :: (String, [String]) -> Doc 
oneLine (x, xs) = text x $+$  
                    foldr step mempty xs
        where step x z = z $+$ nest 5 (text x)


slines :: [String] -> String 
slines xs = render $ foldr step mempty xs 
    where step x z = text x $+$ z  



printTANC :: TANC -> String 
printTANC d = let sp = selectPart d 
                  tp = tablePart d
                  na = nameAlias d 
              in render $ text "selectPart" $+$ 
                          (nest 5 $ foldr (\x z -> text (show x) $+$ z) mempty sp) $+$
                          text "tablePart" $+$ 
                          (nest 5 $ foldr (\x z -> text (show x) $+$ z) mempty tp) $+$
                          text "nameAlias" $+$ 
                          (nest 5 $ foldr (\x z -> text (show x) $+$ z) mempty na) 



showScalarExpr (FunCall _ p se) = text "Funcall" $+$ (nest 5 (text $ show $ getName p)) $+$ text "Name components scalar expression" $+$ 
                            (nest 5 $ text $ show $ foldr (\x z -> getNameComponentsFromScalarExpr x : z) [] se)
showScalarExpr (Cast _ xs _) = text "Cast" $+$ 
                              (nest 5 (text $ show $ getNameComponentsFromScalarExpr xs ))
showScalarExpr (NumberLit _ xs) = text "Number lit" $+$ 
                                            (nest 5 $ text $ show xs)
showScalarExpr x = text "ERROR IN SCALAR EXPR" $+$ (nest 5 $ text (show x))
showSubTref x = text "empty" $+$ text "show sub tref" $+$ (nest 5 $ text $ show x)


showSelectItemList :: SelectItem -> Doc 
showSelectItemList (SelExp _ se) = text "select expression" $+$ 
                                        (nest 5 $ text $ show se)  
showSelectItemList (SelectItem _ se a) = text "select item" $+$
                                         (nest 5 $ text $ show (se, a))

showJoinTref :: TableRef -> Doc 
showJoinTref (JoinTref _ l _ _ r o a) = text "show left table ref" $+$ 
                                        (nest 5 $ text $ show l) $+$
                                        text "show right table ref" $+$
                                        (nest 5 $ text $ show r) $+$
                                        text "On expr" $+$ 
                                        (nest 5 $ text $ show o) $+$
                                        text "alias" $+$
                                        (nest 5 $ text $ show a) 



showTableRef :: TableRef -> Doc 
showTableRef x@(isJoin -> True)  = text "Left table:" $+$ 
                             (nest 5 (showTableRef $ getTableLeft x)) $+$ 
                             text "Right table" $+$ 
                             (nest 5 (showTableRef $ getTableRight x))
showTableRef x@(isTref -> True) = text "Table reference:" $+$
                                (nest 5 $ text $ show (getTableRefTref x)) 
showOnExpr :: OnExpr -> Doc 
showOnExpr (Just d) = showJoinExpr d 

showJoinExpr :: JoinExpr -> Doc 
showJoinExpr (JoinOn _ s) = text "Join expr" $+$ (nest 5 $ text (show s))


{-- Debug tools --}
errorQuery = parseQueryExpr "" "select a.id from account a join (select d from car GROUP BY d) c on a.id = c.d"

bla :: Connection -> IO ()
bla c = do 
    views <- getViews c "doesx" "public" 
    print $ viewsToTables views 
    print $ tablesToViews views 


showQueryExpr = foldr (\x z -> showTableRef x $+$ z) mempty $ getTablesRef $ parseViewQuery testview

dumpUpdateDependencies :: IO ()
dumpUpdateDependencies = do 
                c <- conn 
                views <- getViewsDependencies c 
                writeFile "views-to-tables" $ toTXT views 
                writeFile "tables-to-views" $ toTXT (revertList views)

testview = "select a.id, a.energy, c.car from account a join car c on a.id = c.account_id" 
testNC = getNameComponentsSelect $ parseViewQuery testview
testq = "select a.id, d.id_c, c.lala from account a left join car c on a.id = car.account_id right join data d on d.car_id = c.id"
{-- Tools --}

-- | Revert dependencies views <-> tables
revertList :: [(String, [String])] -> [(String, [String])]
revertList xs = worker $ getTablesFromDependencies xs
        where worker = foldr step [] 
                    where step x z = let b = findT x xs 
                                     in (x, b) : z 

getTablesFromDependencies :: [(String, [String])] -> [String]
getTablesFromDependencies (fmap snd -> xs) = S.toList $ S.fromList (concat xs)

findT :: String -> [(String, [String])] -> [String]
findT nm xs = worker xs 
    where worker ((t, xs):xss) = if nm `elem` xs  
                                         then t : worker xss
                                         else worker xss
          worker [] = [] 

dumpTables :: Connection -> FilePath -> Type -> IO ()
dumpTables c fp t = do 
            xs <- searchTables c t 
            writeFile fp $ slines xs 

removeIfZero :: [(String, [String])] -> [(String, [String])]
removeIfZero [] = []
removeIfZero ((t, xs):xss) | null xs = removeIfZero xss 
                           | otherwise = (t, xs) : removeIfZero xss 

withConnection :: MonadIO m => (Connection -> m a) -> m a 
withConnection m = do 
            c <- liftIO $ connectPostgreSQL "host=192.168.1.77 dbname=deosx user=postgres port=5439 password=wetwetwet"
            a <- m c
            liftIO $ disconnect c
            return a

conn :: IO Connection 
conn = connectPostgreSQL' "host=192.168.1.77 dbname=deosx user=postgres port=5439 password=wetwetwet"



