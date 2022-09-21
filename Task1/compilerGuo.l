/*第一部分 头文件和变量*/
%{
	#include <stdlib.h>
	#include <stdio.h>
	FILE* f;
	int i;
	int leng;
	int comment_flag;
	int comment_begin;
%}
/*flex属性,记录符号所在行号*/
%option yylineno
/*第二部分 定义正则表达式*/
LINECHANGE \t
SPACE [ ]+
FLOAT (0|[1-9]+)?\.([0-9]*)?(e(\-)?[0-9]+)?
FLOATERROR [0-9]+e
NOTE [\/]{2}.*
OCTINT 0[1-7][0-7]*
OCTERROR 0([0-7]*[8-9]+[0-7]*)+
HEXINT 0[xX][1-9A-Fa-f][0-9A-Fa-f]+
HEXERROR 0[xX]([0-9a-fA-F]*[g-zG-Z]+[0-9a-fA-F]*)+
LONGCOMMENT \/\*(.+\n)+\*\/

/*第三部分 操作 action 这里面的注释必须顶格一个空格*/
%%
FLOATERROR {printf("Error Type A at line %d: Illgal float number: \'%s\'.\n", yylineno, yytext);}
{FLOAT} {printf("FLOAT at line %d: %s\n", yylineno, yytext);}
{NOTE} {printf("COMMENT at line %d: %s\n", yylineno, yytext);}
{OCTINT} {printf("INT8 at line %d: %s\n", yylineno, yytext);}
{OCTERROR} {printf("Error Type A at line %d: Illgal octal number: \'%s\'\n", yylineno, yytext);}
{HEXINT} {printf("INT16 at line %d: %s.\n", yylineno, yytext);}
{HEXERROR} {printf("Error Type A at line %d: Illgal hexademical number: \'%s\'.\n", yylineno, yytext);}
{LONGCOMMENT} {printf("LONGCOMMENT at line %d: %s\n", yylineno, yytext);} 
. {printf("UNDEFINED at line %d: %s\n", yylineno, yytext);}
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
