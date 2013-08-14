{-# LANGUAGE GADTs, FlexibleContexts, FlexibleInstances,
 MultiParamTypeClasses, OverloadedStrings #-}
-- | Event expression matcher primitives 
module Data.Event where 

import Data.Decider
import Data.Conversion
import qualified Data.Aeson as AS
import qualified Data.Vector as V 
import Control.Monad 
import Control.Applicative
import qualified Data.Text as T 
import Data.Attoparsec.Number 
import Data.InRules
import Data.Convertible 
import qualified Data.HashMap.Strict as Map
import Data.Aeson
import Data.Maybe 
-- S means match always 
-- I means match only with cond


data Symbol where 
     -- TournamentI :: pos -> id -> type id  
    TournamentI :: Maybe Integer -> Maybe Integer -> Maybe Integer -> Symbol 
    LevelI :: Integer -> Symbol 
    RaceI :: Maybe Integer -> Maybe Integer -> Symbol 
    PracticeI :: Maybe Integer -> Symbol 
    MissionI :: Integer -> Symbol 
 deriving Show 

instance ToInRule Symbol where 
    toInRule (TournamentI pos id typ) = InObject $ Map.fromList $ 
                                [("string", InString "tournament"),
                                 ("pos", InString (fromMaybe "" (show <$> pos))),
                                 ("tournament_id", InString (fromMaybe "" (show <$> id))),
                                 ("type_id", InString (fromMaybe "" (show <$> typ)))
                                 ] 
    toInRule (LevelI l) = InObject $ Map.fromList $ [
                            ("string", InString "level"),
                            ("level", InInteger l)
                        ]
    toInRule (PracticeI i) = InObject $ Map.fromList $ [
                            ("string", InString "practice"),
                            ("track_id", InString (fromMaybe "" (show <$> i)))
            ]
    toInRule (MissionI i) = InObject $ Map.fromList $ [
                            ("string", InString "mission"),
                            ("mission_id", InInteger i)
                        ]
    toInRule (RaceI pos id) = InObject $ Map.fromList $ [
                            ("string", InString "race"),
                            ("track_id", InString (fromMaybe "" (show <$> id))),
                            ("pos", InString (fromMaybe "" (show <$> pos))) 
            ]


testSymbolRule = All [One $ PracticeI (Just 2), One $ PracticeI  Nothing, One $ TournamentI (Just 1) Nothing (Just 3), Any [One $ PracticeI (return 9), One $ PracticeI $ return 12]]
instance ToInRule (Expr g Symbol) where 
       toInRule (Any xs) = InObject $ Map.fromList [
                                        ("string" , InString "any"),
                                        ("object", InArray $ toInRule <$> xs)
                                    ]
       toInRule (All xs) = InObject $ Map.fromList [
                                        ("string", InString "all"),
                                        ("object", InArray $ toInRule <$> xs)
                                    ]
       toInRule (FromTo p q x) = InObject $ Map.fromList [
                                        ("string", InString "between"),
                                        ("from", InInteger p), 
                                        ("to", InInteger q),
                                        ("object", toInRule x)
                                ]
       toInRule (One p) =  toInRule p 
       toInRule (From p q) = InObject $ Map.fromList [
                                ("string", InString "from"),
                                ("from", InInteger p),
                                ("object", toInRule q)
                ]
       toInRule (To p q) = InObject $ Map.fromList [
                                ("string", InString "to"),
                                ("to", InInteger p),
                                ("object", toInRule q)
                ]

 

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
    Mission :: Integer -> Event 
        deriving (Show, Eq)



instance ToInRule Event where 
    toInRule (Tournament p d t) = InArray [InString "T", InInteger p, InInteger d, InInteger t]
    toInRule (PracticeRace p lid) = InArray [InString "P", InInteger p, InInteger lid]
    toInRule (ChallengeRace p t lid) = InArray [InString "R", InInteger p, InInteger t, InInteger lid]
    toInRule (Level p) = InArray [InString "L", InInteger p]
    toInRule (Mission l) = InArray [InString "M", InInteger l]


instance FromInRule Event where 
    fromInRule (InArray [InString "T", InInteger p, InInteger d, InInteger t]) = Tournament p d t
    fromInRule (InArray [InString "P", InInteger p, InInteger l]) = PracticeRace p l
    fromInRule (InArray [InString "R", InInteger p, InInteger t, InInteger l]) = ChallengeRace p t l
    fromInRule (InArray [InString "L", InInteger p]) = Level p 
    fromInRule (InArray [InString "M", InInteger p]) = Mission p 



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

-- | Matcher for tournament types 
instance Evaluate Event Symbol where 
    match (Tournament pos id type_id) (TournamentI x y z) = cmp x pos && cmp y id && cmp z type_id  
    match (PracticeRace track_id _) (PracticeI x) = cmp x track_id 
    match (ChallengeRace pos tid _) (RaceI x y) = cmp x pos && cmp y tid 
    match (Level i) (LevelI p) = i == p
    match (Mission i) (MissionI p) = i == p 
    match _ _ = False  
                                                                                
