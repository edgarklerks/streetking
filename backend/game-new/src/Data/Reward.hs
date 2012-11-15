{-# LANGUAGE ViewPatterns #-}
module Data.Reward where 


import Data.Event 

import Model.EventStream
import Model.Rule
import Model.Action
import Data.Decider 

import Text.Parsec.Combinator
import Text.Parsec.Prim hiding ((<|>), many)
import Text.Parsec.String
import Text.Parsec.Char
import Control.Applicative
import qualified Model.Rule as R
import qualified Model.Action as A 
import qualified Model.Account as ACC 
import qualified Model.EventStream as E 
import Model.General 
import Data.SqlTransaction 
import Control.Monad 
import Database.HDBC.SqlValue
import Database.HDBC.PostgreSQL
import Data.Database 
import Data.Maybe 
import qualified Model.RuleReward as RW 
import System.Random 
import qualified Model.RewardLog as RL 
import qualified Model.Transaction as TR 
import Control.Monad.Trans 


checkRewardLog :: Integer -> SqlTransaction Connection ()
checkRewardLog log = do 
                lg <- load log :: SqlTransaction Connection (Maybe RL.RewardLog)
                case lg of
                    Nothing -> rollback "no such log"
                    Just a -> do 
                        void $ save $ a {
                                    RL.viewed = True
                                }



activateRewards :: Integer -> SqlTransaction Connection () 
activateRewards uid = do 
            xs <- runEventStream uid
            forM_ xs $ \(n,e) -> 
                do
                    es <- search ["id" |== toSql e] [] 10000 0 :: SqlTransaction Connection [RW.RuleReward]
                    forM_ es $ \e -> do 
                                let x = (RW.change e)
                                z <- liftIO $ randomRIO (0, 99)
                                when (x > z) $ do 
                                        -- add shit to account 
                                        let mny = RW.money e
                                        let exp = RW.experience e 
                                        let nmn = RW.name e 
                                        ac <- fromJust <$> load uid :: SqlTransaction Connection (ACC.Account)


                                        TR.transactionMoney uid (def {
                                                    TR.amount = abs mny
                                                  , TR.type = "reward_money"
                                                  , TR.type_id = fromJust $ RW.id e
                                                                  })

                                        void $ save $ ac {
                                            ACC.respect = ACC.respect ac + exp
                                                 }
                                        -- save to reward log 

                                        void $ save $ def {
                                              RL.account_id = Just uid
                                            , RL.rule = RW.rule e
                                            , RL.name = RW.name e
                                            , RL.money = abs mny
                                            , RL.viewed = False 
                                            , RL.experience = exp 
                                            }
            return () 


loadRule :: Integer -> SqlTransaction Connection (String, Expr g Symbol, Bool)
loadRule i = do 
        r <- load i :: SqlTransaction Connection (Maybe R.Rule)
        case r of
            Nothing -> rollback "no such rule"
            Just x@(R.name -> n) -> case parse parseRule "" (R.rule x) of 
                            Left e -> rollback $ show e
                            Right a -> return (n,a, R.once x)


runEventStream :: Integer -> SqlTransaction Connection [(String, Integer)]
runEventStream uid = do 
          es <- search ["account_id" |== toSql uid .&& "active" |== toSql True] [] 10000 0 :: SqlTransaction Connection [E.EventStream]
          xs <- forM es $ \e -> do 
                (n,r,rb) <- loadRule (fromJust $ E.rule_id e)
                let (xs, b) = matchEvent r (E.stream e)  
                case b of 
                    False -> return []  
                    True -> do 
                            if rb 
                                then do 
                                    save (e {E.stream = xs, E.active = False})
                                    return [(n,fromJust $ E.rule_id e)]
                                else do 
                                    save (e {E.stream = xs})
                                    return [(n,fromJust $ E.rule_id e)]
                            
          return $ join xs 




-- parser voor Expr 

testParseRule = do 
    print $ parse parseRule "" ">6T[TRTP]{TRRR1}"
    print $ parse parseRule "" ">6[{TRP}{RPT}{T1,2PR124}]>5<6[TTT]"
    print $ parse parseRule "" "" 
    print $ parse parseRule "" "[[[T]]]" -- [T] 
-- T tournament
-- P practice
-- R race 
-- L level up 
-- T tournament 
-- T1 Tournament id 1 
-- T1,2 Tournament pos 1 id 2
-- R race 
-- R1 race pos 2 
-- {TR} -- tournament or race 
-- [TR] tournament and race 
-- >3T -- at least three tournament 
-- <3T -- at most three tournament 
-- >3<3 -- exactly 3 tournaments
-- >6[{TRP}{RPT}{T1,2PR124}]>5<6[TTT]
-- you have to get at least 6 of (one of TRP and one of RPT and (T id 2 at pos 1) and
-- P and R at pos 124) and between 15 and 18 tournaments.
--
-- >5<6[TTT] -- means you need to get between 5 and 6 three tournaments -- you need to get 15 and 18
-- tournaments 
optimize (All [(All xs)]) = optimize $ All (optimize <$> xs) 
optimize (Any [(Any xs)]) = optimize $ Any (optimize <$> xs)
optimize (All [t]) = optimize t
optimize (Any [t]) = optimize t 
optimize (Any xs) = Any (optimize <$> xs) 
optimize (All xs) = All ((joinSame xs))
optimize z = z 

joinSame xs = let (as,bs) = foldr splitAll ([],[]) xs
              in case as of 
                    [] -> (optimize <$> bs) 
                    [x] -> optimize x : (optimize <$> bs)
                    xs -> optimize <$> (optimize <$> xs) ++ (optimize <$> bs)
    where splitAll (All x) (alls,dfs) = (x ++ alls, dfs)
          splitAll x (alls, dfs) = (alls, x : dfs)

parseRule :: Parser (Expr g Symbol)
parseRule = optimize <$> (All <$> manyRules)



manyRules :: Parser [Expr g Symbol]
manyRules =  many matchRule 

testMatchRule = do  
        print $ parse matchRule "" ">5T"
        print $ parse matchRule "" ">5<6T"
        print $ parse matchRule "" "[T9,2R2T1P]"

matchRule :: Parser (Expr g Symbol)
matchRule = try fromtoE 
         <|> fromE 
         <|> toE 
         <|> allE 
         <|> anyE 
         <|> oneE 
         <?> "no such expression"

fromtoE :: Parser (Expr g Symbol)
fromtoE = FromTo <$> (char '>' *> integer) <*> (char '<' *> integer)  <*> matchRule  

fromE :: Parser (Expr g Symbol)
fromE = char '>' *> (From <$> integer <*> matchRule)

toE :: Parser (Expr g Symbol)
toE = char '<' *> ( To <$> integer <*> matchRule  )

allE :: Parser (Expr g Symbol)
allE = char '[' *> (All <$>  manyRules)  <* char ']'

anyE :: Parser (Expr g Symbol)
anyE = char '{' *> (Any <$> manyRules)  <* char '}'

oneE :: Parser (Expr g Symbol)
oneE = One <$> matchSymbol

-- tournament symbol
--

matchSymbol :: Parser Symbol
matchSymbol =  try tournamentI
           <|> tournamentS 
           <|> try levelI
           <|> levelS 
           <|> try raceI 
           <|> raceS 
           <|> try practiceI
           <|> practiceS 
           <?> "undefined symbol"


tournamentI :: Parser Symbol 
tournamentI = string "T" *> 
                        (TournamentI <$> 
                            (try (Just <$> integer <* char ',') <|> pure Nothing)
                            <*> integer)


tournamentS :: Parser Symbol 
tournamentS = string "T" *> pure TournamentS 

levelI :: Parser Symbol 
levelI = string "L" *> (LevelI <$> integer)

levelS :: Parser Symbol 
levelS = string "L" *> pure LevelS 

raceI :: Parser Symbol
raceI = string "R" *> (RaceI <$> integer)

raceS :: Parser Symbol
raceS = string "R" *> pure RaceS 

practiceI :: Parser Symbol 
practiceI = string "P" *> (PracticeI <$> integer) 

practiceS :: Parser Symbol
practiceS = string "P" *> pure PracticeS  


integer :: Parser Integer 
integer = read <$> many1 num 

num :: Parser Char 
num = oneOf "1234567890"


-- This should you know, kinda work. 
-- Cryptofascism is so avant-garde.   
--
testTournament =do 
            print $ parse matchSymbol "" "T2,3"  
            print $ parse matchSymbol "" "T"
            print $ parse matchSymbol "" "P123"
            print $ parse matchSymbol "" "P"
            print $ parse matchSymbol "" "R123"
            print $ parse matchSymbol "" "R"
            print $ parse matchSymbol "" "L123"
            print $ parse matchSymbol "" "L"
              
                
