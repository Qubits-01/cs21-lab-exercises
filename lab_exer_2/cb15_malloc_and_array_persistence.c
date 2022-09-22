// Reference: https://pythontutor.com/render.html#code=%23include%20%3Cstdio.h%3E%0A%23include%20%3Cstdlib.h%3E%0A%0Aint%20*get_multiples%28int%20n,%20int%20k%29%0A%7B%0A%20%20%20%20int%20*ret%20%3D%20malloc%28k%20*%20sizeof%28int%29%29%3B%0A%0A%20%20%20%20for%20%28int%20i%20%3D%200%3B%20i%20%3C%20k%3B%20i%2B%2B%29%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20ret%5Bi%5D%20%3D%20n%20*%20i%3B%0A%20%20%20%20%20%20%20%20printf%28%22ret%5B%25d%5D%3A%20%25d%5Cn%22,%20i,%20ret%5Bi%5D%29%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20return%20ret%3B%0A%7D%0A%0Avoid%20some_function%28%29%0A%7B%0A%20%20%20%20int%20arr%5B100%5D%20%3D%20%7B%7D%3B%0A%0A%20%20%20%20for%20%28int%20i%20%3D%200%3B%20i%20%3C%20100%3B%20i%2B%2B%29%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20arr%5Bi%5D%20%3D%2021%3B%0A%20%20%20%20%7D%0A%7D%0A%0Aint%20main%28%29%0A%7B%0A%20%20%20%20int%20k%20%3D%2010%3B%0A%20%20%20%20int%20*p%20%3D%20get_multiples%2821,%20k%29%3B%0A%0A%20%20%20%20for%20%28int%20i%20%3D%200%3B%20i%20%3C%20k%3B%20i%2B%2B%29%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20printf%28%22p%5B%25d%5D%3A%20%25d%5Cn%22,%20i,%20p%5Bi%5D%29%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20some_function%28%29%3B%0A%0A%20%20%20%20for%20%28int%20i%20%3D%200%3B%20i%20%3C%20k%3B%20i%2B%2B%29%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20printf%28%22p%5B%25d%5D%3A%20%25d%5Cn%22,%20i,%20p%5Bi%5D%29%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20free%28p%29%3B%0A%0A%20%20%20%20return%200%3B%0A%7D&cumulative=false&curInstr=273&heapPrimitives=nevernest&mode=display&origin=opt-frontend.js&py=c_gcc9.3.0&rawInputLstJSON=%5B%5D&textReferences=false

#include <stdio.h>
#include <stdlib.h>

int *get_multiples(int n, int k)
{
    int *ret = malloc(k * sizeof(int));

    for (int i = 0; i < k; i++)
    {
        ret[i] = n * i;
        printf("ret[%d]: %d\n", i, ret[i]);
    }

    return ret;
}

void some_function()
{
    int arr[100] = {};

    for (int i = 0; i < 100; i++)
    {
        arr[i] = 21;
    }
}

int main()
{
    int k = 10;
    int *p = get_multiples(21, k);

    for (int i = 0; i < k; i++)
    {
        printf("p[%d]: %d\n", i, p[i]);
    }

    some_function();

    for (int i = 0; i < k; i++)
    {
        printf("p[%d]: %d\n", i, p[i]);
    }

    free(p);

    return 0;
}
