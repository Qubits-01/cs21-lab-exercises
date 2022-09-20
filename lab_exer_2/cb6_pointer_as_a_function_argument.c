#include <stdio.h>

void square(int *p)
{
    printf("Value of p: %p\n", p);
    printf("Value of *p: %d\n", *p);

    *p = *p * *p;
}

int main()
{
    int a = 10;

    printf("Address of a: %p\n", &a);

    printf("Value of a: %d\n", a);
    square(&a);
    printf("Value of a: %d\n", a);

    return 0;
}