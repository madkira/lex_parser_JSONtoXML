%{
#include<stdio.h>
#include <string.h>


/*
struct piles p;
p__attribute__beg = NULL;
p__attribute__size = 0;
*/



typedef struct Elem {
  char *stack;
  struct Elem *next;
} elem;

typedef struct piles {
  elem *beg;
  int size;
} Pile;

char *text;
char *balise;
char *inside_balise;

char *amount;
int amount_size;


unsigned char *realloc_properly (unsigned char *ptr){
  unsigned char *ptr_tmp = realloc (ptr, 1000 * sizeof(char));
  if (ptr_tmp != NULL)
    return ptr_tmp;
  return ptr;
}





char *line(char *text, const char *balise, const char *value, int begin, int end, int number_tab){
  char *tmp_text;
  tmp_text = text;
  tmp_text = strcat(tmp_text, "\n");
  int i;
  for(i=0; i< number_tab; i++){tmp_text = strcat(tmp_text, "\t");}
  tmp_text = strcat(tmp_text, "<");
  tmp_text = strcat(tmp_text,balise);
  tmp_text = strcat(tmp_text,">");
  tmp_text = strncat(tmp_text, yytext+begin, yyleng-end);
  tmp_text = strcat(tmp_text,"</");
  tmp_text = strcat(tmp_text,balise);
  tmp_text = strcat(tmp_text,">");
  return tmp_text;
}


void generate_balise(char *name, int begin, int end, int type){
  if(type == 1){
    balise  = (char*) calloc(50,sizeof(char));
    balise = strncpy(balise, name + begin, strlen(name)- end);
  }
  else {
    inside_balise = (char*) calloc(50,sizeof(char));
    inside_balise = strncpy(inside_balise, name + begin, strlen(name)- end);
  }
}


char *contract(char *text, const char *amount, int amount_size){
  char *tmp_text;
  char SInt[10];
  tmp_text = text;
  tmp_text = strcat(tmp_text, "\n\t\t\t\t<");
  tmp_text = strncat(tmp_text, yytext+1, yyleng-2);
  tmp_text = strcat(tmp_text, ">");
  tmp_text = strncat(tmp_text, amount, amount_size);
  tmp_text = strcat(tmp_text, "</");
  tmp_text = strncat(tmp_text, yytext+1, yyleng-2);
  tmp_text = strcat(tmp_text, ">");

}




%}

DIGIT [0-9]
NUM [+-]?{DIGIT}+
FIRSTMESS "\[{"
NEWMESS "},{"
ENDMESS "}\]"


STR   \"([^"\\]|\\(.|\n))*\"

PART  "\"part\":"
METH  "\"meth\":"
TIME  "\"time\":"

DATA  "\"data\":"


HEADING  "\"heading\":"
MEN   "\"men\":"
CONTRACTS "\"contracts\":"
BUDGET  "\"budget\":"


ACTION  "\"action\":"
PARAMETERS  "\"parameters\":"

DIRECTION "\"direction\":"
CREEK "\"creek\":"
PEOPLE "\"people\":"
RANGE "\"range\":"
QUARTZ "\"QUARTZ\":"
WOOD "\"WOOD\":"
ORE "\"ORE\":"
FUR "\"FUR\":"
SUGAR_CANE "\"SUGAR_CANE\":"
FRUITS "\"FRUITS\":"



COST  "\"cost\":"
EXTRAS  "\"extras\":"
STATUS  "\"status\":"

FOUND "\"found\":"
ALTITUDE "\"altitude\":"
ASKED_RANGE "\"asked_range\":"
PRODUCTION  "\"production\":"
KIND  "\"kind\":"

CREEKS "\"creeks\":"
BIOMES "\"biomes\":"
REPORT "\"report\":"
RESOURCES "\"resources\":"
POIS "\"pois\":"


AMOUNT "\"amount\":"
RESOURCE "\"resource\":"



INLINE  {COST}|{ACTION}|{HEADING}|{MEN}|{BUDGET}
EXTPARA {EXTRAS}|{PARAMETERS}

