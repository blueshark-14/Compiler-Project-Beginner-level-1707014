
%{
   #include<stdio.h>
   #include<stdlib.h>
   #include<math.h>	
   int yylex(void) ; 
   
   int sym[26], store[26];
 
%}


%token Num Vr If Else VoidMain Int Float Char Sf Ef Ss Es Com Semi Jug Biyog Gun Vaag Vgses Soman Bigger Smaller LOOP PF SWITCH CASE DEFAULT BREAK Colon
%nonassoc If
%nonassoc Else 
%nonassoc SWITCH
%nonassoc CASE
%nonassoc DEFAULT
%left Smaller Bigger
%left Jug Biyog
%left Gun Vaag Vgses 

%%
 
program: VoidMain Sf Ef Ss ccode Es { printf("\nSuccessful compilation.\n") ; }

ccode: 
     | ccode statement
     | ccode cdecl 
     ;

cdecl:  Type ID1 Semi { printf("\nvalid declaration.\n"); }

Type: Int
 
     | Float

     | Char 
     ;

ID1: ID1 Com Vr  {
                    if(store[$3] == 1)
                    {
                        printf("%c is already declared\n", $3 + 97);
                    }
                    else 
                    {
                       store[$3] = 1;
                    }  
 
             }
     
      | Vr  {
              if(store[$1] == 1)
                    {
                        printf("%c is already declared\n", $1 + 97);
                    }
                    else 
                    {
                       store[$1] = 1;
                    }              

            }   
      ;

statement: Semi
   
    | exp Semi         { printf("\nvalue of expression: %d\n", $1); $$ = $1  ; }
        
    | Vr Soman exp Semi  {
                       sym[$1] = $3 ;
                       printf("\nValue of the variable: %d\n", $3);
					   $$ = $3 ;
                  }
   
    | If Sf exp Ef Ss exp Semi Es {

                        if($3)
                        {
                            printf("\nvalue of expression in IF: %d\n", $6); 
                        }
                        else 
			{
                            printf("\nCondition is FALSE in IF block\n");
                        }
                    } 
    
    | If Sf exp Ef Ss exp Semi Es Else Ss exp Semi Es  {
         
           			if($3)
				{
				  printf("\nvalue of expression in IF: %d\n", $6); 
				}
				else 
				{
				 printf("\nvalue of expression in ELSE : %d\n", $11); 
				}	
                   } 

    | LOOP Sf Num Smaller Num Ef Ss statement Es   {
                                        
                                       int i;
 				       for(int i=$3 ; i<$5 ; i++){ printf("value of the for loop: %d expression value: %d\n", i, $8);}	    
                                   
                                }
   	     
    | PF Sf exp Ef Semi        { printf("\nPrint Expression: %d\n", $3 ) ; $$ = $3; }    

    | SWITCH Sf Vr Ef Ss B Es	
    ;


B : C
	| C D

C : C Jug C

	| CASE Num Colon exp Semi BREAK Semi {}  
        ;

D : DEFAULT Colon exp Semi BREAK Semi {}

exp : Num 
	
	| Vr              { $$  = sym[$1]; }

	| exp Jug exp    { $$ = $1 + $3;  printf("\nPlus er kaj : %d\n", $$); }

	| exp Biyog exp   { $$ = $1 - $3;  }

	| exp Gun exp     { $$ = $1 * $3;  } 

	| exp Vaag exp    { 

			    if($3)   { $$ = $1 / $3;}
				
			    else 
				{
				    $$ = 0 ;
				    printf("\nDivision by zero\n");
				}			

			  } 		

	| exp Vgses exp    { 

			    if($3)   { $$ = $1 % $3;}
				
			    else 
				{
				    $$ = 0 ;
				    printf("\nMod by zero\n");
				}			

			  } 		


	| exp Smaller exp   { $$ = $1 < $3 ; }

	| exp Bigger exp   { $$ = $1 > $3 ; }

	| Sf exp Ef      { $$ = $2 ; }
	
	;
 

%%


int yywrap()
{
  return 1;
}


int yyerror(char *s){
     fprintf(stderr, "%s\n", s);
}


int main()
{
  freopen("input.txt", "r", stdin);
  
  yyparse() ;

}
