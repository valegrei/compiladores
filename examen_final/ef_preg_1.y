%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<ctype.h>
#include<regex.h>
#include<math.h>
char lexema[60];
void yyerror(char *msg);
typedef struct{
    char nombre[60];
    double valor;
    int token;
} tipoTS;
tipoTS TablaSim[100];
int nSim = 0;   //fila de la tabla de simbolo
typedef struct{
    int op;
    int a1;
    int a2;
    int a3;
    int a4;
} tipoCodigo;
tipoCodigo TCodigo[100];
int cx = -1;    //fila de la tabla de codigo
void generarCodigo(int,int,int,int,int);    //llena la tabla de codigo
int localizaSimb(char *,int);   //llenga la tabla de simbolos
void imprimeTablaSim();
void imprimeTablaCod();
int genVarTemp();   //genera variables temporales
int nVarTemp=0;
void interpretarCodigo(); //recorre la tabla de codigo para actualizar la tabla de simbolos
int esPalabraReservada(char *); 
int yylex();
int matchCadena(char *);
%}

%token  PROGRAMA ID VAR NUM ASIGNAR SUMAR RESTAR MENOS_UNARIO MULTIPLICAR DIVIDIR POTENCIAR REPETIR CUANDO SINO SI OTROCASO IMPRIMIR MENOR MAYOR IGUAL SALTARIF SALTARF SALTAR CALCULAR DESDE AUMENTANDO EN HASTA CADENA

%%

S: PROGRAMA ID '{'variables listaInstr'}' ;
variables: VAR listaAsignar;
listaAsignar: lst-asig ';';
lst-asig: lst-asig ',' asig | asig;
listaInstr: instr listaInstr
    | ;
instr: if-st | listaAsignar | print | for-st;
if-st: CUANDO cond {generarCodigo(SALTARIF,$2,'?','-','-'); $$=cx;} bloque 
    {generarCodigo(SALTAR,'?','-','-','-'); $$=cx;TCodigo[$3].a2=cx+1; }
    SINO cond {generarCodigo(SALTARIF,$2,'?','-','-'); $$=cx;} bloque 
    OTROCASO {TCodigo[$8].a1=cx+1;};
bloque: '[' listaInstr ']' | instr;
cond: expr '>' expr {int i=genVarTemp(); generarCodigo(MAYOR,i,$1,$3,'-'); $$=i;}
    | expr '<' expr {int i=genVarTemp(); generarCodigo(MENOR,i,$1,$3,'-'); $$=i;}
    | SI expr '=' expr {int i=genVarTemp(); generarCodigo(IGUAL,i,$1,$3,'-'); $$=i;};
for-st: CALCULAR DESDE ID AUMENTANDO EN ID HASTA ID {generarCodigo(REPETIR,$3,$6,$8,'?'); $$=cx;} listaAsignar {TCodigo[$9].a1=cx+1;};
asig: ID {$$ = localizaSimb(lexema, ID);} '=' expr {generarCodigo(ASIGNAR,$2,$4,'-','-');};
expr: expr '+' term {int i=genVarTemp(); generarCodigo(SUMAR,i,$1,$3,'-'); $$=i;}
    | expr '-' term {int i=genVarTemp(); generarCodigo(RESTAR,i,$1,$3,'-'); $$=i;}
    | term;
term: term '*' factor {int i=genVarTemp(); generarCodigo(MULTIPLICAR,i,$1,$3,'-'); $$=i;}
    | term '/' factor {int i=genVarTemp(); generarCodigo(DIVIDIR,i,$1,$3,'-'); $$=i;}
    | factor;
factor: primario '^' factor {int i=genVarTemp(); generarCodigo(POTENCIAR,i,$1,$3,'-'); $$=i;}
    | primario;
primario: '-' primario {int i=genVarTemp(); generarCodigo(MENOS_UNARIO,i,$2,'-','-'); $$=i;}
    | elemento;
elemento: NUM {$$=localizaSimb(lexema, NUM);}
    | ID {$$=localizaSimb(lexema, ID);} 
    | CADENA {$$=localizaSimb(lexema, CADENA);};
print: IMPRIMIR elemento {generarCodigo(IMPRIMIR,$2,'-','-','-');} ';';
%%

int genVarTemp(){
    char t[60];
    sprintf(t,"_T%d",nVarTemp++);
    return localizaSimb(t,ID);
}