LINEPARA {DIRECTION}|{RESOURCE}|{CREEK}|{PEOPLE}|{RANGE}|{QUARTZ}|{WOOD}|{ORE}|{FUR}|{SUGAR_CANE}|{FRUITS}
LINEEXT {RANGE}|{FOUND}|{ALTITUDE}|{ASKED_RANGE}|{AMOUNT}|{PRODUCTION}|{KIND}

OBJEXT {CREEKS}|{BIOMES}|{REPORT}|{RESOURCES}|{POIS}

LINEEXTPARA {LINEPARA}|{LINEEXT}

%s ARGUSTR
%s ARGUINT

%s VALINT
%s VALSTR
%s INLINE


%s CONTRACTS
%s EXTPARA
%s TRASH


%s DATA


UTF   (.|\n)


%%


^{FIRSTMESS}  {printf("\n\t<MESSAGE"); text = (char*) calloc(1000,sizeof(char));}
^{NEWMESS}  {printf(">"); printf("%s", text);printf("\n\t</MESSAGE>\n\t<MESSAGE"); free(text); text = (char*) calloc(1000,sizeof(char));}
^{ENDMESS}  {printf(">\n\t</MESSAGE>"); free(text);}


{PART}  {BEGIN ARGUSTR; printf(" PART=");}
{METH}  {BEGIN ARGUSTR; printf(" METH=");}
<ARGUSTR>{STR} {ECHO; BEGIN 0;}

{TIME}  {BEGIN ARGUINT; printf(" TIME=");}
<ARGUINT>{NUM}  {printf("\""); ECHO; printf("\""); BEGIN 0;}

{DATA}  {;}



{INLINE} {generate_balise(yytext, 1 , 3, 1); BEGIN INLINE;}

<INLINE>{NUM} {text = line(text,balise, yytext, 0, 0, 2); BEGIN 0;}
<INLINE>{STR} {text = line(text,balise, yytext, 1, 2, 2); BEGIN 0;}


{CONTRACTS} {generate_balise(yytext, 1, 3, 1); text = strcat(text, "\n\t\t<"); text = strcat(text, balise);  text = strcat(text, ">"); BEGIN CONTRACTS;}

<CONTRACTS>{RESOURCE} {;}
<CONTRACTS>{AMOUNT} {;}
<CONTRACTS>{NUM} {amount = yytext; amount_size = yyleng;}
<CONTRACTS>{STR} {contract(text, amount, amount_size);}
<CONTRACTS>"]," {text = strcat(text, "\n\t\t</"); text = strcat(text, balise);  text = strcat(text, ">"); BEGIN 0;}

{EXTPARA} {generate_balise(yytext, 1, 3, 1); text = strcat(text, "\n\t\t<"); text = strcat(text, balise); text = strcat(text, ">"); BEGIN EXTPARA;}

<EXTPARA>{LINEEXTPARA} {generate_balise(yytext, 1, 3, 2);}
<EXTPARA>{STR} {text = line(text,inside_balise, yytext, 1, 2, 3);}
<EXTPARA>{NUM} {text = line(text,inside_balise, yytext, 0, 0, 3);}


<EXTPARA>^"  }," { text = strcat(text, "\n\t\t</"); text = strcat(text, balise); text = strcat(text, ">"); BEGIN 0;}
<EXTPARA>{STATUS} { text = strcat(text, "\n\t\t</"); text = strcat(text, balise); text = strcat(text, ">"); generate_balise(yytext, 1 , 3, 1); BEGIN INLINE;}

<EXTPARA>{OBJEXT} {BEGIN TRASH;}
<TRASH>{LINEEXTPARA} {generate_balise(yytext, 1, 3, 2); BEGIN EXTPARA;}
<TRASH>{STATUS} { text = strcat(text, "\n\t\t</"); text = strcat(text, balise); text = strcat(text, ">"); generate_balise(yytext, 1 , 3, 1); BEGIN INLINE;}

{NUM}   ;//{ECHO; printf("\t\t %d\n", p__attribute__size);}
{UTF}   ;

%%


int main(void) {
  printf("<?xml version=\"1.0\"?>\n<LISTE>");
  yylex();
  printf("\n</LISTE>\n");
  return 0;
}
