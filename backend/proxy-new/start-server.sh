#!/bin/sh 
killall proxy-new
killall game-new 
killall setup-nodes
#valgrind --leak-check=full --leak-resolution=high -v --num-callers=40 --track-origins=yes  --log-file="valgrind.log" --trace-children=yes  ./dist/build/proxy-new/proxy-new --no-compression -p $1 +RTS -K256M -N2 -w -Sstatsp.log -qg & 
./dist/build/proxy-new/proxy-new --no-compression -p $1 +RTS -K256M -N4 -w -Sstatsp.log & 

cd ../game-new/
./start-server.sh
cd ../proxy-new/