void generarCodigo(int op, int a1, int a2, int a3,int a4){
    cx++;
    TCodigo[cx].op = op;
    TCodigo[cx].a1 = a1;
    TCodigo[cx].a2 = a2;
    TCodigo[cx].a3 = a3;
    TCodigo[cx].a4 = a4;
}

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

void imprimeTablaCod(){
    int i;
    for(i=0; i<cx; i++){
        printf("%d a1 = %d, a2 = %d, a3 = %df\n",TCodigo[i].op,TCodigo[i].a1,TCodigo[i].a2,TCodigo[i].a3);
    }
}

void interpretarCodigo(){
    int i,a1,a2,a3,op;
    for(i=0;i<=cx;i++){
        op=TCodigo[i].op;
        a1=TCodigo[i].a1;
        a2=TCodigo[i].a2;
        a3=TCodigo[i].a3;
        if(op==ASIGNAR)
            TablaSim[a1].valor=TablaSim[a2].valor;
        if(op==SUMAR)
            TablaSim[a1].valor=TablaSim[a2].valor+TablaSim[a3].valor;
        if(op==RESTAR)
            TablaSim[a1].valor=TablaSim[a2].valor-TablaSim[a3].valor;
        if(op==MULTIPLICAR)
            TablaSim[a1].valor=TablaSim[a2].valor*TablaSim[a3].valor;
        if(op==DIVIDIR)
            TablaSim[a1].valor=TablaSim[a2].valor/TablaSim[a3].valor;
        if(op==POTENCIAR)
            TablaSim[a1].valor=pow(TablaSim[a2].valor,TablaSim[a3].valor);
        if(op==MENOS_UNARIO)
            TablaSim[a1].valor=TablaSim[a2].valor*(-1);
        if(op==MAYOR)
            TablaSim[a1].valor = (TablaSim[a2].valor > TablaSim[a3].valor) ? 1 : 0;
        if(op==MENOR)
            TablaSim[a1].valor = (TablaSim[a2].valor < TablaSim[a3].valor) ? 1 : 0;
        if(op==IGUAL)
            TablaSim[a1].valor = (TablaSim[a2].valor == TablaSim[a3].valor) ? 1 : 0;
        if(op==SALTARF)
            if(TablaSim[a1].valor==0)   i=a2-1;
    }
}

int matchCadena(char *str){
    int resp = 0;
    char pattern[] = "^\"[a-zA-Z0-9 ]+\"$";
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

// codigo, scanner, parser
void yyerror(char *msg){
    printf("ERROR:%s", msg);
}

int esPalabraReservada(char *lexema){
    if(!strcasecmp(lexema,"Programa")) return PROGRAMA;
    else if(!strcasecmp(lexema,"Var")) return VAR;
    else if(!strcasecmp(lexema,"calcular")) return CALCULAR;
    else if(!strcasecmp(lexema,"desde")) return DESDE;
    else if(!strcasecmp(lexema,"aumentando")) return AUMENTANDO;
    else if(!strcasecmp(lexema,"en")) return EN;
    else if(!strcasecmp(lexema,"hasta")) return HASTA;
    else if(!strcasecmp(lexema,"Imprimir")) return IMPRIMIR;
    else if(!strcasecmp(lexema,"cuando")) return CUANDO;
    else if(!strcasecmp(lexema,"sino")) return SINO;
    else if(!strcasecmp(lexema,"si")) return SI;
    else if(!strcasecmp(lexema,"otroCaso")) return OTROCASO;
    else if(matchCadena(lexema)) return CADENA;
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
            }while(isdigit(c));
            ungetc(c,stdin);	// devuelve el caracter a la entrada estandar	
            lexema[i] = 0;
            
            return NUM;
        }

        return c;
    }
}

int main(){
	// llamar al scanner o analizador lexico esto lo inicia el parser o analizador sintactivo (yyparse)
    if(!yyparse()) printf(" cadena es valida\n");
    else printf(" cadena invalida\n");
    printf("\nImprime tabla de simbolos:\n");
    imprimeTablaSim();
    printf("\nImprime tabla de codigos:\n");
    imprimeTablaCod();
    interpretarCodigo();
    printf("\nImprime tabla de simbolos luego de Interpretar el codigo:\n");
    imprimeTablaSim();
    return 0;
}
