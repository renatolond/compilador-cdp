all: cdp teste.cd
	./cdp -s fatorial.cd -d fatorial.c
	./cdp -s laco.cd -d laco.c
	./cdp -s string.cd -d string.c
	./cdp -s mdc.cd -d mdc.c
	./cdp -s calculadora.cd -d calculadora.c
	./cdp -s vazio.cd -d vazio.c
	g++ -o cdp_fatorial fatorial.c
	g++ -o cdp_laco laco.c
	g++ -o cdp_string string.c
	g++ -o cdp_mdc mdc.c
	g++ -o cdp_vazio vazio.c
	g++ -o cdp_calculadora calculadora.c

lex.yy.c: Cdp.lex
	lex Cdp.lex

y.tab.c: Cdp.y
	yacc Cdp.y

cdp: lex.yy.c y.tab.c
	g++ -o cdp y.tab.c -lfl
