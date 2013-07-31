module Main where 


import System.Random 



main = undefined 

data Model = Model {
            task_end :: Integer, 
            task_updated :: Integer, 
            skill :: Integer, 
            rate :: Double,
            current_improvement :: Integer, 
            current_time :: Integer,
            seed :: StdGen 

    } deriving Show

def s = Model {
        task_end = 1000 + 120 * 60 * 1000,
        task_updated = 0,
        skill = 50,
        rate = 0.0000015,
        current_improvement = 0,
        current_time = 1000,
        seed = s
    }
steps s = let bs = part_improve_model (0.9,1) 1000 (2 * 60 * 60) (def s)
        in ((/100) .  fromIntegral . current_improvement) `fmap` bs 


part_improve_model :: (Double, Double) -> Integer -> Int -> Model -> [Model]
part_improve_model  range ss n m = take n $ iterate step m
    where step x = let ut = max 0 $ min (task_end x) (current_time x) - task_updated x 
                       sk = skill x 
                       pr' = rate x  
                       a = fromIntegral (sk * ut)
                       ci = round (a * pr') 
                       (rnd, seed') = randomR range $ seed x 
                   in if ci >= 1 then 
                            x {
                                task_updated = current_time x,
                                current_improvement = min (10^4) $ current_improvement x + ci,
                                 current_time = current_time x + ss,
                                 seed = seed' 
                            }
                        else x {
                                current_time = current_time x + ss,
                                seed = seed' 
                            }

                   
