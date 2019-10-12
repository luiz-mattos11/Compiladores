CC = gcc
LIB = -lfl -L/usr/local/opt/flex/lib
o ?= cafezinho

all: $(o).x

lex: lex.yy.c

bison: y.tab.c

yacc: bison

lex.yy.c: $(o).l
	flex $(o).l 
	
y.tab.c: $(o).y
	bison -dy $(o).y

y.tab.h: $(o).y

$(o).x: lex.yy.c y.tab.c y.tab.h
	$(CC) lex.yy.c y.tab.c -o $(o).x $(LIB)

clean:
	rm -rf lex.yy.c
	rm -rf y.tab.c
	rm -rf y.tab.h
	rm -rf $(o).x

