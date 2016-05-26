%{
#include<stdio.h>
#include <string.h>

/*
#define MAXHEIGHT 5
#define MAXWIDTH 50
#define TRUE 1
#define FALSE 0

int position;
char **balises;
balises = calloc(MAXHEIGHT, sizeof(char*));
if( balises) {
  int i;
  for( i = 0; i <  MAXHEIGHT; i++){
    balise[i] = calloc(MAXWIDTH, sizeof(char));
  }
}
position = 0;



void push(char *balise_name){
  balises[position] = strcat(balises[position], balise_name);
  position++;
}

char *pop(){
  position--;
  return balises[position];
}

char *peek(){
  return balises[position-1];
}
*/

char *text;
char *balise;
char *inside_balise;
char *inner;

char *report_biome;
char *report;
int range_report;

char *amount;
int amount_size;



unsigned char *realloc_properly (unsigned char *ptr){
  unsigned char *ptr_inner = realloc (ptr, 1000 * sizeof(char));
  if (ptr_inner != NULL)
    return ptr_inner;
  return ptr;
}


char *write_open_balise(char *text, const char *name, int newline, int nb_tab){
  char *open;
  open = text;
  if(newline == 1)
    open = strcat(open, "\n");
  int i;
  for(i = 0; i < nb_tab; i++)
    open = strcat(open, "\t");
  open = strcat(open, "<");
  open = strcat(open, name);
  open = strcat(open, ">");
  return open;
}

char *write_close_balise(char *text, const char *name, int newline, int nb_tab){
  char *close;
  close = text;
  if(newline == 1)
    close = strcat(close, "\n");
  int i;
  for(i = 0; i < nb_tab; i++)
    close = strcat(close, "\t");
  close = strcat(close, "</");
  close = strcat(close, name);
  close = strcat(close, ">");
  return close;
}



char *line(char *text, const char *balise, const char *value, int begin, int end, int number_tab){
  char *inner_text;
  inner_text = text;
  inner_text = strcat(inner_text, "\n");
  int i;
  for(i=0; i< number_tab; i++){inner_text = strcat(inner_text, "\t");}
  inner_text = strcat(inner_text, "<");
  inner_text = strcat(inner_text,balise);
  inner_text = strcat(inner_text,">");
  inner_text = strncat(inner_text, yytext+begin, yyleng-end);
  inner_text = write_close_balise(inner_text, balise, 0, 0);

  return inner_text;
}


void generate_balise_name(char *name, int begin, int end, int type){
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
  char *inner_text;
  char SInt[10];
  inner_text = text;
  inner_text = strcat(inner_text, "\n\t\t\t<");
  inner_text = strncat(inner_text, yytext+1, yyleng-2);
  inner_text = strcat(inner_text, ">");
  inner_text = strncat(inner_text, amount, amount_size);
  inner_text = strcat(inner_text, "</");
  inner_text = strncat(inner_text, yytext+1, yyleng-2);
  inner_text = strcat(inner_text, ">");

}




%}

DIGIT [0-9]
NUM [+-]?{DIGIT}+("."{DIGIT}+)?
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
COND "\"cond\":"

POIS "\"pois\":"


AMOUNT "\"amount\":"
RESOURCE "\"resource\":"



INLINE  {COST}|{ACTION}|{HEADING}|{MEN}|{BUDGET}
EXTPARA {EXTRAS}|{PARAMETERS}

LINEPARA {DIRECTION}|{RESOURCE}|{CREEK}|{PEOPLE}|{RANGE}|{QUARTZ}|{WOOD}|{ORE}|{FUR}|{SUGAR_CANE}|{FRUITS}
LINEEXT {RANGE}|{FOUND}|{ALTITUDE}|{ASKED_RANGE}|{AMOUNT}|{PRODUCTION}|{KIND}

OBJEXT {REPORT}|{RESOURCES}

LINEEXTPARA {LINEPARA}|{LINEEXT}

SIMPLEEXTARR  {CREEKS}|{BIOMES}|{POIS}

DATARESOURCES {COND}|{RESOURCE}|{AMOUNT}

%s ARGUSTR
%s ARGUINT

%s VALINT
%s VALSTR
%s INLINE


%s CONTRACTS
%s EXTPARA
%s TRASH

%s SIMPLEEXTARR
%s RESOURCES
%s REPORT

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



{INLINE} {generate_balise_name(yytext, 1 , 3, 1); BEGIN INLINE;}

<INLINE>{NUM} {text = line(text,balise, yytext, 0, 0, 2); BEGIN 0;}
<INLINE>{STR} {text = line(text,balise, yytext, 1, 2, 2); BEGIN 0;}


