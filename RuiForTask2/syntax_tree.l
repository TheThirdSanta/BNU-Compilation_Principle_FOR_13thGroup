/*
	按照C-Tokens文件中要求定义
    对终结符建立叶子结点，返回Token
	19-10-26
*/


/*第一部分 头文件和变量*/
%{
	#include <stdlib.h>
	#include <stdio.h>
    #include "syntax_tree.h"
    #include "syntax_tree.tab.h"
%}

/*flex属性,记录符号所在行号*/
%option yylineno

/*第二部分 定义正则表达式*/
/*十进制*/
INT_DEC 0|[1-9][0-9]*
/*十六进制*/
INT_HEX 0[xX][a-fA-F0-9]+
/*八进制*/
INT_OCT 0[1-7][0-7]*
/*二进制*/
INT_BIN 0[bB][01]+
/*INT类型汇总*/
INT {INT_HEX}|{INT_DEC}|{INT_OCT}|{INT_BIN}|{INT_HEX_ERROR}|{INT_OCT_ERROR}|{INT_BIN_ERROR}
/*浮点数-科学计数法*/
FLOAT ((([0-9]+\.[0-9]*)|([0-9]*\.[0-9]+)|INT)[Ee][-+]?[0-9]+)|({INT}\.[0-9])
/*词法分析输出错误，但是语法分析当做INT进行处理*/
/*十六进制错误*/
INT_HEX_ERROR 0[xX][a-fA-F0-9]*[g-zG-Z]+[a-fA-F0-9]*
/*八进制错误*/
INT_OCT_ERROR 0[0-7]*[89]+[0-7]*
/*二进制错误*/
INT_BIN_ERROR 0[bB][01]*[2-9]+[01]*

/*标识符*/
ID [a-z_A-Z][a-z_A-Z0-9]*

/*关键字*/
STRUCT struct
RETURN return
IF if
ELSE else
WHILE while
TYPE int|float

/*符号*/
SEMI  ;
COMMA ,
ASSIGNOP  =
PLUS  \+
MINUS \-
STAR  \*
DIV   \/
AND   &&
DOT   \.
NOT   \!
LP    \(
RP    \)
LB    \[
RB    \]
LC    \{
RC    \}
RELOP >|<|>=|<=|==|!=

/*注释*/
COMMENT \/\/[^\n]*
/*空白符*/
SPACE [ \f\r\t\v]+
/*换行*/
EOL \n
/*未定义字符*/
AERROR .

/*第三部分 操作 action 这里面的注释必须顶格一个空格*/
%%
 /*跳过空白和注释*/
{SPACE} {}
{COMMENT} {}
{EOL} {}
 /*关键字*/
{TYPE} {yylval.type_tnode=newAst("TYPE",0,yylineno);return TYPE;}
{STRUCT} {yylval.type_tnode=newAst("STRUCT",0,yylineno);return STRUCT;}
{RETURN} {yylval.type_tnode=newAst("RETURN",0,yylineno); return RETURN;}
{IF} {yylval.type_tnode=newAst("IF",0,yylineno);return IF;}
{ELSE} {yylval.type_tnode=newAst("ELSE",0,yylineno); return ELSE;}
{WHILE} {yylval.type_tnode=newAst("WHILE",0,yylineno); return WHILE;}
 /*数字类型错误*/
{INT_HEX_ERROR} {printf("INT_HEX_ERROR at line %d: charachters \"%s\"\n",yylineno,yytext);}
{INT_OCT_ERROR} {printf("INT_OCT_ERROR at line %d: charachters \"%s\"\n",yylineno,yytext);}
{INT_BIN_ERROR} {printf("INT_BIN_ERROR at line %d: charachters \"%s\"\n",yylineno,yytext);}
 /*数字类型表示*/
{INT} {yylval.type_tnode=newAst("INT",0,yylineno); return INT;}
{FLOAT} {yylval.type_tnode=newAst("FLOAT",0,yylineno); return FLOAT;}
 /*符号*/
{SEMI} {yylval.type_tnode=newAst("SEMI",0,yylineno); return SEMI;}
{COMMA} {yylval.type_tnode=newAst("COMMA",0,yylineno); return COMMA;}
{ASSIGNOP} {yylval.type_tnode=newAst("ASSIGNOP",0,yylineno); return ASSIGNOP;}
{PLUS} {yylval.type_tnode=newAst("PLUS",0,yylineno); return PLUS;}
{MINUS} {yylval.type_tnode=newAst("MINUS",0,yylineno); return MINUS;}
{STAR} {yylval.type_tnode=newAst("STAR",0,yylineno); return STAR;}
{DIV} {yylval.type_tnode=newAst("DIV",0,yylineno); return DIV;}
{AND} {yylval.type_tnode=newAst("AND",0,yylineno); return AND;}
{DOT} {yylval.type_tnode=newAst("DOT",0,yylineno); return DOT;}
{NOT} {yylval.type_tnode=newAst("NOT",0,yylineno); return NOT;}
{LP} {yylval.type_tnode=newAst("LP",0,yylineno); return LP;}
{RP} {yylval.type_tnode=newAst("RP",0,yylineno); return RP;}
{LB} {yylval.type_tnode=newAst("LB",0,yylineno); return LB;}
{RB} {yylval.type_tnode=newAst("RB",0,yylineno); return RB;}
{LC} {yylval.type_tnode=newAst("LC",0,yylineno); return LC;}
{RC} {yylval.type_tnode=newAst("RC",0,yylineno); return RC;}
{RELOP} {yylval.type_tnode=newAst("RELOP",0,yylineno); return RELOP;}
 /*标识符*/
{ID} {yylval.type_tnode=newAst("ID",0,yylineno); return ID;}
 /*错误*/
{AERROR} {
	hasFault=1;
	printf("Error type A at line %d: Mysterious character '%s'\n",yylineno,yytext);
}
%%

/*第四部分 函数 function*/
int yywrap()
{
	/*此函数必须由用户提供,或者声明 %option noyywrap
	当词法分析程序遇到文件结尾时，它调用例程yywrap()来找出下一步要做什么
	如果返回0，扫描程序继续扫描，如果返回1，扫描程序就返回报告文件结尾*/
    return 1;
}
