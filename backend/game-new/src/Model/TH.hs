{-# LANGUAGE TemplateHaskell, NoMonomorphismRestriction, ViewPatterns #-}
module Model.TH where 

import Language.Haskell.TH
import Language.Haskell.Syntax
import Language.Haskell.TH.Lib
import Control.Monad
import Data.Maybe 
import Data.Default 
import Database.HDBC 
import Data.Database
import Data.List
import Control.Applicative
import qualified Data.Aeson as AS
import Data.InRules
import qualified Data.HashMap.Strict as H
import qualified Data.ByteString as B

checkTables :: String -> [(String,a)] -> Q ()
checkTables tbl (fmap fst -> xs) = runIO $ do 
                c <- dbconn 
                ns <- (fmap.fmap) fst $ describeTable c tbl 
                putStrLn $ "Checking " ++ (show tbl) ++ "..."
                when (not $ null (xs \\ ns)) $ error $ tbl ++ " is not correctly defined, clashing fields: " ++ (show $ xs \\ ns) 
                disconnect c
                return ()

{-- 
 -
 - And God saideth, let there be light. And I turneth the switch. 
 -
 --}

genAll :: String -> String -> [(String, Name)] ->  Q [Dec]
genAll nm tbl xs = do checkTables tbl xs
                      r <- genRecord nm xs  
                      i <- genInstance nm xs
                      d <- genDatabase nm tbl "id" xs
                      x <- genDefaultInstance nm xs
                      fj <- genInstanceFromJSON nm xs
                      tj <- genInstanceToJSON nm xs
                      fir <- genInstanceFromInRule nm xs
                      tir <- genInstanceToInRule nm xs
                      return $ r ++ i ++ d ++ x ++ fj ++ tj ++ fir ++ tir 

genAllId :: String -> String -> String -> [(String, Name)] -> Q [Dec]
genAllId nm tbl td xs = 
                   do checkTables tbl xs
                      r <- genRecord nm xs  
                      i <- genInstance nm xs
                      d <- genDatabase nm tbl td xs
                      x <- genDefaultInstance nm xs
                      fj <- genInstanceFromJSON nm xs
                      tj <- genInstanceToJSON nm xs
                      fir <- genInstanceFromInRule nm xs
                      tir <- genInstanceToInRule nm xs
 
                      return $ r ++ i ++ d ++ x ++ fj ++ tj ++ fir ++ tir 

-- genMapableRecord :: String -> [(String, Name)] -> Q [Dec]
genMapableRecord nm xs = do 
                r <- genRecord nm xs
                i <- genInstance nm xs
                d <- genDefaultInstance nm xs
                fj <- genInstanceFromJSON nm xs
                tj <- genInstanceToJSON nm xs
                fir <- genInstanceFromInRule nm xs
                tir <- genInstanceToInRule nm xs
 

                return $ r ++ i ++ d ++ fj ++ tj ++ fir ++ tir 

genRecord :: String -> [(String, Name)] -> Q [Dec]
genRecord nm xs = sequence [dataD (cxt []) (mkName nm) [] [recC (mkName nm) tp] ([''Show, ''Eq])]
    where
        tp = foldr step [] xs
        step (x,t) z = (varStrictType (mkName x) (strictType notStrict (conT t)))  : z 

genDatabase :: String -> String -> String -> [(String, Name)] ->  Q [Dec]
genDatabase n tbl td xs = sequence [instanceD (cxt []) (appT (appT (conT (mkName "Database")) (conT (mkName "Connection"))) (conT (mkName n))) (loadDb tbl td ++ saveDb tbl ++ searchDB tbl ++ deleteDb tbl ++ fieldsDb xs ++ tableDb tbl)]

genInstance :: String -> [(String, Name)] -> Q [Dec] 
genInstance nm xs = sequence [instanceD (cxt []) (appT (conT (mkName "Mapable")) (conT $ mkName nm)) (tmMap nm (fmap fst xs) ++ frmMap nm (fmap fst xs) ++ tmHashMap nm (fmap fst xs) ++ frmHashMap nm (fmap fst xs))]  

genDefaultInstance :: String -> [(String, Name)] -> Q [Dec]
genDefaultInstance nm xs = sequence [instanceD (cxt []) (appT (conT (mkName "Default")) (conT $ mkName nm)) fdn]
    where fdn = [funD (mkName "def") [clausem]]
          clausem = clause [] (decs) []
          decs  = normalB (recConE (mkName nm) mm)
          mm = fmap (\(x,y) -> fieldExp (mkName x) (sigE (varE (mkName "def")) (conT y) )) xs
tmMap n xs = [funD (mkName "toMap") [clausem]]
    where clausem = clause [varP (mkName "a")] (decs xs) []
          decs xs = normalB (foldr step mm xs) 
          mm = varE (mkName "sempty") 
          step x z = appE (appE (appE (varE (mkName "sinsert")) (stringE x)) f) z
                where f = appE (varE (mkName "htsql")) (appE (varE (mkName x)) (varE (mkName "a")))
frmMap n xs = [funD (mkName "fromMap") [clausem]]

    where clausem = clause [varP (mkName "m")] (decs xs) [] 
            where decs (x:xs) = normalB (foldl step (s x) xs)
                  lk x = appE (appE (varE (mkName "mlookup")) ((stringE x))) (varE $ mkName "m")
                  s x = appE (appE (varE (mkName "fmap")) (conE (mkName n))) (lk x)
                  step z x = appE (appE [|ap|] z) (lk x) 

loadDb :: String -> String -> [DecQ] 
loadDb n td = [funD (mkName "load") [clausem]]
    where clausem = clause [(varP (mkName "i"))] (normalB $ ff (appE decs [|[(td,  $(appE (varE $ mkName "htsql") (varE (mkName "i"))))]|])) []
            where decs = appE sl [| [ (td, $(varE $ mkName "cEQ")) ]|]
                  sl = appE (varE (mkName "select")) (stringE n)
                  ff = appE (varE $ mkName "nhead")
fieldsDb :: [(String, Name)] -> [DecQ]
fieldsDb xs = [funD (mkName "fields") $ [clause 
                    [varP (mkName "i")] (normalB $  
                        let xs' = fmap (\(x,y) -> (x, nameBase y)) xs 
                        in [|xs'|]) []
                    
                ]]
tableDb :: String -> [DecQ] 
tableDb s = [funD (mkName "tableName") [clause 
                    [varP (mkName "i")] (normalB ([|s|])) [] 
                ]
            ]


searchDB :: String -> [DecQ]
searchDB tbl = [funD (mkName "search") [clausem]]
    where clausem = clause [(varP (mkName "xs")), varP (mkName "order"), varP (mkName "limit"), varP (mkName "offset")] (normalB (appE (varE $ mkName "mfp") dec)) []
            where dec = appE (appE (varE $ mkName "transaction") (varE $ mkName "sqlGetAllAssoc")) decs
                  decs = appE (appE (appE sl ordr) lmt) offs
                  ordr = (varE (mkName "order")) 
                  offs = appE (conE $ mkName "Offset") (appE ((varE $ mkName "htsql")) (varE $ mkName "offset"))
                  lmt = appE (conE $ mkName "Limit") (appE (varE (mkName "htsql")) (varE (mkName "limit")))
                  sl = appE (appE (appE (conE (mkName "Select")) (appE (varE (mkName "table")) (stringE tbl))) ([|[ $(varE $ mkName "selectAll") ]|])) (varE $ mkName "xs")

deleteDb :: String -> [DecQ]
deleteDb tbl = [funD (mkName "delete") [clausem]]
    where clausem = clause [varP (mkName "e"), (varP (mkName "xs"))]  (normalB $ trn $ appE (appE (conE (mkName "Delete")) table) (varE $ mkName "xs")) []
            where table = appE (varE (mkName "table")) (stringE tbl)
                  trn x = appE (appE (varE (mkName "transaction")) (varE (mkName "sqlExecute"))) x 


saveDb :: String -> [DecQ]
saveDb n = [funD (mkName "save") [clausem]]
    where clausem = clause [(varP (mkName "i"))] (normalB $ appE (varE $ mkName "mco") decs) []
          decs = appE (appE (varE $ mkName "upsert") (stringE n)) (appE (varE $ mkName "toHashMap") (varE $ mkName "i"))

tmHashMap n xs = [funD (mkName "toHashMap") [clausem]]
    where clausem = clause [varP (mkName "a")] (decs xs) []
          decs xs = normalB (foldr step mm xs) 
          mm = varE (mkName "nempty") 
          step x z = appE (appE (appE (varE (mkName "ninsert")) (stringE x)) f) z
                where f = appE (varE (mkName "htsql")) (appE (varE (mkName x)) (varE (mkName "a")))



frmHashMap n xs = [funD (mkName "fromHashMap") [clausem]]
    where clausem = clause [varP (mkName "m")] (decs xs) [] 
            where decs (x:xs) = normalB (foldl step (s x) xs)
                  lk x = appE (appE (varE (mkName "nlookup")) ((stringE x))) (varE $ mkName "m")
                  s x = appE (appE (varE (mkName "fmap")) (conE (mkName n))) (lk x)
                  step z x = appE (appE [|ap|] z) (lk x) 

genInstanceToJSON name xs = sequence [instanceD (return []) (appT (conT ''AS.ToJSON) (conT $ mkName name)) ([mkToJson $ map fst xs])]
genInstanceFromJSON name xs = sequence [instanceD (return []) (appT (conT ''AS.FromJSON) (conT $ mkName name)) $ [mkParser name $ map fst xs ]]

mkParser :: String -> [String] ->  Q Dec  
mkParser cnst (x1:xs)  = funD (mkName "parseJSON") [cls]
    where cls = clause [] body []  
          body = normalB (lamE [conP (mkName "AS.Object") [varP vn]] $ foldl step start xs )
          apl = [|(<*>)|]
          start = appE (appE (varE (mkName "fmap")) (conE $ mkName cnst)) (appE (appE lku (varE vn)) (stringE x1))
          vn = mkName "v"
          lku = [|(AS..:)|]
          step z x = appE (appE apl z) (appE (appE lku (varE vn)) (stringE x))



mkToJson :: [String] -> Q Dec 
mkToJson xs = funD (mkName "toJSON") [cls]
    where cls = clause [] body []
          body = normalB $ (lamE [varP vn]) (appE start (foldr step (varE $ mkName "hempty") xs))
          start = [| AS.toJSON|] 
          vn = mkName "v"
          step x z = appE (appE (appE hinsert ((stringE x))) (appE start (appE (varE (mkName x)) (varE vn) ))) z
          hinsert = [|H.insert|]

hempty :: H.HashMap String AS.Value 
hempty = H.empty

hiempty :: H.HashMap String InRule 
hiempty = H.empty


hfromlist :: [(String, AS.Value)] -> H.HashMap String AS.Value 
hfromlist = H.fromList

hmlookup :: String -> H.HashMap String b -> b
hmlookup k m = fromJust $ H.lookup k m

genInstanceToInRule name xs = sequence [instanceD (return []) (appT (conT ''Data.InRules.ToInRule) (conT $ mkName name)) ([mkToInRule $ map fst xs])]
genInstanceFromInRule name xs = sequence [instanceD (return []) (appT (conT ''Data.InRules.FromInRule) (conT $ mkName name)) $ [mkFromInRule name $ map fst xs ]]

mkFromInRule :: String -> [String] ->  Q Dec  
mkFromInRule cnst (x1:xs)  = funD (mkName "fromInRule") [cls]
    where cls = clause [] body []  
          body = normalB (lamE [varP vn] $ mby `appE` foldl step start xs )
          apl = [|(<*>)|]
          start = appE (appE (varE (mkName "fmap")) (conE $ mkName cnst)) (appE (appE lku (varE vn)) (stringE x1))
          vn = mkName "v"
          lku = [|(\x y -> fromInRule <$>  (.>) x y)|]
          mby = [|fromJust|]
          step z x = appE (appE apl z) (appE (appE lku (varE vn)) (stringE x))



mkToInRule :: [String] -> Q Dec 
mkToInRule xs = funD (mkName "toInRule") [cls]
    where cls = clause [] body []
          body = normalB $ (lamE [varP vn]) (appE start (foldr step (varE $ mkName "hiempty") xs))
          start = [|toInRule|] 
          vn = mkName "v"
          step x z = appE (appE (appE hinsert ((stringE x))) (appE start (appE (varE (mkName x)) (varE vn) ))) z
          hinsert = [|H.insert|]


