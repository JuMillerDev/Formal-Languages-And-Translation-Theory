%{
#include <stdio.h>
#include <string.h>
int yywrap();
int yylex();

int lines = 0;
int words = 0;
%}

%%

^[[:blank:]]*(\n)?  ;
[[:blank:]]*\n      { fprintf(yyout,"\n"); lines++; }              
[[:blank:]]*        { fprintf(yyout," ");}    
[a-zA-Z]+           { words++; ECHO; }

%%

int yywrap() {
    fprintf(yyout,"\n\n");
    fprintf(yyout,"line count: %d\n", lines);
    fprintf(yyout,"word count: %d\n", words);
    return 1;
}

int main(int argc, char* argv[]) {
    yyin = fopen(argv[1], "r");
    char dest[12] = "r.";
    strcat(dest, argv[1]);
    yyout = fopen(dest, "w");
    return yylex();
}