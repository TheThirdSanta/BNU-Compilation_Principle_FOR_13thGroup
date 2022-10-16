/*
*bison语法分析，对每条规则 按照孩子兄弟表示法建立语法结点
*/
%{
#include<unistd.h>
#include<stdio.h>   
#include "syntax_tree.h"
int yylex();

%}

%union{
    tnode type_tnode;
	// 这里声明double是为了防止出现指针错误（segmentation fault）
	double d;
}

/*声明记号*/
%token <type_tnode> INT FLOAT
%token <type_tnode> TYPE STRUCT RETURN IF ELSE WHILE ID COMMENT SPACE SEMI COMMA ASSIGNOP PLUS
%token <type_tnode> MINUS STAR DIV AND OR DOT NOT LP RP LB RB LC RC AERROR RELOP EOL

%type  <type_tnode> Program ExtDefList ExtDef ExtDecList Specifire StructSpecifire 
%type  <type_tnode> OptTag Tag VarDec FunDec VarList ParamDec Compst StmtList Stmt DefList Def DecList Dec Exp Args

/*优先级*/
/*C-minus中定义的运算符的优先级，并没有包括所有C语言的*/
%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT 
%left LP RP LB RB DOT

%nonassoc LOWER_THAN_ELSE 
%nonassoc ELSE

/*产生式*/
/*$$表示左表达式 ${num}表示右边的第几个表达式*/
%%
/*High-level Definitions*/
Program:ExtDefList {$$=newAst("Program",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
    ;
ExtDefList:ExtDef ExtDefList {$$=newAst("ExtDefList",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;}
	| {$$=newAst("ExtDefList",0,-1);nodeList[nodeNum]=$$;nodeNum++;}
	;
ExtDef:Specifire ExtDecList SEMI    {$$=newAst("ExtDef",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}    
	|Specifire SEMI	{$$=newAst("ExtDef",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;}
	|Specifire FunDec Compst	{$$=newAst("ExtDef",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	;
ExtDecList:VarDec {$$=newAst("ExtDecList",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	|VarDec COMMA ExtDecList {$$=newAst("ExtDecList",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	;
/*Specifire*/
Specifire:TYPE {$$=newAst("Specifire",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	|StructSpecifire {$$=newAst("Specifire",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	;
StructSpecifire:STRUCT OptTag LC DefList RC {$$=newAst("StructSpecifire",5,$1,$2,$3,$4,$5);nodeList[nodeNum]=$$;nodeNum++;}
	|STRUCT Tag {$$=newAst("StructSpecifire",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;}
	;
OptTag:ID {$$=newAst("OptTag",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	|{$$=newAst("OptTag",0,-1);nodeList[nodeNum]=$$;nodeNum++;}
	;
Tag:ID {$$=newAst("Tag",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	;
/*Declarators*/
VarDec:ID {$$=newAst("VarDec",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	|VarDec LB INT RB {$$=newAst("VarDec",4,$1,$2,$3,$4);nodeList[nodeNum]=$$;nodeNum++;}
	;
FunDec:ID LP VarList RP {$$=newAst("FunDec",4,$1,$2,$3,$4);nodeList[nodeNum]=$$;nodeNum++;}
	|ID LP RP {$$=newAst("FunDec",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	;
VarList:ParamDec COMMA VarList {$$=newAst("VarList",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|ParamDec {$$=newAst("VarList",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	;
ParamDec:Specifire VarDec {$$=newAst("ParamDec",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;}
    ;

/*Statement*/
Compst:LC DefList StmtList RC {$$=newAst("Compst",4,$1,$2,$3,$4);nodeList[nodeNum]=$$;nodeNum++;}
	;
StmtList:Stmt StmtList{$$=newAst("StmtList",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;}
	| {$$=newAst("StmtList",0,-1);nodeList[nodeNum]=$$;nodeNum++;}
	;
Stmt:Exp SEMI {$$=newAst("Stmt",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;}
	|Compst {$$=newAst("Stmt",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	|RETURN Exp SEMI {$$=newAst("Stmt",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
    |IF LP Exp RP Stmt %prec LOWER_THAN_ELSE {$$=newAst("Stmt",5,$1,$2,$3,$4,$5);nodeList[nodeNum]=$$;nodeNum++;}
    |IF LP Exp RP Stmt ELSE Stmt {$$=newAst("Stmt",7,$1,$2,$3,$4,$5,$6,$7);nodeList[nodeNum]=$$;nodeNum++;}
	|WHILE LP Exp RP Stmt {$$=newAst("Stmt",5,$1,$2,$3,$4,$5);nodeList[nodeNum]=$$;nodeNum++;}
	;
/*Local Definitions*/
DefList:Def DefList{$$=newAst("DefList",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;}
	| {$$=newAst("DefList",0,-1);nodeList[nodeNum]=$$;nodeNum++;}
	;
Def:Specifire DecList SEMI {$$=newAst("Def",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	;
DecList:Dec {$$=newAst("DecList",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	|Dec COMMA DecList {$$=newAst("DecList",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	;
Dec:VarDec {$$=newAst("Dec",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	|VarDec ASSIGNOP Exp {$$=newAst("Dec",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	;
/*Expressions*/
Exp:Exp ASSIGNOP Exp{$$=newAst("Exp",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
        |Exp AND Exp{$$=newAst("Exp",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
        |Exp OR Exp{$$=newAst("Exp",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
        |Exp RELOP Exp{$$=newAst("Exp",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
        |Exp PLUS Exp{$$=newAst("Exp",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
        |Exp MINUS Exp{$$=newAst("Exp",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
        |Exp STAR Exp{$$=newAst("Exp",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
        |Exp DIV Exp{$$=newAst("Exp",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
        |LP Exp RP{$$=newAst("Exp",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
        |MINUS Exp {$$=newAst("Exp",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;}
        |NOT Exp {$$=newAst("Exp",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;}
        |ID LP Args RP {$$=newAst("Exp",4,$1,$2,$3,$4);nodeList[nodeNum]=$$;nodeNum++;}
        |ID LP RP {$$=newAst("Exp",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
        |Exp LB Exp RB {$$=newAst("Exp",4,$1,$2,$3,$4);nodeList[nodeNum]=$$;nodeNum++;}
        |Exp DOT ID {$$=newAst("Exp",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
        |ID {$$=newAst("Exp",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
        |INT {$$=newAst("Exp",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
        |FLOAT{$$=newAst("Exp",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
        ;
Args:Exp COMMA Args {$$=newAst("Args",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
        |Exp {$$=newAst("Args",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
        ;
%%
