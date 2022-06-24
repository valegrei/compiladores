/*
* Victor Augusto Alegre Ibañez
**/
%{
#include<ctype.h>
#include<string.h>
#include<stdio.h>
#define YYSTYPE double
char lexema[255];
void yyerror(char *);
int yylex(void);    //para implementar el analizador lexico
%}

%token NUM;

%%
lista: expr lista {printf("%g\n",$1);} | ;
expr: expr'+'termino{$$=$1+$3;}| termino {$$ = $1;};
termino: termino'*'NUM{$$=$1*$3;}| NUM {$$=$1;};
%%

void yyerror(char *msg){
    printf("error: %s",msg);
}

int yylex(void){
    double t;
    int c;
    c=getchar();
    if(isdigit(c)){
        ungetc(c,stdin);
        scanf("%lf", &t);
        yylval = t;
        return NUM;
    }
    return c;
}

int main(void){
    return yyparse();
}