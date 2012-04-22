module Data.DatabaseTemplate where 

import qualified Data.Database as D 
import qualified Data.HashMap.Strict as S 
import Data.SqlTransaction
import Data.Maybe  

data DTD = Con D.ConOp String String 
        | And DTD DTD  
        | Or DTD DTD 
    deriving Show 

(+&&) = And 
(+||) = Or 

(+==) = Con D.OpEQ 
(+>=) = Con D.OpGTE 
(+>) = Con D.OpGT 
(+<) = Con D.OpLT 
(+<=) = Con D.OpLTE 
(+%) = Con D.OpContains
(+%%) = Con D.OpIContains

infixr 2 +||
infixr 3 +&& 

infix 4 +== 
infix 4 +>= 
infix 4 +>
infix 4 +< 
infix 4 +<= 
infix 4 +% 
infix 4 +%% 

dtd :: DTD -> S.HashMap String SqlValue -> D.Constraints 
dtd x = maybeToList . evalDTD x

evalDTD :: DTD -> S.HashMap String SqlValue -> Maybe D.Constraint
evalDTD (And x y) p = case evalDTD x p of 
                        Nothing -> evalDTD y p
                        Just n -> case evalDTD y p of 
                            Nothing -> return $ n 
                            Just p -> return $ D.And n p
evalDTD (Or x y) p = case evalDTD x p of 
                      Nothing -> evalDTD y p 
                      Just n -> case evalDTD y p of 
                            Nothing -> return $ n 
                            Just p -> return $ D.Or n p
evalDTD (Con c x y) p = do 
                case (S.lookup y p) of 
                        Nothing -> Nothing 
                        Just p -> case c of 
                                D.OpEQ -> return $ x D.|== p 
                                D.OpGTE -> return $ x D.|>= p
                                D.OpLTE -> return $ x D.|<= p 
                                D.OpGT -> return $ x D.|< p 
                                D.OpLT -> return $ x D.|> p 
                                D.OpContains -> return $ x D.|% p
                                D.OpIContains -> return $ x D.|%% p
