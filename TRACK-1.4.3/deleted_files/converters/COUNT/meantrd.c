#include <stdio.h>
#include <stdlib.h>
#include "splice.h"

#define  FSTART  0

/* function to write to file the track data obtained by combining
   different sets of track data                                        */


extern float sum_wt, sum_per;

extern int aniso;
extern int iper_num;

void meantrd(FILE *tsf, struct tot_tr *all_tr, int tr_count, int fld, int gpr, int ipr, float alat, float alng)

{

    int i, j;
    int trc=0;
    int awt=0;

    long int pl=0;

    struct tot_tr *altr;
    struct fet_pt_tr *atr;

    if(aniso == 'y') fprintf(tsf, "%d\n", 1);
    else fprintf(tsf, "%d\n", 0);

    if(iper_num){
       fprintf(tsf, "PER_INFO %1d %12.5f\n", 1, sum_per);
    }

    else {

       for(i=0; i < tr_count; i++) {

           if((all_tr + i)->awt) {
             awt = (all_tr + i)->awt;
             fprintf(tsf, "WT_INFO %1d %12.5f\n", awt, sum_wt);
             break;

           }
       }
    }


    fprintf(tsf, "%d %d\n", gpr, ipr);


    pl = ftell(tsf);

    fprintf(tsf, "TRACK_NUM  %8d\n", tr_count);

    for(i=0; i < tr_count; i++){

        altr = all_tr + i;

        awt = altr->awt;

        if(altr->num > 0){

           ++trc;

           if(altr->time) fprintf(tsf, "TRACK_ID  %d START_TIME %ld\n", i+1, altr->time);
           else fprintf(tsf, "TRACK_ID  %d\n", i+1);

           fprintf(tsf, "POINT_NUM  %d\n", altr->num);

           if(fld == 's'){

              if(aniso == 'y' && awt){

                 for(j=0; j < altr->num; j++){

                     atr = (altr->trpt) + j;

                     if(atr->time)
                        fprintf(tsf, "%10d %f %f %e %f %f %f %f ", atr->time, atr->xf, atr->yf, atr->zf, atr->sh_an, atr->or_vec[0], atr->or_vec[1], atr->wght);
                     else
                        fprintf(tsf, "%d %f %f %e %f %f %f %f ", atr->fr_id, atr->xf, atr->yf, atr->zf, atr->sh_an, atr->or_vec[0], atr->or_vec[1], atr->wght);

                     if(atr->nfm)
                        fprintf(tsf, "%d\n", atr->nfm);
                     else
                        fprintf(tsf, "\n");

                 }

              }

              else if(aniso == 'y' && !awt){

                 for(j=0; j < altr->num; j++){

                     atr = (altr->trpt) + j;

                     if(atr->time)
                        fprintf(tsf, "%10d %f %f %e %f %f %f ", atr->time, atr->xf, atr->yf, atr->zf, atr->sh_an, atr->or_vec[0], atr->or_vec[1]);
                     else
                        fprintf(tsf, "%d %f %f %e %f %f %f ", atr->fr_id, atr->xf, atr->yf, atr->zf, atr->sh_an, atr->or_vec[0], atr->or_vec[1]);

                     if(atr->nfm)
                        fprintf(tsf, "%d\n", atr->nfm);
                     else
                        fprintf(tsf, "\n");

                 }

              }

              else if(aniso == 'n' && awt){

                 for(j=0; j < altr->num; j++){

                     atr = (altr->trpt) + j;

                     if(atr->time)
                        fprintf(tsf, "%10d %f %f %e %f ", atr->time, atr->xf, atr->yf, atr->zf, atr->wght);
                     else
                        fprintf(tsf, "%d %f %f %e %f ", atr->fr_id, atr->xf, atr->yf, atr->zf, atr->wght);

                     if(atr->nfm)
                        fprintf(tsf, "%d\n", atr->nfm);
                     else
                        fprintf(tsf, "\n");

                 }

              }

              else {

                 for(j=0; j < altr->num; j++){

                     atr = (altr->trpt) + j;

                     if(atr->time)
                        fprintf(tsf, "%10d %f %f %e ", atr->time, atr->xf, atr->yf, atr->zf);
                     else
                        fprintf(tsf, "%d %f %f %e ", atr->fr_id, atr->xf, atr->yf, atr->zf);

                     if(atr->nfm)
                        fprintf(tsf, "%d\n", atr->nfm);
                     else
                        fprintf(tsf, "\n");

                 }
  
              }

           }

           else if(fld == 'v'){

              if(!awt){

                 for(j=0; j < altr->num; j++){

                     atr = (altr->trpt) + j;

                     fprintf(tsf, "%d %f %f %e %e %e", atr->fr_id, atr->xf, atr->yf, atr->zf, atr->gwthr, atr->tend);
                     fprintf(tsf, " %e %e\n", atr->vec[0], atr->vec[1]);

                 }

              }

              else {

                 for(j=0; j < altr->num; j++){

                     atr = (altr->trpt) + j;

                     fprintf(tsf, "%d %f %f %e %e %e", atr->fr_id, atr->xf, atr->yf, atr->zf, atr->gwthr, atr->tend);
                     fprintf(tsf, " %e %e %f\n", atr->vec[0], atr->vec[1], atr->wght);

                 }

              }


           }

        }

    } 

    if(trc != tr_count){

       fseek(tsf, pl, FSTART);
       fprintf(tsf, "TRACK_NUM  %8d", trc);

    }


    return;

}
