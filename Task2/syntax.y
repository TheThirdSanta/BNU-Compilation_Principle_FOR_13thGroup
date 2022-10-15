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
}
