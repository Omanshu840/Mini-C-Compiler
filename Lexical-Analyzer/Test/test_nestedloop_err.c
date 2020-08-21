#include <stdio.h>

void main(){
  int i = 1, n = 15;

  while(i < n){
    for (int j = 0; j < i; j++) {
      printf("*", i);
    }

    printf("\n");
    i++;
  }
  //Error
  int !!error = n;
}
