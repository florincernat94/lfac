%{
#include "y.tab.h"
#include <stdio.h>
%}
%option noyywrap
%%
"int"|"float"|"caracter"|"sir"|"boolean" {yylval.strval = strdup(yytext);return DTIP;}
"struct_"[a-zA-Z0-9]+ {yylval.strval=strdup(yytext); return STRUCTURA;}
"vec_"[a-zA-Z0-9]+ {yylval.strval=strdup(yytext); return VECTOR;}
"variabila_"[a-zA-Z0-9]+ {yylval.abc.nume_variabila=strdup(yytext);yylval.abc.valoare_intreaga=atoi(yytext);return VARIABILA;}
"constanta_"[a-zA-Z0-9]+ {yylval.abc.nume_variabila=strdup(yytext);yylval.abc.valoare_intreaga=atoi(yytext);return CONSTANTA;}
"privat" {yylval.strval=strdup(yytext); return PRIVAT;}
"public" {yylval.strval=strdup(yytext); return PUBLIC;}
"clasa_"[a-zA-Z0-9]+ {yylval.strval=strdup(yytext); return CLASA;}
"if" {return DACA;}
"else" {return ALTFEL;}
"while" {return CATTIMP;}
"for" {return PENTRU;}
"incepe_program" {return INCEPUT;}
"sfarsit_program" {return SFARSIT;}
[0-9]+"."[0-9]+ {yylval.floatval=atof(yytext); return FLOATNUMAR;}
[0-9]+ {yylval.intval=atoi(yytext);return NUMAR;}
"adevarat" {yylval.intval=1;yylval.abc.valoare_intreaga=1; return ADEVARAT;}
"fals" {yylval.intval=0;yylval.abc.valoare_intreaga=0; return FALS;}
"=" {return ATRIBUIRE;}
"sau" {return SAU;}
"si" {return SI;}
"negatie" {return NEGATIE;} 
"concatenare" {return CONCATENARE;}
"functie_"[a-zA-Z0-9]+ {yylval.strval=strdup(yytext); return FUNCTIE;}
"Eval" {return EVAL;}
"<" {return MAIMIC;}
">" {return MAIMARE;}
"==" {return EGALITATE;}
"++" {return PLUSPLUS;}
"--" {return MINUSMINUS;}
[a-zA-Z0-9]+ {yylval.strval=strdup(yytext); return OBIECT;}
"'"[a-zA-Z0-9]*"'" {yylval.strval=strdup(yytext); return CARACTERE;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}
