/*
Proyecto de Compiladores
Integrantes:
- Alegre Ibañez, Victor Augusto
- Chung Alvarez, Alex Steve
*/
%{
//Incluimos librerias y cabeceras
#include<stdio.h>
#include<string.h>
#include<ctype.h>
//#include<regex.h>
//#include<stdlib.h>
//#define YYSTYPE double
char lexema[100];

void yyerror (char const *s);
int yylex();
%}

%define parse.error verbose

%token  NUM ID DEFINE PARA DEL AL MIENTRAS INFINITO BUCLE HAZ SI ENTONCES SINO O MUESTRA FIN Y DEVUELVE CADENA VERDADERO FALSO ROMPE

// leer ids, enteros y reales.
%%
instruc: instruc linea
        | linea;
linea: asignacion
    | impresion
    | cond
    | funcion
    | bucle;
//Bucles
bucle: BUCLE INFINITO HAZ instruc1 FIN
    | MIENTRAS bool HAZ instruc1 FIN
    | PARA ID rango HAZ instruc1 FIN;
rango: DEL NUM AL NUM;
instruc1: instruc1 linea1 | linea1;
linea1: asignacion
    | impresion
    | cond1
    | funcion
    | bucle
    | ROMPE;
//condicionales
cond: SI bool ENTONCES instruc FIN
    | SI bool ENTONCES instruc SINO instruc FIN;
cond1: SI bool ENTONCES instruc1 FIN
    | SI bool ENTONCES instruc1 SINO instruc1 FIN;
bool: bool Y bool1
    | bool O bool1
    | bool1;
bool1: VERDADERO
    | FALSO
    | '(' bool ')'
    | expr rel expr;
rel: '=''=' | '>' | '<' | '<''=' | '>''=' | '!''=' ;

// funciones
funcion: DEFINE ID argumentos HAZ instruc retorna FIN ; //
argumentos: argumentos ',' ID | ID |;
retorna: DEVUELVE valor | ;

// impresiones
impresion: MUESTRA valor;
// operaciones aritméticas
asignacion: ID '=' valor 
valor: expr | CADENA | lista;
lista: '['items']';
items: items ',' valor | valor;
expr: expr '+' term 
    | expr '-' term 
    | term;
term: term '*' factor 
    | term '/' factor
    | factor;
factor: primario '^' factor
    | primario;
primario: '-' primario
    | elemento;
elemento: ID 
    | NUM 
    | '(' expr ')';

%%

// codigo, scanner, parser
void yyerror (char const *s) {
   fprintf (stderr, "%s\n", s);
 }

int yylex(){	// esto retorna un token es decir numeros
	// analizador lexico hecho a mano
    char c;
    while(1){
        c = getchar();
        if(c=='\n') continue;
        if(isspace(c)) continue;
        if(c=='"'){
             int i=0;
            do{
                lexema[i++] = c;
                c = getchar();
            }while(c!='"');
            lexema[i++] = c;
            lexema[i] = 0;
            printf("\n%s\n",lexema);
            return CADENA;
        }

        if(isalpha(c)){
            int i=0;
            do{
                lexema[i++] = c;
                c = getchar();
            }while(isalnum(c));
            ungetc(c,stdin);
            lexema[i] = 0;
            if(strcasecmp(lexema,"define")==0) return DEFINE;
            else if(strcasecmp(lexema,"o")==0) return O;
            else if(strcasecmp(lexema,"y")==0) return Y;
            else if(strcasecmp(lexema,"para")==0) return PARA;
            else if(strcasecmp(lexema,"del")==0) return DEL;
            else if(strcasecmp(lexema,"al")==0) return AL;
            else if(strcasecmp(lexema,"infinito")==0) return INFINITO;
            else if(strcasecmp(lexema,"mientras")==0) return MIENTRAS;
            else if(strcasecmp(lexema,"bucle")==0) return BUCLE;
            else if(strcasecmp(lexema,"haz")==0) return HAZ;
            else if(strcasecmp(lexema,"si")==0) return SI;
            else if(strcasecmp(lexema,"entonces")==0) return ENTONCES;
            else if(strcasecmp(lexema,"sino")==0) return SINO;
            else if(strcasecmp(lexema,"muestra")==0) return MUESTRA;
            else if(strcasecmp(lexema,"fin")==0) return FIN;
            else if(strcasecmp(lexema,"devuelve")==0) return DEVUELVE;
            else if(strcasecmp(lexema,"verdadero")==0) return VERDADERO;
            else if(strcasecmp(lexema,"falso")==0) return FALSO;
            else if(strcasecmp(lexema,"rompe")==0) return ROMPE;

            return ID;
        }
        if(isdigit(c)){
            int i=0;
            do{
                lexema[i++] = c;
                c = getchar();
            }while(isdigit(c));   // "," para la parte flotante
            ungetc(c,stdin);	// devuelve el caracter a la entrada estandar	
            lexema[i] = 0;

            /*if(matchReal(lexema)) {
                yylval = parseReal(lexema);
                return REAL;
            }*/
            return NUM;
        }

        return c;
    }
}


int main(){
	// llamar al scanner o analizador lexico esto lo inicia el parser o analizador sintactivo (yyparse)
    if(!yyparse()) printf(" cadena es valida\n");
    else printf(" cadena invalida\n");
    return 0;
}
