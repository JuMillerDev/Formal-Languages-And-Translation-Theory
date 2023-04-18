%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include "zad1y.hpp"
#define P 1234577

extern int yylex();
%}


%%
[ \t]  ;  
\\\n   ;
^#(.|\\\n)*\n ;
[[:digit:]]+ { 
    ECHO;
    yylval = atoi(yytext); 
    return NUM; 
}
"(" {ECHO;return '(';}
")" {ECHO;return ')';}
"+" {ECHO;return '+';}
"-" {ECHO;return '-';}
"*" {ECHO;return '*';}
"/" {ECHO;return '/';}
"^" {ECHO;return '^';}
\n  {ECHO;return '\n';}
.   {ECHO;return ERR;}
%%