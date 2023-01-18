/* analizor pentru un MPL */

%{
   /* definitii accesibile in yylex si main */
  #include "bison.tab.h"
  #include <string.h>

  struct Element {
    int cod;
    char simbol[20];
    char tip[20];
  };

  struct TS {
    struct Element elemente[50];
    int pozCurenta;
    int codCurent;
  };

  struct FIP {
    int coduri[1000];
    int pozCurenta;
  };

  struct TS tsIds = {.pozCurenta = 0, .codCurent = 0 };
  struct TS tsConstants = {.pozCurenta = 0, .codCurent = 0 };

  struct FIP fip = {.pozCurenta = 0 };
  int liniaCurenta = 1;

  void adaugaFIP(int cod);

  void adaugaTS(int codFIP, char simbol[]);

%}

  /* reguli */
id       [a-zA-Z]+[a-zA-Z_0-9-]*
myInt    [-+]{0,1}(0|[1-9]+[0-9]*)
myString \"[a-zA-Z0-9 $_]*\"
myChar   \'[0-9]\'|\'[a-zA-Z]\'

%%

"apar" { adaugaFIP(5); return APAR; }
"daca" { adaugaFIP(6); return DACA; }
"daca nu" { adaugaFIP(7); return DACANU; }
"ia" { adaugaFIP(8); return IA; }
"urla" { adaugaFIP(9); return URLA; }
"tot fa pana" { adaugaFIP(10); return TOTFAPANA; }
"opreste te frate" { adaugaFIP(11); return OPRESTETEFRATE; }
"SI" { adaugaFIP(12); return SI; }
"SAU" { adaugaFIP(13); return SAU; }
"+" { adaugaFIP(14); return '+'; }
"++" { adaugaFIP(15); return INCREMENT; }
"-" { adaugaFIP(16); return '-'; }
"--" { adaugaFIP(17); return DECREMENT; }
"*" { adaugaFIP(18); return '*'; }
"%" { adaugaFIP(19); return '%'; }
"/" { adaugaFIP(20); return '/'; }
"+=" { adaugaFIP(21); return ADUNA; }
"-=" { adaugaFIP(22); return INMULTESTE; }
"/=" { adaugaFIP(23); return IMPARTE; }
"=" { adaugaFIP(24); return '='; }
"<" { adaugaFIP(25); return MAIMIC; }
"<=" { adaugaFIP(26); return MAIMICEGAL; }
"==" { adaugaFIP(27); return EGALITATE; }
">=" { adaugaFIP(28); return MAIMAREEGAL; }
">" { adaugaFIP(29); return MAIMARE; }
";" { adaugaFIP(30); return ';'; }
"," { adaugaFIP(31); return ','; }
"[" { adaugaFIP(32); return '['; }
"]" { adaugaFIP(33); return ']'; }
"{" { adaugaFIP(34); return '{'; }
"}" { adaugaFIP(35); return '}'; }
"(" { adaugaFIP(36); return '('; }
")" { adaugaFIP(37); return ')'; }
":=" { adaugaFIP(38); return ATRIBUIE; }
":" { adaugaFIP(39); ;return ':'; }


{id} { adaugaTS(1, yytext); return ID; }
{myInt} { adaugaTS(2, yytext); return MYINT; }
{myString} { adaugaTS(3, yytext); return MYSTRING; }
{myChar} { adaugaTS(4, yytext); return MYCHAR; }
[ \t]+   /* whitespace */
[\n] {liniaCurenta++;}
.  { printf("ERROR: %s - atom nespecificat la linia %d!\n", yytext, liniaCurenta);
     return -1; }

%%


void adaugaFIP(int cod) {
  fip.coduri[fip.pozCurenta] = cod;
  fip.pozCurenta++;
}

void adaugaTS(int codFIP, char simbol[]) {
  adaugaFIP(codFIP);

  for(int i = 0; i < tsIds.pozCurenta; i++) {
    if (strcmp(tsIds.elemente[i].simbol, simbol) == 0) return;
  }

  for(int i = 0; i < tsConstants.pozCurenta; i++) {
    if (strcmp(tsConstants.elemente[i].simbol, simbol) == 0) return;
  }

  char tip[20];
  if (codFIP == 1){
    tsIds.elemente[tsIds.pozCurenta].cod = tsIds.codCurent;
    strcpy(tsIds.elemente[tsIds.pozCurenta].simbol, simbol);
    strcpy(tip, "ID");
    strcpy(tsIds.elemente[tsIds.pozCurenta].tip, tip);
    tsIds.codCurent++;
    tsIds.pozCurenta++;
  }


  if(codFIP == 2 || codFIP == 3 || codFIP == 4){
    tsConstants.elemente[tsConstants.pozCurenta].cod = tsConstants.codCurent;
    strcpy(tsConstants.elemente[tsConstants.pozCurenta].simbol, simbol);
    strcpy(tip, "CONSTANT");
    strcpy(tsConstants.elemente[tsConstants.pozCurenta].tip, tip);
    tsConstants.codCurent++;
    tsConstants.pozCurenta++;
  }

}



int yywrap() {}
void show() {

  printf("\n----- FIP -----\n");
  for (int i = 0; i < fip.pozCurenta; i++)
    printf("%d ", fip.coduri[i]);

  printf("\n");

  FILE* fIds;
  FILE* fConstants;


  fIds = fopen("tsIds", "w");
  fConstants = fopen("tsConstants", "w");


  printf("\n----- TS - Ids -----\n");
  for (int i = 0; i < tsIds.pozCurenta; i++){
    printf("COD=%d -> SYMBOL: %s\n", i, tsIds.elemente[i].simbol);
    fprintf(fIds, "COD=%d -> SYMBOL: %s\n", i, tsIds.elemente[i].simbol);
  }

  printf("\n----- TS - Constants -----\n");
  for (int i = 0; i < tsConstants.pozCurenta; i++){
    printf("COD=%d -> SYMBOL: %s\n", i, tsConstants.elemente[i].simbol);
    fprintf(fConstants, "COD=%d -> SYMBOL: %s\n", i, tsConstants.elemente[i].simbol);
  }

  fclose(fIds);
  fclose(fConstants);

}




