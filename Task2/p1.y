%{

%}

/*定义类型*/
%union{
  int type_int;
  float type_float;
  double type_double; 
}
/*定义tokens*/
%token <type_int> INT 
%token <type_float> FLOAT
%token ASSSIGNOP AND OR RELOP PLUS MINUS STAR DIV LP RP NOT LB RB DOT ID COMMA SEMI ELSE IF RETURN LC RC TYPE STRUCT WHILE

/*结合性及优先级，在最后一行的优先级最高*/
%right ASSIGN
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left star DIV
%right NOT
%left LP RP DOT LB RB

/*定义非终结符*/
%type <type_double> ExtDeflist ExtDef ExtDecList Specifier StructSpecifier OptTag Tag VarDec FunDec VarList ParamDec CompSt StmtList Stmt DefList Def DecList Dec Exp Args

%%
