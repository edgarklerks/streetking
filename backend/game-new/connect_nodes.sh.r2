#!/bin/sh 

# richard is een sukkel
if [ ! -f setup-nodes ]; then 
        echo "need setup-nodes from src/setup-nodes.hs";
        exit;
fi 
./setup-nodes "tcp://172.18.0.10:92137" "tcp://172.18.0.10:10232" advertise "tcp://172.18.0.10:10239"
./setup-nodes "tcp://172.18.0.10:92135" "tcp://172.18.0.10:10239" advertise "tcp://172.18.0.10:10232"
./setup-nodes "tcp://172.18.0.10:92139" "tcp://172.18.0.10:10239" dumpinfo 
./setup-nodes "tcp://172.18.0.10:92131" "tcp://172.18.0.10:10232" dumpinfo 


