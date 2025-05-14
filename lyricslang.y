%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;
extern int yylineno;
int yylex(void);
void yyerror(const char *s);

#define MAX_VARIABLES 100

struct Variable {
    char *name;
    int value;
    int is_defined;
};
struct Variable symbolTable[MAX_VARIABLES];
int variableCount = 0;

void setVariable(char *name, int value) {
    for (int i = 0; i < variableCount; i++) {
        if (strcmp(symbolTable[i].name, name) == 0) {
            symbolTable[i].value = value;
            symbolTable[i].is_defined = 1;
            printf("Variable '%s' updated to %d.\n", name, value);
            return;
        }
    }
    if (variableCount < MAX_VARIABLES) {
        symbolTable[variableCount].name = strdup(name);
        symbolTable[variableCount].value = value;
        symbolTable[variableCount].is_defined = 1;
        printf("Variable '%s' set to %d.\n", name, value);
        variableCount++;
    } else {
        fprintf(stderr, "Error: Variable symbol table is full.\n");
    }
}

int getVariable(char *name) {
    for (int i = 0; i < variableCount; i++) {
        if (strcmp(symbolTable[i].name, name) == 0) {
            if (symbolTable[i].is_defined) {
                return symbolTable[i].value;
            } else {
                fprintf(stderr, "Error: Variable '%s' used before assignment.\n", name);
                return 0;
            }
        }
    }
    fprintf(stderr, "Error: Variable '%s' not declared.\n", name);
    return 0;
}

#define MAX_FUNCTIONS 100
struct FunctionSymbol {
    char *name;
};
struct FunctionSymbol functionTable[MAX_FUNCTIONS];
int functionCount = 0;

void addFunctionSymbol(char *name) {
    if (functionCount < MAX_FUNCTIONS) {
        functionTable[functionCount].name = strdup(name);
        printf("Function '%s' defined.\n", name);
        functionCount++;
    } else {
        fprintf(stderr, "Error: Function symbol table is full.\n");
    }
}
%}

%union {
    int num;
    char *str;
    int val;
    void *ptr;
}

%token <str> IDENTIFIER STRING
%token <num> NUMBER
%token <val> VALUE

%token PRINT INPUT IF ELSEIF ELSE WHILE FOR FUNCTION RETURN BREAK CONTINUE DONE_KEYWORD VAR_DECL
%token TRUE_KEYWORD FALSE_KEYWORD IS_VALID SWITCH CASE DEFAULT

%token EQUALS EQ_OP NE_OP LT_OP GT_OP LE_OP GE_OP
%token PLUS MINUS MULTIPLY DIVIDE
%token COLON

%type <val> expression term factor condition
%type <str> identifier
%type <val> block_statement
%type <ptr> else_if_clauses_opt else_if_clauses else_if_clause else_clause_opt

%left PLUS MINUS
%left MULTIPLY DIVIDE
%left EQ_OP NE_OP LT_OP GT_OP LE_OP GE_OP

%%

program:
    statement_list
    ;

statement_list:
    statement
    | statement_list statement
    ;

statement:
    expression_statement
    | print_statement
    | input_statement
    | variable_declaration_statement
    | assignment_statement
    | if_statement
    | while_statement
    | for_statement
    | switch_statement
    | function_definition
    | return_statement
    | BREAK ';'
    | CONTINUE ';'
    | block_statement
    | ';'
    ;

block_statement:
    '{' statement_list '}' { $$ = 0; }
    ;

print_statement:
    PRINT expression ';'       { printf("Saying: %d\n", $2); }
    | PRINT STRING ';'         { printf("Saying: %s\n", $2); if ($2) free($2); }
    ;

input_statement:
    INPUT identifier ';' {
        char buffer[256];
        printf("Enter value for %s: ", $2);
        if (fgets(buffer, sizeof(buffer), stdin)) {
            buffer[strcspn(buffer, "\n")] = 0;  // Remove newline
            char *endptr;
            int val = strtol(buffer, &endptr, 10);
            if (*endptr == '\0') {
                setVariable($2, val);
            } else {
                printf("Read string: %s\n", buffer);
                // Optional: store as string if symbol table supports it
            }
        } else {
            fprintf(stderr, "Failed to read input. Setting '%s' to 0.\n", $2);
            setVariable($2, 0);
        }
        if ($2) free($2);
    }
    ;

