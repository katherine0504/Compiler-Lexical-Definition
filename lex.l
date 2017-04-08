/*
	Topic: Homework1 for Compiler Course
	Deadline: xxx.xx.xxxx
*/

%{

/*	Definition section */

/*	insert the C library and variables you need */

	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>

/*
	Symbol table function

	TAs create the basic function which you have to fill.
	We encourage you define new function to make the program work better.
	However, the four basic functions must be finished.
*/
	void create_symbol();
	void insert_symbol();
	int lookup_symbol();
	void dump_symbol();
	int linenum = 0;

%}

/*	define regular expression label */

letter [a-zA-Z]
digit [0-9]
id {letter}+({letter}|{digit})*
int {digit}+
double {digit}+\.{digit}+
%%

 /*	Rules section */

"int"       {printf("%s\t TOKEN \n", yytext);}
"double"    {printf("%s\t TOKEN \n", yytext);}
"if"        {printf("%s\t TOKEN \n", yytext);}
"else"      {printf("%s\t TOKEN \n", yytext);}
"while"     {printf("%s\t TOKEN \n", yytext);}
"print"     {printf("%s\t PRINT FUNCTION \n", yytext);}
","         {printf("%s \t COMMA \n", yytext);}
"("         {printf("%s \t LB \n", yytext);}
")"         {printf("%s \t RB \n", yytext);}
"\""        {printf("%s \t QUO \n", yytext);} 
";" 				{printf("%s \t SEMICOLON \n",yytext); }
"=" 				{printf("%s \t ASSIGN \n",yytext);}
"+" 				{printf("%s \t OPERATOR \n",yytext);}
"-"         {printf("%s \t OPERATOR \n",yytext);}
"*"         {printf("%s \t OPERATOR \n",yytext);}
"/"         {printf("%s \t OPERATOR \n",yytext);}
">"         {printf("%s \t RELATIONAL \n",yytext);}
">="        {printf("%s \t RELATIONAL \n",yytext);}
"<"         {printf("%s \t RELATIONAL \n",yytext);}
"<="        {printf("%s \t RELATIONAL \n",yytext);}
"=="        {printf("%s \t RELATIONAL \n",yytext);}
"!="        {printf("%s \t RELATIONAL \n",yytext);}
"^"         {printf("%s \t EXPONENTIATION \n",yytext);}
"%"         {printf("%s \t REMAINDER \n",yytext);}
{double}    {printf("%s \t FLOATNUMBER \n",yytext);}
{id} 				{printf("%s \t ID \n",yytext); }
{digit}+		{printf("%s \t NUMBER \n",yytext);
             create_symbol();}
[\n]				{;}
" "         {;}
%%

/*	C Code section */

/*	You have to define your C function in this section */

int main(int argc,char *argv[]){

	yyin = fopen(argv[1],"r");
	yylex();
	dump_symbol();

	return 0;
}

int yywrap(void) {
    return 1;
}

void create_symbol(){
  printf("CREATE\n");
}

void insert_symbol(char* s){

}

int lookup_symbol(char* sym){

}

void dump_symbol(){
	
}
