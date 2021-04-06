#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct comentario { 
  
    char* id;
    char* date; 
    char* user;
    char* commentText;
    char* timestamp;
    int likes;
    int numberOfReplies;
    struct comentario *replies;
    struct comentario *next;
    
}*Comentario;

Comentario criaComentario ();
void printaJson (Comentario l , FILE *yyout, int profundidade);
int isempty(int  * posCabecaStack);
int isfull(int * posCabecaStack, int MAXSIZE);
Comentario peek(int * posCabecaStack , Comentario * stack);
Comentario pop(int * posCabecaStack , Comentario * stack);
void push(Comentario data , int * posCabecaStack , int  MAXSIZE , Comentario * stack);
Comentario paraFim (Comentario c);
