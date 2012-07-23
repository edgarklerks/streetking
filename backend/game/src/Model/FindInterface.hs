{-# LANGUAGE TemplateHaskell, OverloadedStrings, NoMonomorphismRestriction #-}
module Model.FindInterface where 

import Language.Haskell.TH
import Language.Haskell.TH.Syntax
import Control.Applicative
import qualified Data.Aeson as AS
import Data.InRules
import qualified Data.HashMap.Strict as H
import qualified Data.ByteString as B

findInstance :: String -> [String] -> ExpQ 
findInstance x xs = do 
        i <- reifyInstances (mkName x) ((ConT . mkName) <$> xs) 
        showE i 


showReify :: String -> ExpQ 
showReify t = do 
    s <- reify (mkName t)
    showE s
    

showE :: (Show a) => a -> ExpQ 
showE = stringE . show 


mkInstanceDeclToJSON name xs = sequence [instanceD (return []) (appT (conT ''AS.ToJSON) (conT $ mkName name)) ([mkToJson xs])]
mkInstanceDeclFromJSON name xs = sequence [instanceD (return []) (appT (conT ''AS.FromJSON) (conT $ mkName name)) $ [mkParser  name xs ]]



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
hfromlist :: [(String, AS.Value)] -> H.HashMap String AS.Value 
hfromlist = H.fromList 


{-
data Test = Test {
        a :: Int,
        b :: Int 
    }
-}


-- LamE [ConP Data.Aeson.Types.Internal.Object [VarP v]] (InfixE (Just (InfixE (Just (ConE Model.FindInterface.Test)) (VarE Data.Functor.<$>) (Just (InfixE (Just (VarE v_1627442293)) (VarE Data.Aeson.Types.Class..:) (Just (LitE (StringL \"test\"))))))) (VarE Control.Applicative.<*>) (Just (InfixE (Just (VarE v_1627442293)) (VarE Data.Aeson.Types.Class..:) (Just (LitE (StringL \"test2\"))))))
--
 -- information from a splice 
 -- $(stringE . show =<< [|myncode|])
 --
 -- create a splice:
 -- [|<*>|]
 -- splice into haskell:
 -- $([|<*>|])


-- "LamE [VarP c_1627404679] (InfixE (Just (VarE Data.Aeson.Types.Class.toJSON)) (VarE GHC.Base.$) (Just (InfixE (Just (VarE Data.HashMap.Strict.fromList)) (VarE GHC.Base.$) (Just (ListE [TupE [LitE (StringL \"a\"),AppE (VarE Model.FindInterface.a) (VarE c_1627404679)],TupE [LitE (StringL \"b\"),AppE (VarE Model.FindInterface.b) (VarE c_1627404679)]])))))
