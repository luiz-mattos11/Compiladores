bison -dy cafezinho.y

flex cafezinho.l

gcc lex.yy.c y.tab.c -o cafezinho.exe