%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int yylex(void);
int yyerror(const char *s);

void clean(char *str);
void parse_link(char *str);
void parse_image(char *str);
%}

%union {
    char* str;
}

%token <str> H1 H2 H3 BOLD ITALIC
%token <str> UNORDERED_LIST ORDERED_LIST NESTED_LIST
%token <str> TASK_DONE TASK_PENDING
%token <str> LINK IMAGE TEXT STRIKE
%token NEWLINE

%%

input:
      input line
    | line
    ;

line:
    H1 { 
		clean($1);
		printf("<h1>%s</h1>", $1);
		free($1); 
	}
    | H2 {
		clean($1);
		printf("<h2>%s</h2>", $1);
		free($1);
	}
    | H3 {
		clean($1);
		printf("<h3>%s</h3>", $1); 
		free($1); 
	}
    | BOLD {
		clean($1);
		printf("<b>%s</b>", $1);
		free($1); 
	}
    | ITALIC { 
		clean($1); 
		printf("<i>%s</i>", $1);
		free($1); 
	}
	| UNORDERED_LIST {
		clean($1);
		printf("<ul><li>%s</li></ul>", $1);
		free($1);
	}
	| ORDERED_LIST { 
		clean($1); 
		printf("<ol><li>%s</li></ol>", $1);
		free($1); 
	}
	| NESTED_LIST {
		clean($1);
		printf("<ul style='margin-left:20px'><li>%s</li></ul>", $1);
		free($1);
	}
	| TASK_DONE {
		clean($1);
		printf("<li>✅ %s</li>", $1);
		free($1);
	}
	| TASK_PENDING {
		clean($1);
		printf("<li>🔲 %s</li>", $1);
		free($1);
	}
	| STRIKE {
		clean($1);
		printf("<del>%s</del>", $1);
		free($1);
	}
    | LINK { 
		parse_link($1); 
		free($1); 
	}
	| IMAGE {
		parse_image($1);
		free($1);
	}
    | TEXT { 
		printf("%s", $1); 
		free($1); 
	}
    | NEWLINE { 
		printf("\n"); 
	}
    ;

%%

void clean(char *str) {
    int i = 0, j = 0;
    char temp[1000];

    while (str[i]) {

        // CASE: [x] or [ ]
        if (str[i] == '[' &&
            str[i+2] == ']' &&
            (str[i+1] == 'x' || str[i+1] == ' ')) {

            i += 3;   // skip entire "[x]" or "[ ]"
            continue;
        }

        // normal cleanup
        if (str[i] != '#' &&
            str[i] != '*' &&
            str[i] != '`' &&
            str[i] != '~' &&
            str[i] != '>') {

            temp[j++] = str[i];
        }

        i++;
    }

    temp[j] = '\0';
    strcpy(str, temp);
}

void parse_link(char *str) {
    char text[100], url[200];
    sscanf(str, "[%[^]]](%[^)])", text, url);
    printf("<a href=\"%s\">%s</a>", url, text);
}

void parse_image(char *str) {
    char alt[100], url[200];
    sscanf(str, "![%[^]]](%[^)])", alt, url);
    printf("<img src=\"%s\" alt=\"%s\" style=\"max-width:300px;\">", url, alt);
}

int main() {
    yyparse();
    return 0;
}

int yyerror(const char *s) {
    printf("Error: %s\n", s);
    return 0;
}