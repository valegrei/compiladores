/* Victor Augusto Alegre Ibanez
 20130504C
 Segunda PC
 Pregunta 1
 Operaciones de + - * / con () y numeros reales
 -2,3-5*(3/2-1,2);*/
%{
//Incluimos librerias y cabeceras
#include<stdio.h>
#include<string.h>
#include<ctype.h>
#include<regex.h>
#include<stdlib.h>
#define YYSTYPE double
char lexema[64];

int matchReal(char *str);
double parseReal(char *str);
void replaceChar(char *str, char replace, char newChar);
void yyerror(char *msg);
int yylex();
%}

%token  REAL

// leer ids, enteros y reales.
%%
linea: linea expr ';'  {printf("%g\n",$2);} 
    | ;
expr: expr '+' term {$$ = $1+$3;} 
    | expr '-' term {$$ = $1-$3;} 
    | term {$$ = $1;} ;
term: term '*' factor {$$ = $1*$3;} 
    | term '/' factor {$$ = $1/$3;}
    | factor {$$ = $1;} ;
factor: '-' factor {$$ = -$2;} 
    | primario {$$ = $1;} ;
primario: REAL {$$ = $1;} 
    | '(' expr ')' {$$ = $2;};
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
        
        if(isdigit(c)){
            int i=0;
            do{
                lexema[i++] = c;
                c = getchar();
            }while(isdigit(c) || c == ',');   // "," para la parte flotante
            ungetc(c,stdin);	// devuelve el caracter a la entrada estandar	
            lexema[i] = 0;

            if(matchReal(lexema)) {
                yylval = parseReal(lexema);
                return REAL;
            }
            
        }

        return c;
    }
}

int matchReal(char *str){
    int resp = 0;
    char pattern[] = "^[0-9]+(,[0-9]+)?$";
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

double parseReal(char *str){
    replaceChar(str,',','.');
    return atof(str);
}

void replaceChar(char *str, char replace, char newChar){
    int len = strlen(str);
    for(int i = 0; i < len ; i++){
        if(str[i] == replace)
            str[i] = newChar;
    }
}

int main(){
	// llamar al scanner o analizador lexico esto lo inicia el parser o analizador sintactivo (yyparse)
    if(!yyparse()) printf(" cadena es valida\n");
    else printf(" cadena invalida\n");
    return 0;
}
