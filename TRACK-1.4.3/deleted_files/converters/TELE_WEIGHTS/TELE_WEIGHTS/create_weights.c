#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "splice.h"
#include "mem_er.h"
#include "file_handle.h"

#define DNUM  3

/* combine sets of tr_trs files */

struct tot_tr *read_tracks(FILE * , int * , int * , int * , int , float * , float * );

void meantrd(FILE * , struct tot_tr * , int , int , int * , int * , float * , int );

int aniso;

float t_scale=0.0;
float tele_sum=0.0;

int main(int argc, char *argv[])

{


    int i, trc=0;
    int nf=0;

    int istr[DNUM], iend[DNUM];
    float ival[DNUM];

    long int pl, plw;

    int gpr, ipr;
    float alat, alng;

    int trnum=0;
    int tr_count;

    char filnamin[100];
    char filnamout[]="weights_trs";

    FILE *fin=NULL;
    FILE *fout=NULL;
    FILE *fdat=NULL;

    struct tot_tr *alltr=NULL;

    if(argc != 3){
       printf("USAGE: [dat file] [tanh scaling]\n");
       exit(1);

    }

    fdat = fopen(argv[1], "r");
    if(!fdat){
      printf("****ERROR****, can't open file %s\n", argv[1]);
      exit(1);
    }

    sscanf(argv[2], "%f", &t_scale);

    for(i=0; i < DNUM; i++)fscanf(fdat, "%d", istr+i);

    for(i=0; i < DNUM; i++)fscanf(fdat, "%d", iend+i);


    fclose(fdat);

    fout = fopen(filnamout, "w");
    if(!fout){
      printf("****ERROR****, can't open file %s\n", filnamout);
      exit(1);
    }



    printf("How many files do you want to combine?\n");
    scanf("%d", &nf);

    printf("%d\n", nf);


    while(trc < nf){

       printf("What is the next tr_trs file?\n");
       scanf("%s", filnamin);
       printf("%s\n", filnamin);

       fin=fopen(filnamin, "r");
       if(!fin){
          printf("****ERROR****, can't open file %s\n", filnamin);
          exit(1);
       }

       printf("What are the %d teleconnection indicies?\n", DNUM);
       for(i=0; i<DNUM; i++) {

           scanf("%f", ival+i);

           if(*(ival + i) * t_scale > 0.0) tele_sum += tanh(*(ival+i)*t_scale);

       }

       alltr = read_tracks(fin, &tr_count, &gpr, &ipr, 's', &alat, &alng);


       if(!trc){

          if(aniso == 'y') fprintf(fout, "%d\n", 1);
          else fprintf(fout, "%d\n", 0);

          plw = ftell(fout);

          fprintf(fout, "WT_INFO %1d %12.5f\n", 1, tele_sum);

          fprintf(fout, "%d %d\n", gpr, ipr);

          if(gpr) fprintf(fout, "%f %f\n", alat, alng);

          pl = ftell(fout);

          fprintf(fout, "TRACK_NUM  %8d\n", tr_count);



       }

       trnum += tr_count;

       meantrd(fout, alltr , tr_count, 's', istr, iend, ival, DNUM);

       for(i=0; i < tr_count; i++) free((alltr+i)->trpt);

       free(alltr);

       ++trc;

       fclose(fin);
       fin=NULL;




    } 


    fseek(fout, pl, FSTART);
    fprintf(fout, "TRACK_NUM  %8d", trnum);

    fseek(fout, plw, FSTART);
    fprintf(fout, "WT_INFO %1d %12.5f\n", 1, tele_sum);

    fclose(fout);



    return 0;

}
