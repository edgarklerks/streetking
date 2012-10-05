#!/bin/sh 

if [ ! -f setup-nodes ]; then 
        echo "need setup-nodes from src/setup-nodes.hs";
        exit;
fi 
./setup-nodes "tcp://192.168.1.108:92137" "tcp://192.168.1.108:10232" advertise "tcp://192.168.1.108:10239"
./setup-nodes "tcp://192.168.1.108:92135" "tcp://192.168.1.108:10239" advertise "tcp://192.168.1.108:10232"
./setup-nodes "tcp://192.168.1.108:92139" "tcp://192.168.1.108:10239" dumpinfo 
./setup-nodes "tcp://192.168.1.108:92131" "tcp://192.168.1.108:10232" dumpinfo 


