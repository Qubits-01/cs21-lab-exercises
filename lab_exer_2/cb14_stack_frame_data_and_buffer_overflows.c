#include <stdio.h>

int main()
{
    char s[5];
    int x = 1;

    // printf("Address of s: %p\n", s);
    // printf("Address of x: %p\n\n", &x);

    printf("x is %d\n", x);
    printf("Enter a string: ");
    scanf("%s", s);
    printf("x is %d\n", x);

    // printf("\nAddress of s: %p\n", s);
    // printf("Address of x: %p\n", &x);

    return 0;
}