/*第一部分 头文件和变量*/
%{
	#include <stdlib.h>
	#include <stdio.h>
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
TYPE (int)|(char)|(float)|(double)|(long)|(short)
KEYWORD (if)|(else)|(return)|(struct)
INT  (0)|([1-9][0-9]*)
FLOAT  [0-9]*+*\.[0-9]*e?-?[0-9]*
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
BRACKET  "("|")"|"["|"]"|"{"|"}"
IB \n
FLOATERROR ([0-9]+e[a-zA-Z0-9]*)|([0-9]*e[0-9]*+*\.[0-9]*)
OCTINT (0[1-7]([0-7]*))
OCTERROR 0([0-7]*[8-9]+[0-7]*)+
HEXINT 0[xX][1-9A-Fa-f][0-9A-Fa-f]+
HEXERROR 0[xX]([0-9a-fA-F]*[g-zG-Z]+[0-9a-fA-F]*)+
LONGCOMMENT \/\*(.+\n)+\*\/
AERROR .
/*注释*/
COMMENT ("//".*)|("/*"([*]*(([^*/])+([/])*)*)*"*/")
COMMENT_BEGIN "/*"
/*空白符*/
SPACE [ ]
SPACETAB \t
/*第三部分 操作 action 这里面的注释必须顶格一个空格*/
%%
{SPACE}    {chars+=yyleng;}
{SPACETAB} {chars+=4;}
{TYPE}     {printf("TYPE at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{KEYWORD}  {printf("KEYWORD at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{INT}     {printf("INT data at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{FLOAT}    {printf("FLOAT at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{ID}       {printf("ID at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{SEMI}     {printf("SEMI at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{COMMA}    {printf("COMMA at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{ASSIGNOP} {printf("ASSIGNOP at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{RELOP}    {printf("RELOP at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{PLUS}     {printf("PLUS at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{BRACKET}  {printf("BRACKET at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{MINUS}    {printf("MINUS at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{START}    {printf("START at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{DIV}      {printf("DIV at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{AND}      {printf("AND at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{OR}       {printf("OR at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{NOT}      {printf("NOT at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{FLOATERROR} {printf("Error Type A at line %d,char %d: Illgal float number: \'%s\'.\n",yylineno,chars,yytext);chars+=yyleng;}
{OCTINT}   {printf("INT8 at line %d,char%d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{OCTERROR}+  {printf("Error Type A at line %d,char %d: Illgal octal number: \'%s\'\n",yylineno,chars,yytext);chars+=yyleng;}
{HEXINT}   {printf("INT16 at line %d,char %d:%s\n",yylineno,chars,yytext);chars+=yyleng;}
{HEXERROR} {printf("Error Type A at line %d,char %d: Illgal hexademical number: \'%s\'.\n",yylineno,chars,yytext);chars+=yyleng;}
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