{CONTRACTS} {generate_balise_name(yytext, 1, 3, 1); text = write_open_balise(text, balise, 1, 2); BEGIN CONTRACTS;}

<CONTRACTS>{RESOURCE} {;}
<CONTRACTS>{AMOUNT} {;}
<CONTRACTS>{NUM} {amount = yytext; amount_size = yyleng;}
<CONTRACTS>{STR} {contract(text, amount, amount_size);}
<CONTRACTS>"]," {text = write_close_balise(text, balise, 1, 2); BEGIN 0;}

{EXTPARA} {generate_balise_name(yytext, 1, 3, 1); text = write_open_balise(text, balise, 1, 2); BEGIN EXTPARA;}

<EXTPARA>{LINEEXTPARA} {generate_balise_name(yytext, 1, 3, 2);}
<EXTPARA>{STR} {text = line(text,inside_balise, yytext, 1, 2, 3);}
<EXTPARA>{NUM} {text = line(text,inside_balise, yytext, 0, 0, 3);}


<EXTPARA>^"  }," { text = write_close_balise(text, balise, 1, 2); BEGIN 0;}
<EXTPARA>{STATUS} { text = write_close_balise(text, balise, 1, 2); generate_balise_name(yytext, 1 , 3, 1); BEGIN INLINE;}


<EXTPARA>{SIMPLEEXTARR} {generate_balise_name(yytext, 1, 3, 2); text = write_open_balise(text, inside_balise, 1, 3); BEGIN SIMPLEEXTARR;}
<SIMPLEEXTARR>{STR} {inner = (char*) calloc(50,sizeof(char)); inner = strncat(inner, inside_balise, strlen(inside_balise)-1); text = line(text, inner, yytext, 1, 2, 4);}
<SIMPLEEXTARR>"]" {text = write_close_balise(text, inside_balise, 1, 3); BEGIN EXTPARA;}


<EXTPARA>{RESOURCES} {generate_balise_name(yytext, 1, 3, 2); text = write_open_balise(text, inside_balise, 1, 3); BEGIN RESOURCES;}
<RESOURCES>"{" {inner = (char*) calloc(50,sizeof(char)); inner = strncat(inner, inside_balise, strlen(inside_balise)-1); text = write_open_balise(text, inner, 1, 4);}
<RESOURCES>{DATARESOURCES}  {inner = (char*) calloc(50,sizeof(char)); inner = strncat(inner, yytext+1, yyleng-3);}
<RESOURCES>{STR} {text = line(text, inner, yytext, 1, 2, 5);}
<RESOURCES>"}" {inner = (char*) calloc(50,sizeof(char)); inner = strncat(inner, inside_balise, strlen(inside_balise)-1); text = strcat(text, "\n\t\t\t\t</"); text = strcat(text, inner); text = strcat(text, ">");}
<RESOURCES>"]" {text = write_close_balise(text, inside_balise, 1, 3); BEGIN EXTPARA;}


<EXTPARA>{REPORT} {text = strcat(text, "\n\t\t\t<"); range_report = 1; report = calloc(2, sizeof(char)); sprintf(report, "%i", range_report); inner = (char*) calloc(10, sizeof(char)); inner = strncat(inner, yytext+1, yyleng - 3); text =strcat(text, inner); text = strcat(text, "s>\n\t\t\t\t<");  text =strcat(text, inner); text = strcat(text, " RANGE=\""); text = strcat(text, report); text = strcat(text, "\">"); BEGIN REPORT;}

<REPORT>{STR} {report_biome = (char*) calloc(50,sizeof(char)); report_biome = strncat(report_biome, yytext+1, yyleng -2); if(3 < range_report){text = write_open_balise(text, report_biome, 1, 5); text = write_close_balise(text, report_biome, 1, 5);}}

<REPORT>{NUM} {text = line(text, report_biome, yytext, 0, 0, 5);}
<REPORT>^"        ["  {if(1 != range_report){text = write_close_balise(text, inner, 1, 4); text = strcat(text, "\n\t\t\t\t<");  text =strcat(text, inner); text = strcat(text, " RANGE=\""); text = strcat(text, report); text = strcat(text, "\">");} range_report++; sprintf(report, "%i", range_report);}

<REPORT>^"      ]" {text = write_close_balise(text, inner, 1, 4); text = strcat(text, "\n\t\t\t</"); text =strcat(text, inner); text = strcat(text, ">"); BEGIN EXTPARA;}


{UTF}   ;

%%

int main(void) {
  printf("<?xml version=\"1.0\"?>\n<LISTE>");
  yylex();
  printf("\n</LISTE>\n");
  return 0;
}