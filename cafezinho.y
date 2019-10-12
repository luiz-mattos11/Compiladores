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

Programa : DeclFuncVar DeclProg {printf("GGWP");}
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

DeclProg : PROGRAM Bloco {printf("== DeclProg 1 =====\n");}
		 ;

Bloco : OPENBRACE ListaDeclVar ListaComando CLOSEBRACE {printf("== BLOCO 1\n");}
	  | OPENBRACE ListaDeclVar CLOSEBRACE {printf("== BLOCO 2\n");}
	  ;

ListaDeclVar : Tipo ID DeclVar SEMICOLON ListaDeclVar {printf("== ListaDeclVar 1\n");}
			 | Tipo ID OPENBRAC INTCONST CLOSEBRAC DeclVar SEMICOLON ListaDeclVar {printf("== ListaDeclVar 2\n");}
			 | /* vazio */ {printf("== ListaDeclVar 3\n");}
			 ;

DeclVar : COMMA ID DeclVar {printf("DeclVar 1\n");}
		| COMMA ID OPENBRAC INTCONST CLOSEBRAC DeclVar {printf("DeclVar 2\n");}
		| /* vazio */ {printf("== DeclVar 3\n");}
		;

Tipo : INT {printf("== INT\n");}
     | CAR {printf("== CAR\n");}
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