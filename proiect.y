%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
extern char* yytext;
extern FILE* yyin;
extern int yylineno;
FILE *st;
FILE *stocareVariabila;

int yyerror(char * s){
	printf("Eroare: %s la linia:%d\n",s,yylineno);
}

int yylex();

int ok_spatiu=0;
void functie_spatiu(){
	if(ok_spatiu==0)
		fprintf(st,"\n\n");
	ok_spatiu++;
}

struct variabila{
	int val_int;
	float val_zec;
	int val_bool;
	char* val_car;
	int type;
	char* nume;
}variabile[100];
int i=0;
int ok_cautare=0;
int cautare_variabila(char *name_var){
	if(i==0&&ok_cautare==0){
		ok_cautare=1;
		printf("Variabilele globale nu pot fi initiliazate cu alte variabile\n");
		exit(0);
	}
	for(int k=0;k<i;k++){
		//printf("%s\n",variabile[k].nume);
		//printf("%s %s\n",variabile[k].nume,name_var);
		if(strcmp(variabile[k].nume,name_var)==0)
			return k;
	}
	return -1;
}

int verificare_variabila(char *name_var){
	for(int k=0;k<i;k++){
		if(strcmp(variabile[k].nume,name_var)==0)
			return 0;
	}
	printf("Variabila nu a fost declarata\n");
	return -1;
}

int stocare_variabila(char* tip, char* name){
	/*0-int 1-float 2-bool 3-caracter 4-string*/
	for(int k=0;k<i;k++){
		//printf("%s %s\n",variabile[k].nume,name_var);
		if(strcmp(variabile[k].nume,name)==0){
			printf("%s - variabila deja declarata\n",name);
			exit(0);
		}
	}
	
	if(strcmp(tip,"int")==0){
		variabile[i].type=0;

	}
	if(strcmp(tip,"float")==0){
		variabile[i].type=1;

	}
	if(strcmp(tip,"boolean")==0){
		variabile[i].type=2;

	}
	if(strcmp(tip,"caracter")==0){
		variabile[i].type=3;
		
	}
	if(strcmp(tip,"sir")==0){
		variabile[i].type=4;
		
	}
	variabile[i].nume=name;
	// printf("%s\n",variabile[i].nume);
	i++;
	//printf("i=%d\n\n",i);
	//printf("%s %d",variabile[i].nume,variabile[i].type);
	return 1;
}

int atribuire_variabila_aritmetica(char* name, int valoare){
	if(valoare!=floor(valoare)){
		printf("%s - valoarea asignata nu este de tipul potrivit\n",name);
		exit(0);
		return 0;
	}
	//printf("%d\n",i);
	for(int j=0;j<i;j++){
		if(strcmp(variabile[j].nume,name)==0){
			if(variabile[j].type==0){
				variabile[j].val_int=valoare;
				return 1;
			}
			else {
				printf("%s - variabila nu este de tipul potrivit\n",variabile[j].nume);
				exit(0);
				return 0;
			}
		}
	}
	printf("%s - variabila nu a fost declarata\n",name);
	exit(0);
	return 0;
}

int atribuire_variabila_float(char* name, float valoare){
	if(valoare==(int)valoare){
		printf("%s - valoarea asignata nu este de tipul potrivit\n",name);
		exit(0);
	}
	for(int j=0;j<i;j++){
		if(strcmp(variabile[j].nume,name)==0){
			if(variabile[j].type==1){
				variabile[j].val_zec=valoare;
				return 1;
			}
			else {
				printf("%s - variabila nu este de tipul potrivit\n",variabile[j].nume);
				exit(0);
				return 0;
			}
		}
	}
	printf("%s - variabila nu a fost declarata\n",name);
	exit(0);
	return 0;
}

int atribuire_variabila_bool(char* name, int valoare){
	for(int j=0;j<i;j++){
		if(strcmp(variabile[j].nume,name)==0){
			if(variabile[j].type==2){
				if(valoare==1){
					variabile[j].val_bool=1;
					return 1;
				}
				if(valoare==0){
					variabile[j].val_bool=0;
					return 1;
				}
			}
			else {
				printf("%s - variabila nu este de tipul potrivit\n",variabile[j].nume);
				exit(0);
				return 0;
			}
		}
	}
	printf("%s - variabila nu a fost declarata\n",name);
	exit(0);
	return 0;
}

int atribuire_variabila_sir(char* name, char* valoare){
	/*1-caracter 2-sir*/
	for(int j=0;j<i;j++){
		if(strcmp(variabile[j].nume,name)==0){
			if(variabile[j].type==3){
				if(strlen(valoare)==3){
					variabile[j].val_car=valoare;
					return 1;
				}
			}
			if(variabile[j].type==4){
				variabile[j].val_car=valoare;
				return 2;
			}
			else {
				printf("%s - variabila nu este de tipul potrivit\n",variabile[j].nume);
				exit(0);
				return 0;
			}
		}
	}
	printf("%s - variabila nu a fost declarata\n",name);
	exit(0);
	return 0;
}

%}
%union{
	int intval;
	char *strval;
	float floatval;
	_Bool boolval;
	struct var{
		int valoare_intreaga;
		float valoare_zecimala;
		_Bool valoare_booleana;
		char* valoare_caracter;
		char* nume_variabila;
	}abc;
}
%token DACA ALTFEL CATTIMP PENTRU INCEPUT SFARSIT ATRIBUIRE SAU SI NEGATIE EVAL MAIMIC MAIMARE EGALITATE PLUSPLUS MINUSMINUS
%token <strval> PUBLIC
%token <strval> PRIVAT
%token <strval> DTIP
%token <strval> VECTOR
%token <strval> CLASA
%token <strval> STRUCTURA
%token <strval> FUNCTIE
%token <strval> OBIECT
%token <intval> NUMAR
%token <floatval> FLOATNUMAR
%token <intval> ADEVARAT
%token <intval> FALS
%token <strval> CARACTERE
%token <strval> CONCATENARE
%token <abc> VARIABILA
%token <abc> CONSTANTA
%type <intval> bool_var
%type <intval> expr_bool
%type <intval> expr_ar
%type <intval> adev_fals_var
%type <floatval> expr_float
%type <intval> var_const
%type <floatval> var_const_float
%type <strval> expr_sir

