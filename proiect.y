%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
extern char* yytext;
extern FILE* yyin;
extern int yylineno;

int yyerror(char * s){
	printf("Eroare: %s la linia:%d\n",s,yylineno);
}

int yylex();

%}

%token BEGIN END TYPE IF ELSE WHILE FOR FLOATINGNUMBER NUMBER

%left '+' '-'
%left '*' '/'
%start starting_point
%%

starting_point: declarations BEGIN END {printf("program corect sintactic\n");}
			;

%%

int main(int argc, char** argv){
	/*st=fopen("symbol_table.txt","w");
	fprintf (st, "[NUME] [TIP] - [STRUCTURA/CLASA/FUNCTIE/GLOBAL]\n"); */
	yyin=fopen(argv[1],"r");
	printf("%d", yyparse());
}
