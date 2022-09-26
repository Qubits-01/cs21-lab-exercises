#include <stdio.h>

#include <stdlib.h>



int global = 1;

const int const_global = 1;



void f()

{

    int k = 10;

    int *p1 = &k;

    int *p2 = malloc(sizeof(int));

    static int x = 1;

    char *s1 = "Hello";

    char s2[] = "Hello";



    printf("Address of k: %p\n", &k);

    printf("Address of p1: %p\n", &p1);

    printf("Address of p2: %p\n", &p2);

    printf("Address pointed to by p1: %p\n", p1);

    printf("Address pointed to by p2: %p\n", p2);

    printf("Address of global: %p\n", &global);

    printf("Address of const_global: %p\n", &const_global);

    printf("Address of x: %p\n", &x);

    printf("Address of s1: %p\n", &s1);

    printf("Address of s2: %p\n", &s2);

    printf("Address pointed to by s1: %p\n", s1);

    printf("Address pointed to by s2: %p\n", s2);



    free(p2);

}



int main()

{
    f();

    printf("Address of main: %p\n", &main);

    printf("Address of f: %p\n", &f);


    while (1);

    return 0;
}