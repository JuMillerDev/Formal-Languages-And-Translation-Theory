%{
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

int yywrap();
int yylex();

bool print_doc = false;
%}

BCKSLSH \\|\n

%x singlelinecomment
%x includestring
%x multilinecomment
%x singlelinedoccomment
%x multilinedoccomment
%x commentinstring

%%
#include[[:blank:]]*{BCKSLSH}*                     {BEGIN(includestring); ECHO;}
<includestring>{
    \<.*\>                              { ECHO; BEGIN(INITIAL);}
    ".*"                                { ECHO; BEGIN(INITIAL);}
}

\"                              {BEGIN(commentinstring);  ECHO;}
<commentinstring>{   
    \\{2}                       ECHO;
    \\\n                        ECHO;
    \\\"                        ECHO;
    \"                          {ECHO; BEGIN(INITIAL);}
    .                           ECHO;
}

\/{BCKSLSH}*\/                 {BEGIN(singlelinecomment);}
<singlelinecomment>{
    .*\\\n                      ;
    .                           ;      
    [^\\]\n                        {fprintf(yyout,"\n"); BEGIN(INITIAL);}
}

\/{BCKSLSH}*\*                 BEGIN(multilinecomment);
<multilinecomment>{
    .|\n                        ;
    \*{BCKSLSH}*\/             BEGIN(INITIAL);
}

\/{BCKSLSH}*\/{BCKSLSH}*\/    {BEGIN(singlelinedoccomment); if(print_doc) ECHO;}
<singlelinedoccomment>{
    .                           {if(print_doc) ECHO;}
    .*\\\n                      {if(print_doc) ECHO;}
    .?\n                     {if(print_doc) fprintf(yyout,"\n"); BEGIN(INITIAL);}
}

\/{BCKSLSH}*\*{BCKSLSH}*\*    {BEGIN(multilinedoccomment); if(print_doc) ECHO;}
<multilinedoccomment>{
    .|\n                        {if(print_doc) ECHO;}
    \*{BCKSLSH}*\/             {fprintf(yyout,"\n"); if(print_doc) ECHO; BEGIN(INITIAL);}
}

%%

int yywrap() {
    return 1;
}

int main(int argc, char* argv[]) {
    yyin = fopen(argv[1], "r");
    char dest[12] = "r.";
    strcat(dest, argv[1]);
    yyout = fopen(dest, "w");
    return yylex(); 
}