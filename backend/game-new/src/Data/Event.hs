{-# LANGUAGE GADTs, FlexibleContexts, FlexibleInstances,
 MultiParamTypeClasses, OverloadedStrings #-}
-- | Event expression matcher primitives 
module Data.Event where 

import Data.Decider
import Data.Conversion
import qualified Data.Aeson as AS
import qualified Data.Vector as V 
import Control.Monad 
import qualified Data.Text as T 
import Data.Attoparsec.Number 
-- S means match always 
-- I means match only with cond


data Symbol where 
     -- TournamentI :: pos -> id -> type id  
    TournamentI :: Maybe Integer -> Maybe Integer -> Maybe Integer -> Symbol 
    LevelI :: Integer -> Symbol 
    RaceI :: Maybe Integer -> Maybe Integer -> Symbol 
    PracticeI :: Maybe Integer -> Symbol 
 deriving Show 


matchEvent :: Expr g Symbol -> [Event] -> ([Event], Bool) 
matchEvent e = runDecider (eventDecider e)

eventDecider :: Expr g Symbol -> Decider Event  
eventDecider = buildDecider match 

 -- Elke regel heeft zijn eigen stream per gebruiker 
 -- die worden opgeslagen in de database
 -- streams worden parallel afgehandeld. 
 -- position and then id 
data Event where 
    -- pos and Id
    Tournament :: Integer -> Integer -> Integer -> Event 
    -- Race practice  place 
    PracticeRace :: Integer -> Integer -> Event
    ChallengeRace :: Integer -> Integer -> Integer -> Event 
    -- Level 
    Level :: Integer -> Event      
        deriving (Show, Eq)



instance ToInRule Event where 
    toInRule (Tournament p d t) = InArray [InString "T", InInteger p, InInteger d, InInteger t]
    toInRule (PracticeRace p lid) = InArray [InString "P", InInteger p, InInteger lid]
    toInRule (ChallengeRace p t lid) = InArray [InString "R", InInteger p, InInteger t, InInteger lid]
    toInRule (Level p) = InArray [InString "L", InInteger p]


instance FromInRule Event where 
    fromInRule (InArray [InString "T", InInteger p, InInteger d, InInteger t]) = Tournament p d t
    fromInRule (InArray [InString "P", InInteger p, InInteger l]) = PracticeRace p l
    fromInRule (InArray [InString "R", InInteger p, InInteger t, InInteger l]) = ChallengeRace p t l
    fromInRule (InArray [InString "L", InInteger p]) = Level p 




instance AS.ToJSON Event where 
        toJSON = fromInRule . toInRule 

instance AS.FromJSON Event where 
        parseJSON (AS.Array x) = case x V.! 0 of 
                                    (AS.String "T") -> return $ Tournament (toInt $ x V.! 1) (toInt $ x V.! 2) (toInt $ x V.! 3)
                                    (AS.String "P") -> return $ PracticeRace (toInt $ x V.! 1) (toInt $ x V.! 2) 
                                    (AS.String "R") -> return $ ChallengeRace (toInt $ x V.! 1) (toInt $ x V.! 2) (toInt $ x V.! 3)
                                    (AS.String "L") -> return $ Level (toInt $ x V.! 1)
                                    otherwise -> mzero 
        parseJSON _ = mzero 

toInt :: AS.Value -> Integer
toInt (AS.Number (I x)) = x

cmp :: Eq a => Maybe a -> a -> Bool 
cmp Nothing _ = True 
cmp (Just a) b | a == b = True 
               | otherwise = False 

instance Evaluate Event Symbol where 
-- | Matcher for tournament types 
    match (Tournament pos id type_id) (TournamentI x y z) = cmp x pos && cmp y id && cmp z type_id  
    match (PracticeRace track_id _) (PracticeI x) = cmp x track_id 
    match (ChallengeRace pos tid _) (RaceI x y) = cmp x pos && cmp y tid 
    match (Level i) (LevelI p) = i == p
    match _ _ = False  
                                                                                
