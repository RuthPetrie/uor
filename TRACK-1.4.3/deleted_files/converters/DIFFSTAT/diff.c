#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "statistic.h"
#include "mem_er.h"

#define  MAXCHR   200
#define  TOLFLD   1.0e-6


struct tot_stat *read_stats(FILE * );
void statdmp(FILE * , struct tot_stat * );

int prgr, prty;


void main()

{

     int i,n=1, n1, j;
     int pg, pt;
     int istat=1;

     float scale=1.0;

     struct tot_stat *comp=NULL, *std=NULL, *stat=NULL;

      
     FILE *cpin=NULL, *stdo=NULL, *statin=NULL;

     char cpfn[MAXCHR], stdfn[MAXCHR], statfn[MAXCHR];

     double diff;

     printf("Do you want straight differences             '1' \r\n"
            "Relative difference from first stats read,   '2' \r\n"
            "Percentage difference from first stats read, '3' \r\n"
            "2nd File - 1st File                              \n\n");
     scanf("%d", &istat);

     if(istat < 1 || istat > 3) {

        printf("***ERROR***, don't know stat comparison type %d\n", istat);
        exit(1);

     }


     printf("What is the composite file to read?\n");
     scanf("%s", cpfn);

     cpin = fopen(cpfn, "r");
     if(cpin == NULL){
        printf("****ERROR****, cant open file \r\n"
               "               %s\r\n"
               "               for read\n\n", cpfn);
        exit(1);
     }

     comp = read_stats(cpin);

     pg = prgr;
     pt = prty;

     fclose(cpin);

     std = (struct tot_stat * )malloc_init(sizeof(struct tot_stat));
     mem_er((std == NULL) ? 0 : 1, sizeof(struct tot_stat));

     std->ptnum = comp->ptnum;

     std->xa1 = comp->xa1;
     std->xa2 = comp->xa2;
     std->ya1 = comp->ya1;
     std->ya2 = comp->ya2;

     for(i=0; i < STNM; i++){

         std->kern[i] = comp->kern[i];
         std->sm[i] = comp->sm[i];
         std->scden = comp->scden;
         std->add_den_sc = comp->add_den_sc;

     }

     std->ptst = (struct pt_stat * )calloc(std->ptnum, sizeof(struct pt_stat));
     mem_er((std->ptst == NULL) ? 0 : 1, std->ptnum * sizeof(struct pt_stat));


     for(i=0; i < n; i++){

         printf("Input next statistic filename.\n");
         scanf("%s", statfn);

         statin = fopen(statfn, "r");

         if(statin == NULL){
            printf("****ERROR****, cant open file \r\n"
                   "               %s\r\n"
                   "               for read\n\n", statfn);
            exit(1);
         }

         
         stat = read_stats(statin);

         if(pg != prgr || pt != prty || stat->ptnum != comp->ptnum ||
            stat->scden != comp->scden || stat->add_den_sc != comp->add_den_sc){

            printf("****ERROR****, stats files are incompatable.\n");
            exit(1);


         }

         fclose(statin);
         statin = NULL;

         for(j=0; j<STNM; j++) std->datnm[j] = stat->datnm[j] - comp->datnm[j];

         if(istat == 1){

            for(j=0; j < stat->ptnum; j++){ 

               (std->ptst + j)->xs = (comp->ptst + j)->xs;
               (std->ptst + j)->ys = (comp->ptst + j)->ys;

               ((std->ptst + j)->stat1).mean = ((stat->ptst + j)->stat1).mean - ((comp->ptst + j)->stat1).mean;
               ((std->ptst + j)->stat1).var = ((stat->ptst + j)->stat1).var - ((comp->ptst + j)->stat1).var;
               ((std->ptst + j)->stat2).mean = ((stat->ptst + j)->stat2).mean - ((comp->ptst + j)->stat2).mean;
               ((std->ptst + j)->stat2).var = ((stat->ptst + j)->stat2).var - ((comp->ptst + j)->stat2).var;
               (std->ptst + j)->stat3 = (stat->ptst +j)->stat3 - (comp->ptst + j)->stat3;
               (std->ptst + j)->stat4 = (stat->ptst +j)->stat4 - (comp->ptst + j)->stat4;
               (std->ptst + j)->stat5 = (stat->ptst +j)->stat5 - (comp->ptst + j)->stat5;
               (std->ptst + j)->stat6 = (stat->ptst +j)->stat6 - (comp->ptst + j)->stat6;
               ((std->ptst + j)->stat7).xcomp = ((stat->ptst +j)->stat7).xcomp - ((comp->ptst + j)->stat7).xcomp;
               ((std->ptst + j)->stat7).ycomp = ((stat->ptst +j)->stat7).ycomp - ((comp->ptst + j)->stat7).ycomp;
               (std->ptst + j)->stat8 = (stat->ptst +j)->stat8 - (comp->ptst + j)->stat8;
               (std->ptst + j)->stat9 = (stat->ptst +j)->stat9 - (comp->ptst + j)->stat9;
               (std->ptst + j)->stat10 = (stat->ptst +j)->stat10 - (comp->ptst + j)->stat10;
               ((std->ptst + j)->stat11).xcomp = ((stat->ptst +j)->stat11).xcomp - ((comp->ptst + j)->stat11).xcomp;
               ((std->ptst + j)->stat11).ycomp = ((stat->ptst +j)->stat11).ycomp - ((comp->ptst + j)->stat11).ycomp;
               (std->ptst + j)->stat12 = (stat->ptst +j)->stat12 - (comp->ptst + j)->stat12;
               (std->ptst + j)->stat13 = (stat->ptst +j)->stat13 - (comp->ptst + j)->stat13;

            }



         }

         else if(istat == 2 || istat == 3){

            if(istat == 3) scale = 100.0;

            for(j=0; j < stat->ptnum; j++){ 

               (std->ptst + j)->xs = (comp->ptst + j)->xs;
               (std->ptst + j)->ys = (comp->ptst + j)->ys;

               if(fabs(((comp->ptst + j)->stat1).mean) > TOLFLD)
                 ((std->ptst + j)->stat1).mean = scale * (((stat->ptst + j)->stat1).mean - ((comp->ptst + j)->stat1).mean) / ((comp->ptst + j)->stat1).mean;
               else ((std->ptst + j)->stat1).mean = 0.0;
               if(fabs(((comp->ptst + j)->stat1).var) > TOLFLD) 
                 ((std->ptst + j)->stat1).var = scale * (((stat->ptst + j)->stat1).var - ((comp->ptst + j)->stat1).var) / ((comp->ptst + j)->stat1).var;
               else ((std->ptst + j)->stat1).var = 0.0;
               if(fabs(((comp->ptst + j)->stat2).mean) > TOLFLD)
                 ((std->ptst + j)->stat2).mean = scale * (((stat->ptst + j)->stat2).mean - ((comp->ptst + j)->stat2).mean) / ((comp->ptst + j)->stat2).mean;
               else
                 ((std->ptst + j)->stat2).mean = 0.0;
               if(fabs(((comp->ptst + j)->stat2).var) > TOLFLD) 
                 ((std->ptst + j)->stat2).var = scale * (((stat->ptst + j)->stat2).var - ((comp->ptst + j)->stat2).var) / ((comp->ptst + j)->stat2).var;
               else ((std->ptst + j)->stat2).var = 0.0;
               if(fabs((comp->ptst + j)->stat3) > TOLFLD)
                 (std->ptst + j)->stat3 = scale * ((stat->ptst +j)->stat3 - (comp->ptst + j)->stat3) / (comp->ptst + j)->stat3;
               else (std->ptst + j)->stat3 = 0.0;
               if(fabs((comp->ptst + j)->stat4) > TOLFLD)
                 (std->ptst + j)->stat4 = scale * ((stat->ptst +j)->stat4 - (comp->ptst + j)->stat4) / (comp->ptst + j)->stat4;
               else (std->ptst + j)->stat4 = 0.0;
               if(fabs((comp->ptst + j)->stat5) > TOLFLD)
                 (std->ptst + j)->stat5 = scale * ((stat->ptst +j)->stat5 - (comp->ptst + j)->stat5) / (comp->ptst + j)->stat5;
               else (std->ptst + j)->stat5 = 0.0;
               if(fabs((comp->ptst + j)->stat6) > TOLFLD)
                 (std->ptst + j)->stat6 = scale * ((stat->ptst +j)->stat6 - (comp->ptst + j)->stat6) / (comp->ptst + j)->stat6;
               else (std->ptst + j)->stat6 = 0.0;
               if(fabs(((comp->ptst + j)->stat7).xcomp) > TOLFLD)
                 ((std->ptst + j)->stat7).xcomp = scale * (((stat->ptst +j)->stat7).xcomp - ((comp->ptst + j)->stat7).xcomp) / ((comp->ptst + j)->stat7).xcomp;
               else ((std->ptst + j)->stat7).xcomp = 0.0;
               if(fabs(((comp->ptst + j)->stat7).ycomp) > TOLFLD) 
                 ((std->ptst + j)->stat7).ycomp = scale * (((stat->ptst +j)->stat7).ycomp - ((comp->ptst + j)->stat7).ycomp) / ((comp->ptst + j)->stat7).ycomp;
               else ((std->ptst + j)->stat7).ycomp = 0.0;
               if(fabs((comp->ptst + j)->stat8) > TOLFLD)
                 (std->ptst + j)->stat8 = scale * ((stat->ptst +j)->stat8 - (comp->ptst + j)->stat8) / (comp->ptst + j)->stat8;
               else (std->ptst + j)->stat8 = 0.0;
               if(fabs((comp->ptst + j)->stat9) > TOLFLD)
                 (std->ptst + j)->stat9 = scale * ((stat->ptst +j)->stat9 - (comp->ptst + j)->stat9) / (comp->ptst + j)->stat9;
               else (std->ptst + j)->stat9 = 0.0;
               if(fabs((comp->ptst + j)->stat10) > TOLFLD)
                 (std->ptst + j)->stat10 = scale * ((stat->ptst +j)->stat10 - (comp->ptst + j)->stat10) / (comp->ptst + j)->stat10;
               else (std->ptst + j)->stat10 = 0.0;
               if(fabs(((comp->ptst + j)->stat11).xcomp) > TOLFLD)
                 ((std->ptst + j)->stat11).xcomp = scale * (((stat->ptst +j)->stat11).xcomp - ((comp->ptst + j)->stat11).xcomp) / ((comp->ptst + j)->stat11).xcomp;
               else ((std->ptst + j)->stat11).xcomp = 0.0;
               if(fabs(((comp->ptst + j)->stat11).ycomp) > TOLFLD)
                 ((std->ptst + j)->stat11).ycomp = scale * (((stat->ptst +j)->stat11).ycomp - ((comp->ptst + j)->stat11).ycomp) / ((comp->ptst + j)->stat11).ycomp;
               else ((std->ptst + j)->stat11).ycomp = 0.0;
               if(fabs((comp->ptst + j)->stat12) > TOLFLD)
                 (std->ptst + j)->stat12 = scale * ((stat->ptst +j)->stat12 - (comp->ptst + j)->stat12) / (comp->ptst + j)->stat12;
               else (std->ptst + j)->stat12 = 0.0;

            }

         }

         free(stat->ptst); 
         free(stat);

     }


     printf("Input output filename.\n");
     scanf("%s", stdfn);

     stdo = fopen(stdfn, "w");

     if(stdo == NULL){
        printf("****ERROR****, cant open file \r\n"
               "               %s\r\n"
               "               for write\n\n", stdfn);
        exit(1);
     }

     statdmp(stdo, std);

     fclose(stdo);

     return;

}
