%{
   #include<stdio.h>
   #include "cp.tab.h"
   #include<stdlib.h>
   #include<math.h>
   #include<string.h>
   extern int yylval; 
%}

keyWord					SWITCH|CASE|BREAK|DEFAULT

%%
  
"int"    { return Int;}
"float"  { return Float;}
"char"   { return Char;}

[0-9]+  {
        yylval =  atoi(yytext);
        return Num;
      }

"PF"     { return PF; }
"Sf"     { return Sf; } 
"Ef"     { return Ef; }
"Ss"     { return Ss; }
"Es"     { return Es; }
"COMA"    { return Com;}
"SEMI"   { return Semi; }
"(+)"    { return Jug; }
"(-)"    { return Biyog; }
"(*)"    { return Gun; }
"(/)"    {return Vaag; }
"(%)"    { return Vgses; }
"(=)"    { return Soman; }
"(:)"    { return Colon; }
"BORO"   { return Bigger; }
"CHOTO"  { return Smaller; }

[a-z]+  {
         yylval = *yytext - 'a';
         return Vr;   
    }

"JODI"        { return If;  }
"NAHOLE"      { return Else; }
"LOOP"        { return LOOP; }
SWITCH      { return SWITCH;}
CASE        { return CASE; }
DEFAULT     { return DEFAULT; }
BREAK       { return BREAK; }  


"MAIN"  { return VoidMain; }

[ \t\n]*     ; 

.   {
      yyerror("Unknown Character.\n");
    }
 

%%