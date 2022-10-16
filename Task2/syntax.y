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

%token INT FLOAT
%token TYPE
%token LF
%token ID
%token SEMI COMMA DOT
%token ASSIGNOP RELOP
%token PLUS MINUS STAR DIV
%token AND OR NOT 
%token LP RP LB RB LC RC
%token STRUCT RETURN
%token IF ELSE WHILE

%right ASSIGNOP
%left OR AND
%nonassoc RELOP
%left PLUS MINUS STAR DIV
%right NOT
%right DOT LP RP LB RB
%nonassoc ELSE

%%

// This is a place to define the operations.

// High-level Definitions
Program: ExtDefList {
	$$ = insertNode($1, "Program", $1->linenum, NONTERMINAL);	};
ExtDefList: ExtDef ExtDefList {
	$$ = insertNode($1, "ExtDefList", @1.first_line, NONTERNIMAL);	
	$1->brother = $2;	}
	| {
	$$ = insertNode(NULL, "ExtDefList", yylineno, NONTERMINAL);	};
ExtDef: Specifier ExtDecList SEMI {
	$$ = insertNode($1, "ExtDef", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;
	}
	| Speciefier SEMI {
	$$ = insertNode($1, "Extdef", @1.first_line, NONTERMINAL);
	$1->brother = $2;		}
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
	| Exp OR Exp {}
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
	| FLOAT {}
	| error RB {}
	| error INT {}
	| FLOAT error ID {}
	| INT error ID {}
	| INT error INT {};
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

void yyerror(char* msg){
	fprintf("Error type B at line %d: Syntax error.", yylineno);
	errors++;
}
