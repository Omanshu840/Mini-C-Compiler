%{
	#include <stdio.h>
	#include <string.h>
	
	struct Constant_Table
	{
		char token_name[100];
		char token_type[100];
		int size;
	}CT[1001];

	struct Symbol_Table
	{
		char token_name[100];
		char token_type[100];
		int size;
	}ST[1001];

	int find_hash(char *str)
	{
		int value = 0;
		for(int i = 0 ; i < strlen(str) ; i++)
		{
			value = 10*value + (str[i] - 'A');
			value = value % 1001;
			while(value < 0)
				value = value + 1001;
		}
		return value;
	}

	int lookup(char *str , int lookup_Mode)
	{
		if(lookup_Mode == 0)
		{
			int value = find_hash(str);
			if(ST[value].size == 0)
			{
				return 0;
			}
			else if(strcmp(ST[value].token_name,str)==0)
			{
				return 1;
			}
			else
			{
				for(int i = value + 1 ; i!=value ; i = (i+1)%1001)
				{
					if(strcmp(ST[i].token_name,str)==0)
					{
						return 1;
					}
				}
				return 0;
			}
		}
		else
		{
			int value = find_hash(str);
			if(CT[value].size == 0)
				return 0;
			else if(strcmp(CT[value].token_name,str)==0)
				return 1;
			else
			{
				for(int i = value + 1 ; i!=value ; i = (i+1)%1001)
				{
					if(strcmp(CT[i].token_name,str)==0)
					{
						return 1;
					}
				}
				return 0;
			}
		}
	}

	void insert(char *str1, char *str2, int insert_Mode)  
	{
		if(insert_Mode == 0)
		{
			if(lookup(str1, 0)) 
			{
				return;
			}
			else
			{
				int value = find_hash(str1);
				if(ST[value].size == 0)
				{
					strcpy(ST[value].token_name,str1);
					strcpy(ST[value].token_type,str2);
					ST[value].size = strlen(str1);
					return;
				}

				int pos = 0;

				for (int i = value + 1 ; i!=value ; i = (i+1)%1001)
				{
					if(ST[i].size == 0)
					{
						pos = i;
						break;
					}
				}

				strcpy(ST[pos].token_name,str1);
				strcpy(ST[pos].token_type,str2);
				ST[pos].size = strlen(str1);
			}
		}
		else
		{
			if(lookup(str1, 1))
				return;
			else
			{
				int value = find_hash(str1);
				if(CT[value].size == 0)
				{
					strcpy(CT[value].token_name,str1);
					strcpy(CT[value].token_type,str2);
					CT[value].size = strlen(str1);
					return;
				}

				int pos = 0;

				for (int i = value + 1 ; i!=value ; i = (i+1)%1001)
				{
					if(CT[i].size == 0)
					{
						pos = i;
						break;
					}
				}

				strcpy(CT[pos].token_name,str1);
				strcpy(CT[pos].token_type,str2);
				CT[pos].size = strlen(str1);
			}
		}
	}

	void printTables()
	{
		printf("\n\n--------------------------------------------------");
		printf("\nSYMBOL TABLE\n");
		printf("--------------------------------------------------\n");
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(ST[i].size == 0)
				continue;

			printf("\t%s\t\t\t%s\n",ST[i].token_name, ST[i].token_type);
		}
		printf("--------------------------------------------------\n");
		printf("\n\n--------------------------------------------------");
		printf("\nCONSTANT TABLE\n");
		printf("--------------------------------------------------\n");
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(CT[i].size == 0)
				continue;

			printf("\t%s\t\t\t%s\n",CT[i].token_name, CT[i].token_type);
		}
		printf("--------------------------------------------------\n");
	}
%}


