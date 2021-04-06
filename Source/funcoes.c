#include "funcoes.h"
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 


Comentario criaComentario (){
  
  Comentario h = NULL;
  h = malloc(sizeof(struct comentario));
  h->likes = 0;
  h->numberOfReplies = 0;
  h->replies = NULL;
  h->next = NULL;
  h->timestamp = "NA";
  h->date = "";
  h->user = "";
  h->id = "";
  h->commentText = "";
  
  return h;
}

char* repeteN (char arr[], int profundidade){
	


	for ( int i = 0; i < profundidade+1; i++){
		arr[i] = '\t';
	}

	arr[profundidade+1] = '\0';
	return arr;
}

void printaJson (Comentario l , FILE *yyout, int profundidade){

	Comentario aux = l;
	char arr[profundidade+2];
	repeteN(arr,profundidade);
	while(aux != NULL){
		
		fprintf(yyout,"%s{\n\t%s\"id\": %s,\n",arr,arr,aux->id);
		fprintf(yyout,"\t%s\"user\": \"%s\",\n",arr,aux->user);
		fprintf(yyout,"\t%s\"date\": %s,\n",arr,aux->date);
		fprintf(yyout,"\t%s\"timestamp\": \"%s\",\n",arr,aux->timestamp);
		fprintf(yyout,"\t%s\"commentText\": \"%s\",\n",arr,aux->commentText);
		fprintf(yyout,"\t%s\"likes\": %d,\n",arr,aux->likes);		
		fprintf(yyout,"\t%s\"hasReplies\": %s,\n",arr,(aux->numberOfReplies>0) ? "true" : "false");
		fprintf(yyout,"\t%s\"numberOfReplies\": %d,\n",arr,aux->numberOfReplies);	
		

		Comentario repliesStruct = aux->replies;
		fprintf(yyout,"%s\t\"replies\": [",arr);
		if (repliesStruct == NULL){
			fprintf(yyout,"]\n",arr);	
		} else {
			fprintf(yyout,"\n");	
			printaJson(repliesStruct,yyout, profundidade +1);	
			fprintf(yyout,"\t%s]\n",arr);	
		}

		if (aux -> next == NULL){
			fprintf(yyout,"%s}\n",arr);
		}
		else {
			fprintf(yyout,"%s},\n",arr);
		}
				
		aux = aux -> next;
	}
	}
	
int isempty(int  * posCabecaStack) {

   if((*posCabecaStack) == -1)
      return 1;
   else
      return 0;
}
   
int isfull(int * posCabecaStack , int MAXSIZE) {
   if((*posCabecaStack) == MAXSIZE)
      return 1;
   else
      return 0;
}

Comentario peek(int * posCabecaStack ,  Comentario stack[]) {
   return stack[(*posCabecaStack)];
}

Comentario pop(int * posCabecaStack , Comentario stack[]) {
   Comentario data;
	
   if(!isempty(posCabecaStack)) {
      data = stack[(*posCabecaStack)];
      (*posCabecaStack) = (*posCabecaStack) - 1;   
      return data;
   } 
}

void push (Comentario novo , int * posCabecaStack , int MAXSIZE , Comentario stack[]) {

   if(!isfull(posCabecaStack , MAXSIZE)) {
      (*posCabecaStack) = (*posCabecaStack) + 1;   
      stack[(*posCabecaStack)] = novo;
   }
}


Comentario paraFim (Comentario c){
    Comentario ant = c;
		while(c -> next != NULL){
			c = c -> next;
			ant = c;
			
		}
	

    return ant;
}

/*void dobraStack (Comentario stack[] , int * MAXSIZE){
	stack = realloc ( stack , sizeof(struct comentario) * 2 * (*MAXSIZE));
	(*MAXSIZE) = (*MAXSIZE) * 2;
}*/


