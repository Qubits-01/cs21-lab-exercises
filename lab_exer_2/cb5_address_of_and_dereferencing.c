#include <stdio.h>

int main()
{
    int a = 1;   // a is of type int
    int *p = &a; // p is of type int *
                 // &a is of type int *
                 // The = operator must have the same type for both sides.

    printf("Address of a: %p\n", &a);
    printf("Value of p: %p\n", p);

    printf("Value of *p: %d\n", *p);
    printf("Value of a: %d\n", a);

    *p = *p + 1; // *p is of type int; its value can be added to 1.

    printf("Value of *p: %d\n", *p);
    printf("Value of a: %d\n", a);

    a = a + 1; // Does this change the value of *p?

    printf("Value of *p: %d\n", *p);
    printf("Value of a: %d\n", a);

    return 0;
}