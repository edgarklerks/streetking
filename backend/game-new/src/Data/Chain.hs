{-# LANGUAGE MultiParamTypeClasses, TypeFamilies, RankNTypes, NoMonomorphismRestriction, GADTs, DeriveDataTypeable, OverloadedStrings, TemplateHaskell, TypeSynonymInstances, FlexibleInstances, OverlappingInstances, UndecidableInstances, TypeOperators  #-}
module Data.Chain where 

import Data.Typeable 
import Data.DataPack
import Data.Aeson.TH 

import qualified Data.Aeson as AS
import qualified Model.Task as TK
import Data.SqlTransaction
import Database.HDBC.PostgreSQL

class Execute f  where 
    executeTask :: f -> TK.Task -> SqlTransaction Connection Bool 

instance Execute (Succ a) where 
    executeTask f d = rollback "no task handler"

data Zero

data Succ  a  

type One = Succ Zero 
type Two = Succ One 
type Three = Succ Two 
type Four = Succ Three 
type Five = Succ Four 
type Six = Succ Five 
type Seven = Succ Six 
type Eight = Succ Seven 
type Nine = Succ Eight 
type Ten = Succ Nine 
type Eleven = Succ Ten 
type Twelfe = Succ Eleven
type Thirteen = Succ Twelfe
type Fourteen = Succ Thirteen
type Fifteen = Succ Fourteen 
type Sixteen = Succ Fifteen 
type Seventeen = Succ Sixteen
type Eighteen = Succ Seventeen
type Nineteen = Succ Eighteen 
type Twenty = Succ Nineteen 



type family (:+:) a b 

type instance (:+:) (Succ a) (Succ (Succ b)) = (:+:) (Succ (Succ a)) (Succ b) 
type instance (:+:) (Succ a) One =  Succ (Succ a)
type instance (:+:) (Succ a) Zero = Succ a

type family (:*:) a b
type instance (:*:) Zero (Succ (Succ b)) = Zero 
type instance (:*:) Two Zero = Zero
type instance (:*:) Two One = Two
type instance (:*:) Two Two = Four
type instance (:*:) Two Three = Six 
type instance (:*:) Two Four = Eight 
type instance (:*:) Two Five = Ten
type instance (:*:) Two Six = Twelfe
type instance (:*:) Two Seven = Fourteen
type instance (:*:) Two Eight = Sixteen
type instance (:*:) Two Nine = Eighteen 
type instance (:*:) Two Ten = Twenty 
-- Two Twelve  
type instance (:*:) Two (Succ (Succ (Succ (Succ (Succ (Succ (Succ (Succ (Succ (Succ (Succ a))))))))))) = (Eleven :+: Eleven)  :+: (Two :*: a)
type instance (:*:) Three Zero = Zero 
type instance (:*:) Three One = Three 
type instance (:*:) Three Two = Six 
type instance (:*:) Three Three = Nine 
type instance (:*:) Three Four = Twelfe 
type instance (:*:) Three Five = Fifteen 
type instance (:*:) Three Six = Eighteen
type instance (:*:) Three Seven = Three :+: Eighteen 
type instance (:*:) Three Eight = Two :*: Three  :+: Three :*: Six
type instance (:*:) Three Nine = Twenty :+: Seven 
type instance (:*:) Three Ten = Twenty :+: Ten
type instance (:*:) Three (Succ (Succ (Succ (Succ (Succ (Succ (Succ (Succ (Succ (Succ (Succ a))))))))))) = (Twenty :+: Thirteen)  :+: Three :*: a

type instance (:*:) (Succ (Succ (Succ (Succ a)))) b =  Succ (Succ (Succ a)) :*: b :+: b

type family (:-:) a b 
type instance (:-:) b Zero = b 
type instance (:-:) Zero b = Zero 
type instance (:-:) (Succ b) (Succ a) = b :-: a


type family Fib a  
type instance Fib Zero = Zero
type instance Fib One = One 
type instance Fib (Succ (Succ a)) = Fib (Succ a) :+: Fib (a)

infixl 7 :*:
infixl 6 :+: 

plus :: a -> Succ a 
plus _ = undefined 

class Number a where 
        toNum :: a -> Int 


instance Number Zero where 
        toNum _ = 0 

instance Number a => Number (Succ a) where 
        toNum f = 1 + toNum (minus f)



minus :: Succ a -> a 
minus = undefined 



