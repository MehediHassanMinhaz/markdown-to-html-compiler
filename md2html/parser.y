%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern FILE *yyin;
FILE *outFile;

void clean(char *str);
void parse_link(char *str);
int yylex(void);
int yyerror(const char *s);
%}

%union {
    char* str;
}

%token <str> H1 H2 H3 BOLD ITALIC LIST CODE LINK TEXT
%token NEWLINE

%%

input:
      input line
    | line
    ;

line:
      H1      { clean($1); printf("<h1>%s</h1>\n", $1); free($1); }
    | H2      { clean($1); printf("<h2>%s</h2>\n", $1); free($1); }
    | H3      { clean($1); printf("<h3>%s</h3>\n", $1); free($1); }
    | BOLD    { clean($1); printf("<b>%s</b>", $1); free($1); }
    | ITALIC  { clean($1); printf("<i>%s</i>", $1); free($1); }
    | LIST    { clean($1); printf("<li>%s</li>\n", $1); free($1); }
    | CODE    { clean($1); printf("<code>%s</code>", $1); free($1); }
    | LINK    { parse_link($1); free($1); }
    | TEXT    { printf("%s", $1); free($1); }
    | NEWLINE { printf("<br>\n"); }
    ;

%%

void clean(char *str) {
    int i, j = 0;
    char temp[1000];

    for (i = 0; str[i]; i++) {
        if (str[i] != '#' && str[i] != '*' && str[i] != '-' && str[i] != '`')
            temp[j++] = str[i];
    }
    temp[j] = '\0';
    strcpy(str, temp);
}

void parse_link(char *str) {
    char text[100], url[200];
    sscanf(str, "[%[^]]](%[^)])", text, url);
    printf("<a href=\"%s\">%s</a>", url, text);
}

/*
int main() {
    int choice;
    char inputFile[100];

    while (1) {
        printf("\n=== Markdown to HTML Converter ===\n");
        printf("1. Convert File\n");
        printf("2. Exit\n");
        printf("Enter choice: ");
        scanf("%d", &choice);

        if (choice == 1) {
            printf("Enter Markdown file name: ");
            scanf("%s", inputFile);

            yyin = fopen(inputFile, "r");
            if (!yyin) {
                printf("File not found!\n");
                continue;
            }

            outFile = fopen("output.html", "w");
            fprintf(outFile, "<html><body>\n");

            yyparse();

            fprintf(outFile, "\n</body></html>");
            fclose(yyin);
            fclose(outFile);

            printf("Conversion Done! Check output.html\n");
        }
        else if (choice == 2) {
            printf("Exiting...\n");
            break;
        }
        else {
            printf("Invalid choice!\n");
        }
    }

    return 0;
}
*/

int main() {
    yyparse();
    return 0;
}

int yyerror(const char *s) {
    printf("Error: %s\n", s);
    return 0;
}