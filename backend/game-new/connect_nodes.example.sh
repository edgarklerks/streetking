#!/bin/sh 

if [ ! -f setup-nodes ]; then 
        echo "need setup-nodes from src/setup-nodes.hs";
        exit;
fi
 
./setup-nodes "tcp://192.168.4.12:92137" "tcp://192.168.4.12:20232" advertise "tcp://192.168.4.12:20239"
./setup-nodes "tcp://192.168.4.12:92137" "tcp://192.168.4.12:20239" advertise "tcp://192.168.4.12:20232"
./setup-nodes "tcp://192.168.4.12:92139" "tcp://192.168.4.12:20239" dumpinfo 
./setup-nodes "tcp://192.168.4.12:92131" "tcp://192.168.4.12:20232" dumpinfo 


