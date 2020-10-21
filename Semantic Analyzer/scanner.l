%{
	#include <stdio.h>
	#include <string.h>
	#include "y.tab.h"

	struct Symbol_Table
	{
		char token_name[100];
		char token_class[100];
		char token_datatype[100];
		char token_value[100];
		int nestval;
		int lineno;
		int length;
		int params_count;
	}ST[1001];

	struct Constant_Table
	{
		char token_name[100];
		char token_datatype[100];
		int length;
	}CT[1001];

	int currnest = 0;
	int params_count = 0;
	extern int yylval;

	int hash(char *str)
	{
		int token_value = 0;
		for(int i = 0 ; i < strlen(str) ; i++)
		{
			token_value = 10*token_value + (str[i] - 'A');
			token_value = token_value % 1001;
			while(token_value < 0)
				token_value = token_value + 1001;
		}
		return token_value;
	}

	int lookupST(char *str)
	{
		int token_value = hash(str);
		if(ST[token_value].length == 0)
		{
			return 0;
		}
		else if(strcmp(ST[token_value].token_name,str)==0)
		{
			
			return token_value;
		}
		else
		{
			for(int i = token_value + 1 ; i!=token_value ; i = (i+1)%1001)
			{
				if(strcmp(ST[i].token_name,str)==0)
				{
					
					return i;
				}
			}
			return 0;
		}
	}

	int lookupCT(char *str)
	{
		int token_value = hash(str);
		if(CT[token_value].length == 0)
			return 0;
		else if(strcmp(CT[token_value].token_name,str)==0)
			return 1;
		else
		{
			for(int i = token_value + 1 ; i!=token_value ; i = (i+1)%1001)
			{
				if(strcmp(CT[i].token_name,str)==0)
				{
					return 1;
				}
			}
			return 0;
		}
	}

	void insertSTline(char *str1, int line)
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(strcmp(ST[i].token_name,str1)==0)
			{
				ST[i].lineno = line;
			}
		}
	}


	void insertST(char *str1, char *str2)
	{
		if(lookupST(str1))
		{
			if(strcmp(ST[lookupST(str1)].token_class,"Identifier")==0 && strcmp(str2,"Array Identifier")==0)
			{
				printf("Error use of array\n");
				exit(0);
			}	
			return;
		}
		else
		{
			int token_value = hash(str1);
			if(ST[token_value].length == 0)
			{
				strcpy(ST[token_value].token_name,str1);
				strcpy(ST[token_value].token_class,str2);
				ST[token_value].length = strlen(str1);
				ST[token_value].nestval = 9999;
				ST[token_value].params_count = -1;
				insertSTline(str1,yylineno);
				return;
			}

			int pos = 0;

			for (int i = token_value + 1 ; i!=token_value ; i = (i+1)%1001)
			{
				if(ST[i].length == 0)
				{
					pos = i;
					break;
				}
			}

			strcpy(ST[pos].token_name,str1);
			strcpy(ST[pos].token_class,str2);
			ST[pos].length = strlen(str1);
			ST[pos].nestval = 9999;
			ST[pos].params_count = -1;
		}
	}

	void insertSTtype(char *str1, char *str2)
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(strcmp(ST[i].token_name,str1)==0)
			{
				strcpy(ST[i].token_datatype,str2);
			}
		}
    }

	void insertSTvalue(char *str1, char *str2)
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(strcmp(ST[i].token_name,str1)==0 && ST[i].nestval == currnest)
			{
				strcpy(ST[i].token_value,str2);
			}
		}
	}


	void insertSTnest(char *s, int nest)
	{
		if(lookupST(s) && ST[lookupST(s)].nestval != 9999)
		{
             int pos = 0;
             int token_value = hash(s);
			for (int i = token_value + 1 ; i!=token_value ; i = (i+1)%1001)
			{
				if(ST[i].length == 0)
				{
					pos = i;
					break;
				}
			}

			strcpy(ST[pos].token_name,s);
			strcpy(ST[pos].token_class,"Identifier");
			ST[pos].length = strlen(s);
			ST[pos].nestval = nest;
			ST[pos].params_count = -1;
			ST[pos].lineno = yylineno;
		}
		else
		{
			for(int i = 0 ; i < 1001 ; i++)
			{
				if(strcmp(ST[i].token_name,s)==0 )
				{
					ST[i].nestval = nest;
				}
			}
		}
	}

	void insertSTparamscount(char *s, int count)
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(strcmp(ST[i].token_name,s)==0 )
			{
				ST[i].params_count = count;
			}
		}
	}

	int getSTparamscount(char *s)
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(strcmp(ST[i].token_name,s)==0 )
			{
				return ST[i].params_count;
			}
		}
		return -2;
	}

	void insertSTF(char *s)
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(strcmp(ST[i].token_name,s)==0 )
			{
				strcpy(ST[i].token_class,"Function");
				return;
			}
		}

	}

	void insertCT(char *str1, char *str2)
	{
		if(lookupCT(str1))
			return;
		else
		{
			int token_value = hash(str1);
			if(CT[token_value].length == 0)
			{
				strcpy(CT[token_value].token_name,str1);
				strcpy(CT[token_value].token_datatype,str2);
				CT[token_value].length = strlen(str1);
				return;
			}

			int pos = 0;

			for (int i = token_value + 1 ; i!=token_value ; i = (i+1)%1001)
			{
				if(CT[i].length == 0)
				{
					pos = i;
					break;
				}
			}

			strcpy(CT[pos].token_name,str1);
			strcpy(CT[pos].token_datatype,str2);
			CT[pos].length = strlen(str1);
		}
	}

	void deletedata (int nesting)
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(ST[i].nestval == nesting)
			{
				ST[i].nestval = 99999;
			}
		}


	}

	int checkscope(char *s)
	{
		int flag = 0;
		for(int i = 0 ; i < 1000 ; i++)
		{
			if(strcmp(ST[i].token_name,s)==0)
			{
				if(ST[i].nestval > currnest)
				{
					flag = 1;
				}
				else
				{
					flag = 0;
					break;
				}
			}
		}
		if(!flag)
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}

	int check_id_is_func(char *s)
	{
		for(int i = 0 ; i < 1000 ; i++)
		{
			if(strcmp(ST[i].token_name,s)==0)
			{
				if(strcmp(ST[i].token_class,"Function")==0)
					return 1;
			}
		}
		return 0;
	}

	int checkarray(char *s)
	{
		for(int i = 0 ; i < 1000 ; i++)
		{
			if(strcmp(ST[i].token_name,s)==0)
			{
				if(strcmp(ST[i].token_class,"Array Identifier")==0)
				{
					return 0;
				}
			}
		}
		return 1;
	}

	int duplicate(char *s)
	{
		for(int i = 0 ; i < 1000 ; i++)
		{
			if(strcmp(ST[i].token_name,s)==0)
			{				
				if(ST[i].nestval == currnest)
				{
			        return 1;
				}
			}
		}
		
		return 0;
	}

	int check_duplicate(char* str)
	{
		for(int i=0; i<1001; i++)
		{
			if(strcmp(ST[i].token_name, str) == 0 && strcmp(ST[i].token_class, "Function") == 0)
			{
				printf("ERROR: Redeclaration of Function\n");
				exit(0);
			}
		}
	}

	int check_declaration(char* str, char *check_type)
	{
		for(int i=0; i<1001; i++)
		{
			if(strcmp(ST[i].token_name, str) == 0 && strcmp(ST[i].token_class, "Function") == 0 || strcmp(ST[i].token_name,"printf")==0 )
			{
				return 1;
			}
		}
		return 0;
	}

	int check_params(char* type_specifier)
	{
		if(!strcmp(type_specifier, "void"))
		{
			printf("ERROR: Params of type void\n");
			exit(0);
		}
		return 0;
	}

	char gettype(char *s, int flag)
	{
			for(int i = 0 ; i < 1001 ; i++ )
			{
				if(strcmp(ST[i].token_name,s)==0)
				{
					return ST[i].token_datatype[0];
				}
			}
		
	}

	void printST()
	{
		printf("%10s | %10s | %10s | %10s | %10s | %10s | %10s |\n", "Line No", "Token", "Class", "Datatype", "Value", "Nesting", "Parameters");
		printf("\n");
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(ST[i].length == 0)
			{
				continue;
			}
			char *scope_depth;
			int j;
			if(ST[i].nestval == 99999)
			{
				scope_depth = "*";
			}
			if(ST[i].nestval == 9999)
			{
				scope_depth = "**";
			}
			if(ST[i].nestval == 999)
			{
				scope_depth = "***";
			}
			if(ST[i].nestval == 99)
			{
				scope_depth = "****";
			}
			if(ST[i].nestval == 9)
			{
				scope_depth = "*****";
			}
			if(strcmp(ST[i].token_name, "main") == 0)
			{
				printf("%10d | %10s | %10s | %10s | %10s | %10s | %10d |\n", ST[i].lineno, ST[i].token_name, ST[i].token_class, ST[i].token_datatype, ST[i].token_value, scope_depth, 0);
			}
			else
			{
				printf("%10d | %10s | %10s | %10s | %10s | %10s | %10d |\n", ST[i].lineno, ST[i].token_name, ST[i].token_class, ST[i].token_datatype, ST[i].token_value, scope_depth, ST[i].params_count);
			}
		}
    }


	void printCT()
	{
		printf("%10s | %10s\n","Name", "Type");
		printf("\n");
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(CT[i].length == 0)
				continue;

			printf("%10s | %15s\n",CT[i].token_name, CT[i].token_datatype);
		}
	}
	char curid[20];
	char curtype[20];
	char curval[20];

