%{

 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>

 extern int yylex();
 extern int yyparse();
 extern FILE* yyin;

 void yyerror(const char* s);
 extern void printfInfo();

 extern int liniaCurenta;
 void show();

%}


// cuvinte cheie
%token ID
%token MYINT
%token MYCHAR
%token MYSTRING
%token APAR
%token DACA
%token DACANU
%token IA
%token URLA
%token TOTFAPANA
%token OPRESTETEFRATE
%token SI
%token SAU
%token INCREMENT
%token DECREMENT
%token ADUNA
%token INMULTESTE
%token IMPARTE
%token MAIMIC
%token MAIMICEGAL
%token EGALITATE
%token MAIMAREEGAL
%token MAIMARE
%token ATRIBUIE

%%


program : lista_instructiuni
        ;

lista_instructiuni : instructiuni
                   | instructiuni lista_instructiuni
                   ;

instructiuni : lista_declaratii
             | lista_operatii
             | lista_declaratii lista_operatii
             ;

lista_declaratii : declaratie
                 | declaratie lista_declaratii
                 ;

lista_operatii : operatie
               | operatie lista_operatii
               ;

declaratie : APAR nume_variabile
           ;


nume_variabile : nume
               | nume ',' nume_variabile
               ;

nume : ID
     | ID '[' MYINT ']'
     ;

operatie : atribuire
         | op_rapida
         | instr_rel
         | instr_ciclare
         | OPRESTETEFRATE
         | intrare
         | iesire
         ;


atribuire : ID '=' expr
          ;

expr : ID
     | MYINT
     | expr semn expr
     ;

semn : '+'
     | '-'
     | '*'
     | '%'
     | '/'
     ;

op_rapida : ID semn_special
          ;

semn_special : INCREMENT
             | DECREMENT
             ;

intrare : IA nume_variabile
        ;

iesire : URLA date_iesire
       ;

date_iesire : MYSTRING
            ;


instr_rel : DACA '(' relatie ')' '{' program '}'
          | DACA '(' relatie ')' '{' program '}' DACANU '{' program '}'
          ;


instr_ciclare : TOTFAPANA '(' relatie ')' '{' program '}'
              ;

relatie : conditie
        | conditie SI relatie
        | conditie SAU relatie
        ;

conditie : elem_relatie comparator elem_relatie
         ;

elem_relatie : expr
             ;

comparator : MAIMIC
           | MAIMICEGAL
           | EGALITATE
           | MAIMAREEGAL
           | MAIMARE
           ;

%%

int main(int argc, char* argv[]) {
  FILE* f;
  char filename[100];
  printf("FILE: ");
  scanf("%s", filename);
  f = fopen(filename, "r");
  if (!f) {
   printf("Cannot open file\n");
   return -1;
  }
  printf("\nAnalysis started\n\n");
  yyin = f;
  do {
    yyparse();
  } while (!feof(yyin));
  printf("\nAnalysis completed\n");
  show();
  fclose(f);
}

void yyerror(const char* s) {
  printf("\nERROR: line %d!\n%s\n\n", liniaCurenta, s);
  exit(1);
}
