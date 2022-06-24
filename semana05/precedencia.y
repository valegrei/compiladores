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
int yylex();    //para implementar el analizador lexico
%}

%token NUM;

%%
lista: expr lista {printf("%g\n",$1);} | ;
expr: expr'+'NUM{$$=$1+$3;};
expr: expr'*'NUM{$$=$1*$3;};
expr: NUM;
%%

void yyerror(char *msg){
    printf("error: %s",msg);
}

int yylex(){
    double t;
    int c;
    if(isdigit(c)){
        ungetc(c,stdin);
        scanf("%lf", &t);
        yylval = t;
        return NUM;
    }
    return c;
}

int main(){
    return yyparse();
}