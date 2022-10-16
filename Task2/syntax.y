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
	| Specifier Fundec CompSt {
	$$ = insertNode($1, "ExtDef", @1.first_line, NONTERMINAL);
	$1->brother = $2;		};
ExtDecList: Vardec {
	$$ = insertNode($1, "ExtDecList", @1.first_line, NONTERMINAL);		}
	| VarDec COMMA ExtDecList {
	$$ = insertNode($1, "ExtDecList", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;		 };

// Specifiers
Specifier: TYPE {
	$$ = insertNode($1, "Specifier", @1.first_line, NONTERMINAL);		}
	| StructSpecifier {
	$$ = insertNode($1, "Specifier", @1.first_line, NONTERMINAL);		};
StructSpecifier: STRUCT OptTag LC DefList RC {
	$$ = insertNode($1, "StructSpecifier", @1.first_line, NONTERMINAL);	
	$1->brother = $2;
	$2->brother = $3;
	$3->brother = $4;
	$4->brother = $5;	}
	| Struct Tag {
	$$ = insertNode($1, "StructSpecifier", @1.first_line, NONTERMINAL);
	$1->brother = $2		};
OptTag: ID {
	$$ = insertNode($1, "OptTag", @1.first_line, NONTERMINAL);	}
	| {
	$$ = insertNode(NULL, "OptTag", yylineno, NONTERMINAL);
	};
Tag: ID {
	$$ = insertNode($1, "Tag", @1.first_line, NONTERMINAL);};

// Declarators
VarDec: ID {
	$$ = insertNode($1, "VarDec", @1.first_line, NONTERMINAL);
	}
	| VarDec LB INT RB {
	$$ = insertNode($1, "VarDec", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	
	$3->brother = $4;
	};
FunDec: ID LP VarList RP {
	$$ = insertNode($1, "FunDec", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	
	$3->brother = $4;
	}
	| ID LP RP {
	$$ = insertNode($1, "FunDec", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;
	};
VarList: ParamDec COMMA VarList {
	$$ = insertNode($1, "VarList", @1.first_line, NONTERMINAL);
	$1->brother = $2;	
	}
	| ParamDec {
	$$ = insertNode($1, "VarList", @1.first_line, NONTERMINAL);	
	};
ParamDec: Specifier VarDec {
	$$ = insertNode($1, "ParamDec", @1.first_line, NONTERMINAL);
	$1->brother = $2;		};

// Statements
CompSt: LC DefList StmtList RC {
	$$ = insertNode($1, "CompSt", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	
	$3->brother = $4;	};
StmtList: Stmt StmtList {
	$$ = insertNode($1, "StmtList", @1.first_line, NONTERMINAL);
	$1->brother = $2;	}
	| {
	$$ = insertNode(NULL, $1, "StmtList", yylineno, NONTERMINAL);
	};
Stmt: Exp SEMI {}
	| CompSt {
	$$ = insertNode($1, "Stmt", @1.first_line, NONTERMINAL);
	}
	| RETURN Exp SEMI {
	$$ = insertNode($1, "Stmt", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	}
	| IF LP Exp RP Stmt {
	$$ = insertNode($1, "Stmt", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;
	$3->brother = $4;	}
	| IF LP Exp RP Stmt ELXE Stmt {
	$$ = insertNode($1, "Stmt", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;
	$3->brother = $4;
	$4->brother = $5;
	$5->brother = $6;
	$6->brother = $7;		}
	| WHILE LP Exp RP Stmt {
	$$ = insertNode($1, "Stmt", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;
	$3->brother = $4;
	$4->brother = $5;		};

// Local Definitions
DefList: Def DefList {
	$$ = insertNode($1, "DefList", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	}
	| {
	$$ = insertNode(NULL, "DefList", yylineno, NONTERMINAL);
	};
Def: Specifier DecList SEMI {
	$$ = insertNode($1, "Def", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	};
DecList: Dec {
	$$ = insertNode($1, "DecList", @1.first_line, NONTERMINAL);
	}
	| Dec COMMA DecList {
	$$ = insertNode($1, "DecList", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	};
Dec: VarDec {
	$$ = insertNode($1, "Dec", @1.first_line, NONTERMINAL);
	}
	| VarDec ASSIGNOP Exp {
	$$ = insertNode($1, "Dec", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	};

// Expressions
Exp: Exp ASSIGNOP Exp {
	$$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	}
	| Exp AND Exp {
	$$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	}
	| Exp OR Exp {
	$$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	}
	| Exp RELOP Exp {
	$$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	}
	| Exp PLUS Exp {
	$$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	}
	| Exp MINUS Exp {
	$$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	}
	| Exp STAR Exp {
	$$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	}
	| Exp DIV Exp {
	$$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	}
	| LP Exp RP {
	$$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	}
	| MINUS Exp {
	$$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	}
	| NOT Exp {
	$$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	}
	| ID LP Args RP {
	$$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	}
	| ID LP RP {
	$$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	}
	| Exp LB Exp RB {
	$$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	}
	| Exp DOT ID {
	$$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	}
	| ID {$$ = insertNode($1, "Stmt", @1.first_line, NONTERMINAL);}
	| INT {$$ = insertNode($1, "Stmt", @1.first_line, NONTERMINAL);}
	| FLOAT {$$ = insertNode($1, "Stmt", @1.first_line, NONTERMINAL);}
	| error RB {
	yyerror();}
	| error INT {yyerror();}
	| FLOAT error ID {yyerror();}
	| INT error ID {yyerror();}
	| INT error INT {yyerror();};
Args: Exp COMMA Args {
	$$ = insertNode($1, "Args", @1.first_line, NONTERMINAL);
	$1->brother = $2;
	$2->brother = $3;	}
	| Exp {
	$$ = insertNode($1, "Exp", @1.first_line, NONTERMINAL);		};

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
	fprintf("Error type B at line %d: Syntax error.\n", yylineno);
	errors++;
}
