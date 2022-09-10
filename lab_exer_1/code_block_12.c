#include <stdio.h>
#include <inttypes.h>

int main()
{
    int16_t i = 0;

    do
    {
        printf("Hello %d\n", i);
        i++;
        printf("%d\n", i);
    } while (i > 0);

    return 0;
}