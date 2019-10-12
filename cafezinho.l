%{
  #include <stdio.h>
  #include "y.tab.h"
  
  int yyerror(char *errormsg);
  int yyparse();

  static int verifyCarconst(void);
  static int ignoreMultilineComment(void);

  static int commentStart = 0;
  static int carStart = 0;
%}

%option yylineno
  
%%
[,]            { return COMMA; }
[(]            { return OPENPAR; }
[)]            { return CLOSEPAR; }
"\["           { return OPENBRAC; }
"\]"           { return CLOSEBRAC; }
[{]            { return OPENBRACE; }
[}]            { return CLOSEBRACE; }
"?"            { return QUESTION; }
":"            { return COLON; }
"=="           { return EQUAL; }
">="           { return BIGTHAN; }
"<="           { return LESSTHAN; }
"="            { return ASSIGN; }
"programa"     { return PROGRAM; }
"retorne"      { return RETURN; }
"leia"         { return LEIA; }
"escreva"      { return ESCREVA; }
"novalinha"    { return NOVALINHA; }
"se"           { return SE; }
"entao"        { return ENTAO; }
"senao"        { return SENAO; }
"enquanto"     { return ENQUANTO; }
"execute"      { return EXECUTE; }
"e"            { return AND; }
"ou"           { return OR; }
">"            { return BIG; }
"<"            { return LESS; }
"!"            { return NOT; }
"+"            { return SUM; }
"-"            { return SUB; }
"/*"           { ignoreMultilineComment();}
"/"            { return DIV; }
"*"            { return MULT; }
";"            { return SEMICOLON; }
"%"            { return MOD; }
"int"          { return INT;  }
"car"          { return CAR; }
[0-9]*         { return INTCONST; }
["]            { return verifyCarconst(); }
[_a-zA-Z0-9]*  { return ID; }
" "  ;
"\n" ;
"\t" ;
.    { yyerror("Erro: Caractere inválido.");  }
<<EOF>> { fprintf(stderr, "END OF FILE"); }
%%

int yywrap(void){
     if(commentStart){
          fprintf(stderr, "ERRO: Comentario nao termina. Linha: %d.\n",commentStart);
          commentStart = 0;
          return 0;
     } else if(carStart){
          fprintf(stderr, "ERRO: Cadeia de caracteres nao termina. Linha: %d.\n",carStart);
          carStart = 0;
          return 0;
     }
     
     return 0;
}

int yyerror(char *errormsg){
     fprintf(stderr, "ERRO: %s. Linha: %d caractere: %c\n",errormsg, yylineno, yytext[0]);
     exit(1);
}

static int ignoreMultilineComment(void){
     register int c;

     commentStart = yylineno;

     for ( ; ; ){
          while ( (c = input()) != '*' && c != EOF );

          if ( c == '*' ){
               while ( (c = input()) == '*' );

               if ( c == '/' ){
                    commentStart = 0;
                    break;                    
               }

               if ( c == EOF ){
                    commentStart = 0;
                    fprintf(stderr, "ERRO: Comentario nao termina. Linha: %d\n.", yylineno);
                    return 0;
               }
          }
     }
}

static int verifyCarconst(void){
     register int c;

     carStart = yylineno;

     for ( ; ; ){
          while ( (c = input()) != '"' && c != EOF && c != '\n');

          if ( c == '\n'){
               fprintf(stderr, "Erro: Cadeia de caracteres ocupa mais de uma linha. Linha: %d\n", yylineno);
               carStart = 0;
               return -1;
          }

          if ( c == '"' ){
               carStart = 0;
               return CARCONST;
          }

          if ( feof(yyin) ){
               carStart = 0;
               fprintf(stderr, "Erro: Cadeia de caracteres não termina. Linha: %d\n", yylineno);
               return 0;
          }
     }
}


int main(int argc, char **argv){     
     FILE *arq = fopen(argv[1],"r");
     
     if( arq == NULL ){
          printf("Não foi possivel abrir o arquivo '%s'", argv[1]);
          return 0;
     }

     yyin = fopen(argv[1],"r");
	yyparse();
     fclose(yyin);

     return 0;
}
