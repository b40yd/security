#include <stdio.h>
#include <stdlib.h>

void catcher(void)
{
        setresuid(geteuid(),geteuid(),geteuid());
        printf("WIN!\n");
        system("/bin/sh");
        exit(0);
}


int main(int argc, char **argv)
{
   const int pass = 271;
   if (argc == 2){
        if(pass == atoi(argv[1])){
            catcher();
        }else{
            puts("Please enter 3 pass!");
        }
   }else{
        puts("need 3 pass!");
   }
   return 0;
}