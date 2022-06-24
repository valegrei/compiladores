/* Victor Augusto Alegre Ibanez
 20130504C
 Segunda PC
 Pregunta 2
 Operaciones de + - * pow y sqrt con () y numeros octales
 Ejemplo:

 Programa Ejemplo;
 Inicio
 x = -701-11*(105^11-r(6011));
 y = x^2 -(11-x);
 Fin*/
%{
//Incluimos librerias y cabeceras
#include<stdio.h>
#include<string.h>
#include<ctype.h>
#include<regex.h>
char lexema[64];

int matchOctal(char *str);
void yyerror(char *msg);
int yylex();
%}

%token  ID OCT INICIO FIN PROG SQRT

// leer ids, enteros y reales.
%%
programa: encab INICIO instr FIN;
encab: PROG ID ';';
instr: instr ID '=' expr ';' 
    | ; 
expr: expr '+' term 
    | expr '-' term 
    | term;
term: term '*' factor 
    | factor;
factor: primario '^' factor 
    | SQRT '(' expr ')' 
    | primario;
primario: '-' primario
    | elemento;
elemento: ID 
    | OCT 
    | '(' expr ')';
%%

// codigo, scanner, parser
void yyerror(char *msg){
    printf("error:%s", msg);
}

int yylex(){	// esto retorna un token es decir numeros
	// analizador lexico hecho a mano
    char c;
    while(1){
        c = getchar();
        if(c=='\n') continue;
        if(isspace(c)) continue;
        
        
        if(isalpha(c)){ // Verfica si es un caracter
            int i = 0;
            do{
                lexema[i++] = c;
                c = getchar();
            }while(isalnum(c));
            ungetc(c,stdin);	// devuelve el caracter a la entrada estandar
            lexema[i] = 0;
            
            if(strcasecmp(lexema,"r")==0) return SQRT;
            else if(strcasecmp(lexema,"Inicio")==0) return INICIO;
            else if(strcasecmp(lexema,"Fin")==0) return FIN;
            else if(strcasecmp(lexema,"Programa")==0) return PROG;

            return ID;	// devuelve el token
        }

        if(isdigit(c)){
            int i=0;
            do{
                lexema[i++] = c;
                c = getchar();
            }while(isdigit(c));
            ungetc(c,stdin);	// devuelve el caracter a la entrada estandar	
            lexema[i] = 0;

            if(matchOctal(lexema)) return OCT;
            
        }

        return c;
    }
}

int matchOctal(char *str){
    int resp = 0;
    char pattern[] = "^[0-7]+$";
    //printf("\n%s",pattern);
    regex_t re;
    if(regcomp(&re,pattern,REG_EXTENDED | REG_NOSUB)!=0){
        printf("Error en compilar regex");
        return 0;
    }
    if(regexec(&re,str,0,NULL,0)==0) 
        resp = 1;
    regfree(&re);
    return resp;
}

int main(){
	// llamar al scanner o analizador lexico esto lo inicia el parser o analizador sintactivo (yyparse)
    if(!yyparse()) printf(" cadena es valida\n");
    else printf(" cadena invalida\n");
    return 0;
}
