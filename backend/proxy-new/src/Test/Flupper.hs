module Test.Flupper where 

import Test.App 
import Control.Monad.Trans 
import qualified Data.HashMap.Strict as S 
import qualified Data.ByteString.Lazy as L 
import Data.Maybe 
import Control.Applicative
import Control.Concurrent


testServer = TS "127.0.0.1" 9003
bareServer = TS "127.0.0.1" 9123

main = do xs <- runTests test testServer 
          print xs 

bareTests = do xs <- runTests testTournament bareServer 
               print xs

testTournament = do 
       setMethod "POST" 
       setName "tournament get test" 
       setQuery [("userid", "34")] 
       setResource "Tournament" 
       setAction "get" 
       setArguments [("tournament_id", "124")] 
       initRequest (\r -> liftIO (print r) *> setSucceed True ) 

       setMethod "POST"
       setName "tournament result test"
       setAction "result"
       setArguments [("tournament_id", "124")] 
       initRequest (\r -> liftIO (print r) *> setSucceed True)




application_token = setMethod "POST" *>
                    setName "get application token" *>
                    setResource "Application" *> 
                    setAction "identify" *> 
                    setQuery [("token", "demodemodemo")] *>
                    initRequest (\r -> let k = fromJust $ S.lookup "result" (getMap r)
                                       in setQuery [("application_token", k)] *> setSucceed True) 

                    

user_token = setMethod "POST" *> 
             setName "get user token" *> 
             setResource "User" *> 
             setAction "login" *>
             setArguments [
                    ("email", "edgar.klerks@gmail.com"),
                    ("password", "wetwetwet")
                ] *>
             initRequest (\r -> let k = fromJust $ S.lookup "result" (getMap r)
                                in modifyQuery (("user_token", k):) *> setSucceed True ) 
                            

test = application_token *> 
       user_token *>
       userMe *>
       gameTree


userMe = setName "user me" *>
         setMethod "GET" *>
         setResource "User" *> 
         setAction "me" *>
         setArguments [] *>
         pass 

gameTree = setName "game tree test" *> 
           setMethod "GET" *> 
           setResource "Game" *> 
           setAction "tree" *>
           setArguments [] *> 
           pass

pass = run (const True)

getMap :: Response -> S.HashMap String String 
getMap r = fromJust (decode $ responseBody r) 
                                                                               
