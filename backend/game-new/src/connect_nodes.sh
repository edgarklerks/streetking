./setup-nodes "tcp://192.168.1.230:92132" "tcp://192.168.1.230:10232" advertise "tcp://192.168.1.230:10239"
./setup-nodes "tcp://192.168.1.230:92132" "tcp://192.168.1.230:10239" advertise "tcp://192.168.1.230:10232"
./setup-nodes "tcp://127.0.0.1:92132" "tcp://192.168.1.230:10239" dumpinfo 
./setup-nodes "tcp://127.0.0.1:92132" "tcp://192.168.1.230:10232" dumpinfo 


