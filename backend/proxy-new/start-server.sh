#!/bin/sh 
killall proxy-new
killall game-new 
./dist/build/proxy-new/proxy-new -p $1 & 
cd ../game-new/
./start-server.sh
cd ../proxy-new/
