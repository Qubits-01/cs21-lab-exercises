#include <stdio.h>
#include <stdlib.h>

typedef struct point Point;
struct point
{
    int x;
    int y;
};

typedef struct
{ // Direct typedef definition
    int x;
    int y;
    int z;
} Point3D;

int main()
{
    /* Uninitialized structs */
    struct point p1;
    Point p2;

    /* Initialized struct */
    Point p3 = {.x = 1, .y = 2};

    /* Pointer to heap-allocated structs */
    Point *p4 = malloc(sizeof(Point));
    Point *p5 = malloc(sizeof(struct point));

    /* Pointers to existing structs */
    Point *ptr1 = &p3; // Why does this need &?
    Point *ptr2 = p4;  // Why does this not need &?

    /* Assigning field values */
    p1.x = 1; // . is used to access struct fields
    p1.y = 2;

    (*p4).x = 10; // Pointers must be dereferenced first
    p4->y = 20;   // -> is syntactic sugar for * followed by .

    printf("x field of p3: %d\n", p3.x);
    printf("x field of p4: %d\n", p4->x);

    free(p5);
    free(ptr2); // No need to free p4; why?

    return 0;
}