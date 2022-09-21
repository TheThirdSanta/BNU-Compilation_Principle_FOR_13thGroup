/*第一部分 头文件和变量*/
%{
	#include <stdlib.h>
	#include <stdio.h>
	FILE* f;
	int i;
	int comment_flag;
	int comment_begin;
%}
/*flex属性,记录符号所在行号*/
%option yylineno
/*第二部分 定义正则表达式*/
TYPE (int)|(char)|(float)|(double)|(long)|(short)
KEYWORD (if)|(else)|(return)|(struct)
INT  [-+]?([01][0-9]{9}|20[0-9]{8}|21[0-3][0-9]{7}|214[0-6][0-9]{6}|2147[0-3][0-9]{5}|21474[0-7][0-9]{4}|214748[0-2][0-9]{3}|2147483[0-5][0-9]{2}|21474836[0-3][0-9]|214748364[0-7])|-2147483648
FLOAT  [-+]?([0-9]*\.[0-9]+|[0-9]+)
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
DOT  "."
NOT  "!"
BRACKET  "("|")"|"["|"]"|"{"|"}"
IB  [\f\n\r\t\v]

%%
 /*第三部分 操作 action 这里面的注释必须顶格一个空格*/
{TYPE}+ {printf("TYPE at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
{KEYWORD} {printf("KEYWORD at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
{INT}+ {printf("INT data at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
{FLOAT}+ {printf("FLOAT at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
{ID}+ {printf("ID at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
{SEMI}+ {printf("SEMI at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
{COMMA}+ {printf("COMMA at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
{ASSIGNOP}+ {printf("ASSIGNOP at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
{RELOP}+ {printf("RELOP at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
{PLUS}+ {printf("PLUS at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
{BRACKET} {printf("BRACKET at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
{MINUS}+ {printf("MINUS at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
{START}+ {printf("STAR at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
{DIV}+ {printf("DIV at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
{AND}+ {printf("AND at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
{OR}+ {printf("OR at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
{DOT}+ {printf("DOT at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
{NOT}+ {printf("NOT at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
. {printf ("ERROR Type at line %d,char%d:%s\n",yylineno,yyleng,yytext);}
{IB}+  

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
 /*第四部分 函数 function*/
int yywrap()
{
	/*此函数必须由用户提供,或者声明 %option noyywrap
	当词法分析程序遇到文件结尾时，它调用例程yywrap()来找出下一步要做什么
	如果返回0，扫描程序继续扫描，如果返回1，扫描程序就返回报告文件结尾*/
    return 1;
}
