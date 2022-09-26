#include <stdio.h>

#include <stdlib.h>



typedef struct node Node;

struct node

{

    int value;

    struct node *left;

    struct node *right;

};



void initialize_node(Node *p, int value)

{

    p->value = value;

    p->left = NULL; // NULL is the null pointer; signifies pointing to "nothing"

    p->right = NULL;

}



Node *make_node(int value)

{

    Node *ret = malloc(sizeof(Node));

    initialize_node(ret, value);

    return ret;

}



int main()

{

    Node *root = make_node(0xa1a2a3a4);

    Node *a = make_node(0xb1b2b3b4);

    Node b;

    initialize_node(&b, 0xc1c2c3c4);



    root->left = a;

    root->right = &b;



    printf("Address pointed to by root: %p\n", root);

    printf("Address pointed to by a: %p\n", a);

    printf("Address of b: %p\n\n", &b);



    printf("Value of root->value: %x\n", root->value);

    printf("Address pointed to by root->left: %p\n", root->left);

    printf("Address pointed to by root->right: %p\n", root->right);

    printf("Address of root->value: %p\n", &root->value);

    printf("Address of root->left: %p\n", &root->left);

    printf("Address of root->right: %p\n\n", &root->right);



    char *byteptr = (char *)root; // Makes a char * pointing to what root points to;

    // (char *) typecasts the Node * root into a char *



    for (int i = 0; i < sizeof(Node); i++)

    {

        printf("Byte at address %p (byte %d of root): %hhx\n", byteptr + i, i, *(byteptr + i));

    }

    printf("sizeof(Node): %d\n", sizeof(Node));
    printf("sizeof(root): %d\n", sizeof(root));
    printf("sizeof(root->value): %d\n", sizeof(root->value));
    printf("sizeof(root->left): %d\n", sizeof(root->left));
    printf("sizeof(root->right): %d\n", sizeof(root->right));
    printf("sizeof(int): %d\n", sizeof(int));

    free(root);

    free(a); // Why should free not be called for b?



    return 0;

}