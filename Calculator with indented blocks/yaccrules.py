from lexrules import tokens, P

tokens = tokens[:-3]
rpn = ""
zero_div = False
beyond_div = False
precedence = (
    ('left', 'ADD', 'SUB'),
    ('left', 'MUL', 'DIV'),
    ('right', 'NEG'),
    ('nonassoc', 'POW')
)

def nwd(a, b):
    while b != 0:
        a, b = b, a % b
    return a

def p_line_expr(p):
    'line : expr ENDL'
    global rpn, zero_div, beyond_div
    print(rpn)
    print(f"= {p[1]}")
    rpn = ""
    zero_div = False
    beyond_div = False

def p_line_error(p):
    'line : error ENDL'
    global rpn, zero_div, beyond_div
    if zero_div:
        print("Blad: dzielenie przez 0")
    elif beyond_div:
        print("Blad: nie ma odwrotnosci modulo")
    else:
        print("Blad: zla skladnia")
    rpn = ""
    zero_div = False
    beyond_div = False

def p_expr_number(p):
    'expr : number'
    global rpn
    rpn += f"{p[1] % P} "
    p[0] = (p[1] % P)

def p_expr2_number(p):
    'expr2 : pownum'
    global rpn
    rpn += f"{p[1] % (P-1)} "
    p[0] = (p[1] % (P-1))

def p_expr_paren(p):
    'expr : LPAREN expr RPAREN'
    p[0] = p[2]

def p_expr2_paren(p):
    'expr2 : LPAREN expr2 RPAREN'
    p[0] = p[2]

def p_expr_neg(p):
    'expr : SUB LPAREN expr RPAREN %prec NEG'
    global rpn
    rpn += "~ "
    p[0] = -p[3] % P

def p_expr2_neg(p):
    'expr2 : SUB LPAREN expr2 RPAREN %prec NEG'
    global rpn
    rpn += "~ "
    p[0] = (-p[3] % (P-1))

def p_expr_add(p):
    'expr : expr ADD expr'
    global rpn
    rpn += "+ "
    p[0] = (p[1] + p[3]) % P

def p_expr2_add(p):
    'expr2 : expr2 ADD expr2'
    global rpn
    rpn += "+ "
    p[0] = (p[1] + p[3]) % (P-1)

def p_expr_sub(p):
    'expr : expr SUB expr'
    global rpn
    rpn += "- "
    p[0] = (p[1] - p[3]) % P

def p_expr2_sub(p):
    'expr2 : expr2 SUB expr2'
    global rpn
    rpn += "- "
    p[0] = (p[1] - p[3]) % (P-1)

def p_expr_mul(p):
    'expr : expr MUL expr'
    global rpn
    rpn += "* "
    p[0] = (p[1] * p[3]) % P

def p_expr2_mul(p):
    'expr2 : expr2 MUL expr2'
    global rpn
    rpn += "* "
    p[0] = (p[1] * p[3]) % (P-1)

def p_expr_pow(p):
    'expr : expr POW expr2'
    global rpn
    rpn += " ^ "
    p[0] = pow(p[1], p[3], P)

def p_expr_div(p):
    'expr : expr DIV expr'
    global rpn
    rpn += "/ "
    if p[3] == 0:
        global zero_div
        zero_div = True
        raise SyntaxError
    elif nwd(p[3], P-1) != 1:
        global beyond_div
        beyond_div = True
        raise SyntaxError
    p[0] = (p[1] * pow(p[3], -1, P)) % P
    if p[0] < 0:
        p[0] = ((-p[0] % P) + P) % P
    

def p_expr2_div(p):
    'expr2 : expr2 DIV expr2'
    global rpn
    rpn += "/ "
    if p[3] == 0:
        global zero_div
        zero_div = True
        raise SyntaxError
    elif nwd(p[3], P-1) != 1:
        global beyond_div
        beyond_div = True
        raise SyntaxError
    p[0] = (p[1] * pow(p[3], -1, P-1)) % (P-1)
    if p[0] < 0:
        p[0] = ((-p[0] % (P-1)) + (P-1)) % (P-1) 

def p_number_pos(p):
    'number : NUM'
    p[0] = p[1]

def p_number_neg(p):
    'number : SUB number %prec NEG'
    p[0] = ((-p[2] % P)+P) % P

def p_pownum_pos(p):
    'pownum : NUM'
    p[0] = p[1]

def p_pownum_neg(p):
    'pownum : SUB pownum %prec NEG'
    p[0] = ((-p[2] % (P-1))+ (P-1)) % (P-1)

def p_error(p):
    pass