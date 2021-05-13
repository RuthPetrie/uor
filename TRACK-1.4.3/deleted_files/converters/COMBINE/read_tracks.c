#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "splice.h"
#include "mem_er.h"

/* function to read in track data obtained by combining different sets
   of track data                                                        */

#define  FIELDWD  120

int wc(char * );

float sum_wt=0.0, sum_per=0.0;
int iper_num=0;

int aniso;

struct tot_tr *read_tracks(FILE *tsf, int *tr_count, int *gpr, int *ipr, int fld, float *alat, float *alng)

{

    int i, j, trid;
    int awt=0;

    char tex[10];
    char fldr[FIELDWD];

    struct tot_tr *all_tr=NULL, *altr=NULL;
    struct fet_pt_tr *atr=NULL;

    iper_num = 0;

    fgets(fldr, FIELDWD, tsf);

    if(wc(fldr) == 1){
       sscanf(fldr, "%d", &aniso);
       if(aniso == 1) aniso = 'y';
       else aniso = 'n';

       fgets(fldr, FIELDWD, tsf);

       if(strstr(fldr, "WT_INFO")) {
          sscanf(fldr, "%*s %d %f", &awt, &sum_wt);
          fscanf(tsf, "%d %d", gpr, ipr);

       }
       else if(strstr(fldr, "PER_INFO")) {
          sscanf(fldr, "%*s %d %f", &iper_num, &sum_per);
          fscanf(tsf, "%d %d", gpr, ipr);
       }
       else if(wc(fldr) == 1) {
          sscanf(fldr, "%d", &awt);
          fscanf(tsf, "%d %d", gpr, ipr);
       }
       else sscanf(fldr, "%d %d", gpr, ipr);

    }
 
    else {sscanf(fldr, "%d %d", gpr, ipr); aniso = 'n';}


    if(*gpr) fscanf(tsf, "%f %f", alat, alng);

    fscanf(tsf, "%s %d\n", tex, tr_count);

    all_tr = (struct tot_tr * )calloc(*tr_count, sizeof(struct tot_tr));
    mem_er((all_tr == NULL) ? 0 : 1, *tr_count * sizeof(struct tot_tr));


    for(i=0; i < *tr_count; i++){

        altr = all_tr + i;

        altr->awt = awt;

        fgets(fldr, FIELDWD, tsf);

        sscanf(fldr, "%*s %d %*s %ld", &altr->trid, &altr->time);

        fgets(fldr, FIELDWD, tsf);
        sscanf(fldr, "%*s %d\n", &altr->num);

        altr->trpt = (struct fet_pt_tr * )calloc(altr->num, sizeof(struct fet_pt_tr));
        mem_er((altr->trpt == NULL) ? 0 : 1, altr->num * sizeof(struct fet_pt_tr));

        if(fld == 's'){

           if(aniso == 'y' && awt){

              for(j=0; j < altr->num; j++){

                  atr = (altr->trpt) + j;

                  fgets(fldr, FIELDWD, tsf);
                  atr->nfm = 0;

                  if(altr->time)

                     sscanf(fldr, "%10ld %f %f %e %f %f %f %f %d", &atr->time, &atr->xf, &atr->yf, &atr->zf, &(atr->sh_an), &(atr->or_vec[0]), &(atr->or_vec[1]), &atr->wght, &atr->nfm);
                  else
                     sscanf(fldr, "%d %f %f %e %f %f %f %f %d", &atr->fr_id, &atr->xf, &atr->yf, &atr->zf, &(atr->sh_an), &(atr->or_vec[0]), &(atr->or_vec[1]), &atr->wght, &atr->nfm);

              }

           }

           else if(aniso == 'y' && !awt){

              for(j=0; j < altr->num; j++){

                  atr = (altr->trpt) + j;

                  fgets(fldr, FIELDWD, tsf);
                  atr->nfm = 0;

                  if(altr->time)
                     sscanf(fldr, "%10ld %f %f %e %f %f %f %d", &atr->time, &atr->xf, &atr->yf, &atr->zf, &(atr->sh_an), &(atr->or_vec[0]), &(atr->or_vec[1]), &atr->nfm);
                  else
                     sscanf(fldr, "%d %f %f %e %f %f %f %d", &atr->fr_id, &atr->xf, &atr->yf, &atr->zf, &(atr->sh_an), &(atr->or_vec[0]), &(atr->or_vec[1]), &atr->nfm);


              }

           }

           else if(aniso == 'n' && awt){

              for(j=0; j < altr->num; j++){

                  atr = (altr->trpt) + j;

                  fgets(fldr, FIELDWD, tsf);
                  atr->nfm = 0;

                  if(altr->time)
                     sscanf(fldr, "%10ld %f %f %e %f %d", &atr->time, &atr->xf, &atr->yf, &atr->zf, &atr->wght, &atr->nfm);
                  else
                     sscanf(fldr, "%d %f %f %e %f %d", &atr->fr_id, &atr->xf, &atr->yf, &atr->zf, &atr->wght, &atr->nfm);


              }


           }

           else {

              for(j=0; j < altr->num; j++){

                  atr = (altr->trpt) + j;

                  fgets(fldr, FIELDWD, tsf);
                  atr->nfm = 0;

                  if(altr->time)
                     sscanf(fldr, "%10ld %f %f %e %d", &atr->time, &atr->xf, &atr->yf, &atr->zf, &atr->nfm);
                  else
                     sscanf(fldr, "%d %f %f %e %d", &atr->fr_id, &atr->xf, &atr->yf, &atr->zf, &atr->nfm);


              }

           }

        }

        else if(fld == 'v'){

           printf("****WARNING****, older track, phase speed files may not be read correctely,\r\n"
                  "                 there should be 1 integer and 7 float fields for          \r\n"
                  "                 correct read.                                             \n\n");

           if(!awt){

              for(j=0; j < altr->num; j++){

                  atr = (altr->trpt) + j;

                  fscanf(tsf, "%d %f %f %e %e %e", &atr->fr_id, &atr->xf, &atr->yf, &atr->zf, &atr->gwthr, &atr->tend);
                  fscanf(tsf, "%e %e\n", &atr->vec[0], &atr->vec[1]);

              }

           }

           else {

              for(j=0; j < altr->num; j++){

                  atr = (altr->trpt) + j;

                  fscanf(tsf, "%d %f %f %e %e %e", &atr->fr_id, &atr->xf, &atr->yf, &atr->zf, &atr->gwthr, &atr->tend);
                  fscanf(tsf, "%e %e %f\n", &atr->vec[0], &atr->vec[1], &atr->wght);

              }

           }

        }

    }

    return all_tr;

}


int wc(char *st)

{

    int nw=0, state=0;
    int i=0, c;

    while((c=st[i++]) != '\0'){

       if(c == ' ' || c == '\n' || c == '\t')

          state = 0;

       else if (!state){

          state = 1;
          ++nw;
       }


    }

    return nw;

}   
