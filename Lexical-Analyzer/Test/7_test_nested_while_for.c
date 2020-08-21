#include <stdio.h>
/*
  Nested Loop no errors
  Prints a pyramid
*/

void main(){
  int i = 1, n = 15;

  while(i < n){
    for (int j = 0; j < i; j++) {
      printf("*", i);
    }

    printf("\n");
    i++;
  }
}
