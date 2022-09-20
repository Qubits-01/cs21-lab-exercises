#include <stdio.h>

int main()
{
    char *s1 = "Hello";   // s1 points to a read-only string.
    char s2[] = "Hello";  // s2 points to a modifiable string.
    char s3[6] = "Hello"; // Must leave space for the null terminator.
    char *s4 = s3;        // s4 points to first element (H).

    printf("s3: %s\n", s3); // char arrays decay into char pointers.
    printf("s4: %s\n", s4); // Pointed string must have null terminator.
    s3[4] = '!';
    printf("s3: %s\n", s3);
    printf("s4: %s\n", s4);

    return 0;
}