%left '+' '-'
%left '*' '/'
%start simbol_start
%%

simbol_start: declaratii INCEPUT cod SFARSIT {printf("program corect sintactic\n");}
			;
declaratii: CLASA '{' privat_public '}' ';' declaratii {fprintf (st, "%s - global\n",$1);}
          | DTIP VARIABILA ATRIBUIRE expr_ar ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_intreaga=$4;atribuire_variabila_aritmetica($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - global %d\n",$2.nume_variabila,$1,$2.valoare_intreaga);}
		  | DTIP VARIABILA ATRIBUIRE expr_bool ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_booleana=$4;atribuire_variabila_bool($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - global %d\n",$2.nume_variabila,$1,$2.valoare_booleana);}
		  | DTIP VARIABILA ATRIBUIRE expr_sir ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_caracter=$4;atribuire_variabila_sir($2.nume_variabila,$2.valoare_caracter);fprintf (st, "%s %s - global %s\n",$2.nume_variabila,$1,$2.valoare_caracter);}
		  | DTIP VARIABILA ATRIBUIRE bool_var ';' declaratii {stocare_variabila($1,$2.nume_variabila);fprintf (st, "%s %s - global %d\n",$2.nume_variabila,$1,$4);}
		  | DTIP VARIABILA ATRIBUIRE expr_float ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_zecimala=$4;atribuire_variabila_float($2.nume_variabila,$2.valoare_zecimala);fprintf (st, "%s %s - global %f\n",$2.nume_variabila,$1,$2.valoare_zecimala);}
		  | DTIP VARIABILA ';' declaratii {stocare_variabila($1,$2.nume_variabila);fprintf (st, "%s %s - global\n",$2.nume_variabila,$1); }
		  | DTIP VECTOR dimensiune ';' declaratii {fprintf (st, "%s %s - global\n",$2,$1); }
		  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista '}' ';' declaratii {fprintf (st, "%s %s",$2,$1); }
		  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_string '}' ';' declaratii {fprintf (st, "%s %s - global\n",$2,$1); }
		  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_booleana '}' ';' declaratii {fprintf (st, "%s %s - global\n",$2,$1); }
		  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_float '}' ';' declaratii {fprintf (st, "%s %s - global\n",$2,$1); }
		  | DTIP CONSTANTA ATRIBUIRE expr_ar ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_intreaga=$4;atribuire_variabila_aritmetica($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - global %d\n",$2.nume_variabila,$1,$2.valoare_intreaga);}
		  | DTIP CONSTANTA ATRIBUIRE expr_bool ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_booleana=$4;atribuire_variabila_bool($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - global %d\n",$2.nume_variabila,$1,$2.valoare_booleana);}
		  | DTIP CONSTANTA ATRIBUIRE expr_sir ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_caracter=$4;atribuire_variabila_sir($2.nume_variabila,$2.valoare_caracter);fprintf (st, "%s %s - global %s\n",$2.nume_variabila,$1,$2.valoare_caracter);}
		  | DTIP CONSTANTA ATRIBUIRE bool_var ';' declaratii {stocare_variabila($1,$2.nume_variabila);fprintf (st, "%s %s - global %d\n",$2.nume_variabila,$1,$4);}
		  | DTIP CONSTANTA ATRIBUIRE expr_float ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_zecimala=$4;atribuire_variabila_float($2.nume_variabila,$2.valoare_zecimala);fprintf (st, "%s %s - global %f\n",$2.nume_variabila,$1,$2.valoare_zecimala);}
		  | DTIP FUNCTIE '(' parametri_initializare ')' '{' cod_functie '}' ';' declaratii {fprintf (st, "%s %s - global\n",$2,$1); }
		  | STRUCTURA '{' cod_structura '}' ';' declaratii {fprintf (st, "%s - global\n",$1); }
		  |
		  ;

dimensiune: '[' NUMAR ']' dimensiune
		  | '[' NUMAR ']'
		  | '[' VARIABILA ']' dimensiune
		  | '[' VARIABILA ']'
		  ;
lista: expr_ar ',' lista
	 | expr_ar
	 ;
lista_string: expr_sir ',' lista_string
			| expr_sir
			;
lista_booleana: expr_bool ',' lista_booleana
			  | expr_bool
			  | bool_var
			  | bool_var ',' lista_booleana
			  ;
lista_float: expr_float ',' lista_float
		   | expr_float
		   ;

privat_public: publicclasa privatclasa
			 ;
publicclasa: PUBLIC ':' cod_clasa
		   ;
privatclasa: PRIVAT ':' cod_clasa
		   |
		   ;

