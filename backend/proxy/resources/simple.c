#include <sys/types.h>
#include <stdio.h>
#include <curl/curl.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/file.h>
#include <time.h>
#include <sys/uio.h>
#include <string.h>

/* Never writes anything, just returns the size presented */
size_t my_dummy_write(char *ptr, size_t size, size_t nmemb, void *userdata)
{
   return size * nmemb;
}


CURL * initr() {
  CURL * curl;    
  curl = curl_easy_init();
  curl_easy_setopt(curl, CURLOPT_URL, "http://devel.graffity.me:9001/User/addSkill?application_token=7AXUYXU4ZIDSIXHFLC7MLQPOHHGXBJGDOZY6HXA%3D&user_token=KTDSZIK7LNYP6D3EN4LW7ETL3LLORKWIWRLOWDA%3D");
    /* Now specify the POST data */ 
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "{\"skill_acceleration\":\"1\" }");
    curl_easy_setopt(curl, CURLOPT_VERBOSE, 0);
    curl_easy_setopt(curl, CURLOPT_NOPROGRESS, 1);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, &my_dummy_write);
 
    return curl;
}

int main(int argc, char * argv[]){
      time_t d; 
      time_t e;
      int i; 
      time_t s = time(NULL);
      
      int fd;

      CURL * c = NULL;
      for(i = 0; i < 40; i++){
            if(!fork()){
                 c = initr();
                 break;
            }
      }

      if(!c){
            // Bye parent 
            exit(0);
      }
      d = time(NULL);
      if(d == -1){
              printf("Error");
              exit(-1);
      }
      for(i = 0; i < 500; i++){ 
              curl_easy_perform(c);
      }
      e = time(NULL);
      fd = open("stat.txt", O_CREAT | O_APPEND | O_WRONLY | O_EXLOCK);

      char buffer[1000];
      bzero(buffer, 1000);
      
      snprintf(buffer, 1000, "d\t%d,e\t%d,s\t%d\n",e - d, e, s);
      write(fd, buffer, strlen(buffer));
      close(fd);

}

