%{

/*	Definition section */

	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>
	#include <string.h>
	#include <stdbool.h>

/* Symbol table function */

	int linenum = 0;
	int idx = 0;
	bool table_created = false;
	bool one_comment = false;
	bool in_comment = false;
	bool in_string = false;
	char type_tmp[15];
	
	struct info {
		char id[50];
		char type[15];
	};
  
  struct info table[500];
	
	void create_symbol();
	void insert_symbol(char *s);
	int lookup_symbol(char *sym);
	void dump_symbol();
	void print_single_comment();
	void print_multi_comment();
	
%}

/*	define regular expression label */

letter [a-zA-Z]
digit [0-9]
id {letter}+({letter}|{digit})*
int {digit}+
double {digit}+\.{digit}+
_int [iI][nN][tT]
_double [dD][oO][uU][bB][lL][eE]
_if [iI][fF]
_else [eE][lL][sS][eE]
_while [wW][hH][iI][lL][eE]
_print [pP][rR][iI][nN][tT]

%%

 /*	Rules section */

{_int}      {strcpy(type_tmp, yytext);}
{_double}   {strcpy(type_tmp, yytext);}
{_if}	      {printf("%s\t IF FUNCTION \n", yytext);}
{_else}     {printf("%s\t ELSE FUNCTION \n", yytext);}
{_while}    {printf("%s\t WHILE FUNCTION \n", yytext);}
{_print}    {printf("%s\t PRINT FUNCTION \n", yytext);}
","         {printf("%s \t COMMA \n", yytext);}
"("         {printf("%s \t LB \n", yytext);}
")"         {printf("%s \t RB \n", yytext);}
"\""        {
							if (!in_string) {
								in_string = true;
							} else {
								in_comment = false;
							}
							printf("%s \t QUO \n", yytext);
						} 
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
"//"(.)*"\n" {
							print_single_comment();
							linenum++;
							}
"/""*"(.|\n)*"*""/"	{print_multi_comment();}
{double}    {printf("%s \t FLOATNUMBER \n",yytext);}
{id} 				{  
							if (in_string) {
								printf("%s \t STRING \n", yytext);
							} else {						
								if (lookup_symbol(yytext) == -1) {
									printf("%s \t %s TYPE VAR\n", yytext, type_tmp);
									insert_symbol(yytext);
								} else {
									printf("%s \t ID \n",yytext);
								}
							}
						}
{digit}+		{printf("%s \t NUMBER \n",yytext);}
[\n]				{
							if (one_comment) {
								one_comment = false;
								linenum++;
							} else {
								linenum++;
							}
						}
" "         {;}
[\t]				{;}

%%

/*	C Code section */

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
		table_created = true;
		printf("Create a symbol table\n");
		return;
}

void insert_symbol(char* s){
	if (!table_created) {
		create_symbol();
	}
	strcpy(table[idx].id, s);
  strcpy(table[idx].type, type_tmp);
	idx++;
	printf("Insert a symbol: %s\n", s);
	return;
}

int lookup_symbol(char* sym){
	int i;
	for (i = 0; i < idx; i++) {
		if (!strcmp(sym, table[i].id) ) {
			return idx;
			/* found */
		}
	}
	return -1;
}

void dump_symbol(){
	int i;
	printf("\nParse over, the line number is %d.\n\n", linenum);
	printf("The symbol table dump:\n");
	
	for (i = 0; i < idx; i++) {
		printf("%d\t%s\t%s\n", i+1, table[i].id, table[i].type);
	}
	return;
}

void print_single_comment() {
	int i, len;
	len = strlen(yytext);
	printf(" ");
	for(i = 2; i < len; i++) {
		printf("%c", yytext[i]);
	}
	return;
}

void print_multi_comment() {
	int i, len;
	len = strlen(yytext);
	for(i = 2; i < len; i++) {
		if (yytext[i] == '*' && yytext[i+1] == '/') {
			printf("\n");
			return;
		} else if (yytext[i] == '\n') {
			printf("\n");
			linenum++;
		} else {
			printf("%c", yytext[i]);
		}
	}
	return;
}
