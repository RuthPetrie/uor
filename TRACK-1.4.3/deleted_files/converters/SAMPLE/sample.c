#include <stdio.h>
#include "splice.h"
#include "mem_er.h"

#define MAXCHR  150
#define TOLWT   1.0e-6

void meantrd(FILE * , struct tot_tr * , int , int , int , int , float , float );
struct tot_tr *read_tracks(FILE * , int * , int * , int * , int , float * , float * );
float ran3(int * );

void main(void)

{
   int i, j;
   int nr=0, ns=0;
   int idum;
   int trnum, ntr=0;
   int gpr, ipr;
   int nsamp=0;
   int *isamp=NULL;
   int nu=0, umo=0, umo5=0;
   int awt = 0;
   int iw=0, iin=0;

   float alat, alng;
   float ran;

   FILE *fin=NULL;
   FILE *fout=NULL;

   char trname[MAXCHR];
   char filout[MAXCHR];
   char odir[MAXCHR];
   char fnum[10];
   
   struct tot_tr *all_tr=NULL, *atr1=NULL, *atr2=NULL, *allout=NULL;
   struct fet_pt_tr *fpt1=NULL, *fpt2=NULL;


   printf("What is the raw track file to be used?\n\n");
   scanf("%s", trname);

   strcpy(filout, strstr(trname, "tr_trs"));

   fin = fopen(trname, "r");
   if(!fin){
      printf("File %s cannot be opened for read\n\n", trname);
      exit(1);
   }


   all_tr = read_tracks(fin, &trnum, &gpr, &ipr, 's', &alat, &alng);

   fclose(fin);

   printf("What is the ouput directory for samples?\n\n");
   scanf("%s", odir);
   

   awt = all_tr->awt;

   if(awt){
      printf("Track ensemble has weights, do you want to sample from  \r\n"
             "whole ensemble or only use tracks with non-zero weights.\r\n"
             "Input '0' for all and '1' for selective.                \n\n");
      scanf("%d", &iw);

   }

   if(iw){
      ntr = 0;

      for(i=0; i < trnum; i++){
          atr1 = all_tr + i;
          iin = 0;
          for(j=0; j < atr1->num; j++){
              fpt1 = atr1->trpt + j;
              if(fpt1->wght > TOLWT) {++ntr; iin = 1; break;}
          }
          if(!iin) atr1->awt = 0;
      }


      trnum = ntr;

   }


   printf("Input a seed value, must be negative\n\n");
   scanf("%d", &idum);

   printf("How many samples do you want?\n\n");
   scanf("%d", &nsamp);

   if(nsamp <= 0){
      printf("***ERROR***, number of samples must be positive and non-zero\n\n");
     exit(1);

   }

   allout = (struct tot_tr * )calloc(trnum, sizeof(struct tot_tr));
   mem_er((all_tr == NULL) ? 0 : 1);

   isamp = (int *)calloc(trnum, sizeof(int));
   mem_er((isamp == NULL) ? 0 : 1);

   while(ns < nsamp){

      strcpy(filout, odir);
      strcat(filout, strstr(trname, "tr_trs"));
      sprintf(fnum, ".%04d", ns);
      strcat(filout, fnum);


      fout = fopen(filout, "w");
      if(!filout){
         printf("Can't open file %s for write\n\n", filout);
         exit(1);
      }

      nr = 0;
      nu = umo = umo5 = 0;
      while(nr < trnum){

         ran = ran3(&idum) * (float) (trnum - 1) + 0.5;

         atr1 = all_tr + (int)ran;
         if(iw && !(atr1->awt))continue;


         ++(*(isamp + (int)ran));

         atr2 = allout +nr;

         atr2->num = atr1->num;
         atr2->awt = atr1->awt;


         atr2->trpt = (struct fet_pt_tr * )calloc(atr2->num, sizeof(struct fet_pt_tr));
         mem_er((atr2->trpt == NULL) ? 0 : 1);

         for(i=0; i < atr2->num; i++) {

             fpt1 = atr1->trpt + i;
             fpt2 = atr2->trpt + i;
             *fpt2 = *fpt1; 

         } 

         ++nr;

      }

      for(i=0; i < trnum; i++){
          if(*(isamp+i) == 0) ++nu;
          if(*(isamp+i) > 1) ++umo;
          if(*(isamp+i) > 5) ++umo5;
      }

      printf("Number of tracks not used = %d\n", nu);
      printf("Number of tracks used more than once = %d\n", umo);
      printf("Number of tracks used more than 5 times = %d\n", umo5);

      meantrd(fout, allout, trnum, 's', gpr, ipr, alat, alng);

      fclose(fout);
      fout = NULL;

      ++ns;

      for(i=0; i < trnum; i++){
          free((allout + i)->trpt);
          memset(allout, NULL, trnum*sizeof(struct tot_tr));
      }

      memset(isamp, NULL, trnum*sizeof(int));

   }

   for(i=0; i < trnum; i++)free((all_tr + i)->trpt);
   free(all_tr);
   free(isamp);

   return;

}
