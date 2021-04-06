%{ 
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include "funcoes.h"

int len = 0;
int indice = 0;
int iniciado = 0;

extern FILE *yyin, *yyout; 

Comentario lista = NULL;
Comentario ant = NULL;
Comentario atual = NULL;
Comentario ultimo = NULL;

int MAXSIZE = 20;       
Comentario stack [20];
int posCabecaStack = -1;      
char buff[1000];   
int tags = 0;

%}

digito 		[0-9]
espaco		[\ \t\r\n]
alpha                [a-zA-Z]  
acentos            \xc3[\x80-\xbf]    
letra                 {alpha}|{acentos}

username  ({letra}|{digito}|{espaco})+
timestamp ({alpha}|{digito}|{espaco})+
data             title\=\".*(AM|PM)\"
user             class\=\"post-body\".*data-username.*\"\>
inicioComentario class\=\"post\"{espaco}id\=\"post\-{digito}+\"
fimComentario    class\=\"show-children\-wrapper[' ']hidden\"
likes            data\-role\=\"likes\"\>{digito}+
inicioTexto      class\=\"post-message\".*\<div\>
inicioParagrafo  \<p\>
fimParagrafo     \<\/p\>

%option stack
%x comentario user_SC texto tempo 

%% 


{inicioComentario} {											
											yy_push_state(comentario);
											atual = criaComentario ();
											if (ultimo != NULL){
												ultimo -> next = atual;
											}
											
                                            push(atual,&posCabecaStack , MAXSIZE , stack);
											if(iniciado == 0){
												iniciado = 1;
												lista = atual;
											}											
											atual->id =  strdup(yytext+16); 

											
}

<comentario>{fimComentario}   {

														
											ultimo = pop(&posCabecaStack , stack);
											if (isempty(&posCabecaStack)){
												yy_pop_state();
											}
}


<comentario>{inicioComentario} {
											
											

																			                                      
											atual = criaComentario (); 
                                            
                                            
											ant = peek(&posCabecaStack , stack);
											if (ant->replies == NULL){
												ant-> replies = atual;
												ant->numberOfReplies++;

											}
											else {
												ant->numberOfReplies++;
												ant = paraFim(ant->replies);  
												ant -> next = atual;

											}


											atual->id =  strdup(yytext+16); 
											push(atual,&posCabecaStack , MAXSIZE , stack);
	


}




<comentario>{data} {  	
											atual->date =  strdup(yytext+6); 
											yy_push_state(tempo);
}

<comentario>{user} {                        yy_push_state(user_SC); } 


<comentario>{likes} {                       atual -> likes =  atoi(yytext+18);}

<comentario>{inicioTexto} {                 yy_push_state(texto); 
                                            		   len = 0;
							   atual->commentText = malloc(1);} 


<tempo>{timestamp} {
											atual -> timestamp = strdup(yytext);
											yy_pop_state();	
	}



<user_SC>{username}  {
											atual -> user = strdup(yytext); 
											yy_pop_state();
	
	}


<texto>{    

{fimParagrafo}                                                                   {
											len+= 2; 
											atual->commentText= realloc(atual-> commentText, len * sizeof(char) + 1); 
											strcat(atual->commentText,"\\n");
											}

											
{inicioParagrafo}                                                                      { ; }
\<i\>|\<\/i\>                                                                          { ; }
\<b\>|\<\/b\>                                                                          { ; }
\<br\>|\<\/br\>                                                                        { ; }
\<u\>|\<\/u\>                                                                          { ; } 
\<\/div\>                                                         				{ yy_pop_state(); }

													
[\"]                                    {len+=2; 
								      atual->commentText= realloc(atual-> commentText, len * sizeof(char) + 1); 
								      strcat(atual->commentText,"\\\"");} 								

.                                     {len+=1; 
								      atual->commentText= realloc(atual-> commentText, len * sizeof(char) + 1); 
								      strcat(atual->commentText,yytext);}

}



<*>.|\n                                            {;}

%% 
  
  
int yywrap() 
{ 
    return 1; 
} 
  

int main(int argc, char *argv[]) 
{ 

	if ((yyin = fopen(argv[1],"r") )== NULL ) {
	    printf("Não consegui ler '%s'\n", argv[1]);
	    return 0;
	}

	if ((yyout = fopen(strcat(argv[2],".json"),"w")) == NULL ) {
	    printf("Não consegui escrever '%s'\n", argv[2]);
	return 0;
	}

	yylex();
	fprintf(yyout,"{\n\t\"commentThread\": \n\t[\n");	
	printaJson(lista,yyout,1);
	fprintf(yyout,"\t]\n}");
}

	


