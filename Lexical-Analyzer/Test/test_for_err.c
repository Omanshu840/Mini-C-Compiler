#include <stdio.h>
//Error in For
void main(){
  int i = 1, n = 15;

  for (i = 0; i < n; i++) {
    for (i = 0; i < 10; i++);
    printf("*");
  }
}
