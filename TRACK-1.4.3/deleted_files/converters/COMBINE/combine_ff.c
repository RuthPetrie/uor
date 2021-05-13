#include <stdio.h>
#include <stdlib.h>
#include "splice.h"
#include "mem_er.h"
#include "file_handle.h"

/* combine sets of tr_trs files */

struct tot_tr *read_tracks(FILE * , int * , int * , int * , int , float * , float * );

void meantrd(FILE * , struct tot_tr * , int , int );

extern int aniso;


void main(void)

{


    int i, trc=0;
    int nf=0;
    int itsc=0, itim=1;

    long int pl, plw;

    int gpr, ipr;
    float alat, alng;
    float sum_per=0.0;

    int trnum=0;
    int tr_count;

    char filnamin[100];
    char filnamout[]="combined_tr_trs";

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

    printf("What time scaling is required?   \r\n"
           " '1'    for seasonal.            \r\n"
           " '2'    for monthly.             \r\n"
           " '3'    for daily.               \n\n");
    scanf("%d", &itsc);

    if(itsc == 2){
       printf("How many months per season?\n");
       scanf("%d", &itim);

    }
    else if(itsc == 3){
       printf("How many days per season?\n");
       scanf("%d", &itim);
    }

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

          plw = ftell(fout);

          fprintf(fout, "PER_INFO %1d %12.5f\n", 1, sum_per);

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

       sum_per += (float)itim;



    } 


    fseek(fout, pl, FSTART);
    fprintf(fout, "TRACK_NUM  %8d", trnum);
    fseek(fout, plw, FSTART);
    fprintf(fout, "PER_INFO %1d %12.5f\n", 1, sum_per);

    fclose(fout);



    return;

}
