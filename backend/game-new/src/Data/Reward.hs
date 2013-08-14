{-# LANGUAGE ViewPatterns, RecordWildCards, ScopedTypeVariables #-}
module Data.Reward where 

import           Control.Applicative
import           Control.Monad 
import           Control.Monad.Trans 
import           Data.Conversion
import           Data.Database 
import           Data.Decider 
import           Data.Event 
import           Data.List as List
import           Data.Maybe 
import           Data.Monoid hiding (Any, All) 
import           Data.SqlTransaction 
import           Database.HDBC.PostgreSQL
import           Database.HDBC.SqlValue
import           Model.Action
import           Model.EventStream
import           Model.General 
import           System.Random 
import           Text.Parsec.Char
import           Text.Parsec.Combinator
import           Text.Parsec.Prim hiding ((<|>), many)
import           Text.Parsec.String
import qualified Data.Account as DA
import qualified Model.Account as ACC 
import qualified Model.Action as A 
import qualified Model.EventStream as E 
import qualified Model.RewardLog as RL 
import qualified Model.RewardLogEvents as RLE 
import qualified Model.Rule as R
import qualified Model.RuleReward as RW 
import qualified Model.Transaction as TR 

newtype Rewards = Rewards {
                    unRewards :: [Reward]
                  }
    deriving (Show)
instance ToInRule Rewards where 
        toInRule (Rewards xs) = toInRule xs 
instance ToInRule Reward where 
        toInRule (Reward rl nm prz) = fromList $ [
                                      ("rule", toInRule rl)
                                    , ("name", toInRule nm)
                                    , ("prizes", toInRule prz)
                                ]


instance ToInRule Prize where 
    toInRule (Money x) = fromList $ [("money", InInteger x)]
    toInRule (Experience x) = fromList $ [("experience", InInteger x)]

data Reward = Reward {
                rule :: String,
                name :: String,
                prizes :: [Prize]
            }
    deriving (Show)

data Prize  = Money Integer 
            | Experience Integer 
    deriving (Show)

transform :: RL.RewardLog -> Reward 
transform rw = Reward {
              rule = RL.rule rw
            , name = RL.name rw 
            , prizes = [
                      Money (RL.money rw)
                    , Experience (RL.experience rw)
                ]
        }

testRewards = transformRewards $ [
             RL.RewardLog (Just 1) (Just 1) "1" "1" 1 True 2    
           , RL.RewardLog (Just 2) (Just 1) "2" "2" 2 True 3  
           , RL.RewardLog (Just 3) (Just 1) "1" "1" 3 True 4  
           , RL.RewardLog (Just 3) (Just 1) "1" "1" 3 True 6 

    ]
transformRewards :: [RL.RewardLog] -> Rewards
transformRewards xs = concatRewards $ Rewards $ transform <$> xs 

concatRewards :: Rewards -> Rewards 
concatRewards (Rewards xs) = Rewards $ foldr step [] xs  
    where step x [] = [x] 
          step x (y:ys) | name x == name y && rule x == rule y = (x `dot` y) : ys
                        | otherwise = y : step x ys 
          dot :: Reward -> Reward -> Reward 
          dot (Reward rl nm prs) (Reward _ _ qrs) = Reward rl nm (joinReward $ prs <> qrs)
          joinReward xs = foldr prize [] xs
                where prize x [] = [x]
                      prize x (y:ys) = case (x,y) of 
                                        (Money x, Money y) -> Money (x + y) : ys 
                                        (Experience x, Experience y) -> Experience (x + y) : ys
                                        otherwise -> y : prize x ys 
            

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
            forM_ xs $ \(n,e,ess) -> 
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

                                        -- add experience to account
                                        -- void $ save $ ac { ACC.respect = ACC.respect ac + exp }
                                        void $ DA.addRespect uid exp

                                        let (rids, tids, pids) = extractEvent ess 

                                        -- save to reward log 
                                        reward_id <- save $ def {
                                              RL.account_id = Just uid
                                            , RL.rule = RW.rule e
                                            , RL.name = RW.name e
                                            , RL.money = abs mny
                                            , RL.viewed = False 
                                            , RL.experience = exp 
                                            }
                                        saveRewardLogEvent rids tids pids reward_id 
            return () 

saveRewardLogEvent :: [Integer] -> [Integer] -> [Integer] -> Integer -> SqlTransaction Connection ()
saveRewardLogEvent rs ts ps rewid = do 
                forM_ rs $ \r -> do 

                        save (def {
                               RLE.type = "race",
                               RLE.type_id = r,
                               RLE.reward_log_id = rewid
                            })
                forM_ ts $ \t -> do 
                        save (def {
                                RLE.type = "tournament",
                                RLE.type_id = t,
                                RLE.reward_log_id = rewid 
                                  })
                forM_ ps $ \p -> do 
                        save (def {
                                RLE.type = "practice",
                                RLE.type_id = p,
                                RLE.reward_log_id = rewid
                                  })


extractEvent :: [Event] -> ([Integer], [Integer], [Integer])
extractEvent xs = foldr step ([],[],[]) xs 
        where step x (rs,ts,ps) = case x of 
                                    Tournament _ i _ -> (rs,  i : ts, ps)
                                    PracticeRace _ i -> ( rs, ts, i: ps)
                                    ChallengeRace _ _ i -> (i : rs,ts, ps) 
                                    otherwise -> (rs,ts,ps) 

loadRule :: Integer -> SqlTransaction Connection (String, Expr g Symbol, Bool)
loadRule i = do 
        r <- load i :: SqlTransaction Connection (Maybe R.Rule)
        case r of
            Nothing -> rollback "no such rule"
            Just x@(R.name -> n) -> case parse parseRule "" (R.rule x) of 
                            Left e -> rollback $ show e
                            Right a -> return (n,a, R.once x)


runEventStream :: Integer -> SqlTransaction Connection [(String, Integer, [Event])]
runEventStream uid = do 
          es <- search ["account_id" |== toSql uid .&& "active" |== toSql True] [] 10000 0 :: SqlTransaction Connection [E.EventStream]
          xs <- forM es $ \e -> do 
                (n,r,rb) <- loadRule (fromJust $ E.rule_id e)
                let stream = fromJust $ E.stream e <|> Just [] 
                let (xs, b) = matchEvent r stream 
                case b of 
                    False -> return []  
                    True -> do 
                            if rb 
                                then do 
                                    save (e {E.stream = Just xs, E.active = False})
                                    return [(n,fromJust $ E.rule_id e, stream List.\\ xs)]
                                else do 
                                    save (e {E.stream = Just xs})
                                    return [(n,fromJust $ E.rule_id e, stream List.\\ xs)]
                            
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

ruleToExpression :: String -> Expr g Symbol 
ruleToExpression  xs = case parse parseRule "" xs of 
                            Left e -> Any [] 
                            Right a -> a 

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
           <|> try raceI 
           <|> raceS 
           <|> try practiceI
           <|> practiceS 
           <|> missionI
           <?> "undefined symbol"


missionI :: Parser Symbol 
missionI = string "M" *> (MissionI <$> integer)


tournamentI :: Parser Symbol 
tournamentI = string "T" *> (uncurry3 TournamentI <$>  parseTriple)


tournamentS :: Parser Symbol 
tournamentS = string "T" *> pure (TournamentI Nothing Nothing Nothing)

levelI :: Parser Symbol 
levelI = string "L" *> (LevelI <$> integer)


raceI :: Parser Symbol
raceI = string "R" *> (uncurry RaceI <$> parsePair)

raceS :: Parser Symbol
raceS = string "R" *> pure (RaceI Nothing Nothing)

practiceI :: Parser Symbol 
practiceI = string "P" *> (PracticeI <$> parseArg) 

practiceS :: Parser Symbol
practiceS = string "P" *> pure (PracticeI Nothing)


uncurry3 :: (a -> b -> c -> d) -> (a,b,c) -> d
uncurry3 f (a,b,c) = f a b c

parseTriple :: Parser (Maybe Integer, Maybe Integer, Maybe Integer)
parseTriple = do 
        x <- parseArg 
        char ','
        y <- parseArg 
        char ','
        z <- parseArg 
        return (x,y,z)

parsePair :: Parser (Maybe Integer, Maybe Integer)
parsePair = do 
        x <- parseArg 
        char ','
        y <- parseArg 
        return (x,y)

parseArg :: Parser (Maybe Integer)
parseArg = parseEmpty <|> parseInteger  

    where parseEmpty :: Parser (Maybe Integer)
          parseEmpty = char '_' *> pure Nothing 
          parseInteger :: Parser (Maybe Integer)
          parseInteger = Just <$> integer 

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
              

eitherToMaybe :: Either a b -> Maybe b 
eitherToMaybe (Left e) = Nothing 
eitherToMaybe (Right a) = Just a 

rewardAction :: Event -> SqlTransaction Connection [RW.RuleReward] 
rewardAction sb = do 
    xs <- search [] [] 1000000 0 :: SqlTransaction Connection [RW.RuleReward]
    let ys =  flip fmap xs $ \rw -> 
                let step x | match sb x = Just rw 
                           | otherwise = Nothing 
                in step =<< toOne  =<< eitherToMaybe (parse parseRule "" (RW.rule rw))

    return $ catMaybes ys

