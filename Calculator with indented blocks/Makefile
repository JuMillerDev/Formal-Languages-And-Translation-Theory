main: calc.y lex.l
	bison -d -o zad1y.cpp calc.y
	flex lex.l
	g++ -o zad1 zad1y.cpp lex.yy.c

clean:
	rm zad1y.cpp zad1y.hpp lex.yy.c zad1