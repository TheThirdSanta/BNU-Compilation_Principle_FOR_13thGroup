#include<string.h>
#include<stdio.h>
#include<malloc.h>
typedef int NODE_TYPE;
//非终结符
#define NONTERMINAL 0
//输出类型
#define INT_TYPE 1
#define FLOAT_TYPE 2
#define STRING_TYPE 3

struct Node
{
    /* data */
    struct Node *child;
    struct Node *brother;
    int lineNum; 
    char *name;
    NODE_TYPE type;
    union 
    {
        /* data */
        char *id_name;
        int intValue;
        float floatValue;
    };
};

struct Node *head;
// 函数的声明们
struct Node *createNode(char *name, int line, NODE_TYPE type);
struct Node *insertNode(struct Node *node, char *name, int line, NODE_TYPE type);
void printNode(struct Node *node, FILE *f);
void printTree(struct Node* head, int depth, FILE *f);

