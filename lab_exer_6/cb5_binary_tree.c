#include <stdio.h>
#include <stdlib.h>

typedef struct node Node;
struct node
{
    int data;
    struct node *left;
    struct node *right;
};

Node *new_node(int data)
{
    Node *ret = malloc(sizeof(Node));
    ret->data = data;
    ret->left = NULL;
    ret->right = NULL;

    return ret;
}

void link(Node *parent, Node *left, Node *right)
{
    parent->left = left;
    parent->right = right;
}

int depth(Node *root)
{
    if (root == NULL)
        return -1;

    int left = depth(root->left);
    int right = depth(root->right);

    return 1 + (left > right ? left : right);
}

int even_level_max(Node *root, int level)
{
    if (root == NULL)
        return 0x80000000;

    int left = even_level_max(root->left, level + 1);
    int right = even_level_max(root->right, level + 1);
    int greater = (left > right) ? left : right;

    if (level % 2 == 0)
        return (greater > root->data) ? greater : root->data;
    else
        return greater;
}

int main()
{
    Node *a = new_node(5);
    Node *b = new_node(10);
    Node *c = new_node(17);
    Node *d = new_node(1);
    Node *e = new_node(0);
    Node *f = new_node(10);
    Node *g = new_node(12);
    Node *h = new_node(1);
    Node *i = new_node(2);
    Node *j = new_node(15);

    link(a, b, c);
    link(b, d, e);
    link(c, f, g);
    link(d, NULL, NULL);
    link(e, NULL, NULL);
    link(f, h, i);
    link(g, j, NULL);
    link(h, NULL, NULL);
    link(i, NULL, NULL);
    link(j, NULL, NULL);

    int height = depth(a);
    printf("%d\n", height);
    printf("%d\n", even_level_max(a, 0));

    return 0;
}