%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%option noyywrap

%%

"###".*                     { yylval.str = strdup(yytext); return H3; }
"##".*                      { yylval.str = strdup(yytext); return H2; }
"#".*                       { yylval.str = strdup(yytext); return H1; }

"**"[^*]+"**"               { yylval.str = strdup(yytext); return BOLD; }
"*"[^*]+"*"                 { yylval.str = strdup(yytext); return ITALIC; }

!\[[^\]]*\]\([^)]+\)        { yylval.str = strdup(yytext); return IMAGE; }
\[[^\]]+\]\([^)]+\)         { yylval.str = strdup(yytext); return LINK; }

~~[^~]+~~                   { yylval.str = strdup(yytext); return STRIKE; }

"- [x]".*                   { yylval.str = strdup(yytext); return TASK_DONE; }
"- [ ]".*                   { yylval.str = strdup(yytext); return TASK_PENDING; }

[ \t]+-.*                   { yylval.str = strdup(yytext); return NESTED_LIST; }
[0-9]+\\..* 	            { yylval.str = strdup(yytext); return ORDERED_LIST; }
"-".*                       { yylval.str = strdup(yytext); return UNORDERED_LIST; }

\n                          { return NEWLINE; }
[^~\*\n[]+		            { yylval.str = strdup(yytext); return TEXT; }

%%