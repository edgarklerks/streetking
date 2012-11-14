#!/bin/sh 

if [ ! -f setup-nodes ]; then 
        echo "need setup-nodes from src/setup-nodes.hs";
        exit;
fi 
./setup-nodes "tcp://172.18.0.10:92237" "tcp://172.18.0.10:10232" advertise "tcp://172.18.0.10:10259"
./setup-nodes "tcp://172.18.0.10:92235" "tcp://172.18.0.10:10259" advertise "tcp://172.18.0.10:10232"
./setup-nodes "tcp://172.18.0.10:92239" "tcp://172.18.0.10:10259" dumpinfo 
./setup-nodes "tcp://172.18.0.10:92231" "tcp://172.18.0.10:10232" dumpinfo 


