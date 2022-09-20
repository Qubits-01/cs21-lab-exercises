#include <stdio.h>

int main()
{
    int x;
    int *p = &x;

    printf("Enter an integer: ");
    scanf("%d", &x);
    printf("You entered: %d\n", x);

    printf("Enter another integer: ");
    scanf("%d", p);
    printf("x: %d\n", x);
    printf("*p: %d\n", *p);

    return 0;
}