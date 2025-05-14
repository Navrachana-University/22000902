
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     IDENTIFIER = 258,
     STRING = 259,
     NUMBER = 260,
     VALUE = 261,
     PRINT = 262,
     INPUT = 263,
     IF = 264,
     ELSEIF = 265,
     ELSE = 266,
     WHILE = 267,
     FOR = 268,
     FUNCTION = 269,
     RETURN = 270,
     BREAK = 271,
     CONTINUE = 272,
     DONE_KEYWORD = 273,
     VAR_DECL = 274,
     TRUE_KEYWORD = 275,
     FALSE_KEYWORD = 276,
     IS_VALID = 277,
     SWITCH = 278,
     CASE = 279,
     DEFAULT = 280,
     EQUALS = 281,
     EQ_OP = 282,
     NE_OP = 283,
     LT_OP = 284,
     GT_OP = 285,
     LE_OP = 286,
     GE_OP = 287,
     PLUS = 288,
     MINUS = 289,
     MULTIPLY = 290,
     DIVIDE = 291,
     COLON = 292
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 74 "lyricslang.y"

    int num;
    char *str;
    int val;
    void *ptr;



/* Line 1676 of yacc.c  */
#line 98 "lyricslang.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


