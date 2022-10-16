%{
<<<<<<< HEAD
    #include <stdio.h>
    #include <stdlib.h>
    #include "tree.h"

    extern int yylineno;
    void yyerror(char*);
    void myerror(char *msg);
    int yylex();
    int errors = 0;                 // 记录找出的语法错误次数
    #define YYSTYPE struct Node*    // 将所有的 token 类型设置为 Node*
%}


%token INT                         /* int 类型 */
%token FLOAT                       /* float 类型 */
%token TYPE                        /* TYPE 终结符 */
%token LF                          /* 换行符 \n */
%token ID                          /* 标识符 */ 
%token SEMI COMMA DOT              /* 结束符号 ; , */
%token ASSIGNOP RELOP              /* 比较赋值符号 = > < >= <= == != */
%token PLUS MINUS STAR DIV         /* 运算符 + - * / */
%token AND OR NOT                  /* 判断符号 && || ! */
%token LP RP LB RB LC RC           /* 括号 ( ) [ ] { } */
%token STRUCT                      /* struct */
%token RETURN                      /* return */
%token IF                          /* if */
%token ELSE                        /* else */
%token WHILE                       /* while */

// 定义结合性和优先级次序
%right ASSIGNOP
%left OR
%left AND
%nonassoc RELOP
%left PLUS MINUS
%left STAR DIV
%right NAGATE NOT
%right DOT LP LB RP RB
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

 /*-----------------------------------------|
 |          High-level Definitions          |
 |-----------------------------------------*/
Program : ExtDefList {
        $$ = insertNode($1, "Program", $1->lineNum, NONTERMINAL);
    }
    ;

ExtDefList : ExtDef ExtDefList {
        $$ = insertNode($1, "ExtDefList", @1.first_line, NONTERMINAL);
        $1->brother = $2;
    }
    | {
        $$ = insertNode(NULL, "ExtDefList", yylineno, NONTERMINAL);
    }

    ;

