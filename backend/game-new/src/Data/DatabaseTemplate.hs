{-# LANGUAGE ViewPatterns #-}
-- | DSL for expression queries, which can extract data from 
-- | a map and build a database contstraint from the DSL.
-- | We have two operators a lifted one, which pulls the 
-- | right side from the map and the left side is the field in the database.
-- | "id" +== "user-id"
-- | This generates id = 1 (if user_id contains 1)
-- | We also have fixed operators, which don't pull up a value from the hash map, 
-- | but have a fixed value
-- | "id" +==| (toSql 12)
-- | There also is an if statement:
-- | ifdtd ("account" +==| 1)
module Data.DatabaseTemplate where 

import qualified Data.Database as D 
import qualified Data.HashMap.Strict as S 
import Data.SqlTransaction
import Data.Maybe  
import Database.HDBC.Types
import Data.SortOrder 

data DTD = Con D.ConOp String DTD 
        | And DTD DTD  
        | Or DTD DTD 
        | Lift String 
        | Fix SqlValue  
        | If String (String -> Bool) DTD DTD
        | OrderedBy DTD [String]
        | Nop

orderedBy = OrderedBy 

-- | Transform a DTD bottom up  
transformDTD :: (DTD -> DTD) -> DTD -> DTD 
transformDTD f z = p z 
    where 
        p (And x y) = f $ And (transformDTD f x) (transformDTD f y)
        p (Or x y) = f $ Or (transformDTD f x) (transformDTD f y)
        p (Con x y z) = f $ Con x (y) (transformDTD f z)
        p t@(Lift x) = f t
        p t@(Fix a) = f t
        p (If v p d e) = f $ If v p (transformDTD f d) (transformDTD f e)
        p (OrderedBy x y) = f $ OrderedBy (transformDTD f x) y

-- | Filter certain DTD out 
filterDTD :: (DTD -> Bool) -> DTD -> DTD 
filterDTD f = transformDTD step 
    where 
        step x | f x   = Nop 
               | otherwise = x

(+&&) = And 
(+||) = Or 

-- | Equal operator 
(+==) x y = Con D.OpEQ x (Lift y)
(+>=) x y = Con D.OpGTE x (Lift y)
(+>) x y = Con D.OpGT x (Lift y)
(+<) x y = Con D.OpLT x (Lift y)
(+<=) x y = Con D.OpLTE x (Lift y)
-- | Like 
(+%) x y = Con D.OpContains x (Lift y)
-- | ILike 
(+%%) x y = Con D.OpIContains x (Lift y)
(+<>) x y = Con D.OpNEQ x (Lift y)
ifdtd = If

infixr 2 +||
infixr 3 +&& 

infix 4 +<>
infix 4 +== 
infix 4 +>= 
infix 4 +>
infix 4 +< 
infix 4 +<= 
infix 4 +% 
infix 4 +%% 

(+==|) x y = Con D.OpEQ x (Fix y)
(+>=|) x y = Con D.OpGTE x (Fix y)
(+>|) x y = Con D.OpGT x (Fix y)
(+<|) x y = Con D.OpLT x (Fix y)
(+<=|) x y = Con D.OpLTE x (Fix y)
(+%|) x y = Con D.OpContains x (Fix y)
(+%%|) x y = Con D.OpIContains x (Fix y)
(+<>|) x y = Con D.OpNEQ x (Fix y)

infix 4 +<>|
infix 4 +==| 
infix 4 +>=|
infix 4 +>|
infix 4 +<|
infix 4 +<=| 
infix 4 +%| 
infix 4 +%%| 


dtd :: DTD -> S.HashMap String SqlValue -> D.Constraints 
dtd x = maybeToList . evalDTD x

evalDTD :: DTD -> S.HashMap String SqlValue -> Maybe D.Constraint
evalDTD Nop p = Nothing 
evalDTD (OrderedBy _ _) p = Nothing 
evalDTD (If t pred i e) p = case S.lookup t p of 
                                Nothing -> evalDTD e p 
                                Just v -> case pred (fromSql v) of 
                                                True -> evalDTD i p
                                                False -> evalDTD e p
                                                
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
evalDTD (Con c x (Fix (toSql -> y))) p =  case c of 
                                D.OpEQ -> return $ x D.|== y 
                                D.OpGTE -> return $ x D.|>= y
                                D.OpLTE -> return $ x D.|<= y 
                                D.OpGT -> return $ x D.|< y 
                                D.OpLT -> return $ x D.|> y 
                                D.OpContains -> return $ x D.|% y
                                D.OpIContains -> return $ x D.|%% y
                                D.OpNEQ -> return $ x D.|<> y
            
evalDTD (Con c x (Lift y)) p = do 
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
                                D.OpNEQ -> return $ x D.|<> p
