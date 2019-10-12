%{
  #include <stdio.h>
  #include "y.tab.h"
  int yyerror(char *errormsg);
  int yyparse();
  extern int eof;
  static int verifyCarconst(void);
  static int ignoreMultilineComment(void);

  static int commentStart = 0;
  static int carStart = 0;

%}

%option yylineno
  
%%
[,]            { fprintf(stderr, "Achou ,\n"); return COMMA; }
[(]            { fprintf(stderr, "Achou (\n"); return OPENPAR; }
[)]            { fprintf(stderr, "Achou )\n"); return CLOSEPAR; }
"\["           { fprintf(stderr, "Achou [\n"); return OPENBRAC; }
"\]"           { fprintf(stderr, "Achou ]\n"); return CLOSEBRAC; }
[{]            { fprintf(stderr, "Achou {\n"); return OPENBRACE; }
[}]            { fprintf(stderr, "Achou }\n"); return CLOSEBRACE; }
"?"            { fprintf(stderr, "Achou ?\n"); return QUESTION; }
":"            { fprintf(stderr, "Achou :\n"); return COLON; }
"=="           { fprintf(stderr, "Achou ==\n"); return EQUAL; }
">="           { fprintf(stderr, "Achou >=\n"); return BIGTHAN; }
"<="           { fprintf(stderr, "Achou <=\n"); return LESSTHAN; }
"="            { fprintf(stderr, "Achou =\n"); return ASSIGN; }
"programa"     { fprintf(stderr, "Achou programa\n"); return PROGRAM; }
"retorne"      { fprintf(stderr, "Achou retorne\n"); return RETURN; }
"leia"         { fprintf(stderr, "Achou leia\n"); return LEIA; }
"escreva"      { fprintf(stderr, "Achou escreva\n"); return ESCREVA; }
"novalinha"    { fprintf(stderr, "Achou novalinha\n"); return NOVALINHA; }
"se"           { fprintf(stderr, "Achou se\n"); return SE; }
"entao"        { fprintf(stderr, "Achou entao\n"); return ENTAO; }
"senao"        { fprintf(stderr, "Achou senao\n"); return SENAO; }
"enquanto"     { fprintf(stderr, "Achou enquanto\n"); return ENQUANTO; }
"execute"      { fprintf(stderr, "Achou execute\n"); return EXECUTE; }
"e"            { fprintf(stderr, "Achou e\n"); return AND; }
"ou"           { fprintf(stderr, "Achou ou\n"); return OR; }
">"            { fprintf(stderr, "Achou >\n"); return BIG; }
"<"            { fprintf(stderr, "Achou <\n"); return LESS; }
"!"            { fprintf(stderr, "Achou !\n"); return NOT; }
"+"            { fprintf(stderr, "Achou +\n"); return SUM; }
"-"            { fprintf(stderr, "Achou -\n"); return SUB; }
"/*"           { fprintf(stderr, "Achou */\n"); ignoreMultilineComment();}
"/"            { fprintf(stderr, "Achou /\n"); return DIV; }
"*"            { fprintf(stderr, "Achou *\n"); return MULT; }
";"            { fprintf(stderr, "Achou ;\n"); return SEMICOLON; }
"%"            { fprintf(stderr, "Achou %\n"); return MOD; }
"int"          { fprintf(stderr, "Achou int\n"); return INT;  }
"car"          { fprintf(stderr, "Achou car\n"); return CAR; }
[0-9]*         { fprintf(stderr, "Achou intconst\n"); return INTCONST; }
["]            { fprintf(stderr, "Achou aspa\n"); return verifyCarconst(); }
[_a-zA-Z0-9]*  { fprintf(stderr, "Achou id\n"); return ID; }
" "  ;
"\n" ;
"\t" ;
.    { yyerror("Erro: Caractere inválido.");  }
<<EOF>> {fprintf(stderr, "END OF FILE");}
%%

int yywrap(void)
{
     if(commentStart){
          fprintf(stderr, "ERRO: Comentario nao termina. Linha: %d\n.",commentStart);
          commentStart = 0;
     } else if(carStart){
          fprintf(stderr, "ERRO: Cadeia de caracteres nao termina. Linha: %d.\n",carStart);
          carStart = 0;
     }
     
     return 0;
}

int yyerror(char *errormsg)
{
     fprintf(stderr, "ERRO: %s. Linha: %d caractere: %c\n",errormsg, yylineno, yytext[0]);
     exit(1);
}

static int ignoreMultilineComment(void){
     register int c;

     commentStart = yylineno;

     for ( ; ; ) {
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

static int verifyCarconst(void)
{
     register int c;

     carStart = yylineno;

     for ( ; ; ) {
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


int main(int argc, char **argv)
{     
     FILE *arq = fopen(argv[1],"r");
     
     if( arq == NULL ) {
          printf("Não foi possivel abrir o arquivo '%s'", argv[1]);
          return 0;
     }

     yyin = fopen(argv[1],"r");
	yyparse();
     fclose(yyin);

     return 0;
}
/*
int main(int argc, char **argv){
     yyparse();
}*/
