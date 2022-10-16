#include "syntax_tree.h"

// 用于遍历
int i;

Ast newAst(char *name, int num, ...)
{
    // 生成父节点
    tnode father = (tnode)malloc(sizeof(struct treeNode));
    // 添加子节点
    tnode temp = (tnode)malloc(sizeof(struct treeNode));
    if (!father)
    {
        yyerror("create treenode error");
        exit(0);
    }
    father->name = name;

    // 参数列表，详见 stdarg.h 用法
    va_list list;
    // 初始化参数列表
    va_start(list, num);

    // 表示当前节点不是终结符号，还有子节点
    if (num > 0)
    {
        // 第一个孩子节点
        temp = va_arg(list, tnode);
        setChildTag(temp);
        father->fchild = temp;
        // 父节点行号为第一个孩子节点的行号
        father->line = temp->line;

        // 多个节点，继续添加
        if (num >= 2)
        {
            for (i = 0; i < num - 1; ++i)
            {
                temp->next = va_arg(list, tnode);
                temp = temp->next;
                // 该节点为其他节点的子节点
                setChildTag(temp);
            }
        }
    }
    else //表示当前节点是终结符（叶节点）或者空的语法单元，此时num表示行号（空单元为-1）,将对应的值存入union
    {
        father->line = va_arg(list, int);
        // strcmp()==0 表示相同
        if ((!strcmp(name, "ID")) || (!strcmp(name, "TYPE")))
        {
            char *str;
            str = (char *)malloc(sizeof(char) * 40);
            strcpy(str, yytext);
            father->id_type = str;
            // father->id_type = (char*)malloc(sizeof(char)*40);
            // strcpy(father->id_type,yytext);
        }
        else if (!strcmp(name, "INT"))
        {
            father->intval = atoi(yytext);
        }
        else
        {
            father->fltval = atof(yytext);
        }
    }
    return father;
}

// 父节点->左子节点->右子节点....
void Preorder(Ast ast, int level)
{
    // printf(" into ");
    if (ast != NULL)
    {
        // 层级结构缩进
        for (i = 0; i < level; ++i)
        {
            printf(" ");
        }
        // printf(" rline ");
       if (ast->line != -1)
        {
            printf("%s", ast->name);
            // 根据不同类型打印节点数据
            if ((!strcmp(ast->name, "ID")) || (!strcmp(ast->name, "TYPE")))
            {
                printf(": %s", ast->id_type);
            }
            else if (!strcmp(ast->name, "INT"))
            {
                printf(": %d", ast->intval);
            }
            else if (!strcmp(ast->name, "FLOAT"))
            {
                printf(": %f", ast->fltval);
            }
            else if (!strcmp(ast->name, "SEMI"))
            {
                printf(": %c", ';');
            }
            else if (!strcmp(ast->name, "LC"))
            {
                printf(": %c", '(');
            }
            else if (!strcmp(ast->name, "RC"))
            {
                printf(": %c",')' );
            }
            else if (!strcmp(ast->name, "COMMA"))
            {
                printf(": %c", ',');
            }
            else if (!strcmp(ast->name, "LB"))
            {
                printf(": %c", '[');
            }
            else if (!strcmp(ast->name, "RB"))
            {
                printf(": %c", ']');
            }
             else if (!strcmp(ast->name, "LC"))
            {
                printf(": %c", '{');
            }
             else if (!strcmp(ast->name, "RC"))
            {
                printf(": %c", '}');
            }
             else if (!strcmp(ast->name, "STRUCT"))
            {
                printf(": %s", "struct");
            }
             else if (!strcmp(ast->name, "IF"))
            {
                printf(": %s", "if");
            }
             else if (!strcmp(ast->name, "RETURN"))
            {
                printf(": %s", "return");
            }
             else if (!strcmp(ast->name, "ELSE"))
            {
                printf(": %s", "else");
            }
             else if (!strcmp(ast->name, "WHILE"))
            {
                printf(": %s", "while");
            }
             else if (!strcmp(ast->name, "ASSIGNOP"))
            {
                printf(": %c", '=');
            }
             else if (!strcmp(ast->name, "DOT"))
            {
                printf(": %c", '.');
            }
            else
            {
                printf("(%d)", ast->line);
            }
        }
        else if((ast->line == -1))
            printf("%s:%s","Empty","Empty");
        printf("\n");
        Preorder(ast->fchild, level + 1);
        Preorder(ast->next, level);
    }
}

// 错误处理
void yyerror(char *msg)
{
    hasFault = 1;
    fprintf(stderr, "Error type B at Line %d: %s\n", yylineno, msg);
}

// 设置节点打印状态 该节点为子节点
void setChildTag(tnode node)
{
    int i;
    for (i = 0; i < nodeNum; i++)
    {
        if (nodeList[i] == node)
        {
            nodeIsChild[i] = 1;
        }
    }
}

// 主函数 扫描文件并且分析
// 因为bison会自己调用yylex()，所以在main函数中不需要再调用它了
// bison使用yyparse()进行语法分析，所以需要我们在main函数中调用yyparse()和yyrestart()
int main(int argc, char **argv)
{
    int j;
    if (argc < 2)
    {
        return 1;
    }
    for (i = 1; i < argc; i++)
    {
        // 初始化节点记录列表
        nodeNum = 0;
        memset(nodeList, 0, sizeof(tnode) * 5000);
        memset(nodeIsChild, 0, sizeof(int) * 5000);
        hasFault = 0;

        FILE *f = fopen(argv[i], "r");
        if (!f)
        {
            perror(argv[i]);
            return 1;
        }
        yyrestart(f);
        yyparse();
        fclose(f);

        // 遍历所有非子节点的节点
        if (hasFault)
            continue;
        for (j = 0; j < nodeNum; j++)
        {
            if (nodeIsChild[j] != 1)
            {
                Preorder(nodeList[j], 0);
            }
        }
    }
}
