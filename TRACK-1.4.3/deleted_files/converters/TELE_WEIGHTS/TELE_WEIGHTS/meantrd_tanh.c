#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "splice.h"
#include "file_handle.h"


#define SCALE   -1.5


/* function to write to file the track data obtained by combining
   different sets of track data                                        */

extern int aniso;
extern float t_scale;

void meantrd(FILE *tsf, struct tot_tr *all_tr, int tr_count, int fld, int *istr, int *iend, float *ival, int num)

{

    int i, j, k;
    int trc=0;

    long int pl=0;

    float wt;

    struct tot_tr *altr;
    struct fet_pt_tr *atr;



    for(i=0; i < tr_count; i++){

        altr = all_tr + i;

        if(altr->num > 0){

           ++trc;

           fprintf(tsf, "TRACK_ID  %d\n", i+1);
           fprintf(tsf, "POINT_NUM  %d\n", altr->num);

           if(fld == 's'){

              if(aniso == 'y'){

                 for(j=0; j < altr->num; j++){

                     atr = (altr->trpt) + j;

                     for(k=0; k<num; k++){

                         if((iend[k] - atr->fr_id) * (atr->fr_id - istr[k]) >= 0) {
                            if(ival[k] * t_scale <=0.0) wt = 0.0;
                            else
                              wt = tanh(ival[k]*t_scale);
                         }

                     }


                     fprintf(tsf, "%d %f %f %e %f %f %f %f ", atr->fr_id, atr->xf, atr->yf, atr->zf, atr->sh_an, atr->or_vec[0], atr->or_vec[1], wt);

                     if(atr->nfm)
                        fprintf(tsf, "%d\n", atr->nfm);
                     else
                        fprintf(tsf, "\n");

                 }

              }

              else {

                 for(j=0; j < altr->num; j++){

                     atr = (altr->trpt) + j;

                     for(k=0; k<num; k++){

                         if((iend[k] - atr->fr_id) * (atr->fr_id - istr[k]) >= 0) {
                            if(ival[k] * t_scale <=0.0) wt = 0.0;
                            else
                              wt = tanh(ival[k]*t_scale);

                         }


                     }


                     if(atr->nfm)
                        fprintf(tsf, "%d %f %f %e %f %d\n", atr->fr_id, atr->xf, atr->yf, atr->zf, wt, atr->nfm);
                     else
                        fprintf(tsf, "%d %f %f %e %f\n", atr->fr_id, atr->xf, atr->yf, atr->zf, wt);

                 }
  
              }

           }

           else if(fld == 'v'){

              for(j=0; j < altr->num; j++){

                  atr = (altr->trpt) + j;

                  fprintf(tsf, "%d %f %f %e %e", atr->fr_id, atr->xf, atr->yf, atr->zf, atr->gwthr);
                  fprintf(tsf, " %e %e\n", atr->vec[0], atr->vec[1]);

              }

           }

        }

    } 


    return;

}
