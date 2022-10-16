#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>  // 变长参数函数 头文件

void yyrestart(FILE *input_flie);
int yyparse();
// 行数
extern int yylineno;
// 文本
extern char* yytext;
// 错误处理
void yyerror(char *msg);
// 抽象语法树
typedef struct treeNode{
    // 行数
    int line;
    // Token类型
    char* name;
    // fchild是第一个孩子节点，next是兄弟节点，使用孩子兄弟表示法
    struct treeNode *fchild,*next;
    // 联合体，同一时间只能保存一个成员的值，分配空间是其中最大类型的内存大小
    union{
        // id内容或者type类型（int/float）
        char* id_type;
        // 具体的数值
        int intval;
        float fltval;
    };
}* Ast,* tnode;

// 构造抽象语法树(节点)
Ast newAst(char* name,int num,...);

// 先序遍历语法树
void Preorder(Ast ast,int level);

// 所有节点数量
int nodeNum;
// 存放所有节点
tnode nodeList[5000];
int nodeIsChild[5000];
// 设置节点打印状态
void setChildTag(tnode node);

// bison是否有词法语法错误
int hasFault;
