#include <stdio.h>

int main(){
  int a = 10, b = 7;

  if (a % 5 == 0) {
    printf("\n a is divisible by 5");
    if(a % 2 == 0)
      printf("and a is Even.");
    else
      printf("and a is Odd.");

  }
  else if (b % 7){
    printf("\n b is divisible by 7.");
    if(b % 2 == 0)
      printf("and a is Even.");
    else
      printf("and a is Odd.");
  }

  return 0;
}
