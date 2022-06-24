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
#include<stdlib.h>
#include<math.h>
char lexema[100];

typedef struct{ 
    char nombre[100];
    int valor;
} tipoVar;
tipoVar variables[100];
int nVar=0;

void imprimeValores();
int palabrasReservadas(char*);
void asignarValor(char*,int);
int obtenerValor(char*);
int matchBinario(char*);
int convDecimal(char*);
void convBinario(int);
void yyerror (char const *s);
int yylex();
%}

%define parse.error verbose

%union {
  int intval;
  char *strVal;
}

%token PROGRAM BEGIN END //ID
%token <intval> BIN NUM
%token <strVal> ID
%type <intval> elemento primario factor term expr

// leer ids, enteros y reales.
%%
programa: encab BEGIN instr END {imprimeValores();};
encab: PROGRAM ID ';'{printf("Programa: %s\n",$2);} ; 
instr: instr asignacion
    | asignacion; 
asignacion: ID '=' expr ';' {asignarValor($1, $3);} ;
expr: expr '+' term {$$ = $1 + $3;} 
    | expr '-' term {$$ = $1 - $3;}  
    | term {$$ = $1;} ;
term: term '*' factor {$$ = $1 * $3;} 
    | factor {$$ = $1;} ;
factor: primario '^' NUM {$$ = pow($1,$3);} 
    | primario {$$ = $1;} ;
primario: '-' primario {$$ = - $2;} 
    | elemento {$$ = $1;} ;
elemento: ID {$$ = obtenerValor($1);} 
    | BIN {$$ = $1;} 
    | '(' expr ')' {$$ = $2;};
%%

// codigo, scanner, parser
void yyerror (char const *s) {
    fprintf (stderr, "%s\n", s);
}

//Palabras reservadas
int palabrasReservadas(char *str){
    if(!strcasecmp(lexema,"program")) return PROGRAM;
    else if(!strcasecmp(lexema,"begin")) return BEGIN;
    else if(!strcasecmp(lexema,"end")) return END;

    yylval.strVal = _strdup(lexema);
    return ID;	// devuelve el token
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
            return palabrasReservadas(lexema);
        }

        if(isdigit(c)){
            int i=0;
            do{
                lexema[i++] = c;
                c = getchar();
            }while(isdigit(c));
            ungetc(c,stdin);	// devuelve el caracter a la entrada estandar	
            lexema[i] = 0;

            if(matchBinario(lexema)){
                yylval.intval = convDecimal(lexema);
                return BIN;
            }

            yylval.intval = atoi(lexema);
            return NUM;
        }

        return c;
    }
}

void asignarValor(char *nom, int valor){
    int i;
    //printf("Buscando %s y asignar valor %d\n",nom,valor);
    for(i=0;i<nVar;i++){  //busca variable guardad
        if(!strcasecmp(variables[i].nombre,nom)){
            variables[nVar].valor=valor;
            //printf("Se encontro valor, asignando\n");
            return;
        }
    }
    //Agrega una nueva variable
    strcpy(variables[nVar].nombre,nom);
    variables[nVar].valor=valor;
    nVar++;
    //printf("Se asigno un valor, total: %d variables\n",nVar);
}

int obtenerValor(char* nom){
    int i;
    for(i=0;i<nVar;i++){  //busca variable guardad
        //printf("buscando en: %s, valor= %d\n",variables[i].nombre, variables[i].valor);
        if(!strcasecmp(variables[i].nombre,nom)){
            //printf("Encontrado valor: %s = %d\n",variables[i].nombre, variables[i].valor);
            return variables[i].valor;
        }
    }
    return 0;
}

void imprimeValores(){
  int i;
  for(i=0;i<nVar;i++){
    printf("%s = ", variables[i].nombre);
    convBinario(variables[i].valor);
    printf("\n");
  }
}

int matchBinario(char *str){
    int resp = 0;
    char pattern[] = "^[01]+$";
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


//Convierte binario a decimal
int convDecimal(char* bin){
	char rd = bin[0];
	int i, len = 0, dec = 0;
	len = strlen(bin);
	for(i=0; i<len; i++){
		rd = bin[i];
		int dig = rd - '0';
		dec += dig*pow(2,len-1-i);
	}
	return dec;
}

//Convierte decimal a binario
void convBinario(int dec){
	char bin[1000];
    bin[0] = '\0';
	while(dec!=0){
		int r = dec%2;
    	dec = dec/2;
		sprintf(bin + strlen(bin),"%i",r);
	}
	printf("%s",strrev(bin));
}

int main(){
	// llamar al scanner o analizador lexico esto lo inicia el parser o analizador sintactivo (yyparse)
    if(!yyparse()) printf(" cadena es valida\n");
    else printf(" cadena invalida\n");
    return 0;
}
