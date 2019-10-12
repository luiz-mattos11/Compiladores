%{
  #include <stdio.h>
  #include <stdlib.h>
  int yylex(void);
  int yyerror(const char *s);
  FILE *yyin;
%}

%token INT 
%token CAR
%token SUM
%token SUB
%token MULT
%token DIV
%token SEMICOLON
%token CARCONST
%token ID
%token INTCONST
%token COMMA
%token OPENBRAC
%token CLOSEBRAC
%token PROGRAM
%token OPENBRACE
%token CLOSEBRACE
%token OPENPAR
%token CLOSEPAR
%token RETURN
%token LEIA
%token ESCREVA
%token NOVALINHA
%token SE
%token ENTAO
%token SENAO
%token ENQUANTO
%token EXECUTE
%token EQUAL
%token BIG
%token LESSTHAN
%token BIGTHAN
%token LESS
%token QUESTION
%token COLON
%token AND
%token OR
%token NOT
%token MOD
%token ASSIGN

%locations

%%

Programa : DeclFuncVar DeclProg {fprintf(stderr, "SUCESSO."); return 0;}
		 ;

DeclFuncVar : Tipo ID DeclVar SEMICOLON DeclFuncVar
                | Tipo ID OPENBRAC INTCONST CLOSEBRAC DeclVar SEMICOLON DeclFuncVar
                | Tipo ID DeclFunc DeclFuncVar
                | /* vazio */
                ;

DeclFunc : OPENPAR ListaParametros CLOSEPAR Bloco
		;

ListaParametros : ListaParametrosCont 
				| /* vazio */ 
				;

ListaParametrosCont : Tipo ID 
					| Tipo ID OPENBRAC CLOSEBRAC 
					| Tipo ID COMMA ListaParametrosCont
					| Tipo ID OPENBRAC CLOSEBRAC COMMA ListaParametrosCont
					;

DeclProg : PROGRAM Bloco
		 ;

Bloco : OPENBRACE ListaDeclVar ListaComando CLOSEBRACE
	  | OPENBRACE ListaDeclVar CLOSEBRACE
	  ;

ListaDeclVar : Tipo ID DeclVar SEMICOLON ListaDeclVar
			 | Tipo ID OPENBRAC INTCONST CLOSEBRAC DeclVar SEMICOLON ListaDeclVar
			 | /* vazio */
			 ;

DeclVar : COMMA ID DeclVar
		| COMMA ID OPENBRAC INTCONST CLOSEBRAC DeclVar
		| /* vazio */
		;

Tipo : INT
     | CAR
     ;

ListaComando : Comando 
			 | Comando ListaComando
			 ;

Comando : SEMICOLON
		| Expr SEMICOLON
		| RETURN Expr SEMICOLON
		| LEIA LValueExpr SEMICOLON
		| ESCREVA Expr SEMICOLON
		| ESCREVA CARCONST SEMICOLON
		| NOVALINHA SEMICOLON
		| SE OPENPAR Expr CLOSEPAR ENTAO Comando
		| SE OPENPAR Expr CLOSEPAR ENTAO Comando SENAO Comando
		| ENQUANTO OPENPAR Expr CLOSEPAR EXECUTE Comando
		| Bloco
		;

Expr : AssignExpr
	 ;

AssignExpr : CondExpr
		   | LValueExpr ASSIGN AssignExpr
		   ;

CondExpr : OrExpr
		 | OrExpr QUESTION Expr COLON CondExpr
		 ;

OrExpr : OrExpr OR AndExpr	
	   | AndExpr
	   ;

AndExpr : AndExpr AND EqExpr
		| EqExpr
		;
  
EqExpr : EqExpr EQUAL DesigExpr
	   | EqExpr NOT ASSIGN DesigExpr
	   | DesigExpr
	   ;

DesigExpr : DesigExpr LESS AddExpr
		  | DesigExpr BIG AddExpr
		  | DesigExpr LESSTHAN AddExpr
		  | DesigExpr BIGTHAN AddExpr
		  | AddExpr
		  ;

AddExpr : AddExpr SUM MulExpr
		| AddExpr SUB MulExpr
		| MulExpr
		;

MulExpr : MulExpr MULT UnExpr
		| MulExpr DIV UnExpr
		| MulExpr MOD UnExpr
		| UnExpr
		;

UnExpr : SUB PrimExpr
	   | NOT PrimExpr
	   | PrimExpr
	   ;

LValueExpr : ID OPENBRAC Expr CLOSEBRAC
		   | ID
		   ;

PrimExpr : ID OPENPAR ListExpr CLOSEPAR
		 | ID OPENPAR CLOSEPAR
		 | ID OPENBRAC Expr CLOSEBRAC
		 | ID
		 | CARCONST
		 | INTCONST
		 | OPENPAR Expr CLOSEPAR
		 ;

ListExpr : AssignExpr
		 | ListExpr COMMA AssignExpr
		 ;

%%