%}

DE "define"
IN "include"

%%
\n 	{yylineno++;}
([#][" "]*({IN})[ ]*([<]?)([A-Za-z]+)[.]?([A-Za-z]*)([>]?))/["\n"|\/|" "|"\t"]	{ }
([#][" "]*({DE})[" "]*([A-Za-z]+)(" ")*[0-9]+)/["\n"|\/|" "|"\t"]				{ } 
\/\/(.*)																		{ }
\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/										{ }
[ \n\t] ;
";"				{ return(';'); }
","				{ return(','); }
("{")			{ return('{'); }
("}")			{ return('}'); }
"("				{ return('('); }
")"				{ return(')'); }
("["|"<:")		{ return('['); }
("]"|":>") 		{ return(']'); }
":"				{ return(':'); }
"."				{ return('.'); }

"char"			{ strcpy(curtype,yytext); insertST(yytext, "Keyword");return CHAR;}
"double"		{ strcpy(curtype,yytext); insertST(yytext, "Keyword"); return DOUBLE;}
"else"			{ insertST(yytext, "Keyword"); return ELSE;}
"float"			{ strcpy(curtype,yytext); insertST(yytext, "Keyword"); return FLOAT;}
"while"			{ insertST(yytext, "Keyword"); return WHILE;}
"do"			{ insertST(yytext, "Keyword"); return DO;}
"for"			{ insertST(yytext, "Keyword"); return FOR;}
"if"			{ insertST(yytext, "Keyword"); return IF;}
"int"			{ strcpy(curtype,yytext); insertST(yytext, "Keyword"); return INT;}
"long"			{ strcpy(curtype,yytext); insertST(yytext, "Keyword"); return LONG;}
"return"		{ insertST(yytext, "Keyword"); return RETURN;}
"short"			{ strcpy(curtype,yytext); insertST(yytext, "Keyword"); return SHORT;}
"signed"		{ strcpy(curtype,yytext); insertST(yytext, "Keyword"); return SIGNED;}
"sizeof" 		{ insertST(yytext, "Keyword"); return SIZEOF;}
"struct"		{ strcpy(curtype,yytext);   insertST(yytext, "Keyword");  return STRUCT;}
"unsigned"		{ insertST(yytext, "Keyword");   return UNSIGNED;}
"void"			{ strcpy(curtype,yytext);   insertST(yytext, "Keyword");  return VOID;}
"break"			{ insertST(yytext, "Keyword");  return BREAK;}



"++"			{ return increment_operator; }
"--"			{ return decrement_operator; }
"<<"			{ return leftshift_operator; }
">>"			{ return rightshift_operator; }
"<="			{ return lessthan_assignment_operator; }
"<"				{ return lessthan_operator; }
">="			{ return greaterthan_assignment_operator; }
">"				{ return greaterthan_operator; }
"=="			{ return equality_operator; }
"!="			{ return inequality_operator; }
"&&"			{ return AND_operator; }
"||"			{ return OR_operator; }
"^"				{ return caret_operator; }
"*="			{ return multiplication_assignment_operator; }
"/="			{ return division_assignment_operator; }
"%="			{ return modulo_assignment_operator; }
"+="			{ return addition_assignment_operator; }
"-="			{ return subtraction_assignment_operator; }
"<<="			{ return leftshift_assignment_operator; }
">>="			{ return rightshift_assignment_operator; }
"&="			{ return AND_assignment_operator; }
"^="			{ return XOR_assignment_operator; }
"|="			{ return OR_assignment_operator; }
"&"				{ return amp_operator; }
"!"				{ return exclamation_operator; }
"~"				{ return tilde_operator; }
"-"				{ return subtract_operator; }
"+"				{ return add_operator; }
"*"				{ return multiplication_operator; }
"/"				{ return division_operator; }
"%"				{ return modulo_operator; }
"|"				{ return pipe_operator; }
\=				{ return assignment_operator;}

\"[^\n]*\"/[;|,|\)] 			{strcpy(curval,yytext); insertCT(yytext,"String Constant"); return string_constant;}
\'[A-Z|a-z]\'/[;|,|\)|:] 		{strcpy(curval,yytext); insertCT(yytext,"Character Constant"); return character_constant;}
[a-z|A-Z]([a-z|A-Z]|[0-9])*/\[ 	{strcpy(curid,yytext); insertST(yytext, "Array Identifier");  return array_identifier;}
[1-9][0-9]*|0/[;|,|" "|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\]|\}|:|\n|\t|\^] 	{strcpy(curval,yytext); insertCT(yytext, "Number Constant"); yylval = atoi(yytext); return integer_constant;}
([0-9]*)\.([0-9]+)/[;|,|" "|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\n|\t|\^] 	{strcpy(curval,yytext); insertCT(yytext, "Floating Constant"); return float_constant;}
[A-Za-z_][A-Za-z_0-9]* {strcpy(curid,yytext); insertST(curid,"Identifier"); return identifier;}

(.?) {
		if(yytext[0]=='#')
		{
			printf("Error in Pre-Processor directive at line no. %d\n",yylineno);
		}
		else if(yytext[0]=='/')
		{
			printf("ERR_UNMATCHED_COMMENT at line no. %d\n",yylineno);
		}
		else if(yytext[0]=='"')
		{
			printf("ERR_INCOMPLETE_STRING at line no. %d\n",yylineno);
		}
		else
		{
			printf("ERROR at line no. %d\n",yylineno);
		}
		printf("%s\n", yytext);
		return 0;
}

%%
