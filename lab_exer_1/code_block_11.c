#include <stdio.h>
#include <inttypes.h>

int main()
{
    uint16_t i = 0;

    do
    {
        printf("Hello %u\n", i);
        i++;
        printf("%u\n", i);
    } while (i > 0);

    return 0;
}