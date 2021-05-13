#include <Stdio.h>
#include "statistic.h"
#include "splice.h"
#include "grid.h"


/* function to compute the mean track statistics, 
   the sample mean                                      */

double stat_weight(struct pt_stat * , struct fet_pt_tr * , int pl);

extern int tom;
extern GRID *gr;


void track_means(struct tot_tr *trck, int trnum, struct tot_stat *trst, int type, int f1, int f2)

{

    int i, j, k, ii=0;

    int ttmp=tom;

    float fdum;

    double wt;

    struct tot_tr *pp=NULL;
    struct pt_stat *pst=NULL;
    struct fet_pt_tr *pt=NULL;

    switch(tom){
        case 'g':
          printf("current distance measure is GEODESIC\n");
          break;
        case 'e':
          printf("current distance measure is EUCLIDEAN\n");
          break;
        default:
          printf("***error***, distance measure unknown\n");
          exit(1);
    }

    printf("do you want to change the distance measure, 'y' or 'n'\n");
    scanf("\n");
    if(getchar() == 'y'){

       printf("which distance measure is required, 'e' or 'g'\n");

       scanf("%d", &tom);

       if(tom == 'g' && gr->prty != 0){

          printf("***error***, geodesic measure incompatable with data\r\n"
                 "             data must be in lat-long coordinates.  \r\n"
                 "             Distance measure reset to 'e'.\n");

          tom = 'e';

       }

    }         

    for(i=0; i < trnum; i++){

        pp = trck + i;

        for(j=0; j <  pp->num; j++){

            pt = (pp->trpt) + j;

            if(pt->fr_id >= f1 && pt->fr_id <= f2){

              for(k=0; k < trst->ptnum; k++){

                 pst = (trst->ptst) + k;

                 wt = stat_weight(pst, pt, 'p');
                 pst->num += wt;

                 if(type == 1) (pst->stat1).mean += (wt * pt->zf);
                 else if(type == 2) (pst->stat2).mean += (wt * pt->zf);

               }

            }


        }


   }

   for(i=0; i < trst->ptnum; i++){

       pst = (trst->ptst) + i;
       if(type == 1) (pst->stat1).mean /= pst->num;
       if(type == 2) (pst->stat2).mean /= pst->num;
       pst->num = 0.;

   }

   tom = ttmp;

   return;

}
