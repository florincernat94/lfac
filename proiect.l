%{
#include "y.tab.h"
#include <stdio.h>
%}
%option noyywrap
%%
"int"|"float"|"char"|"str"|"boolean" {return TYPE;}
"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"for" {return FOR;}
"begin" {return BEGIN;}
"end" {return END;}
[0-9]+"."[0-9]+ {yylval.floatval=atof(yytext); return FLOATINGNUMBER;}
[0-9]+ {yylval.intval=atoi(yytext);return NUMBER;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}
