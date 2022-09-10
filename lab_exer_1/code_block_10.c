// #include <stdio.h>

// #define N 2021

// int main()
// {
//     int x = N;

//     switch (x)
//     {
//     case -1:
//         printf("N is negative one\n");
//         break;
//     case 0:
//         printf("N is zero\n");
//         break;
//     case 1:
//         printf("N is one\n");
//         break;
//     default:
//         printf("N is not -1, 0, or 1\n");
//         break;
//     }

//     return 0;
// }

// The buggy re-implementation.
#include <stdio.h>

#define N 2021

int main()
{
    int x = N;

    if (x == -1)
    {
        printf("N is negative one\n");
        printf("N is zero\n");
    }
    else if (x == 0)
    {
        printf("N is zero\n");
    }
    else if (x == 1)
    {
        printf("N is one\n");
        printf("N is not -1, 0, or 1\n");
    }
    else
    {
        printf("N is not -1, 0, or 1\n");
    }

    return 0;
}
