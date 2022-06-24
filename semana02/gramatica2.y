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

%token NUM MENOS;

%%
expresion: expresion MENOS NUM | NUM;
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
        if(c=='-') return MENOS;
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