ExtDef : Specifier ExtDecList SEMI {
        $$ = insertNode($1, "ExtDef", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }
    | Specifier SEMI {
        $$ = insertNode($1, "ExtDef", @1.first_line, NONTERMINAL);
        $1->brother = $2;
    }
    | Specifier FunDec CompSt {
        $$ = insertNode($1, "ExtDef", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }


    ;

ExtDecList : VarDec {
        $$ = insertNode($1, "ExtDecList", @1.first_line, NONTERMINAL);
    }
    | VarDec COMMA ExtDecList {
        $$ = insertNode($1, "ExtDecList", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }


    ;

 /*-----------------------------------------|
 |                Specifiers                |
 |-----------------------------------------*/
Specifier : TYPE {
        $$ = insertNode($1, "Specifier", @1.first_line, NONTERMINAL);
    }
    | StructSpecifier {
        $$ = insertNode($1, "Specifier", @1.first_line, NONTERMINAL);
    }
    ;

StructSpecifier : STRUCT OptTag LC DefList RC {
        $$ = insertNode($1, "StructSpecifier", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
        $3->brother = $4;
        $4->brother = $5;
    }
    | STRUCT Tag {
        $$ = insertNode($1, "StructSpecifier", @1.first_line, NONTERMINAL);
        $1->brother = $2;
    }

    ;

OptTag : ID {
        $$ = insertNode($1, "OptTag", @1.first_line, NONTERMINAL);
    }
    | {
        $$ = insertNode(NULL, "OptTag", yylineno, NONTERMINAL);
    }
    ;

Tag : ID {
        $$ = insertNode($1, "Tag", @1.first_line, NONTERMINAL);
    }
    ;

 /*-----------------------------------------|
 |               Declarators                |
 |-----------------------------------------*/
VarDec : ID {
        $$ = insertNode($1, "VarDec", @1.first_line, NONTERMINAL);
    }
    | VarDec LB INT RB {
        $$ = insertNode($1, "VarDec", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
        $3->brother = $4;
    }
    ;

FunDec : ID LP VarList RP {
        $$ = insertNode($1, "FunDec", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
        $3->brother = $4;
    }
    | ID LP RP {
        $$ = insertNode($1, "FunDec", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }
    ;

VarList : ParamDec COMMA VarList {
        $$ = insertNode($1, "VarList", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }
    | ParamDec {
        $$ = insertNode($1, "VarList", @1.first_line, NONTERMINAL);
    }
    ;

ParamDec : Specifier VarDec {
        $$ = insertNode($1, "ParamDec", @1.first_line, NONTERMINAL);
        $1->brother = $2;
    }
    ;

 /*-----------------------------------------|
 |                Statements                |
 |-----------------------------------------*/
CompSt : LC DefList StmtList RC {
        $$ = insertNode($1, "CompSt", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
        $3->brother = $4;
    }
    ;

StmtList : Stmt StmtList {
        $$ = insertNode($1, "StmtList", @1.first_line, NONTERMINAL);
        $1->brother = $2;
    }
    | {
        $$ = insertNode(NULL, "FunDec", yylineno, NONTERMINAL);
    }

    ;
    
Stmt : Exp SEMI {
        $$ = insertNode($1, "Stmt", @1.first_line, NONTERMINAL);
        $1->brother = $2;
    }
    | CompSt {
        $$ = insertNode($1, "Stmt", @1.first_line, NONTERMINAL);
    }
    | RETURN Exp SEMI {
        $$ = insertNode($1, "Stmt", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }
    | IF LP Exp RP Stmt{
        $$ = insertNode($1, "Stmt", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
        $3->brother = $4;
        $4->brother = $5;
    }
    | IF LP Exp RP Stmt ELSE Stmt {
        $$ = insertNode($1, "Stmt", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
        $3->brother = $4;
        $4->brother = $5;
        $5->brother = $6;
        $6->brother = $7;
    }
    | WHILE LP Exp RP Stmt {
        $$ = insertNode($1, "Stmt", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
        $3->brother = $4;
        $4->brother = $5;
    }
    | error RC{ 
        char msg[100];
        sprintf( msg, "error RC:Missing \";\"");
        // printf("8\n");
        myerror( msg );  
    }

    ;

 /*-----------------------------------------|
 |             Local Definitions            |
 |-----------------------------------------*/
DefList : Def DefList {
        $$ = insertNode($1, "DefList", @1.first_line, NONTERMINAL);
        $1->brother = $2;
    }
    | {
        $$ = insertNode(NULL, "DefList", yylineno, NONTERMINAL);
    }
    ;

Def : Specifier DecList SEMI {
        $$ = insertNode($1, "Def", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }

    ;

DecList : Dec {
        $$ = insertNode($1, "DecList", @1.first_line, NONTERMINAL);
    }
    | Dec COMMA DecList {
        $$ = insertNode($1, "DecList", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }

    ;

Dec : VarDec {
        $$ = insertNode($1, "Dec", @1.first_line, NONTERMINAL);
    }
    | VarDec ASSIGNOP Exp {
        $$ = insertNode($1, "Dec", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }
    ;

 /*-----------------------------------------|
 |               Expressions                |
 |-----------------------------------------*/
Exp : Exp ASSIGNOP Exp {
        $$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }
    | Exp AND Exp {
        $$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }
    | Exp OR Exp {
        $$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }
    | Exp RELOP Exp {
        $$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }
    | Exp PLUS Exp {
        $$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }
    | Exp MINUS Exp {
        $$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }
    | Exp STAR Exp {
        $$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }
    | Exp DIV Exp {
        $$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }
    | LP Exp RP {
        $$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }
    | MINUS Exp {
        $$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
        $1->brother = $2;
    }
    | NOT Exp {
        $$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
        $1->brother = $2;
    }
    | ID LP Args RP {
        $$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
        $3->brother = $4;
    }
    | ID LP RP {
        $$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }
    | Exp LB Exp RB {
        $$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
        $3->brother = $4;
    }
    | Exp DOT ID {
        $$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }
    | ID {
        $$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
    }
    | INT {
        $$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
    }
    | FLOAT {
        $$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
    }
    | error RB { 
        char msg[100];
        sprintf( msg, "Missing \"]\"");
        // printf("3\n");
        myerror( msg );                // error
    }
    | error INT { 
        char msg[100];
        sprintf( msg, "error INT:Missing \"]\"");
        // printf("3\n");
        myerror( msg );                // error
    }
    | FLOAT error ID{ 
        char msg[100];
        sprintf( msg, "Syntax error.");
        // printf("6\n");
        myerror( msg );  
    }
    | INT error ID{ 
        char msg[100];
        sprintf( msg, "INT error ID:Missing \";\"");
        // printf("7\n");
        myerror( msg );  
    }
    | INT error INT{ 
        char msg[100];
        sprintf( msg, "INT error INT:Missing \";\"");
        // printf("8\n");
        myerror( msg );  
    }

    
    ;

Args : Exp COMMA Args {
        $$ = insertNode($1, "CompSt", @1.first_line, NONTERMINAL);
        $1->brother = $2;
        $2->brother = $3;
    }
    | Exp {
        $$ = insertNode($1, "CompSt", @1.first_line, NONTERMINAL);
    }
    ;

%%

#include "lex.yy.c"

int main(int argc, char **argv) {
    if (argc <= 1) return 1;
    FILE *f = fopen(argv[1], "r");
    if (!f) {
        perror(argv[1]);
        return 1;
    }
    yylineno = 1;
    yyrestart(f);
    yyparse();

    // 输出语法树
    f = fopen("output.txt", "w");
    if (!f) {   
        perror(argv[1]);
        return 1;
    }
    if (errors == 0) {
        f = fopen("output.txt", "w");
        printTree(head, 0, f);
    }

    return 0;
}

// 重载，令 yyerror 函数失效
void yyerror(char *msg)
{
    // fprintf(stderr, "Error type B at Line %d: %s\n", yylineno,  msg);
    //  printf( "%d: %s\n", yylineno,  msg);
    // errors++;
}

// 设置自定义的 myerror
void myerror(char *msg)
{
    fprintf(stderr, "Error type B at Line %d: %s \n", yylineno,  msg);
    errors++;
=======
	#include<Stdio.h>
	#include<stdlib.h>
	#include"tree.h"

	extern int yylineno;
	int yylex();
	int errors = 0;
	void yyerror(const char* msg);

%}

// This is a place to define the grammars.

%%

// This is a place to defint the operations.

// High-level Definitions
Program: ExtDefList {};
ExtDefList: ExtDef ExtDefList {}
	| {};
ExtDef: Specifier ExtDecList SEMI {}
	| Speciefier SEMI {}
	| Specifier Fundec CompSt {};
ExtDecList: Vardec {}
	| VarDec COMMA ExtDecList {};

// Specifiers
Specifier: TYPE {}
	| StructSpecifier {};
StructSpecifier: STRUCT OptTag LC DefList RC {}
	| Struct Tag {};
OptTag: ID {}
	| {};
Tag: ID {};

// Declarators
VarDec: ID {}
	| VarDec LB INT RB {};
FunDec: ID LP VarList RP {}
	| ID LP RP {};
VarList: ParamDec COMMA VarList {}
	| ParamDec {};
ParamDec: Specifier VarDec {};

// Statements
CompSt: LC DefList StmtList RC {};
StmrList: Stmt StmtList {}
	| {};
Stmt: Exp SEMI {}
	| CompSt {}
	| RETURN Exp SEMI {}
	| IF LP Exp RP Stmt {}
	| IF LP Exp RP Stmt ELXE Stmt {}
	| WHILE LP Exp RP Stmt {};

// Local Definitions
DefList: Def DefList {}
	| {};
Def: Specifier DecList SEMI {};
DecList: Dec {}
	| Dec COMMA DecList {};
Dec: VarDec {}
	| VarDec ASSIGNOP Exp {};

// Expressions
Exp: Exp ASSIGNOP Exp {}
	| Exp AND Exp {}
	| Exp ORExp {}
	| Exp RELOP Exp {}
	| Exp PLUS Exp {}
	| Exp MINUS Exp {}
	| Exp STAR Exp {}
	| Exp DIV Exp {}
	| LP Exp RP {}
	| MINUS Exp {}
	| NOT Exp {}
	| ID LP Args RP {}
	| ID LP RP {}
	| Exp LB Exp RB {}
	| Exp DOT ID {}
	| ID {}
	| INT {}
	| FLOAT {};
Args: Exp COMMA Args {}
	| Exp {};

%%

#include"lex.yy.c"
// Complete the basic needs first.
int main(int argc, char** argv){
	if(argc<=1) return 1;
	FILE* f = fopen(argv[1], "r");
	if(!f) {
		perror(argv[1]);
		return 1;		
	}
	yyrestart(f);
	yyparse();
>>>>>>> 3bdcbc665d48f141f9604d605394e9bd47e7a1a1
}
