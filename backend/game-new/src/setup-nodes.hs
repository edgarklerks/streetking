module Main where 

import Proto 
import MemServerAsync 
import System.Environment



main :: IO ()
main = do 
    xs <- getArgs 
    case xs of 
        [i,o,"advertise",y] -> clientCommand i o (advertise y)
        [i,o,"dumpinfo"] -> clientCommand i o (dumpInfo) 
        _ -> do 
                print "usage setup-nodes (local data) (remote ctrl) advertise (remote-srv)"
                print "usage setup-nodes (local data) (remote ctrl) dumpinfo"




