#include <stdio.h>
#include <stdlib.h>
#include "splice.h"
#include "mem_er.h"
#include "file_handle.h"

/* combine sets of tr_trs files */

struct tot_tr *read_tracks(FILE * , int * , int * , int * , int , float * , float * );

void meantrd(FILE * , struct tot_tr * , int , int );

int aniso;

void main(void)

{


    int i, trc=0;
    int nf=0;

    long int pl;

    int gpr, ipr;
    float alat, alng;

    int trnum=0;
    int tr_count;

    char filnamin[100];
    char filnamout[]="weights_tr_trs";

    FILE *fin=NULL;
    FILE *fout=NULL;

    struct tot_tr *alltr=NULL;


    fout = fopen(filnamout, "w");
    if(!fout){
      printf("****ERROR****, can't open file %s\n", filnamout);
      exit(1);
    }


    printf("How many files do you want to combine?\n");
    scanf("%d", &nf);




    while(trc < nf){

       printf("What is the next tr_trs file?\n");
       scanf("%s", filnamin);
       printf("%s\n", filnamin);

       fin=fopen(filnamin, "r");
       if(!fin){
          printf("****ERROR****, can't open file %s\n", filnamin);
          exit(1);
       }

       alltr = read_tracks(fin, &tr_count, &gpr, &ipr, 's', &alat, &alng);


       if(!trc){

          if(aniso == 'y') fprintf(fout, "%d\n", 1);
          else fprintf(fout, "%d\n", 0);

          fprintf(fout, "%d %d\n", gpr, ipr);

          if(gpr) fprintf(fout, "%f %f\n", alat, alng);

          pl = ftell(fout);

          fprintf(fout, "TRACK_NUM  %8d\n", tr_count);



       }

       trnum += tr_count;

       meantrd(fout, alltr , tr_count, 's');

       for(i=0; i < tr_count; i++) free((alltr+i)->trpt);

       free(alltr);

       ++trc;

       fclose(fin);
       fin=NULL;




    } 


    fseek(fout, pl, FSTART);
    fprintf(fout, "TRACK_NUM  %8d", trnum);


    fclose(fout);



    return;

}
