#include <stdio.h>

#define newLine printf("\n")

int main()
{
    printf("Hello World!\n");

    int i = 0;
    printf("i++: %d\n", i++);
    i = 0;
    printf("++i: %d\n", ++i);

    printf("7 & 5: %d\n", 7 & 5);
    printf("7 && 5: %d\n", 7 && 5);

    newLine;

    return 0;
}