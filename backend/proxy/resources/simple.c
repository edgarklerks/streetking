#include <sys/types.h>
#include <stdio.h>
#include <curl/curl.h>
#include <unistd.h>
#include <stdlib.h>
/* Never writes anything, just returns the size presented */
size_t my_dummy_write(char *ptr, size_t size, size_t nmemb, void *userdata)
{
   return size * nmemb;
}


CURL * initr() {
  CURL * curl;    
  curl = curl_easy_init();
  curl_easy_setopt(curl, CURLOPT_URL, "http://graf2.graffity.me:9021/User/addSkill?application_token=AMTDBBE6MEEWOMWSWE6S5MSBJZFYIUHZ5BJTHEI%3D&user_token=T6GUUJUVV63PVH7RS2YYZWUVAZQLCOSVEXQXR5Y%3D");
    /* Now specify the POST data */ 
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "{\"skill_acceleration\":\"1\" }");
    curl_easy_setopt(curl, CURLOPT_VERBOSE, 0);
    curl_easy_setopt(curl, CURLOPT_NOPROGRESS, 1);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, &my_dummy_write);
 
    return curl;
}

int main(int argc, char * argv[]){
      int i;
    
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
      for(i = 0; i < 500; i++){ 
              curl_easy_perform(c);
      }
}

