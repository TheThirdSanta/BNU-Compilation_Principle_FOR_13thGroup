/*第一部分 头文件和变量*/
%{
	#include <stdlib.h>
	#include <stdio.h>
	#include "syntax.tab.h"
	FILE* f;
	int i;
	int comment_flag;
	int comment_begin;
	int chars=1;
	int line=1;
%}
/*flex属性,记录符号所在行号*/
%option yylineno
%option noyywrap
/*第二部分 定义正则表达式*/
TYPE (int)|(float)
IF (if)
ELSE (else)
RETURN (return)
STRUCT (struct)
WHILE (while)
INT  (0)|([1-9][0-9]*)
FLOAT  [0-9]*DOT[0-9]*(e[+-][0-9]*)?
ID  [_a-zA-Z]|[_a-zA-Z][0-9_a-zA-Z]+
SEMI  ;
COMMA  ,
ASSIGNOP  =
RELOP  >|<|>=|<=|==|!=
PLUS  \+
MINUS  \-
START "*"
DIV  "/"
AND "&&"
OR  "||"
NOT  "!"
LP "("
RP ")"
LB "["
RB "]"
LC "{"
RC "}"
DOT \.
IB \n
/*定义八进制，十六进制*/
OCTINT (0[1-7]([0-7]*))
HEXINT 0[xX][1-9A-Fa-f][0-9A-Fa-f]+
LONGCOMMENT \/\*(?:[^\*]|\*+[^\/\*])*\*+\/
AERROR .
/*注释*/
COMMENT \/\/[^\n]*
COMMENT_BEGIN "/*"
/*空白符*/
SPACE [ ]
SPACETAB \t
/*第三部分 操作 action 这里面的注释必须顶格一个空格*/
%%
{SPACE}    {chars+=yyleng;}
{SPACETAB} {chars+=4;}
{STRUCT}  {
	        struct Node *pNode = createNode("STRUCT", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return STRUCT;}
{RETURN}  {
	        struct Node *pNode = createNode("RETURN", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return RETURN;}
{IF}  {
	        struct Node *pNode = createNode("IF", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return IF;}
{ELSE}  {
	        struct Node *pNode = createNode("ELSE", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return ELSE;}
{WHILE}  {
	        struct Node *pNode = createNode("WHILE", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return WHILE;}
{TYPE} { 
            struct Node *pNode = createNode("TYPE", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);
            return TYPE; }
{INT}      {
	        struct Node *pNode = createNode("INT", 0, INT_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);
			return INT;}
{FLOAT}    {
	        struct Node *pNode = createNode("FLOAT", 0, FLOAT_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return FLOAT;}
{ID}       {
	        struct Node *pNode = createNode("ID", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);
			return ID;}
{SEMI}     {
	        struct Node *pNode = createNode("SEMI", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);
			return SEMI;}
{COMMA}    {
	        struct Node *pNode = createNode("COMMA", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return COMMA;}
{ASSIGNOP} {
	        struct Node *pNode = createNode("ASSIGNOP", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return ASSIGNOP;}
{RELOP}    {
	        struct Node *pNode = createNode("RELOP", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);
	        return RELOP;}
{PLUS}     {
	        struct Node *pNode = createNode("PLUS", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);
	        return PLUS;}
{BRACKET}  {
	        struct Node *pNode = createNode("BRACKET", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return BRACKET;}
{MINUS}    {
	        struct Node *pNode = createNode("MINUS", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return MINUS;}
{STAR}     {
	        struct Node *pNode = createNode("STAR", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return STAR;}
{DIV}      {
	        struct Node *pNode = createNode("DIV", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return DIV;}
{AND}      {
	        struct Node *pNode = createNode("AND", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);
	        return AND;}
{OR}       {
	        struct Node *pNode = createNode("OR", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);
	        return OR;}
{NOT}      {
	        struct Node *pNode = createNode("NOT", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return NOT;}
{DOT}  {
	        struct Node *pNode = createNode("DOT", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return DOT;}
{LP}  {
	        struct Node *pNode = createNode("LP", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return LP;}
{RP}  {
	        struct Node *pNode = createNode("RP", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return RP;}
{RB}  {
	        struct Node *pNode = createNode("RB", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return RB;}
{LC}  {
	        struct Node *pNode = createNode("LC", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return LC;}
{RC}  {
	        struct Node *pNode = createNode("RC", 0, STRING_TYPE);
            yylval = pNode;
            pNode->id_name = strdup(yytext);      
			return RC;}
{OCTINT}   {printf("INT8 at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}

{HEXINT}   {printf("INT16 at line %d,char %d:%s\n",yylineno,chars,yytext);chars+=yyleng;}

{LONGCOMMENT} {printf("LONGCOMMENT at line %d,char %d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{IB} {
	line++;
	chars=1;}
{COMMENT} { 
 printf("NOTE at line: %d char:%d %s\n",yylineno,chars,yytext);chars+=yyleng;}
{COMMENT_BEGIN} {
	comment_flag = 1;
	comment_begin = yylineno;}
{AERROR} {if(comment_flag!=1)  printf("Error type A at line %d,char %d: mysterious charachter '%s'.\n",yylineno,chars,yytext);chars+=yyleng;}

%%
int main(int argc,char** argv){
	if(argc<2){
		/*由lex创建的扫描程序的入口点yylex()
		调用yylex()启动或者重新开始扫描。
		如果lex动作执行讲数值传递给调用的程序return,那么对yylex()的下次调用就从它的停止地方继续。*/
		yylex();
		return 0;
	}
	for(i=1;i<argc;i++){
		f=fopen(argv[i],"r");
		if(!f){
			/*C 库函数 void perror(const char *str) 
			把一个描述性错误消息输出到标准错误 stderr。
			首先输出字符串 str，后跟一个冒号，然后是一个空格。*/
			perror(argv[i]);
			return 1;
		}
		comment_flag = 0;
		/*yyrestart使词法分析器从f中读取标准输入文件*/
        yyrestart(f);
        yylex();
        fclose(f);
	}
	return 0;
}

