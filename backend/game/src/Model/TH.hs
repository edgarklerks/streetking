{-# LANGUAGE TemplateHaskell, NoMonomorphismRestriction #-}
module Model.TH where 

import Language.Haskell.TH
import Language.Haskell.TH.Lib
import Control.Monad
import Data.Maybe 
import Data.Default 

{-- 
 -
 - And God saideth, let there be light. And I turneth the switch. --}

genAll :: String -> String -> [(String, Name)] ->  Q [Dec]
genAll nm tbl xs = do r <- genRecord nm xs  
                      i <- genInstance nm xs
                      d <- genDatabase nm tbl
                      x <- genDefaultInstance nm xs
                      return $ r ++ i ++ d ++ x

genRecord :: String -> [(String, Name)] -> Q [Dec]
genRecord nm xs = sequence [dataD (cxt []) (mkName nm) [] [recC (mkName nm) tp] ([''Show, ''Eq])]
    where
        tp = foldr step [] xs
        step (x,t) z = (varStrictType (mkName x) (strictType notStrict (conT t)))  : z 

genDatabase :: String -> String -> Q [Dec]
genDatabase n tbl = sequence [instanceD (cxt []) (appT (appT (conT (mkName "Database")) (conT (mkName "Connection"))) (conT (mkName n))) (loadDb tbl ++ saveDb tbl ++ searchDB tbl)]

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

loadDb n = [funD (mkName "load") [clausem]]
    where clausem = clause [(varP (mkName "i"))] (normalB $ ff (appE decs [|[("id",  $(appE (varE $ mkName "htsql") (varE (mkName "i"))))]|])) []
            where decs = appE sl [| [ ("id", $(varE $ mkName "cEQ")) ]|]
                  sl = appE (varE (mkName "select")) (stringE n)
                  ff = appE (varE $ mkName "nhead")

searchDB tbl = [funD (mkName "search") [clausem]]
    where clausem = clause [(varP (mkName "xs")), varP (mkName "order"), varP (mkName "limit"), varP (mkName "offset")] (normalB (appE (varE $ mkName "mfp") dec)) []
            where dec = appE (appE (varE $ mkName "transaction") (varE $ mkName "sqlGetAllAssoc")) decs
                  decs = appE (appE (appE sl ordr) lmt) offs
                  ordr = (varE (mkName "order")) 
                  offs = appE (conE $ mkName "Offset") (appE ((varE $ mkName "htsql")) (varE $ mkName "offset"))
                  lmt = appE (conE $ mkName "Limit") (appE (varE (mkName "htsql")) (varE (mkName "limit")))
                  sl = appE (appE (appE (conE (mkName "Select")) (appE (varE (mkName "table")) (stringE tbl))) ([|[ $(varE $ mkName "selectAll") ]|])) (varE $ mkName "xs")

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