cod_clasa: DTIP VARIABILA ';' sfarsit_cod_clasa {fprintf (st, "%s %s - in clasa\n",$2.nume_variabila,$1); }
		 | CLASA OBIECT ';' {fprintf (st, "%s %s - in clasa\n",$2,$1); }
		 | STRUCTURA OBIECT ';' {fprintf (st, "%s %s - in clasa\n",$2,$1); }
		 | DTIP VARIABILA ATRIBUIRE expr_ar ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_intreaga=$4;atribuire_variabila_aritmetica($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in clasa %d\n",$2.nume_variabila,$1,$2.valoare_intreaga);}
		 | DTIP VARIABILA ATRIBUIRE expr_bool ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_booleana=$4;atribuire_variabila_bool($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in clasa %d\n",$2.nume_variabila,$1,$2.valoare_booleana);}
		 | DTIP VARIABILA ATRIBUIRE expr_sir ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_caracter=$4;atribuire_variabila_sir($2.nume_variabila,$2.valoare_caracter);fprintf (st, "%s %s - in clasa %s\n",$2.nume_variabila,$1,$2.valoare_caracter);}
		 | DTIP VARIABILA ATRIBUIRE bool_var ';' declaratii {stocare_variabila($1,$2.nume_variabila);fprintf (st, "%s %s - in clasa %d\n",$2.nume_variabila,$1,$4);}
		 | DTIP VARIABILA ATRIBUIRE expr_float ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_zecimala=$4;atribuire_variabila_float($2.nume_variabila,$2.valoare_zecimala);fprintf (st, "%s %s - in clasa %f\n",$2.nume_variabila,$1,$2.valoare_zecimala);}
		 | DTIP VECTOR dimensiune ';' sfarsit_cod_clasa {fprintf (st, "%s %s - in clasa\n",$2,$1); }
		 | DTIP VECTOR dimensiune ATRIBUIRE '{' lista '}' ';' sfarsit_cod_clasa {fprintf (st, "%s %s - in clasa\n",$2,$1); }
		 | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_string '}' ';' sfarsit_cod_clasa {fprintf (st, "%s %s - in clasa\n",$2,$1); }
		 | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_booleana '}' ';' sfarsit_cod_clasa {fprintf (st, "%s %s - in clasa\n",$2,$1); }
		 | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_float '}' ';' sfarsit_cod_clasa {fprintf (st, "%s %s - in clasa\n",$2,$1); }
		 | DTIP CONSTANTA ATRIBUIRE expr_ar ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_intreaga=$4;atribuire_variabila_aritmetica($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in clasa %d\n",$2.nume_variabila,$1,$2.valoare_intreaga);}
		 | DTIP CONSTANTA ATRIBUIRE expr_bool ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_booleana=$4;atribuire_variabila_bool($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in clasa %d\n",$2.nume_variabila,$1,$2.valoare_booleana);}
		 | DTIP CONSTANTA ATRIBUIRE expr_sir ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_caracter=$4;atribuire_variabila_sir($2.nume_variabila,$2.valoare_caracter);fprintf (st, "%s %s - in clasa %s\n",$2.nume_variabila,$1,$2.valoare_caracter);}
		 | DTIP CONSTANTA ATRIBUIRE bool_var ';' declaratii {stocare_variabila($1,$2.nume_variabila);fprintf (st, "%s %s - in clasa %d\n",$2.nume_variabila,$1,$4);}
		 | DTIP CONSTANTA ATRIBUIRE expr_float ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_zecimala=$4;atribuire_variabila_float($2.nume_variabila,$2.valoare_zecimala);fprintf (st, "%s %s - in clasa %f\n",$2.nume_variabila,$1,$2.valoare_zecimala);}
		 | DTIP FUNCTIE '(' parametri_initializare ')' '{' cod_functie '}' ';' sfarsit_cod_clasa {fprintf (st, "%s %s - in clasa\n",$2,$1); }
		 ;
sfarsit_cod_clasa: cod_clasa
				 |
				 ;
