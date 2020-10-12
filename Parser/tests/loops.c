#include <stdio.h>

int main()
{
    int temp = 0;
    for (temp = 0; temp < 10; temp++)
        continue;

    while (temp > 0)
    {
        temp--;
        for (int i = 0; i < temp; i++)
        {
            temp--;
        }
    }

    do
    {
        temp++;
    } while (temp < 10);
}