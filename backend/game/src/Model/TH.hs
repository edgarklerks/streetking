{-# LANGUAGE TemplateHaskell #-}
module Model.TH where 

import Language.Haskell.TH
import Language.Haskell.TH.Lib
import Control.Monad
import Data.Maybe 


genRecord :: String -> [(String, Name)] -> Q [Dec]
genRecord nm xs = sequence [dataD (cxt []) (mkName nm) [] [recC (mkName nm) tp] ([''Show, ''Eq])]
    where
        tp = foldr step [] xs
        step (x,t) z = (varStrictType (mkName x) (strictType notStrict (conT t)))  : z 

genDatabase :: String -> String -> Q [Dec]
genDatabase n tbl = sequence [instanceD (cxt []) (appT (appT (conT (mkName "Database")) (conT (mkName "Connection"))) (conT (mkName n))) (loadDb tbl ++ saveDb tbl)]

genInstance :: String -> [(String, Name)] -> Q [Dec] 
genInstance nm xs = sequence [instanceD (cxt []) (appT (conT (mkName "Mapable")) (conT $ mkName nm)) (tmMap nm (fmap fst xs) ++ frmMap nm (fmap fst xs) ++ tmHashMap nm (fmap fst xs) ++ frmHashMap nm (fmap fst xs))]  


tmMap n xs = [funD (mkName "toMap") [clausem]]
    where clausem = clause [varP (mkName "a")] (decs xs) []
          decs xs = normalB (foldr step mm xs) 
          mm = varE (mkName "sempty") 
          step x z = appE (appE (appE (varE (mkName "sinsert")) (stringE x)) f) z
                where f = appE (varE (mkName "htsql")) (appE (varE (mkName x)) (varE (mkName "a")))
frmMap n xs = [funD (mkName "fromMap") [clausem]]

    where clausem = clause [varP (mkName "m")] (decs xs) [] 
            where decs (x:xs) = normalB (foldr step (s x) xs)
                  lk x = appE (appE (varE (mkName "mlookup")) ((stringE x))) (varE $ mkName "m")
                  s x = appE (appE (varE (mkName "fmap")) (conE (mkName n))) (lk x)
                  step x z = appE (appE [|ap|] z) (lk x) 

loadDb n = [funD (mkName "load") [clausem]]
    where clausem = clause [(varP (mkName "i"))] (normalB $ ff (appE decs [|[("id",  $(appE (varE $ mkName "htsql") (varE (mkName "i"))))]|])) []
            where decs = appE sl [| [ ("id", $(varE $ mkName "cEQ")) ]|]
                  sl = appE (varE (mkName "select")) (stringE n)
                  ff = appE (varE $ mkName "nhead")

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
            where decs (x:xs) = normalB (foldr step (s x) xs)
                  lk x = appE (appE (varE (mkName "nlookup")) ((stringE x))) (varE $ mkName "m")
                  s x = appE (appE (varE (mkName "fmap")) (conE (mkName n))) (lk x)
                  step x z = appE (appE [|ap|] z) (lk x) 

