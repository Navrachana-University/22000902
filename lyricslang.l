%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lyricslang.tab.h" // Include the Bison-generated header

// External variable for yyin, if you plan to read from a file
extern FILE *yyin;

// Prototype for yyerror, typically defined in the Bison file
void yyerror(const char *s);
%}

%option yylineno

%%

"Say"                   { return PRINT; }
"Ask"                   { return INPUT; }
"ify"                   { return IF; }
"Maybe"                 { return ELSEIF; }
"Nope"                  { return ELSE; }
"Keep"                  { return WHILE; }
"Go"                    { return FOR; }
"Do"                    { return FUNCTION; }
"Back"                  { return RETURN; }
"Stop"                  { return BREAK; }
"Skip"                  { return CONTINUE; }
"Done"                  { return DONE_KEYWORD; }
"Set"                   { return VAR_DECL; } // Changed from VAR to VAR_DECL to distinguish
"Yas"                   { return TRUE_KEYWORD; }
"Nah"                   { return FALSE_KEYWORD; }
"Legit"                 { return IS_VALID; }
"Pick"                  { return SWITCH; }
"Opt"                   { return CASE; }
"Fallback"              { return DEFAULT; }

[Aa][Ss][Kk]            return INPUT;

[0-9]+                  { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return IDENTIFIER; }
\"[^"]*\"               {
                            yylval.str = strdup(yytext + 1); // Skip opening quote
                            if (strlen(yylval.str) > 0 && yylval.str[strlen(yylval.str) - 1] == '"') {
                                yylval.str[strlen(yylval.str) - 1] = '\0'; // Remove closing quote
                            }
                            return STRING;
                        }

"="                     { return EQUALS; }
"=="                    { return EQ_OP; }
"!="                    { return NE_OP; }
"<"                     { return LT_OP; }
">"                     { return GT_OP; }
"<="                    { return LE_OP; }
">="                    { return GE_OP; }
"+"                     { return PLUS; }
"-"                     { return MINUS; }
"*"                     { return MULTIPLY; }
"/"                     { return DIVIDE; }
";"                     { return ';'; }
"("                     { return '('; }
")"                     { return ')'; }
"{"                     { return '{'; }
"}"                     { return '}'; }
":"                     { return COLON; }

[ \t\n]+                { /* ignore whitespace - yylineno is updated by Flex here */ }
.                       { fprintf(stderr, "Invalid character on line %d: %s\n", yylineno, yytext); }

%%

int yywrap() {
    return 1; // Indicates no more files to process
}