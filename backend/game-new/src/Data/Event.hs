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
import qualified Data.List as L 
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


toTemplatish :: Int -> Expr g Symbol -> String 
toTemplatish ind (All xs) = indent ind ++ "DO_ALL_OF{" ++  L.intercalate "" (toTemplatish (ind + 1) <$> xs) ++ "}" 
toTemplatish ind (Any xs) = indent ind ++ "DO_ANY_OF{" ++  L.intercalate "" (toTemplatish (ind+1)  <$> xs) ++ "}" 
toTemplatish ind (FromTo p q x) | p == q = indent ind ++ "DO_EXACTLY{" ++ (show p) ++ " " ++ toTemplatish (ind + 1) x  ++ "}"
toTemplatish ind (FromTo p q x) = indent ind ++ "DO_BETWEEN{" ++ (show p) ++ "," ++ (show q) ++ " " ++ toTemplatish (ind + 1) x  ++ "}"
toTemplatish ind (From p x)  = indent ind ++ "DO_AT_LEAST{" ++ (show p) ++ " " ++ toTemplatish (ind + 1) x ++ "}" 
toTemplatish ind (To p x) = indent ind ++ "DO_AT_MOST{" ++ (show p) ++ " " ++ toTemplatish (ind + 1) x ++ "}" 
toTemplatish ind (One p) = indent ind ++ toTemplatishSymbol p 
    where toTemplatishSymbol (TournamentI p i t) = "TOURNAMENT{"  ++ pos ++ id ++ typ ++ "}" 
                where pos = maybe "" (\x -> " POS{ " ++ show (x)) p ++ "}" 
                      id = maybe "" (\x -> " TOURNAMENT{ " ++ (show x)) i ++ "}"  
                      typ = maybe "" (\x -> " and type: " ++ (show x)) t 
          toTemplatishSymbol (LevelI i) = "grow to or be at level: " ++ (show i)
          toTemplatishSymbol (RaceI p i) = "win a race" ++ pos ++ id 
                where pos = maybe "" (\x -> " at pos: " ++ (show x)) p
                      id = maybe "" (\x -> " and track_id: " ++ (show x)) i
          toTemplatishSymbol (PracticeI i) = "PRACTICE{" ++ id  ++ "}" 
                where id = maybe "" (\x -> " TRACK_ID: " ++ (show x)) i 
          toTemplatishSymbol (MissionI n) = "do mission " ++ (show n)


indent :: Int -> String  
indent n  = ('\n':(replicate (n * 4) ' '))

toEngrish :: Int -> Expr g Symbol -> String 
toEngrish ind (All xs) = indent ind ++ "do all of " ++  L.intercalate "" (toEngrish (ind + 1) <$> xs) ++ "" 
toEngrish ind (Any xs) = indent ind ++ "choose any of " ++  L.intercalate "" (toEngrish (ind+1)  <$> xs) ++ "" 
toEngrish ind (FromTo p q x) | p == q = indent ind ++ "do the following " ++ (show p) ++ " times:  " ++ toEngrish (ind + 1) x  ++ " "
toEngrish ind (FromTo p q x) = indent ind ++ "do the following between " ++ (show p) ++ " and " ++ (show q) ++ " times:  " ++ toEngrish (ind + 1) x  ++ " "
toEngrish ind (From p x)  = indent ind ++ "do the following at least " ++ (show p) ++ " times: " ++ toEngrish (ind + 1) x ++ "" 
toEngrish ind (To p x) = indent ind ++ "do the following at most " ++ (show p) ++ " times: " ++ toEngrish (ind + 1) x ++ "" 
toEngrish ind (One p) = indent ind ++ toEngrishSymbol p 
    where toEngrishSymbol (TournamentI p i t) = "win a tournament"  ++ pos ++ id ++ typ
                where pos = maybe "" (\x -> " at pos: " ++ show (x)) p 
                      id = maybe "" (\x -> " and tournament_id: " ++ (show x)) i 
                      typ = maybe "" (\x -> " and type: " ++ (show x)) t 
          toEngrishSymbol (LevelI i) = "grow to or be at level: " ++ (show i)
          toEngrishSymbol (RaceI p i) = "win a race" ++ pos ++ id 
                where pos = maybe "" (\x -> " at pos: " ++ (show x)) p
                      id = maybe "" (\x -> " and track_id: " ++ (show x)) i
          toEngrishSymbol (PracticeI i) = "practice" ++ id  
                where id = maybe "" (\x -> " at track_id: " ++ (show x)) i 
          toEngrishSymbol (MissionI n) = "do mission " ++ (show n)

{-- 
do all of
   do the following between 5 and 6 times: 
                choose any of (win a tournament, win a race, practice) ), 
                choose any of (win a race, practice, win a tournament), 
                do the following at most 6 times: (
                                        do all of (
                                            win a race, 
                                            do the following at most 3 times: 
                                                    (practice), 
                                            do the following at most 4 times: 
                                                    (win a tournament)
                                        )
                            )
--}
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
                                                                                
