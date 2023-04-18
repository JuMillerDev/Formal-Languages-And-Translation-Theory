%{
#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>
#include<math.h>
#include<string.h>

#define stack_size 100

int yylex();
int yywrap();

bool error = false;
int ptr = -1;
int stack[stack_size];
bool stack_err = false; 

void push(int num) {
    ptr++;
    if (ptr < stack_size) {
        stack[ptr] = num;
    } else {
        fprintf(yyout, "\nStackError");
        stack_err = true;
    } 
}

int pop()  {
    if (ptr >= 0) {
        ptr--;
        return stack[ptr + 1];
    } else {
        fprintf(yyout,"\nBłąd zbyt mało argumentów.\n");
        stack_err = true;
        return 0;
    }
}

%}

%x ERROR

%%
-?[0-9]+       {    ECHO;
                    push(atoi(yytext));
                } 
\+            {     ECHO;
                    push(pop()+pop());
                    
                    if (stack_err) BEGIN(ERROR);
                }
\-             {    ECHO;
                    int a = pop();
                    int b = pop();
                    push(b - a);
                    if (stack_err) BEGIN(ERROR);
                }
\*             {    ECHO;
                    push(pop()*pop());
                    if (stack_err) BEGIN(ERROR);
                }
\/             {    ECHO;
                    int divisor = pop();
                    if (divisor == 0) {
                        fprintf(yyout,"\nBłąd: nie dziel przez 0!\n");
                        BEGIN(ERROR);
                    } else {
                        push(pop() / divisor);
                    }
                    if (stack_err) BEGIN(ERROR);
                }
\%             {    ECHO;
                    int divisor = pop();
                    if (divisor == 0) {
                        fprintf(yyout,"\nBłąd: nie dziel przez 0!\n");
                        BEGIN(ERROR);
                    } else {
                        push(pop() % divisor);
                    }
                    if (stack_err) BEGIN(ERROR);
                }

\^             {    ECHO;
                    push( (int) pow((double) pop(), (double) pop()));
                }  

\n            {       
                    if(!error){
                        if (ptr == 0) {
                        fprintf(yyout,"\n= %d\n", pop());
                    } else if(ptr > 0 ){
                        fprintf(yyout,"\nBłąd: zła ilość operatorów.\n");
                    }
                    } else {
                        fprintf(yyout,"\nZbyt mało argumentów\n");
                        error = false;
                    }
                    ptr = -1;
                    
                }
[^[:blank:]]    {fprintf(yyout,"\nBłąd: zły symbol %s\n", yytext); error = true;};
[[:blank:]]     ;

<ERROR>.*       ECHO;
<ERROR>\n       { 
                    ptr = -1;
                    stack_err = false;
                    BEGIN(INITIAL);
                }
%%

int yywrap() {
    return 1;
}

int main(int argc,char* argv[]) {
    yyin = fopen(argv[1], "r");
    char dest[12] = "r.";
    strcat(dest, argv[1]);
    yyout = fopen(dest, "w");
    return yylex();
}