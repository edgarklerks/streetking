#!/bin/sh 
killall proxy-new
killall game-new 
killall setup-nodes
./dist/build/proxy-new/proxy-new --no-compression -p $1 +RTS -K256M -N2 -w -Sstatsp.log -qg & 
cd ../game-new/
./start-server.sh
cd ../proxy-new/
