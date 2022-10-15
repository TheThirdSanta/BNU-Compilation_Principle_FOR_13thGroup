%{
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
}
