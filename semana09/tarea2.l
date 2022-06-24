%{
#include<stdio.h>
#include<y.tab.h>
void yyerror(char *);    
%}
/* This tells flex to read only one input file */
%option noyywrap

%%
[:space:]
[:digit:]+(\.[:digit:]+)?   {return NUM;}
(?i:algoritmo)              {return ALGORITMO;}
(?i:inicio)                 {return INICIO;}
(?i:fin)                    {return FIN;}
(?i:finalgoritmo)           {return FINALGORITMO;}
[:alpha:][:alnum:]          {return ID;}
%%