variable_declaration_statement:
    VAR_DECL identifier EQUALS expression ';' { setVariable($2, $4); if ($2) free($2); }
    ;

assignment_statement:
    identifier EQUALS expression ';' { setVariable($1, $3); if ($1) free($1); }
    ;

if_statement:
    IF '(' condition ')' block_statement else_if_clauses_opt else_clause_opt DONE_KEYWORD {
        printf("If condition evaluated to: %d\n", $3);
        if ($3 != 0) {
            printf("Executing the 'ify' block.\n");
        } else if ($6 != NULL) {
            printf("Skipping 'maybe' blocks (not fully implemented).\n");
            if ($7 != NULL) {
                printf("Executing the 'nope' block.\n");
            }
        } else if ($7 != NULL) {
            printf("Executing the 'nope' block.\n");
        }
    }
    ;

else_if_clauses_opt:
    /* empty */ { $$ = NULL; }
    | else_if_clauses { $$ = $1; }
    ;

else_if_clauses:
    else_if_clause { $$ = $1; }
    | else_if_clauses else_if_clause { $$ = NULL; }
    ;

else_if_clause:
    ELSEIF '(' condition ')' block_statement { printf("Elseif condition evaluated to: %d\n", $3); $$ = NULL; }
    ;

else_clause_opt:
    /* empty */ { $$ = NULL; }
    | ELSE block_statement { $$ = (void *)$2; }
    ;

while_statement:
    WHILE '(' condition ')' block_statement DONE_KEYWORD { printf("While loop parsed.\n"); }
    ;

for_statement:
    FOR '(' variable_declaration_statement condition ';' expression_opt ')' block_statement DONE_KEYWORD { printf("For loop parsed.\n"); }
    ;

switch_statement:
    SWITCH '(' expression ')' '{' case_list default_case_opt '}' DONE_KEYWORD { printf("Switch statement parsed.\n"); }
    ;

case_list:
    /* empty */
    | case_list CASE expression COLON statement_list { printf("Case parsed.\n"); }
    ;

default_case_opt:
    /* empty */
    | DEFAULT COLON statement_list { printf("Default case parsed.\n"); }
    ;

function_definition:
    FUNCTION identifier '(' ')' block_statement DONE_KEYWORD { addFunctionSymbol($2); if ($2) free($2); }
    ;

return_statement:
    RETURN expression_opt ';' { printf("Return statement parsed.\n"); }
    ;

expression_opt:
    /* empty */
    | expression
    ;

expression_statement:
    expression ';'
    ;

condition:
    expression
    ;

expression:
    identifier                      { $$ = getVariable($1); if ($1) free($1); }
    | NUMBER                        { $$ = $1; }
    | TRUE_KEYWORD                  { $$ = 1; }
    | FALSE_KEYWORD                 { $$ = 0; }
    | expression EQ_OP expression   { $$ = ($1 == $3); }
    | expression NE_OP expression   { $$ = ($1 != $3); }
    | expression LT_OP expression   { $$ = ($1 < $3); }
    | expression GT_OP expression   { $$ = ($1 > $3); }
    | expression LE_OP expression   { $$ = ($1 <= $3); }
    | expression GE_OP expression   { $$ = ($1 >= $3); }
    | expression PLUS term          { $$ = $1 + $3; }
    | expression MINUS term         { $$ = $1 - $3; }
    | term                          { $$ = $1; }
    ;

term:
    factor
    | term MULTIPLY factor { $$ = $1 * $3; }
    | term DIVIDE factor   { $$ = ($3 != 0) ? $1 / $3 : (fprintf(stderr, "Error: Division by zero.\n"), 0); }
    ;

factor:
    NUMBER { $$ = $1; }
    | identifier { $$ = getVariable($1); if ($1) free($1); }
    | '(' expression ')' { $$ = $2; }
    ;

identifier:
    IDENTIFIER { $$ = strdup($1); }
    ;

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror(argv[1]);
            return 1;
        }
        yyin = file;
    } else {
        yyin = stdin;
    }

    printf("Starting parse...\n");
    if (yyparse() == 0) {
        printf("Parsing completed successfully!\n");
    } else {
        printf("Parsing failed.\n");
    }
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error at line %d: %s\n", yylineno, s);
}
