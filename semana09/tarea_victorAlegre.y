/*
Victor Augusto Alegre Ibañez
20130504C

Programa que acepta cadena:
Algoritmo ejemplo
Inicio
    x = 6.1
    y = x
Fin
*/
%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<ctype.h>
#include<regex.h>
char lexema[60];
void yyerror(char *msg);
typedef struct{
    char nombre[60];
    double valor;
    int token;
} tipoTS;
tipoTS TablaSim[100];
int nSim = 0;

int localizaSimb(char *,int);
void imprimeTablaSim();
int nVarTemp=0;
int GenVarTemp();
int esPalabraReservada(char *);
int yylex();
int matchReal(char *);
%}

%token  ALGORITMO ID INICIO FIN NUM FINALGORITMO

// leer ids, enteros y reales.
%%

S: ALGORITMO ID INICIO listaInstr FIN FINALGORITMO;
listaInstr: instr listaInstr
    | ;
instr: ID {$$ = localizaSimb(lexema, ID);} '=' expr;
expr: expr '+' term;
    | term;
term: NUM {$$=localizaSimb(lexema, NUM);} 
    | ID {$$=localizaSimb(lexema, ID);};
%%

int localizaSimb(char *nom, int tok){
    int i;
    for(i=0; i<nSim; i++){
        if(!strcasecmp(TablaSim[i].nombre, nom))
            return i;
    }
    strcpy(TablaSim[nSim].nombre, nom);
    TablaSim[nSim].token = tok;
    if(tok == ID) TablaSim[nSim].valor = 0.0;
    if(tok == NUM) sscanf(nom, "%lf", &TablaSim[nSim].valor);
    nSim++;
    return nSim-1;
}

void imprimeTablaSim(){
    int i;
    for(i=0; i<nSim; i++){
        printf("%d nombre = %s, tok = %d, valor = %lf\n",i,TablaSim[i].nombre, TablaSim[i].token, TablaSim[i].valor);
    }
}

// codigo, scanner, parser
void yyerror(char *msg){
    printf("ERROR:%s", msg);
}

int esPalabraReservada(char *lexema){
    if(!strcasecmp(lexema,"Algoritmo")) return ALGORITMO;
    else if(!strcasecmp(lexema,"Inicio")) return INICIO;
    else if(!strcasecmp(lexema,"Fin")) return FIN;
    else if(!strcasecmp(lexema,"FinAlgoritmo")) return FINALGORITMO;
    return ID;
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
            
            return esPalabraReservada(lexema);	// devuelve el token
        }

        if(isdigit(c)){
            int i=0;
            do{
                lexema[i++] = c;
                c = getchar();
            }while(isdigit(c) || c == '.');
            ungetc(c,stdin);	// devuelve el caracter a la entrada estandar	
            lexema[i] = 0;
            if(matchReal(lexema) == 1)
                return NUM;
        }

        return c;
    }
}

int matchReal(char *str){
    int resp = 0;
    char pattern[] = "^[0-9]+(\\.[0-9]+)?$";
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
    printf("Imprime tabla de simbolos:\n");
    imprimeTablaSim();
    return 0;
}
