#include <stdio.h>
//Parenthesis Error

void main(){
  int a = 10;

  if(a % 2 == 0){
    printf("and a is Even.");
    printf("and a is not Odd.");
  //Missing Parenthesis
  //}
  else{
    printf("and a is Odd.");
  }

  int !!error = a;
}
