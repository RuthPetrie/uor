#include <Stdio.h>
#include <stdlib.h>
#include "mem_er.h"
#include "st_im.h"
#include "st_obj.h"
#include "st_fo.h"
#include "grid.h"

#define  MINI  1.0e+6
#define  TOLM  1.0e-10

void border_obj_fet_filter(struct object * , double ** , struct frame_objs * );
double euclid(struct feature_pts * , struct feature_pts * );
void object_split(struct object * , double ** );

struct stemp{
       double sx;
       double sy;
       double sm;
       double wd;
       double sn;
};

extern int x1u, y1u;
extern int bs;
extern int tf;

extern GRID *gr;

/* function to refine the partition of a complex object using a clustering
   algorithm to compute the centroids of each sub-region.                  */

void object_split_init(struct object *ob, struct frame_objs *fo)

{

     struct point *ptt;
     struct feature_pts *fpts, *fpts1, fpts2;
     struct stemp *t_stor, *ts;

     int i, j, num_eq=0;

     double xt, yt, xint, yint, mtot;
     double min, ptd, ninv;
     double **fuz;
     
/* assign memory for fuzzy memberships and centroids for each set of clusters */

     mem_er(((fuz = (double ** )calloc(ob->fet->feature_num, sizeof(double *))) == NULL) ? 0 : 1);

     for(j=0; j < ob->fet->feature_num; j++) 

        mem_er(((*(fuz+j) = (double * )calloc(ob->point_num, sizeof(double))) == NULL) ? 0 : 1);


     if(ob->fet->feature_num > 1){

        t_stor = (struct stemp * )calloc(ob->fet->feature_num, sizeof(struct stemp));
        mem_er((t_stor == NULL) ? 0 : 1);

        for(j=0; j < ob->point_num; j++){

            ptt = (ob->pt) + j;

            (fpts2.x).xy = obj_xreal((ptt->x) + x1u -2);
            (fpts2.y).xy = *(gr->ygrid + (ptt->y) + y1u -2);

            min = MINI;
            num_eq = 0;

            for(i=0; i < ob->fet->feature_num; i++){

                fpts1 = (ob->fet->fpt) + i;
                ts = t_stor + i;

                ts->wd = euclid(fpts1, &fpts2);

                if(ts->wd < min) min = ts->wd;

            }


            for(i=0; i < ob->fet->feature_num; i++) 

                if(((t_stor+i)->wd - min) < TOLM) ++num_eq;

            ninv = 1.0/((double)num_eq);

            for(i=0; i < ob->fet->feature_num; i++){

                ts = t_stor + i;

                if((ts->wd - min) < TOLM){

                   *(*(fuz+i)+j) = ninv;

                   ptd = ptt->val * ninv;

                   ts->sx += ((fpts2.x).xy) * ptd;
                   ts->sy += ((fpts2.y).xy) * ptd;
                   ts->sm += ptd;
                   ts->sn += ninv;

                }

            }

        }

        for(i=0; i < ob->fet->feature_num; i++){

           ts = t_stor +i;
           fpts = (ob->fet->fpt)+i;

           xt = ts->sx/ts->sm;
           yt = ts->sy/ts->sm;

           (fpts->x).xy = xt;
           (fpts->y).xy = yt;
           fpts->str = ts->sm/ts->sn;
           fpts->track_id = 0;

         }

         free(t_stor);

         if(tf == 6) object_split(ob, fuz);


     }

     else if(ob->fet->feature_num == 1){

           mtot = 0.0;
           xint = 0.0;
           yint = 0.0;

           for(i=0; i < ob->point_num; i++){

               *(*(fuz) + i) = 1.0;

               ptt = (ob->pt) + i;

               xint += obj_xreal((ptt->x) + x1u -2) * ptt->val;
               yint += *(gr->ygrid + (ptt->y) + y1u -2) * ptt->val;
               mtot += ptt->val;

           }

           xt = xint/mtot;
           yt = yint/mtot;

           ((ob->fet->fpt)->x).xy = xt;
           ((ob->fet->fpt)->y).xy = yt;
           (ob->fet->fpt)->str = mtot/ob->point_num;
           (ob->fet->fpt)->track_id = 0;

     }

     if(bs == 'y' && ob->b_or_i != 'i') border_obj_fet_filter(ob, fuz, fo);

     for(i=0; i < ob->fet->feature_num; i++) free(*(fuz+i));

     free(fuz);


     return;

}

