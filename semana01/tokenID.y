%{
#include<ctype.h>
#include<string.h>
#include<stdio.h>
char lexema[255];
void yyerror(char *);
int yylex();    //para implementar el analizador lexico
%}

%token ID

%%
instruccion: instruccion ID | ;    // xy z1 w3xm viz
//instruccion: ;
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
        if(isalpha(c)){
            int i = 0;
            do{
                lexema[i++] = c; //x3yz
                c=getchar();
            }while(isalnum(c));
            ungetc(c,stdin);
            lexema[i] = 0;
            return ID;
        }
        return c;
    }
}

int main(){
    if(!yyparse()) printf("cadena valida \n");
    else printf("cadena invalida\n");
}