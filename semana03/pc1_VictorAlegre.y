/*
* Victor Augusto Alegre Ibañez
**/
%{
#include<ctype.h>
#include<string.h>
#include<stdio.h>
#include<regex.h>
char lexema[255];

int matchFileName(char *str);
int matchRealNum(char *str);
int matchIntNum(char *str);
int matchID(char *str);
void yyerror(char *);
int yylex();    //para implementar el analizador lexico
%}

%token ID ASIGN PUNTCOM INT_NUM REAL_NUM COMA INICIO FIN SUM DIF POW NUMERAL LIBRERIA FILE_NAME PROGRAMA ABR_PAR CERR_PAR VARIABLES REAL_T ;

%%
Programa: librerias nombre_prog declaracion cuerpo;
librerias: LIBRERIA NUMERAL FILE_NAME NUMERAL librerias | ;
nombre_prog: PROGRAMA ID PUNTCOM;
declaracion: VARIABLES tipo lista_var PUNTCOM;
cuerpo: INICIO linea FIN;
tipo: REAL_T;
lista_var: ID COMA lista_var | ID; 
linea: expresion PUNTCOM linea | ;
expresion: ID ASIGN operacion;
operacion: operando SUM operacion | operando DIF operacion | ABR_PAR operacion CERR_PAR | operando;
operando: expo | INT_NUM | REAL_NUM | ID;
expo: operando POW INT_NUM;
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
        if(c=='(') return ABR_PAR;
        if(c==')') return CERR_PAR;
        if(c=='+') return SUM;
        if(c=='-') return DIF;
        if(c=='#') return NUMERAL;
        if(c=='^') return POW;
        if(c==';') return PUNTCOM;
        if(c==',') return COMA;
        if(c=='=') return ASIGN;
        if(isalpha(c)){
            int i = 0;
            do{
                lexema[i++] = c; //x3yz
                c=getchar();
            }while(isalnum(c) || c=='.');
            ungetc(c,stdin);
            lexema[i] = 0;
            if(strcmp(lexema,"Inicio") == 0) return INICIO;
            if(strcmp(lexema,"Fin") == 0) return FIN;
            if(strcmp(lexema,"libreria") == 0) return LIBRERIA;
            if(strcmp(lexema,"Variables")==0) return VARIABLES;
            if(strcmp(lexema,"Programa") == 0) return PROGRAMA;
            if(strcmp(lexema,"Real") == 0) return REAL_T;
            if(matchFileName(lexema)==1) return FILE_NAME;
            if(matchID(lexema)==1) return ID;
        }
        if(isdigit(c)){	// verifica si es un nro. entero y no cero
            int i=0;
            do{
                lexema[i++] = c;
                c = getchar();
            }while(isdigit(c) || c=='.' || c=='E');
            ungetc(c,stdin);	// devuelve el caracter a la entrada estandar	
            lexema[i] = 0;
            if(matchRealNum(lexema)==1) return REAL_NUM;
            if(matchIntNum(lexema)==1) return INT_NUM;
        }
        return c;
    }
}

int matchFileName(char *str){
    int resp = 0;
    char pattern[] = "^[a-zA-Z]\\w*\\.[a-zA-Z]\\w*$";
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

int matchRealNum(char *str){
    int resp = 0;
    char pattern[] = "^\\d\\.\\dE\\d+$";
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

int matchIntNum(char *str){
    int resp = 0;
    char pattern[] = "^\\d+";
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

int matchID(char *str){
    int resp = 0;
    char pattern[] = "^[a-zA-Z]\\w*$";
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
    if(!yyparse()) printf("\ncadena valida \n");
    else printf("\ncadena invalida\n");
}