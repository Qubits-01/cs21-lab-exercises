#include <stdio.h>

int main()
{
    int n;
    scanf("%d", &n);

    for (int asterisk = 1; asterisk <= n; asterisk += 2)
    {
        for (int triangle = 1; triangle <= n; triangle++)
        {
            // left spaces
            for (int spaces = 0; spaces < (n - asterisk) / 2; spaces++)
            {
                printf(" ");
            }

            // asterisks
            for (int ast = 0; ast < asterisk; ast++)
            {
                printf("*");
            }

            if (triangle < n)
            {
                // right spaces
                for (int spaces = 0; spaces < (n - asterisk) / 2; spaces++)
                {
                    printf(" ");
                }
                // gap between triangles
                printf(" ");
            }
        }

        printf("\n");
    }

    return 0;
}