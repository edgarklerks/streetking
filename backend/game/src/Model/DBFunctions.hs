{-# LANGUAGE TemplateHaskell, NoMonomorphismRestriction #-}
module Model.DBFunctions where 

import Language.Haskell.TH
import Language.Haskell.TH.Lib
import Language.Haskell.TH.Ppr
import Control.Monad
import Data.SqlTransaction
import Control.Applicative
import Data.SqlTransaction

type Arg = Name 
type Args = [Arg]
type Ret = Name 
type FName = String 
type Definition = String 
type Arity = Int 

data FType = Row | Scalar 
    deriving Show
data Function = F FType FName Args Ret 
    deriving Show

data SqlFunction = SF FName FType Arity Args Definition Ret 
    deriving Show 



mkFunctions :: [(String, [Name], Name, FType)] -> Q [Dec]
mkFunctions xs = sequence $ (sqlFunctionToSql . ftosql)  <$> step
            where step = fmap (\(x, args, ret, ft) -> F ft x args ret) xs




ftosql :: Function -> SqlFunction 
ftosql (F t name xs ret) = SF name t (length xs) xs (mkFunc name xs) ret
    where mkFunc nm (x:xs) = "select " ++ n ++ " " ++ nm ++ "(" ++ "?" ++ foldr step "" xs ++ ")"
            where step x z =  ",?" ++ z
                  n = case t of 
                        Scalar -> ""
                        Row -> "* from"


sqlFunctionToSql (SF name Scalar ra arg def ret) = funD (mkName name) [clausem]
                where clausem = clause args (decs) [] 

                -- Fold over the arguments to obtain the argument list 
                      decs = normalB (sigE (appE (varE $ mkName "fromSql") (appE (appE (varE $ mkName "sqlGetOne") (stringE def)) argn)) (conT  ret))
                      args = foldr step [] (arg `zip` [1..])
                      step (x,i) z = sigP (varP (mkName ("a" ++ show i))) (tpe x) : z
                            where tpe x = conT x
                      argn = listE $ foldr (\i  z -> ((appE (varE $ mkName "toSql")) $ varE $ mkName $ "a" ++ show i) : z) [] (snd <$> arg `zip` [1..])

  
-- New function declaration 
sqlFunctionToSql (SF name Row ra arg def ret) = funD (mkName name) [clausem]
                where clausem = clause args (decs) [] 

                -- Fold over the arguments to obtain the argument list 
                      decs = normalB (appE (appE (varE $ mkName "sqlGetAllAssoc") (stringE def)) argn)
                      args = foldr step [] (arg `zip` [1..])
                      step (x,i) z = sigP (varP (mkName ("a" ++ show i))) (tpe x) : z
                            where tpe x = conT x
                      argn = listE $ foldr (\i z -> ((appE (varE $ mkName "toSql")) $ varE $ mkName $ "a" ++ show i) : z) [] (snd <$> arg `zip` [1..])

                    
                                                    
                                                    
                

-- "select function(?,?,?,?)" 

ft :: String -> [SqlValue] -> SqlTransaction Connection SqlValue 
ft xs = undefined  
        

