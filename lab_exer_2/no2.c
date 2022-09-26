#include <stdio.h>

#include <stdint.h>



int main()

{

    uint32_t ints[] = {0xa1a2a3a4, 0xb1b2b3b4, 0xc1c2c3c4, 0xd1d2d3d4};



    uint32_t *p1 = ints;

    uint32_t *p2 = p1;



    for (int i = 0; i < 4; i++)

    {

        printf("ints[%d] = %x (%p)\n", i, ints[i], &ints[i]);

        printf("*(ints + %d) = %x (%p)\n", i, *(ints + i), ints + i);

        printf("p1[%d] = %x (%p)\n", i, p1[i], &p1[i]);

        printf("*(p1 + %d) = %x (%p)\n", i, *(p1 + i), p1 + i);

        printf("*p2 = %x (%p)\n", *p2, p2);

        printf("\n");



        p2 += 1;

    }



    return 0;

}