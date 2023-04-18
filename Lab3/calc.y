%{
#define YYSTYPE int
#include <iostream>
#include <string>
#define P 1234577
extern FILE *yyin;

using namespace std;

extern int yylex();
extern int yyparse();
int yyerror(string s);

int nwd(int a, int b);

int zp_sub(int a, int b);
int zp_subpow(int a, int b);

long int euclides(long a,long b,long *x,long *y);

long int zp_inv(long a);
long zp_invpow(long a);

long long zp_div(long a,long b);
long long zp_divpow(long a,long b);

long long zp_pow(long a, long long pow);

string error_msg = "";
string rpn = "";
%}

%token NUM
%token ERR
%left '+' '-'
%left '*' '/'
%right NEG
%nonassoc '^'

%%

input:
    /*empty*/
    | input line
;
line: 
    expr '\n' { 
            cout << rpn << endl;
            cout << "Wynik: " << $1 << "\n" << endl; 
            rpn = "";
        }
    | error '\n' { 
            if (error_msg == "") 
                error_msg = "zla skladnia";
            cout << "Blad: " << error_msg << "\n" << endl; 
            rpn = ""; 
            error_msg = "";
        }
;
expr: 
    number                          { rpn += to_string($1 % P) + " "; $$ = $1 % P;}
    | '(' expr ')'                  { $$ = $2; }
    | '-' '(' expr ')' %prec NEG    { rpn += "~ "; $$ = ((-$3 % P) + P) % P; }
    | expr '+' expr                 { rpn += "+ "; $$ = ($1 + $3) % P; }
    | expr '-' expr                 { rpn += "- "; $$ = zp_sub($1, $3); }
    | expr '*' expr                 { rpn += "* "; $$ = ($1 * $3) % P; }
    | expr '^' expr2                { rpn += "^ "; $$ = zp_pow($1, $3);} 
    | expr '/' expr                 { rpn += "/ "; $$ = zp_div($1, $3);
                                        if($3 == 0) {
                                            error_msg = "dzielenie przez 0";  
                                            YYERROR; 
                                        }else if($$ < 0) {
                                            $$ = ((-$$ % P) + P) % P;
                                        }else if(1 % nwd($3,P) != 0) {
                                            error_msg = "nie ma odwrotnosci modulo";  
                                            YYERROR;
                                        }
                                    }     
;
expr2:
    pownum                          { rpn += to_string($1 % (P-1)) + " " ; $$ = $1 % (P-1);} 
    | '(' expr2 ')'                 { $$ = $2; }
    | '-' '(' expr2 ')' %prec NEG   { rpn += "~ "; $$ = ((-$3 % (P-1)) + (P-1)) % (P-1); }
    | expr2 '+' expr2               { rpn += "+ "; $$ = ($1 + $3) % (P-1); }
    | expr2 '-' expr2               { rpn += "- "; $$ = zp_subpow($1, $3); }
    | expr2 '*' expr2               { rpn += "* "; $$ = ($1 * $3) % (P-1); }
    | expr2 '/' expr2               { rpn += "/ "; $$ = zp_divpow($1, $3);
                                        if($3 == 0) {
                                            error_msg = "dzielenie przez 0";  
                                            YYERROR; 
                                        }else if($$ < 0) {
                                            $$ = ((-$$ % (P-1)) + (P-1)) % (P-1);
                                        }else if(1 % nwd($3,(P-1)) != 0) {
                                            error_msg = "nie ma odwrotnosci modulo";  
                                            YYERROR;
                                        }
                                    }
number:
    NUM                             { $$ = $1; }
    | '-' number %prec NEG          { $$ = ((-$2 % P) + P) % P; }
;
pownum:
    NUM                             { $$ = $1; }
    | '-' pownum %prec NEG          { $$ = ((-$2 % (P-1)) + (P-1)) % (P-1);}

%%

int zp_subpow(int a, int b) {
    int val = (a - b) % (P-1);
    if (val < 0) val += (P-1);
    return val;
}

int nwd(int a, int b)
    {
        if (a == 0){
            return b;
        }
        return nwd(b % a, a);

    }

int zp_sub(int a, int b) {
    int val = (a-b) % P;
    if (val < 0)
        val += P;
    return val;
}

long euclides(long a,long b,long *x,long *y) {
    if (a == 0)
    {
        *x = 0, *y = 1;
        return b;
    }
 
    long x1, y1; // To store results of recursive call
    long gcd = euclides(b%a, a, &x1, &y1);
 
    *x = y1 - (b/a) * x1;
    *y = x1;
 
    return gcd;
}

long zp_inv(long a) {
    long x = 1;
    long y = 0;
    long g = euclides(a, P, &x, &y);
    return (x % P + P) % P;
}

long zp_invpow(long a) {
    long x,y;
    euclides(a, P-1, &x, &y);
    return (x % (P-1) + (P-1)) % (P-1);
}

long long zp_div(long a, long b) {
    a = a % P;
    long long inv = zp_inv(b);
    return ((inv * a) % P);
}

long long zp_divpow(long int a,long int b) {
    a = a % (P-1);
    long int inv = zp_invpow(b);
    return ((inv * a) % (P-1));
}

long long zp_pow(long a, long long pow) {
    if (pow == 0)
        return 1;
    long long mult = a;
    for (int i = 1; i < pow; i++) {
        mult = (mult*a) % P;
    }
    return mult;
}

int yyerror(string s) {	
    return 0;
}

int main(int argc, char* argv[])
{
    yyin = fopen(argv[1], "r");
    yyparse();
    return 0;
}