parametri_initializare: DTIP VARIABILA ',' ultimii_parametrii {stocare_variabila($1,$2.nume_variabila);}
					  | DTIP VARIABILA {stocare_variabila($1,$2.nume_variabila);}
					  | DTIP VARIABILA ATRIBUIRE expr_ar ',' ultimii_parametrii {stocare_variabila($1,$2.nume_variabila);$2.valoare_intreaga=$4;atribuire_variabila_aritmetica($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in clasa %d\n",$2.nume_variabila,$1,$2.valoare_intreaga);}
					  | DTIP VARIABILA ATRIBUIRE expr_ar ',' {stocare_variabila($1,$2.nume_variabila);$2.valoare_intreaga=$4;atribuire_variabila_aritmetica($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in clasa %d\n",$2.nume_variabila,$1,$2.valoare_intreaga);}
					  | DTIP VARIABILA ATRIBUIRE expr_sir ',' ultimii_parametrii {stocare_variabila($1,$2.nume_variabila);$2.valoare_caracter=$4;atribuire_variabila_sir($2.nume_variabila,$2.valoare_caracter);fprintf (st, "%s %s - in clasa %s\n",$2.nume_variabila,$1,$2.valoare_caracter);}
					  | DTIP VARIABILA ATRIBUIRE expr_sir ',' {stocare_variabila($1,$2.nume_variabila);$2.valoare_caracter=$4;atribuire_variabila_sir($2.nume_variabila,$2.valoare_caracter);fprintf (st, "%s %s - in clasa %s\n",$2.nume_variabila,$1,$2.valoare_caracter);}
					  | DTIP VARIABILA ATRIBUIRE expr_bool ',' ultimii_parametrii {stocare_variabila($1,$2.nume_variabila);$2.valoare_booleana=$4;atribuire_variabila_bool($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in clasa %d\n",$2.nume_variabila,$1,$2.valoare_booleana);}
					  | DTIP VARIABILA ATRIBUIRE expr_bool ',' {stocare_variabila($1,$2.nume_variabila);$2.valoare_booleana=$4;atribuire_variabila_bool($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in clasa %d\n",$2.nume_variabila,$1,$2.valoare_booleana);}
					  | DTIP VARIABILA ATRIBUIRE bool_var ',' ultimii_parametrii {stocare_variabila($1,$2.nume_variabila);fprintf (st, "%s %s - in clasa %d\n",$2.nume_variabila,$1,$4);}
					  | DTIP VARIABILA ATRIBUIRE bool_var ',' {stocare_variabila($1,$2.nume_variabila);fprintf (st, "%s %s - in clasa %d\n",$2.nume_variabila,$1,$4);}
					  | DTIP VARIABILA ATRIBUIRE expr_float ',' ultimii_parametrii {stocare_variabila($1,$2.nume_variabila);$2.valoare_zecimala=$4;atribuire_variabila_float($2.nume_variabila,$2.valoare_zecimala);fprintf (st, "%s %s - in clasa %f\n",$2.nume_variabila,$1,$2.valoare_zecimala);}
					  | DTIP VARIABILA ATRIBUIRE expr_float ',' {stocare_variabila($1,$2.nume_variabila);$2.valoare_zecimala=$4;atribuire_variabila_float($2.nume_variabila,$2.valoare_zecimala);fprintf (st, "%s %s - in clasa %f\n",$2.nume_variabila,$1,$2.valoare_zecimala);}
					  | DTIP VECTOR dimensiune ',' ultimii_parametrii
					  | DTIP VECTOR dimensiune
					  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista '}' ',' ultimii_parametrii
					  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista '}' ','
					  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_string '}' ',' ultimii_parametrii
					  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_string '}' ','
					  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_booleana '}' ',' ultimii_parametrii
					  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_booleana '}' ',' 
					  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_float '}' ',' ultimii_parametrii
					  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_float '}' ','
					  | 
					  ;
ultimii_parametrii: DTIP VARIABILA ',' ultimii_parametrii {stocare_variabila($1,$2.nume_variabila);}
				  | DTIP VARIABILA {stocare_variabila($1,$2.nume_variabila);}
			      | DTIP VARIABILA ATRIBUIRE expr_ar ',' ultimii_parametrii {stocare_variabila($1,$2.nume_variabila);$2.valoare_intreaga=$4;atribuire_variabila_aritmetica($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in clasa %d\n",$2.nume_variabila,$1,$2.valoare_intreaga);}
				  | DTIP VARIABILA ATRIBUIRE expr_ar ',' {stocare_variabila($1,$2.nume_variabila);$2.valoare_intreaga=$4;atribuire_variabila_aritmetica($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in clasa %d\n",$2.nume_variabila,$1,$2.valoare_intreaga);}
				  | DTIP VARIABILA ATRIBUIRE expr_sir ',' ultimii_parametrii {stocare_variabila($1,$2.nume_variabila);$2.valoare_caracter=$4;atribuire_variabila_sir($2.nume_variabila,$2.valoare_caracter);fprintf (st, "%s %s - in clasa %s\n",$2.nume_variabila,$1,$2.valoare_caracter);}
				  | DTIP VARIABILA ATRIBUIRE expr_sir ',' {stocare_variabila($1,$2.nume_variabila);$2.valoare_caracter=$4;atribuire_variabila_sir($2.nume_variabila,$2.valoare_caracter);fprintf (st, "%s %s - in clasa %s\n",$2.nume_variabila,$1,$2.valoare_caracter);}
				  | DTIP VARIABILA ATRIBUIRE expr_bool ',' ultimii_parametrii {stocare_variabila($1,$2.nume_variabila);$2.valoare_booleana=$4;atribuire_variabila_bool($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in clasa %d\n",$2.nume_variabila,$1,$2.valoare_booleana);}
				  | DTIP VARIABILA ATRIBUIRE expr_bool ',' {stocare_variabila($1,$2.nume_variabila);$2.valoare_booleana=$4;atribuire_variabila_bool($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in clasa %d\n",$2.nume_variabila,$1,$2.valoare_booleana);}
				  | DTIP VARIABILA ATRIBUIRE bool_var ',' ultimii_parametrii {stocare_variabila($1,$2.nume_variabila);fprintf (st, "%s %s - in clasa %d\n",$2.nume_variabila,$1,$4);}
				  | DTIP VARIABILA ATRIBUIRE bool_var ',' {stocare_variabila($1,$2.nume_variabila);fprintf (st, "%s %s - in clasa %d\n",$2.nume_variabila,$1,$4);}
				  | DTIP VARIABILA ATRIBUIRE expr_float ',' ultimii_parametrii {stocare_variabila($1,$2.nume_variabila);$2.valoare_zecimala=$4;atribuire_variabila_float($2.nume_variabila,$2.valoare_zecimala);fprintf (st, "%s %s - in clasa %f\n",$2.nume_variabila,$1,$2.valoare_zecimala);}
				  | DTIP VARIABILA ATRIBUIRE expr_float ',' {stocare_variabila($1,$2.nume_variabila);$2.valoare_zecimala=$4;atribuire_variabila_float($2.nume_variabila,$2.valoare_zecimala);fprintf (st, "%s %s - in clasa %f\n",$2.nume_variabila,$1,$2.valoare_zecimala);}
				  | DTIP VECTOR dimensiune ',' ultimii_parametrii
				  | DTIP VECTOR dimensiune
				  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista '}' ',' ultimii_parametrii
				  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista '}'
				  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_string '}' ',' ultimii_parametrii
				  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_string '}' ','
				  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_booleana '}' ',' ultimii_parametrii
				  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_booleana '}' ',' 
				  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_float '}' ',' ultimii_parametrii
				  | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_float '}' ',' 
				  ;
cod_functie: DTIP VARIABILA ATRIBUIRE expr_ar ';' cod_functie {stocare_variabila($1,$2.nume_variabila);$2.valoare_intreaga=$4;atribuire_variabila_aritmetica($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in functie %d\n",$2.nume_variabila,$1,$2.valoare_intreaga);}
		   | DTIP VARIABILA ATRIBUIRE expr_bool ';' cod_functie {stocare_variabila($1,$2.nume_variabila);$2.valoare_booleana=$4;atribuire_variabila_bool($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in functie %d\n",$2.nume_variabila,$1,$2.valoare_booleana);}
		   | DTIP VARIABILA ATRIBUIRE expr_sir ';' cod_functie {stocare_variabila($1,$2.nume_variabila);$2.valoare_caracter=$4;atribuire_variabila_sir($2.nume_variabila,$2.valoare_caracter);fprintf (st, "%s %s - in functie %s\n",$2.nume_variabila,$1,$2.valoare_caracter);}
		   | DTIP VARIABILA ATRIBUIRE bool_var ';' cod_functie {stocare_variabila($1,$2.nume_variabila);fprintf (st, "%s %s - in functie %d\n",$2.nume_variabila,$1,$4);}
		   | DTIP VARIABILA ATRIBUIRE expr_float ';' cod_functie {stocare_variabila($1,$2.nume_variabila);$2.valoare_zecimala=$4;atribuire_variabila_float($2.nume_variabila,$2.valoare_zecimala);fprintf (st, "%s %s - in functie %f\n",$2.nume_variabila,$1,$2.valoare_zecimala);}
		   | DTIP VARIABILA ';' cod_functie {stocare_variabila($1,$2.nume_variabila);fprintf (st, "%s %s - in functie\n",$2.nume_variabila,$1); }
		   | DTIP VECTOR dimensiune ';' cod_functie {fprintf (st, "%s %s - in functie\n",$2,$1); }
		   | DTIP VECTOR dimensiune ATRIBUIRE '{' lista '}' ';' cod_functie {fprintf (st, "%s %s - in functie\n",$2,$1); } 
		   | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_string '}' ';' cod_functie {fprintf (st, "%s %s - in functie\n",$2,$1); }
		   | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_booleana '}' ';' cod_functie {fprintf (st, "%s %s - in functie\n",$2,$1); }
		   | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_float '}' ';' cod_functie {fprintf (st, "%s %s - in functie\n",$2,$1); }
		   | DTIP CONSTANTA ATRIBUIRE expr_ar ';' cod_functie {stocare_variabila($1,$2.nume_variabila);$2.valoare_intreaga=$4;atribuire_variabila_aritmetica($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in functie %d\n",$2.nume_variabila,$1,$2.valoare_intreaga);}
		   | DTIP CONSTANTA ATRIBUIRE expr_bool ';' cod_functie {stocare_variabila($1,$2.nume_variabila);$2.valoare_booleana=$4;atribuire_variabila_bool($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in functie %d\n",$2.nume_variabila,$1,$2.valoare_booleana);}
		   | DTIP CONSTANTA ATRIBUIRE expr_sir ';' cod_functie {stocare_variabila($1,$2.nume_variabila);$2.valoare_caracter=$4;atribuire_variabila_sir($2.nume_variabila,$2.valoare_caracter);fprintf (st, "%s %s - in functie %s\n",$2.nume_variabila,$1,$2.valoare_caracter);}
		   | DTIP CONSTANTA ATRIBUIRE bool_var ';' cod_functie {stocare_variabila($1,$2.nume_variabila);fprintf (st, "%s %s - in functie %d\n",$2.nume_variabila,$1,$4);}
		   | DTIP CONSTANTA ATRIBUIRE expr_float ';' cod_functie {stocare_variabila($1,$2.nume_variabila);$2.valoare_zecimala=$4;atribuire_variabila_float($2.nume_variabila,$2.valoare_zecimala);fprintf (st, "%s %s - in functie %f\n",$2.nume_variabila,$1,$2.valoare_zecimala);}
		   | expresie cod_functie
		   |
		   ;
cod_structura: DTIP VARIABILA ATRIBUIRE expr_ar ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_intreaga=$4;atribuire_variabila_aritmetica($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in structura %d\n",$2.nume_variabila,$1,$2.valoare_intreaga);}
		     | DTIP VARIABILA ATRIBUIRE expr_bool ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_booleana=$4;atribuire_variabila_bool($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in structura %d\n",$2.nume_variabila,$1,$2.valoare_booleana);}
		     | DTIP VARIABILA ATRIBUIRE expr_sir ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_caracter=$4;atribuire_variabila_sir($2.nume_variabila,$2.valoare_caracter);fprintf (st, "%s %s - in structura %s\n",$2.nume_variabila,$1,$2.valoare_caracter);}
		     | DTIP VARIABILA ATRIBUIRE bool_var ';' declaratii {stocare_variabila($1,$2.nume_variabila);fprintf (st, "%s %s - in structura %d\n",$2.nume_variabila,$1,$4);}
		     | DTIP VARIABILA ATRIBUIRE expr_float ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_zecimala=$4;atribuire_variabila_float($2.nume_variabila,$2.valoare_zecimala);fprintf (st, "%s %s - in structura %f\n",$2.nume_variabila,$1,$2.valoare_zecimala);}
			 | DTIP VARIABILA ';' sfarsit_cod_structura {stocare_variabila($1,$2.nume_variabila);fprintf (st, "%s %s - in structura\n",$2.nume_variabila,$1); }
			 | DTIP VECTOR dimensiune';' sfarsit_cod_structura {fprintf (st, "%s %s - in structura\n",$2,$1); }
			 | DTIP VECTOR dimensiune ATRIBUIRE '{' lista '}' ';' sfarsit_cod_structura {fprintf (st, "%s %s - in structura\n",$2,$1); }
			 | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_string '}' ';' sfarsit_cod_structura {fprintf (st, "%s %s - in structura\n",$2,$1); }
			 | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_booleana '}' ';' sfarsit_cod_structura {fprintf (st, "%s %s - in structura\n",$2,$1); }
			 | DTIP VECTOR dimensiune ATRIBUIRE '{' lista_float '}' ';' sfarsit_cod_structura {fprintf (st, "%s %s - in structura\n",$2,$1); }
			 | DTIP CONSTANTA ATRIBUIRE expr_ar ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_intreaga=$4;atribuire_variabila_aritmetica($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in structura %d\n",$2.nume_variabila,$1,$2.valoare_intreaga);}
		     | DTIP CONSTANTA ATRIBUIRE expr_bool ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_booleana=$4;atribuire_variabila_bool($2.nume_variabila,$2.valoare_intreaga);fprintf (st, "%s %s - in structura %d\n",$2.nume_variabila,$1,$2.valoare_booleana);}
		     | DTIP CONSTANTA ATRIBUIRE expr_sir ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_caracter=$4;atribuire_variabila_sir($2.nume_variabila,$2.valoare_caracter);fprintf (st, "%s %s - in structura %s\n",$2.nume_variabila,$1,$2.valoare_caracter);}
		     | DTIP CONSTANTA ATRIBUIRE bool_var ';' declaratii {stocare_variabila($1,$2.nume_variabila);fprintf (st, "%s %s - in structura %d\n",$2.nume_variabila,$1,$4);}
		     | DTIP CONSTANTA ATRIBUIRE expr_float ';' declaratii {stocare_variabila($1,$2.nume_variabila);$2.valoare_zecimala=$4;atribuire_variabila_float($2.nume_variabila,$2.valoare_zecimala);fprintf (st, "%s %s - in structura %f\n",$2.nume_variabila,$1,$2.valoare_zecimala);}
		 	 | DTIP FUNCTIE '(' parametri_initializare ')' '{' cod_functie '}' ';' sfarsit_cod_structura {fprintf (st, "%s %s - in structura\n",$2,$1); }
			 | CLASA OBIECT ';' {fprintf (st, "%s %s - in structura\n",$2,$1); }
		 	 | STRUCTURA OBIECT ';' {fprintf (st, "%s %s - in structura\n",$2,$1); }
			 ;
sfarsit_cod_structura: cod_structura
					 | 
					 ;

expresie: VARIABILA ATRIBUIRE expr_ar ';' {atribuire_variabila_aritmetica($1.nume_variabila,$3);fprintf (st, "%s valoare noua=%d\n",$1.nume_variabila,$3);}
		| VARIABILA ATRIBUIRE expr_bool ';' {atribuire_variabila_bool($1.nume_variabila,$3);fprintf (st, "%s valoare noua=%d\n",$1.nume_variabila,$3);}
		| VARIABILA ATRIBUIRE bool_var ';' {atribuire_variabila_bool($1.nume_variabila,$3);fprintf (st, "%s valoare noua=%d\n",$1.nume_variabila,$3);}
		| VARIABILA ATRIBUIRE expr_sir ';' {atribuire_variabila_sir($1.nume_variabila,$3);fprintf (st, "%s valoare noua=%s\n",$1.nume_variabila,$3);}
		| VARIABILA ATRIBUIRE expr_float ';' {atribuire_variabila_float($1.nume_variabila,$3);fprintf (st, "%s valoare noua=%f\n",$1.nume_variabila,$3);}
		| VECTOR dimensiune ATRIBUIRE expr_ar ';' {fprintf (st, "%s valoare noua=%d\n",$1,$4);}
		| VECTOR dimensiune ATRIBUIRE expr_bool ';' {fprintf (st, "%s valoare noua=%d\n",$1,$4);}
		| VECTOR dimensiune ATRIBUIRE bool_var ';' {fprintf (st, "%s valoare noua=%d\n",$1,$4);}
		| VECTOR dimensiune ATRIBUIRE expr_float ';' {fprintf (st, "%s valoare noua=%f\n",$1,$4);}
		| VECTOR dimensiune ATRIBUIRE expr_sir ';'
		| VECTOR dimensiune ATRIBUIRE '{' lista '}' ';'
		| VECTOR dimensiune ATRIBUIRE '{' lista_string '}' ';'
		| VECTOR dimensiune ATRIBUIRE '{' lista_booleana '}' ';'
		| VECTOR dimensiune ATRIBUIRE '{' lista_float '}' ';'
		| DACA '(' expr_bool ')' '{' expresie '}' ';'
		| DACA '(' bool_var ')' '{' expresie '}' ';'
		| ALTFEL '{' expresie '}' ';'
		| CATTIMP '(' expr_bool ')' '{' expresie '}' ';'
		| CATTIMP '(' bool_var ')' '{' expresie '}' ';'
		| PENTRU '(' parametrii_for ')' '{' expresie '}' ';'
		| FUNCTIE '(' parametri_apel ')' ';'
		| CLASA OBIECT ';' {fprintf (st, "%s %s - in functie\n",$2,$1); }
		| OBIECT '.' VARIABILA ATRIBUIRE expr_ar ';' {fprintf (st, "%s.%s valoare noua=%d\n",$1,$3.nume_variabila,$5);}
		| OBIECT '.' VARIABILA ATRIBUIRE expr_bool ';' {fprintf (st, "%s.%s valoare noua=%d\n",$1,$3.nume_variabila,$5);}
		| OBIECT '.' VARIABILA ATRIBUIRE expr_float ';' {fprintf (st, "%s.%s valoare noua=%f\n",$1,$3.nume_variabila,$5);}
		| OBIECT '.' VARIABILA ATRIBUIRE expr_sir ';'
		| OBIECT '.' VARIABILA ATRIBUIRE bool_var ';' {fprintf (st, "%s.%s valoare noua=%d\n",$1,$3.nume_variabila,$5);}
		| OBIECT '.' VECTOR dimensiune ATRIBUIRE expr_ar ';' {fprintf (st, "%s.%s valoare noua=%d\n",$1,$3,$6);}
		| OBIECT '.' VECTOR dimensiune ATRIBUIRE expr_bool ';' {fprintf (st, "%s.%s valoare noua=%d\n",$1,$3,$6);}
		| OBIECT '.' VECTOR dimensiune ATRIBUIRE expr_float ';' {fprintf (st, "%s.%s valoare noua=%f\n",$1,$3,$6);}
		| OBIECT '.' VECTOR dimensiune ATRIBUIRE expr_sir ';'
		| OBIECT '.' VECTOR dimensiune ATRIBUIRE bool_var ';' {fprintf (st, "%s.%s valoare noua=%d\n",$1,$3,$6);}
		| OBIECT '.' VECTOR dimensiune ATRIBUIRE '{' lista '}' ';'
	    | OBIECT '.' VECTOR dimensiune ATRIBUIRE '{' lista_string '}' ';'
	    | OBIECT '.' VECTOR dimensiune ATRIBUIRE '{' lista_booleana '}' ';'
		| OBIECT '.' VECTOR dimensiune ATRIBUIRE '{' lista_float '}' ';'
	    | OBIECT '.' FUNCTIE '(' parametri_apel ')' ';'
		| STRUCTURA OBIECT ';' {fprintf (st, "%s %s - in functie\n",$2,$1); }
		;

expr_sir: CONCATENARE expr_sir ',' expr_sir {strcpy($2+strlen($2)-1,$2+strlen($2));strcpy($4,$4+1);$$=strcat($2,$4);}
		| CARACTERE {$$=$1;}
		;

expr_ar: expr_ar '+' expr_ar {$$=$1+$3;}
	   | expr_ar '-' expr_ar {$$=$1-$3;}
	   | expr_ar '*' expr_ar {$$=$1*$3;}
	   | expr_ar '/' expr_ar {$$=$1/$3;} /* la modul da conflict (9) */
	   | '(' expr_ar ')' {$$=$2;}
	   | var_const {$$=$1;}
	   ;

expr_float: '+' expr_float ',' expr_float {$$=$2+$4;}
		  | '-' expr_float ',' expr_float {$$=$2-$4;}
		  | '*' expr_float ',' expr_float {$$=$2*$4;}
		  | '/' expr_float ',' expr_float {$$=$2/$4;} /* la modul da conflict (9) */
	  	  | '+' expr_float ',' expr_ar {$$=$2+$4;}
	  	  | '+' expr_ar ',' expr_float {$$=$2+$4;}
	  	  | '-' expr_float',' expr_ar {$$=$2-$4;}
	  	  | '-' expr_ar',' expr_float {$$=$2-$4;}
	  	  | '*' expr_float',' expr_ar {$$=$2*$4;}
	      | '*' expr_ar','expr_float {$$=$2*$4;}
	      | '/' expr_float',' expr_ar {$$=$2/$4;}
	      | '/' expr_ar','expr_float {$$=$2/$4;}
		  | '(' expr_float ')' {$$=$2;}
		  | var_const_float {$$=$1;}
		  ;

var_const_float: FLOATNUMAR {$$=$1;}
			   ;

var_const: NUMAR {$$=$1;}
		 | VARIABILA {if(cautare_variabila($1.nume_variabila)==-1){printf("%s - variabila nu a fost declarata\n",$1.nume_variabila);exit(0);}if(variabile[cautare_variabila($1.nume_variabila)].type==0)$$=variabile[cautare_variabila($1.nume_variabila)].val_int;}
		 | CONSTANTA {if(cautare_variabila($1.nume_variabila)==-1){printf("%s - variabila nu a fost declarata\n",$1.nume_variabila);exit(0);}if(variabile[cautare_variabila($1.nume_variabila)].type==0)$$=variabile[cautare_variabila($1.nume_variabila)].val_int;}
		 | VECTOR dimensiune {$$=0;}
		 | FUNCTIE '(' parametri_apel ')' {$$=0;}
		 ;

expr_bool: SI expr_bool ',' expr_bool {$$=$2 && $4;}
		 | SAU expr_bool ',' expr_bool {$$=$2 || $4;}
		 | SI bool_var ',' bool_var {$$=$2 && $4;}
		 | SI adev_fals_var ',' adev_fals_var {$$=$2 && $4;}
		 | SI adev_fals_var ',' bool_var {$$=$2 && $4;}
		 | SI bool_var ',' adev_fals_var {$$=$2 && $4;}
		 | SAU adev_fals_var ',' adev_fals_var {$$=$2 || $4;}
		 | SAU adev_fals_var ',' bool_var {$$=$2 || $4;}
		 | SAU bool_var ',' adev_fals_var {$$=$2 || $4;}
		 | SAU bool_var ',' bool_var {$$=$2 || $4;}
		 | NEGATIE adev_fals_var {$$=!$2;}
		 | NEGATIE bool_var {$$=!$2;}
		 | NEGATIE expr_bool {$$=!$2;}
		 | MAIMIC expr_ar ',' expr_ar {$$=$2<$4;}
		 | MAIMARE expr_ar ',' expr_ar {$$=$2>$4;}
		 | EGALITATE expr_ar ',' expr_ar {$$=$2==$4;}
		 | '(' expr_bool ')' {$$=$2;}
		 ;
bool_var: ADEVARAT {$$=$1;}
		| FALS {$$=$1;}
		;
		
adev_fals_var: VARIABILA {if(cautare_variabila($1.nume_variabila)==-1){printf("%s - variabila nu a fost declarata\n",$1.nume_variabila);exit(0);}$$=variabile[cautare_variabila($1.nume_variabila)].val_int;}
		     | CONSTANTA {if(cautare_variabila($1.nume_variabila)==-1){printf("%s - variabila nu a fost declarata\n",$1.nume_variabila);exit(0);}$$=variabile[cautare_variabila($1.nume_variabila)].val_int;}
			 | VECTOR dimensiune {$$=0;}
			 | FUNCTIE '(' parametri_apel ')' {$$=0;}
			 ;
			 
parametrii_for: VARIABILA ATRIBUIRE var_numar_const ';' limita ';' incrementare
			  ;
var_numar_const: VARIABILA
			   | NUMAR
			   | CONSTANTA
			   ;
limita: MAIMIC expr_ar ',' expr_ar
	  | MAIMARE expr_ar ',' expr_ar
	  | EGALITATE expr_ar ',' expr_ar
	  ;
incrementare: VARIABILA PLUSPLUS
			| VARIABILA MINUSMINUS
			| VARIABILA ATRIBUIRE expr_ar
			;

/* sfarsit declaratii */

cod: un_cod cod 
   | un_cod 
   ;

un_cod: VARIABILA ATRIBUIRE expr_ar ';' {atribuire_variabila_aritmetica($1.nume_variabila,$3);fprintf (st, "%s valoare noua=%d\n",$1.nume_variabila,$3);}
	  | VARIABILA ATRIBUIRE expr_bool ';' {atribuire_variabila_bool($1.nume_variabila,$3);fprintf (st, "%s valoare noua=%d\n",$1.nume_variabila,$3);}
	  | VARIABILA ATRIBUIRE bool_var ';' {atribuire_variabila_bool($1.nume_variabila,$3);fprintf (st, "%s valoare noua=%d\n",$1.nume_variabila,$3);}
	  | VARIABILA ATRIBUIRE expr_sir ';' {atribuire_variabila_sir($1.nume_variabila,$3);fprintf (st, "%s valoare noua=%s\n",$1.nume_variabila,$3);}
	  | VARIABILA ATRIBUIRE expr_float ';' {atribuire_variabila_float($1.nume_variabila,$3);fprintf (st, "%s valoare noua=%f\n",$1.nume_variabila,$3);}
	  | VECTOR dimensiune ATRIBUIRE expr_ar ';' {fprintf (st, "%s valoare noua=%d\n",$1,$4);}
	  | VECTOR dimensiune ATRIBUIRE expr_bool ';' {fprintf (st, "%s valoare noua=%d\n",$1,$4);}
	  | VECTOR dimensiune ATRIBUIRE expr_sir ';'
	  | VECTOR dimensiune ATRIBUIRE bool_var ';' {fprintf (st, "%s valoare noua=%d\n",$1,$4);}
	  | VECTOR dimensiune ATRIBUIRE expr_float ';' {fprintf (st, "%s valoare noua=%f\n",$1,$4);}
	  | VECTOR dimensiune ATRIBUIRE '{' lista '}' ';'
	  | VECTOR dimensiune ATRIBUIRE '{' lista_string '}' ';'
	  | VECTOR dimensiune ATRIBUIRE '{' lista_booleana '}' ';'
	  | VECTOR dimensiune ATRIBUIRE '{' lista_float '}' ';'
	  | DACA '(' expr_bool ')' '{' cod '}' ';'
	  | DACA '(' bool_var ')' '{' cod '}' ';'
	  | ALTFEL '{' cod '}' ';'
	  | CATTIMP '(' expr_bool ')' '{' cod '}' ';'
	  | CATTIMP '(' bool_var ')' '{' cod '}' ';'
	  | PENTRU '(' parametrii_for ')' '{' cod '}' ';'
	  | FUNCTIE '(' parametri_apel ')' ';'
	  | CLASA OBIECT ';' {fprintf (st, "%s %s - in main\n",$2,$1); }
	  | OBIECT '.' VARIABILA ATRIBUIRE expr_ar ';' {fprintf (st, "%s.%s valoare noua=%d\n",$1,$3.nume_variabila,$5);}
	  | OBIECT '.' VARIABILA ATRIBUIRE expr_bool ';' {fprintf (st, "%s.%s valoare noua=%d\n",$1,$3.nume_variabila,$5);}
	  | OBIECT '.' VARIABILA ATRIBUIRE expr_float ';' {fprintf (st, "%s.%s valoare noua=%f\n",$1,$3.nume_variabila,$5);}
	  | OBIECT '.' VARIABILA ATRIBUIRE expr_sir ';'
	  | OBIECT '.' VARIABILA ATRIBUIRE bool_var ';' {fprintf (st, "%s.%s valoare noua=%d\n",$1,$3.nume_variabila,$5);}
	  | OBIECT '.' VECTOR dimensiune ATRIBUIRE expr_ar ';' {fprintf (st, "%s.%s valoare noua=%d\n",$1,$3,$6);}
	  | OBIECT '.' VECTOR dimensiune ATRIBUIRE expr_bool ';' {fprintf (st, "%s.%s valoare noua=%d\n",$1,$3,$6);}
	  | OBIECT '.' VECTOR dimensiune ATRIBUIRE expr_float ';' {fprintf (st, "%s.%s valoare noua=%f\n",$1,$3,$6);}
	  | OBIECT '.' VECTOR dimensiune ATRIBUIRE expr_sir ';'
	  | OBIECT '.' VECTOR dimensiune ATRIBUIRE bool_var ';' {fprintf (st, "%s.%s valoare noua=%d\n",$1,$3,$6);}
	  | OBIECT '.' VECTOR dimensiune ATRIBUIRE '{' lista '}' ';'
	  | OBIECT '.' VECTOR dimensiune ATRIBUIRE '{' lista_string '}' ';'
	  | OBIECT '.' VECTOR dimensiune ATRIBUIRE '{' lista_booleana '}' ';'
	  | OBIECT '.' VECTOR dimensiune ATRIBUIRE '{' lista_float '}' ';'
	  | OBIECT '.' FUNCTIE '(' parametri_apel ')' ';'
	  | STRUCTURA OBIECT ';' {fprintf (st, "%s %s - in main\n",$2,$1); }
	  | EVAL '(' expr_ar ')' ';' {printf("%d - int\n",$3);}
	  | EVAL '(' expr_bool ')' ';' {printf("Eroare Eval - parametru nu este de tip int\n");exit(0);}
	  | EVAL '(' bool_var ')' ';' {printf("Eroare Eval - parametru nu este de tip int\n");exit(0);}
	  | EVAL '(' expr_sir ')' ';' {printf("Eroare Eval - parametru nu este de tip int\n");exit(0);}
	  | EVAL '(' expr_float ')' ';' {printf("Eroare Eval - parametru nu este de tip int\n");exit(0);}
	  | EVAL '(' ')' ';' {printf("Eroare Eval - nu exista parametrii\n");exit(0);}
	  ;

parametri_apel: expr_ar ',' ultimii_parametrii_apel
			  | expr_ar
			  | expr_bool ',' ultimii_parametrii_apel
			  | expr_bool
			  | expr_sir ',' ultimii_parametrii_apel
			  | expr_sir 
			  | bool_var ',' ultimii_parametrii_apel
			  | bool_var
			  | expr_float ',' ultimii_parametrii_apel
			  | expr_float
			  | 
			  ;
ultimii_parametrii_apel: expr_ar ',' ultimii_parametrii_apel
					   | expr_ar
			  		   | expr_bool ',' ultimii_parametrii_apel
					   | expr_bool
			  		   | expr_sir ',' ultimii_parametrii_apel
					   | expr_sir
					   | bool_var ',' ultimii_parametrii_apel
					   | bool_var
					   | expr_float ',' ultimii_parametrii_apel
					   | expr_float
				       ;
/* vector - gata,eval,string,char,matrici + operatii - gata, vectori booleni - variabila la atribuiri*/
%%

int main(int argc, char** argv){
	st=fopen("symbol_table.txt","w");
	fprintf (st, "[NUME] [TIP] - [STRUCTURA/CLASA/FUNCTIE/GLOBAL]\n");
	yyin=fopen(argv[1],"r");
	printf("%d", yyparse());
}
