%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<ctype.h>
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
} tipoCodigo;
tipoCodigo TCodigo[100];
int cx = -1;    //fila de la tabla de codigo
void generarCodigo(int,int,int,int);    //llena la tabla de codigo
int localizaSimb(char *,int);   //llenga la tabla de simbolos
void imprimeTablaSim();
void imprimeTablaCod();
int genVarTemp();   //genera variables temporales
int nVarTemp=0;
void interpretarCodigo(); //recorre la tabla de codigo para actualizar la tabla de simbolos
int esPalabraReservada(char *); 
int yylex();
%}

%token  PROGRAMA ID INICIO FIN NUM ASIGNAR SUMAR SI ENTONCES MAYOR SALTARF
/*
Program MiProg;
Begin
    x:=5;
    y:=6;
    if y>x then
        Begin
            a:=2;
            b:=3;
        End
    z:=6;
End.
*/
%%

S: PROGRAMA ID ';' INICIO listaInstr FIN '.' ;
listaInstr: instr listaInstr
    | ;
instr: SI cond {generarCodigo(SALTARF,$2,'?','-'); $$=cx;} ENTONCES bloque {TCodigo[$3].a2=cx+1;} 
    | ID {$$ = localizaSimb(lexema, ID);} ':' '=' expr {generarCodigo(ASIGNAR,$2,$5,'-');} ';' ;
bloque: INICIO listaInstr FIN
    | instr;
cond: expr '>' expr {int i=genVarTemp(); generarCodigo(MAYOR,i,$1,$3); $$=i;};
expr: expr '+' term {int i=genVarTemp(); generarCodigo(SUMAR,i,$1,$3); $$=i;}
    | term;
term: NUM {$$=localizaSimb(lexema, NUM);}
    | ID {$$=localizaSimb(lexema, ID);} ;
%%

int genVarTemp(){
    char t[60];
    sprintf(t,"_T%d",nVarTemp++);
    return localizaSimb(t,ID);
}

void generarCodigo(int op, int a1, int a2, int a3){
    cx++;
    TCodigo[cx].op = op;
    TCodigo[cx].a1 = a1;
    TCodigo[cx].a2 = a2;
    TCodigo[cx].a3 = a3;
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
        if(op==MAYOR)
            TablaSim[a1].valor = (TablaSim[a2].valor > TablaSim[a3].valor) ? 1 : 0;
        if(op==SALTARF)
            if(TablaSim[a1].valor==0)   i=a2-1;
    }
}

// codigo, scanner, parser
void yyerror(char *msg){
    printf("ERROR:%s", msg);
}

int esPalabraReservada(char *lexema){
    if(!strcasecmp(lexema,"Program")) return PROGRAMA;
    else if(!strcasecmp(lexema,"Begin")) return INICIO;
    else if(!strcasecmp(lexema,"End")) return FIN;
    else if(!strcasecmp(lexema,"if")) return SI;
    else if(!strcasecmp(lexema,"then")) return ENTONCES;
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
