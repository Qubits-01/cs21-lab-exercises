#include <stdio.h>

int main()
{
    int tData = 42;
    int *x = &tData;

    printf("BEFORE\n");
    printf("*x: %d\n", *x);
    printf("address of x: %p\n", x);
    printf("sizeof(*x): %ld\n", sizeof(*x));

    printf("\nDURING\n");

    // printf("*(x++): %d\n", *(x++));
    // printf("address of x: %p\n", x);

    printf("(*x)++: %d\n", (*x)++);
    printf("address of x: %p\n", x);

    printf("\nAFTER\n");
    printf("*x: %d\n", *x);
    printf("address of x: %p\n", x);

    char *a = "1";
    printf("test: %d\n", a);

    return 0;
}
