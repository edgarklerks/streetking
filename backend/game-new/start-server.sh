#!/bin/sh 

./connect_nodes.sh & 
./dist/build/game-new/game-new -p 9123 +RTS -prof  
