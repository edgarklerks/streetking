{-# LANGUAGE GADTs, FlexibleContexts, FlexibleInstances,
 MultiParamTypeClasses, OverloadedStrings #-}
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
    TournamentI :: Maybe Integer -> Integer -> Symbol 
    TournamentS :: Symbol 
    LevelS :: Symbol 
    LevelI :: Integer -> Symbol 
    RaceS :: Symbol
    RaceI :: Integer -> Symbol 
    PracticeS :: Symbol
    PracticeI :: Integer -> Symbol 
 deriving Show 


matchEvent :: Expr g Symbol -> [Event] -> ([Event], Bool) 
matchEvent e = runDecider (eventDecider e)

eventDecider :: Expr g Symbol -> Decider Event  
eventDecider = buildDecider match 

 -- Elke regel heeft zijn eigen stream per gebruiker 
 -- die worden opgeslagen in de database
 -- streams worden parallel afgehandeld. 

data Event where 
    -- place and Id
    Tournament :: Integer -> Integer -> Event 
    -- Race practice  place 
    PracticeRace :: Integer -> Event
    ChallengeRace :: Integer -> Event 
    -- Level 
    Level :: Integer -> Event      
        deriving (Show, Eq)



instance ToInRule Event where 
    toInRule (Tournament p d) = InArray [InString "T", InInteger p, InInteger d]
    toInRule (PracticeRace p) = InArray [InString "P", InInteger p]
    toInRule (ChallengeRace p) = InArray [InString "R", InInteger p]
    toInRule (Level p) = InArray [InString "L", InInteger p]


instance FromInRule Event where 
    fromInRule (InArray [InString "T", InInteger p, InInteger d]) = Tournament p d 
    fromInRule (InArray [InString "P", InInteger p]) = PracticeRace p 
    fromInRule (InArray [InString "R", InInteger p]) = ChallengeRace p 
    fromInRule (InArray [InString "L", InInteger p]) = Level p 




instance AS.ToJSON Event where 
        toJSON = fromInRule . toInRule 

instance AS.FromJSON Event where 
        parseJSON (AS.Array x) = case x V.! 0 of 
                                    (AS.String "T") -> return $ Tournament (toInt $ x V.! 1) (toInt $ x V.! 2)
                                    (AS.String "P") -> return $ PracticeRace (toInt $ x V.! 1) 
                                    (AS.String "R") -> return $ ChallengeRace (toInt $ x V.! 1)
                                    (AS.String "L") -> return $ Level (toInt $ x V.! 1)
                                    otherwise -> mzero 
        parseJSON _ = mzero 

toInt :: AS.Value -> Integer
toInt (AS.Number (I x)) = x
instance Evaluate Event Symbol where 
    match (Tournament pos id) (TournamentI Nothing ids) | id == ids = True
    match (Tournament pos id) (TournamentI (Just p) ids) | id == ids && pos == p = True 
    match (Tournament _ _) (TournamentS ) = True 
    match (Level _) LevelS = True 
    match (Level n) (LevelI p) | n == p = True 
    match (ChallengeRace _) RaceS = True 
    match (ChallengeRace n) (RaceI s) | n == s = True 
    match (PracticeRace _) PracticeS = True 
    match (PracticeRace n) (PracticeI p) | n == p = True 



