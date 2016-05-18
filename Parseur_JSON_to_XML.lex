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


unsigned char *realloc_properly (unsigned char *ptr){
  unsigned char *ptr_tmp = realloc (ptr, 1000 * sizeof(char));
  if (ptr_tmp != NULL)
    return ptr_tmp;
  return ptr;
}





char *line(char *text, const char *balise, const char *value, int begin, int end){
  char *tmp_text;
  tmp_text = text;
  tmp_text = strcat(tmp_text, "\n\t\t<");
  tmp_text = strcat(tmp_text,balise);
  tmp_text = strcat(tmp_text,">");
  tmp_text = strncat(tmp_text, yytext+begin, strlen(yytext)-end);
  tmp_text = strcat(tmp_text,"</");
  tmp_text = strcat(tmp_text,balise);
  tmp_text = strcat(tmp_text,">");
  return tmp_text;
}


void generate_balise(char *name){
  balise  = (char*) calloc(50,sizeof(char));
  balise = strncpy(balise, name+1, strlen(name)-3);
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


COST  "\"cost\":"
EXTRAS  "\"extras\":"
STATUS  "\"status\":"


INLINE  {COST}|{STATUS}|{ACTION}|{HEADING}|{MEN}|{BUDGET}

%s ARGUSTR
%s ARGUINT

%s VALINT
%s VALSTR
%s INLINE

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



{INLINE} {generate_balise(yytext); BEGIN INLINE;}

<INLINE>{NUM} {text = line(text,balise, yytext, 0, 0); BEGIN 0;}
<INLINE>{STR} {text = line(text,balise, yytext, 1, 2); BEGIN 0;}





{NUM}   ;//{ECHO; printf("\t\t %d\n", p__attribute__size);}
{UTF}   ;

%%


int main(void) {
  printf("<?xml version=\"1.0\"?>\n<LISTE>");
  yylex();
  printf("\n</LISTE>\n");
  return 0;
}