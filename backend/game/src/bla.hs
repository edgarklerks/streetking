module Main where 


main :: IO ()
main = print bla 

bla :: Int 
bla = foldr (+) 0 [1,2,3,4,5,6,7,8,9,10] 
