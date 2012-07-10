{-# LANGUAGE NoMonomorphismRestriction #-}
module Main where 


import Database.HDBC
import Database.HDBC.PostgreSQL hiding (begin)
import System.Environment 
import Vector 
import Data.Binary 
import qualified Data.ByteString.Lazy as B
import Control.Applicative
import Control.Monad
import Data.Maybe 


db = connectPostgreSQL "host=db.graffity.me user=deosx password=#*rl& dbname=streetking_dev";

data Cell = Cell {
        begin :: Vector Double,
        end :: Vector Double,
        curvature :: Maybe Double,
        radius :: Maybe Double,
        arclength :: Double 
    }

instance Binary Cell where 
    put (Cell a b c d e) = put a >> put b >> put c >> put d >> put e
    get = Cell <$> get <*> get <*> get <*> get <*> get


main :: IO ()
main = do 
    xs <- getArgs 
    let dst = read (xs !! 0) :: Int
    let dbin = xs !! 1
    let sbin = xs !! 2
    let cbin = xs !! 3
    let cid  = xs !! 4 
    dsb <- decode <$> B.readFile dbin 
    print dsb
    seg <- decode <$> B.readFile sbin 
    cel <- decode <$> B.readFile cbin 
    dumpDatabase dst dsb seg cel cid 
    return ()

jsonArray :: [(Int,Int)] -> String 
jsonArray x = "[" ++ jsonPair x ++ "]"

jsonPair :: [(Int,Int)] -> String 
jsonPair [] = ""
jsonPair [(x,y)] = "[" ++ show x ++ "," ++ show y ++ "]"
jsonPair ((x,y):xs) = "[" ++ (show x) ++ "," ++ (show y) ++ "]," ++ jsonPair xs

dumpDatabase :: Int -> [(Int,Int)] -> [[Vector Double]] -> [Cell] -> String -> IO ()
dumpDatabase (fromIntegral -> dst) dsb seg cel cid = do 
                                  let xs = getData cel dsb 
                                  c <- db 
                                  stm <- prepare c "insert into track_section (track_id, radius,length,segment) values (?,?,?,?)" 
                                  forM_ xs $ \(c, ps) -> do 
                                                let r = fromMaybe 0 (radius c)
                                                execute stm [toSql cid, toSql (r * dst), toSql (arclength c * dst), toSql (jsonArray ps)] 
                                  commit c
                                  disconnect c
                                  


getData :: [Cell] -> [(Int,Int)] -> [(Cell, [(Int,Int)])]
getData c xs = foldr step [] c  
        where step x z = (x, takeWhile (/=e') . dropWhile (/=b') $ xs) : z
                where b = begin x
                      e = end x 
                      b' = (truncate $ getX b, truncate $ getY b) 
                      e' = (truncate $ getX e, truncate $ getY e)
