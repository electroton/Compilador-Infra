/* lexer.l - Lexical analyzer for the Infra language compiler
 * Tokenizes the source code into meaningful symbols for the parser
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tokens.h"

int line_number = 1;
%}

/* Regular expression definitions */
DIGIT       [0-9]
LETTER      [a-zA-Z_]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*
INTEGER     {DIGIT}+
FLOAT       {DIGIT}+"."{DIGIT}+
STRING      \"([^\\\"]|\\.)*\"

%%

/* Keywords */
"programa"      { return TK_PROGRAMA; }
"inicio"        { return TK_INICIO; }
"fim"           { return TK_FIM; }
"se"            { return TK_SE; }
"entao"         { return TK_ENTAO; }
"senao"         { return TK_SENAO; }
"enquanto"      { return TK_ENQUANTO; }
"faca"          { return TK_FACA; }
"para"          { return TK_PARA; }
"ate"           { return TK_ATE; }
"passo"         { return TK_PASSO; }
"leia"          { return TK_LEIA; }
"escreva"       { return TK_ESCREVA; }
"inteiro"       { return TK_INTEIRO; }
"real"          { return TK_REAL; }
"caractere"     { return TK_CARACTERE; }
"logico"        { return TK_LOGICO; }
"verdadeiro"    { return TK_VERDADEIRO; }
"falso"         { return TK_FALSO; }
"retorne"       { return TK_RETORNE; }
"funcao"        { return TK_FUNCAO; }

/* Arithmetic operators */
"+"             { return TK_MAIS; }
"-"             { return TK_MENOS; }
"*"             { return TK_MULT; }
"/"             { return TK_DIV; }
"%"             { return TK_MOD; }

/* Relational operators */
"=="            { return TK_IGUAL; }
"!="            { return TK_DIFERENTE; }
"<"             { return TK_MENOR; }
">"             { return TK_MAIOR; }
"<="            { return TK_MENOR_IGUAL; }
">="            { return TK_MAIOR_IGUAL; }

/* Logical operators */
"&&"            { return TK_E; }
"||"            { return TK_OU; }
"!"             { return TK_NAO; }

/* Assignment */
"<-"            { return TK_ATRIBUICAO; }

/* Delimiters */
"("             { return TK_ABRE_PAREN; }
")"             { return TK_FECHA_PAREN; }
"{"             { return TK_ABRE_CHAVE; }
"}"             { return TK_FECHA_CHAVE; }
"["             { return TK_ABRE_COLCH; }
"]"             { return TK_FECHA_COLCH; }
";"             { return TK_PONTO_VIRG; }
","             { return TK_VIRGULA; }
"."             { return TK_PONTO; }

/* Literals */
{FLOAT}         {
                    yylval.fval = atof(yytext);
                    return TK_NUM_REAL;
                }
{INTEGER}       {
                    yylval.ival = atoi(yytext);
                    return TK_NUM_INTEIRO;
                }
{STRING}        {
                    yylval.sval = strdup(yytext);
                    return TK_CADEIA;
                }

/* Identifier */
{IDENTIFIER}    {
                    yylval.sval = strdup(yytext);
                    return TK_ID;
                }

/* Comments - single line */
"//".*          { /* ignore single-line comments */ }

/* Comments - multi-line */
"/*"([^*]|\*+[^*/])*\*+"/"  { 
                    /* count newlines inside block comments */
                    char *p;
                    for (p = yytext; *p; p++)
                        if (*p == '\n') line_number++;
                }

/* Whitespace */
"\n"            { line_number++; }
[ \t\r]+        { /* ignore whitespace */ }

/* Unknown character */
.               {
                    fprintf(stderr, "Erro lexico: caractere desconhecido '%s' na linha %d\n",
                            yytext, line_number);
                }

%%

int yywrap(void) {
    return 1;
}
