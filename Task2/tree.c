#include<malloc.h>
#include<stdio.h>
#include"tree.h"

struct Node *createNode(char *name,int line,NODE_TYPE type){
    struct Node *pNode = (struct Node *)malloc(sizeof(struct Node));
    pNode -> brother = NULL;
    pNode -> child = NULL;
    pNode -> lineNum = line;
    pNode -> type = type;
    pNode -> name = strdup(name);
    pNode -> intValue = 1;
    return pNode;
}

struct Node *insertNode(struct Node *node,char *name,int line,NODE_TYPE type){
    struct Node *father = (struct Node *) malloc(sizeof(struct Node));
    father -> child = node;
    father -> brother = NULL;
    father ->lineNum = line;
    father -> type = type;
    father -> name = strdup(name);
    father -> intValue = 1;
    head = father;
    return father;
}

void printNode(struct Node *node,FILE *f){
    if(node->type == STRING_TYPE){
        fprintf(f,"%s : %s\n",node->name,node->id_name);
    }
    else if(node->type == INT_TYPE){
        fprintf(f,"INT : %d\n",node->intValue);
    }
    else if(node->type == FLOAT_TYPE){
        fprintf(f,"FLOAT : %f\n",node->floatValue);
    }
    else{
        fprintf(f,"%s (%d)\n",node->name,node->lineNum);
    }
}

void printTree(struct Node *head,int depth,FILE *f){
    if(head == NULL) return;
    for(int i=0;i<depth;++i){
        fprintf(f,"\t");
    }
    printNode(head,f);
    printTree(head->child,depth+1,f);
    printTree(head->brother,depth,f);
}

