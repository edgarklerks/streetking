#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <string.h>
#include <math.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <netdb.h>
#include <unistd.h>
#include <time.h>

enum Method {
    GET,
    POST,
    PUT,
    DELETE,
    OPTIONS,
    HEAD
};

const char * httpVersion = "HTTP/1.1";
const char * contentLength = "Content-Length:";
const char * hostHeader = "Host:";

void error(const char *);

char * buildPacket (enum Method, char *, char *, char *);
int doRequest(char *, int, char *);
int methodSize(enum Method);
const char * methodString(enum Method);


int main(int argc, char * argv[]){
        /* prebuilt packet */

        if(argc < 3){
                error("not enough parameters");
        }

        char * ps = buildPacket(GET, 
                        "r3.graffity.me",
                        argv[1],
                        argv[2]);
       
        int i = 0;

        int successes = 0;
        int fails = 0;
        time_t successTime = 0; 
        time_t failTime = 0; 
        for(i = 0; i < 50; i++){

            time_t btime = time(0);
            int n = doRequest("r3.graffity.me", 9003, ps);
            time_t etime = time(0);
            if(n == 1){
                    successes++;
                    successTime += (etime - btime);
            } else {
                fails++;
                failTime += (etime - btime);
            }
        }

        printf("%d %d %d %d", successes, successTime, fails, failTime);


        return 0; 
}

int doRequest(char * host, int port, char * packet){
        int sock;
        struct sockaddr_in serv_addr;
        struct hostent *server;
        /* Create IP/TCP socket */
        sock = socket(AF_INET, SOCK_STREAM, 0);
        if (sock < 0){
            error("Cannot open socket");
        }

        server = gethostbyname(host);
        if(server == 0){
            error("Cannot lookup server");
        }
        
        /* Copy relevant information from lookup record to serv_addr */
        bzero( (char *) &serv_addr, sizeof(serv_addr));
        serv_addr.sin_family = AF_INET;
        bcopy(
                        (char *)server->h_addr,
                        (char *)&serv_addr.sin_addr.s_addr,
                        server->h_length);
        serv_addr.sin_port = htons(port);
        
        if (connect(sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr)) < 0){
            error("cannot connect to host");
        }
        /* Write packet to server */

        int n = write(sock, packet, strlen(packet));
        if(n < 0){
            error("cannot write to server");
        }

        /* read from server only first part of line:
         * HTTP/1.1 2 */ 
        int bufferSize = 11;

        char * buffer = malloc(bufferSize);

        bzero(buffer, bufferSize);

        n = read(sock, buffer, bufferSize - 1);

        close(sock);
        
        if(n < 0){
            error("Error read from server");
        }
        if( (char)*(buffer + 9) == '2'){
                return 1;
        }
        

        return 0;
    
    
}
 /* 
  * Form of HTTP Request packet:
  * (GET|POST|PUT|DELETE|OPTIONS|HEAD) (URI) (HTTPVERSION)
  * (HEADERS)
  *
  * Content-Length is obligatory
  */

/* Builds a minimal http packet */
char * buildPacket (enum Method p, char * host, char * uri, char * content){
        

        int sizeu = strlen(uri);
        int sizec = strlen(content);
        int sizem = methodSize(p);

        /* First build the header,
         * the header size is: 
         * methodsize + 1 + urisize + 1 + versionsize + 1
         * + contentLengthHeader size + 1 + contentLength size + 
         * hostHeader size + 1 + host size + 2
         *
         * = 
         * methodsize + urisize + versionsize + contentLength size + 
         * contentLengthHeader size + hostHeader size + host size 
         * 8 (for control characters) + 1 (for null)
         * */

        int headerSize = 4 + 9 + sizem + sizeu +  
                        strlen(httpVersion) +
                        strlen(contentLength) + 
                        strlen(hostHeader) + 
                        strlen(host) +  
                        /* number of decimals is the truncated (log of a number) + 1 */
                        (int)trunc(log10((double)sizec) + 1); 

        char * packet = malloc(headerSize + sizec) ;
        snprintf(packet, headerSize + sizec, 
                         "%s %s %s\r\n"
                         "%s %d\r\n"
                         "%s %s\r\n\r\n%s",
                         methodString(p), uri, httpVersion,
                         contentLength, sizec,
                         hostHeader, host,
                         content
                         );
        return packet;



}

const char * methodString(enum Method p){
    if (p == PUT)
        return "PUT";
    if (p == GET)
        return "GET";
    if (p == POST)
        return "POST";
    if (p == DELETE)
        return "DELETE";
    if (p == HEAD)
        return "HEAD";
    if (p == OPTIONS)
        return "OPTIONS";

    return "GET";

}

int methodSize(enum Method p){
    if(p == PUT || p == GET)
            return 3;
    if(p == POST || p == HEAD)
            return 4;
    if(p == DELETE)
            return 6;
    if(p == OPTIONS)
            return 7;

    error("unknown method detected");

}

void error(const char * msg){
    printf("%s\n", msg);
    exit(-1);
}
