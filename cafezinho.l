%{
  #include <stdio.h>
  #include "y.tab.h"
  int yyerror(char *errormsg);
  int yyparse();
  
  static int verifyCarconst(void);
  static void skip_multiple_line_comment(void);

%}

%option yylineno
  
%%
","            { fprintf(stderr, "Achou ,\n"); return COMMA; }
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
"/*"           { fprintf(stderr, "Achou startCom\n"); skip_multiple_line_comment(); }
"/"            { fprintf(stderr, "Achou /\n"); return DIV; }
"*"            { fprintf(stderr, "Achou *\n"); return MULT; }
";"            { fprintf(stderr, "Achou ;\n"); return SEMICOLON; }
"%"            { fprintf(stderr, "Achou %\n"); return MOD; }
"int"          { fprintf(stderr, "Achou int\n"); return INT;  }
"car"          { fprintf(stderr, "Achou car\n"); return CAR; }
[0-9]*         { fprintf(stderr, "Achou intconst\n"); return INTCONST; }
["]            { fprintf(stderr, "Achou \"\n"); verifyCarconst(); }
[_a-zA-Z0-9]*  { fprintf(stderr, "Achou id\n"); return ID; }
" "  ;
"\n" ;
.    { yyerror("Erro: Caractere inválido.");  }
<<EOF>> { printf("match EOF\n"); } 
%%

int yywrap(void)
{
     return 0;
}

int yyerror(char *errormsg)
{
     fprintf(stderr, "LINE: %d AT %c\nERROR: %s\n",yylineno, yytext[0], errormsg);
     exit(1);
}

static int verifyCarconst(void)
{
     while(1){
          switch(input())
          {
               case EOF:
                    fprintf(stderr, "Erro: Cadeia de caracteres não termina. Linha: %d\n", yylineno);
                    exit(-1);
                    return -1;
               break;
               case '\n':
                    fprintf(stderr, "Erro: Cadeia de caracteres ocupa mais de uma linha. Linha: %d\n", yylineno);
                    exit(-1);
                    return -1;
               break;
               case '"':
                    return CARCONST;
               break;
               default:
                    /* skip this character */
               break;
          }
     }
}

static void skip_multiple_line_comment(void){
     char c;
     int hasAsterisk = 0;
     
     for(;;){
          fprintf(stderr, "uaile");

          switch(input()){
               case EOF:
                    fprintf(stderr, "END OF FILE");
                    exit(-1);
                    return ;
               break;
               case '*':
                    fprintf(stderr, "OLHA QUERENDO LINHA: %d\n", yylineno);
                    hasAsterisk = 1;
               break;
               case '/':
                    if (hasAsterisk){
                         fprintf(stderr, "FECHOU");
                    }
               break;
               default:
                    hasAsterisk = 0;
               break;
          }
     }
}

int main(int argc, char **argv)
{     
     FILE *arq = fopen(argv[1],"r");
     
     if( arq == NULL ) {
          printf("could not read '%s'", argv[1]);
     }

     yyin = fopen(argv[1],"r");

	yyparse();
          fprintf(stderr, "PARSOU");
     fclose(yyin);
          fprintf(stderr, "FECHOU");
     return 0;
}
