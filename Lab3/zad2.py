from ply import lex, yacc
import sys

import lexrules
import yaccrules


def main():
    lexer = lex.lex(module=lexrules)
    parser = yacc.yacc(module=yaccrules)
    #inputfile = open(inputfile, 'r')
    while True:
        text = ""
        while True:
            try:
                #inputfile.readline
                text += input()
            except EOFError:
                #inputfile.close()
                return
            text += '\n'
            if not text.endswith('\\\n'):
                break
        parser.parse(text, lexer=lexer)


if __name__ == "__main__":
    #main(sys.argv[1])
    main()