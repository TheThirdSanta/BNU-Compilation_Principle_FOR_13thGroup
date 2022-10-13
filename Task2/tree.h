#include<string.h>
#include<malloc.h>
typedef int NODE_TYPE;

#define NONTERMINAL 0

#define INT_TYPE 1
#define FLOAT_TYPE 2
#define TRING_TYPE 3

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
// 函数的声明
struct Node *createNode(char *name, int line, NODE_TYPE type) {
    struct Node *pNode = (struct Node *) malloc(sizeof(struct Node));
    pNode->brother = NULL;         // 新结点的兄弟为空
    pNode->child = NULL;           // 新结点的子女为空
    pNode->lineNum = line;         // 记录行号，之后输出有用
    pNode->type = type;            // 记录结点类型，根据结点类型来输出
    pNode->name = strdup(name);    // 使用字符串拷贝赋予新结点的结点名
    pNode->intValue = 1;           // 将 int 值默认设为 1
    //printf("%s\n",name);
    return pNode;                  // 返回 pNode
}

struct Node *insertNode(struct Node *node, char *name, int line, NODE_TYPE type) {
    struct Node *father = (struct Node *) malloc(sizeof(struct Node));
    father->child = node;           // 给输入结点一个爹
    father->brother = NULL;         // 父亲结点的兄弟为空
    father->lineNum = line;         // 记录行号，之后输出有用
    father->type = type;            // 记录结点类型，根据结点类型来输出
    father->name = strdup(name);    // 使用字符串拷贝赋予新结点的结点名
    father->intValue = 1;           // 将 int 值默认设为 1
    head = father;                  // 将 head 置为 father
    //printf("%s %d\n",name,line);
    // if (node)
    //  fprintf(stdout, "%s -> %s   line : %d\n", father -> name, node -> name, line);
    return father;                  // 返回 father
}

void printNode(struct Node *node, FILE *f) {
    if (node->type == STRING_TYPE)
        fprintf(f, "%s : %s\n", node->name, node->id_name);     // string 类型的结点输出结点名和结点内容
    else if (node->type == INT_TYPE)
        fprintf(f, "INT : %d\n", node->intValue);               // int 类型的结点输出 INT 和结点值
    else if (node->type == FLOAT_TYPE)
        fprintf(f, "FLOAT : %f\n", node->floatValue);           // float 类型的结点输出 FLOAT 和结点值
    else
        fprintf(f, "%s (%d)\n", node->name, node->lineNum);     // 非终结符输出结点名字和行号
}

void printTree(struct Node *head, int depth, FILE *f) {
    if (head == NULL) return;                       // 遇到空结点，函数结束
    for (int i = 0; i < depth; ++i)
        fprintf(f, "\t");                         // 打印语法树所需的空白（制表符）
    printNode(head, f);
    printTree(head->child, depth + 1, f);       // 考虑该结点的孩子，深度加一，进入下一层递归
    printTree((head->brother), depth, f);       // 考虑该结点的兄弟，深度不变，进入下一层递归
}