operator [[<][=]|[>][=]|[=][=]|[!][=]|[>]|[<]|[\|][\|]|[&][&]|[\!]|[=]|[\^]|[\+][=]|[\-][=]|[\*][=]|[\/][=]|[\%][=]|[\+][\+]|[\-][\-]|[\+]|[\-]|[\*]|[\/]|[\%]|[&]|[\|]|[~]|[<][<]|[>][>]]
floatNumber ([0-9]*)\.([0-9]+)
intNumber [1-9][0-9]*|0
postNumber [;|,|" "|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\]|\}|:|\n|\t|\^]
postIdentifier [" "|;|,|\(|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\n|\.|\{|\^|\t|\]]

%%

\n  {yylineno++;}
([#][" "]*(include)[ ]*([<]?)([A-Za-z]+)[.]?([A-Za-z]*)([>]?))/["\n"|\/|" "|"\t"] {printf("line no: %d\t%s \tPre Processor directive\n",yylineno, yytext);}
([#][" "]*(define)[" "]*([A-Za-z]+)(" ")*({floatNumber}|{intNumber}))/["\n"|\/|" "|"\t"] {printf("line no: %d\t%s \tMacro\n",yylineno, yytext);}
\/\/(.*) {printf("line no: %d\t%s \tSINGLE LINE COMMENT\n", yylineno, yytext);}				
\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/ {printf("line no: %d\t%s \tMULTI LINE COMMENT\n", yylineno, yytext);}
[ \n\t] ;
; {printf("line no: %d\t%s \tSEMICOLON\n", yylineno, yytext);}
, {printf("line no: %d\t%s \tCOMMA\n", yylineno, yytext);}
\{ {printf("line no: %d\t%s \tOPENING BRACES\n", yylineno, yytext);}
\} {printf("line no: %d\t%s \tCLOSING BRACES\n", yylineno, yytext);}
\( {printf("line no: %d\t%s \tOPENING BRACKETS\n", yylineno, yytext);}
\) {printf("line no: %d\t%s \tCLOSING BRACKETS\n", yylineno, yytext);}
\[ {printf("line no: %d\t%s \tSQUARE OPENING BRACKETS\n", yylineno, yytext);}
\] {printf("line no: %d\t%s \tSQUARE CLOSING BRACKETS\n", yylineno, yytext);}
\: {printf("line no: %d\t%s \tCOLON\n", yylineno, yytext);}
\\ {printf("line no: %d\t%s \tFSLASH\n", yylineno, yytext);}
\. {printf("line no: %d\t%s \tDOT\n", yylineno, yytext);}

auto|double|int|struct|break|else|long|switch|case|enum|register|typedef|char|extern|return|union|continue|for|signed|void|do|if|static|while|default|goto|sizeof|volatile|const|float|short|unsigned|main/[\(|" "|\{|;|:|"\n"|"\t"] {printf("line no: %d\t%s \tKEYWORD\n", yylineno, yytext); insert(yytext, "KEYWORD", 0);}
\"[^\n]*\"/[;|,|\)|\}] {printf("line no: %d\t%s \tSTRING CONSTANT\n", yylineno, yytext); insert(yytext,"STRING CONSTANT", 1);}
\'[A-Z|a-z]\'/[;|,|\)|:|\}] {printf("line no: %d\t%s \tCharacter CONSTANT\n", yylineno, yytext); insert(yytext,"Character CONSTANT", 1);}
[a-z|A-Z]([a-z|A-Z]|[0-9])*/\[ {printf("line no: %d\t%s \tARRAY IDENTIFIER\n", yylineno, yytext); insert(yytext, "IDENTIFIER", 0);}

{operator}/[a-z]|[0-9]|;|" "|[A-Z]|\(|\"|\'|\)|\n|\t {printf("line no: %d\t%s \tOPERATOR\n", yylineno, yytext);} 

{intNumber}/{postNumber} {printf("line no: %d\t%s \tNUMBER CONSTANT\n", yylineno, yytext); insert(yytext, "NUMBER CONSTANT", 1);}
{floatNumber}/{postNumber} {printf("line no: %d\t%s \tFloating CONSTANT\n", yylineno, yytext); insert(yytext, "Floating CONSTANT", 1);}
[A-Za-z_][A-Za-z_0-9]*/{postIdentifier} {printf("line no: %d\t%s \tIDENTIFIER\n", yylineno, yytext); insert(yytext, "IDENTIFIER", 0);}


(.?) {
	printf("------------------------------------------------------\n");
	if(yytext[0]=='#')
	{
		printf("ERROR at line no. %d : Error in Pre-Processor directive \n",yylineno);
	}
	else if(yytext[0]=='/')
	{
		printf("ERROR at line no. %d: UNMATCHED_COMMENT \n",yylineno);
	}
	else if(yytext[0]=='"')
	{
		printf("ERROR at line no. %d: INCOMPLETE_STRING \n",yylineno);
	}
	else
	{
		printf("ERROR at line no. %d\n",yylineno);
	}
	printf("\t%s\n", yytext);
	printf("\n--------------------------------------------------\n");
	return 0;
}

%%


int main(int argc , char **argv){

	int i;
	for (i=0;i<1001;i++)
	{
		ST[i].size=0;
		CT[i].size=0;
	}

	printf("\n\n");

	yyin = fopen(argv[1],"r"); 
	yylex();
	
	printTables();
}

int yywrap(){
    return 1;
}