%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%option noyywrap

%%

"###".*                    { yylval.str = strdup(yytext); return H3; }
"##".*                     { yylval.str = strdup(yytext); return H2; }
"#".*                      { yylval.str = strdup(yytext); return H1; }

"**"[^*]+"**"              { yylval.str = strdup(yytext); return BOLD; }
"*"[^*]+"*"                { yylval.str = strdup(yytext); return ITALIC; }

"-".*                      { yylval.str = strdup(yytext); return LIST; }

"`"[^`]+"`"                { yylval.str = strdup(yytext); return CODE; }

"["[^]]+"]""("[^)]*")"     { yylval.str = strdup(yytext); return LINK; }

\n                         { return NEWLINE; }

.                          { yylval.str = strdup(yytext); return TEXT; }

%%