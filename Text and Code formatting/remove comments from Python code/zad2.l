%{
#include <stdio.h>
#include <string.h>

int yywrap();
int yylex();
%}

stringliteral   {stringprefix}?({shortstring}|{longstring})
stringprefix    r|u|R|U|f|F|fr|Fr|fR|FR|rf|rF|Rf|RF
shortstring     "'"({shortstringitem}|\")*"'"|\"({shortstringitem}|')*\"
longstring      "'''"{longstringitem}*"'''"|\"{3}{longstringitem}*\"{3}
shortstringitem {shortstringchar}|{stringescapeseq}
longstringitem  {longstringchar}|{stringescapeseq}
shortstringchar [^\\\n\"']
longstringchar  [^\\]
stringescapeseq [\\].|[\\]\n
%%

{stringliteral} ECHO;
#.*$ ;

%%

int yywrap() { 
    printf("\n");
    return 1; 
} 

int main(int argc, char* argv[]) { 
    yyin = fopen(argv[1], "r");
    char dest[12] = "r.";
    strcat(dest, argv[1]);
    yyout = fopen(dest, "w");
    return yylex(); 
}