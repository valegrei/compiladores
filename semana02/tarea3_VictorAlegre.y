/*
* Victor Augusto Alegre Ibañez
**/
%{
#include<ctype.h>
#include<string.h>
#include<stdio.h>
char lexema[255];
void yyerror(char *);
int yylex();    //para implementar el analizador lexico
%}

%token ID ASIGN DOSP NUM PUNT ABR CERR SUM IMPRIMIR;

%%
programa: ABR linea CERR;
linea: expresion PUNT linea | ;
expresion: asignacion | funcion;
funcion: IMPRIMIR DOSP ID;
asignacion: ID ASIGN lista;
lista: operando SUM lista | operando;
operando: NUM | ID;
%%

void yyerror(char *msg){
    printf("error: %s",msg);
}

int yylex(){
    char c;
    while(1){
        c = getchar();
        if(c=='\n') continue;
        if(c==' ') continue;
        if(c=='[') return ABR;
        if(c==']') return CERR;
        if(c=='.') return PUNT;
        if(c=='+') return SUM;
        if(c==':'){ 
            c = getchar();
            if(c == '=') return ASIGN;
            ungetc(c,stdin);
            return DOSP;
        }
        if(isalpha(c)){
            int i = 0;
            do{
                lexema[i++] = c; //x3yz
                c=getchar();
            }while(isalnum(c));
            ungetc(c,stdin);
            lexema[i] = 0;
            if(strcmp(lexema,"IMPRIMIR") == 0) return IMPRIMIR;
            return ID;
        }
        if(isdigit(c)){	// verifica si es un nro. entero y no cero
            int i=0;
            do{
                lexema[i++] = c;
                c = getchar();
            }while(isdigit(c));
            ungetc(c,stdin);	// devuelve el caracter a la entrada estandar	
            lexema[i] = 0;
            return NUM; // devuelve el token
        }
        return c;
    }
}

int main(){
    if(!yyparse()) printf("\ncadena valida \n");
    else printf("\ncadena invalida\n");
}