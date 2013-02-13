#!/usr/bin/zsh 

./connect_nodes.sh & 
./dist/build/game-new/game-new --no-compression -p 9123 +RTS -K256M -N2 -w -Sstatsg.log -RTS
