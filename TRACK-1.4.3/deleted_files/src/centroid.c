#include <Stdio.h>
#include <stdlib.h>
#include <Math.h>
#include "mem_er.h"
#include "st_im.h"
#include "st_obj.h"
#include "st_fo.h"
#include "grid.h"

#define  TOL   1.0e-2
#define  SEED  1000
#define  PTFRAC 7
#define  DMIN   1.0e+30

struct centrd{
       double x;
       double y;
       double mass;
       double sf;
       double sm;
};


extern int x1u, y1u;
extern double mfuz, mf_1;

extern GRID *gr;

double euclid(struct feature_pts * , struct feature_pts * );

/* function to split up an object based on the nodal local maxima and
   compute the centroids of each sub-region.                          */

void centroid(struct frame_objs *ff)

{

     int h, i, j, k, val_cl_id=0;
     int ptf;

     double ***fuz, **fzz, *fuzt, *fz;
     double nsum, sum, fpp;
     double fun, func, dist, fb, dmin, dm;
     double val_fnc;

     struct centrd **cent, *ct, *ct1, sct;
     struct object *ob;
     struct point *ptt;
     struct feature_pts *fpts, fpts1, fpts2;

/*     srandom(random(sd)); */

/* split objects if required*/

     for(h=0; h < ff->obj_num; h++){

        ob = ff->objs + h; 

        ob->fet = (struct features *)malloc_init(sizeof(struct features));
        mem_er((ob->fet == NULL) ? 0 : 1, sizeof(struct features));

        ptf = (ob->point_num/PTFRAC) + 1;

        if(ptf > 1){

          val_fnc = DMIN;

/* assign memory for fuzzy memberships and centroids for each set of clusters */

          mem_er(((fuz = (double *** )calloc(ptf, sizeof(double *))) == NULL) ? 0 : 1, ptf * sizeof(double *));

          mem_er(((cent = (struct centrd ** )calloc(ptf, sizeof(struct centrd *))) == NULL) ? 0 : 1, ptf * sizeof(struct centrd *));

          for(i=1; i < ptf; i++){

              mem_er(((*(fuz+i) = (double **)calloc(i+1, sizeof(double *))) == NULL) ? 0 : 1, (i+1) * sizeof(double *));

              fzz = *(fuz+i);

              mem_er(((*(cent+i) = (struct centrd *)calloc(i+1, sizeof(struct centrd))) == NULL) ? 0 : 1, (i+1) * sizeof(struct centrd));

              for(j=0; j <= i; j++) 

                  mem_er(((*(fzz+j) = (double * )calloc(ob->point_num, sizeof(double))) == NULL) ? 0 : 1, ob->point_num * sizeof(double));

/* initialize fuzzy memberships */

              for(j=0; j < ob->point_num; j++){

                 sum = 0.0;

                 for(k=0; k <= i; k++){

                     fz = *(fzz+k) + j;
                     sum += (*fz = ((unsigned) rand() >>8));

                 }

                 for(k=0; k < i+1; k++) *(*(fzz+k)+j) /= sum;


              }

/* assign tempory storage for fuzzy memberships */

              mem_er(((fuzt = (double * )calloc(i+1, sizeof(double))) == NULL) ? 0 : 1, (i+1) * sizeof(double));

loop:                /* start of iteration for this fuzzy partition */

/* calculate fuzzy centroids */

              for(j=0; j <= i; j++){

                  ct = *(cent+i) + j;
                  ct->x = ct->y = ct->mass = 0.0;

                  for(k=0; k < ob->point_num; k++){

                     fz = *(fzz +j) + k;
                     ptt = (ob->pt) + k;

                     ct->mass += (fpp = ptt->val * pow(*fz, mfuz));

                     ct->x += (obj_xreal((ptt->x) + x1u - 2) * fpp);
                     ct->y += (*(gr->ygrid + (ptt->y) + y1u - 2) * fpp);

                  }

                  ct->x /= ct->mass;
                  ct->y /= ct->mass;


              }

/* update fuzzy membership */

              nsum = 0.0;

              for(j=0; j < ob->point_num; j++){

                 sum = 0.0;
                 ptt = (ob->pt) + j;

                 (fpts1.x).xy = obj_xreal((ptt->x) + x1u - 2);
                 (fpts1.y).xy = *(gr->ygrid + (ptt->y) + y1u - 2);

                 for(k=0; k <= i; k++){

                    fz = *(fzz+k) + j;
                    *(fuzt +k) = *fz;
                    ct = *(cent+i) + k;

                    (fpts2.x).xy = ct->x;
                    (fpts2.y).xy = ct->y;

                    dist = euclid(&fpts1, &fpts2);

                    sum += (*fz = pow(1.0/dist, mf_1));

                 }

                 for(k=0; k <= i; k++){

                    fz = *(fzz+k) + j;
                    *fz /= sum;
                    nsum = ((fb = (fabs(*fz - *(fuzt+k)))) > nsum) ? fb : nsum;

                  }

              }

              if(nsum > TOL) goto loop;

/* compute final values for the centroids */

              for(j=0; j <= i; j++){

                 ct = *(cent+i) + j;
                 ct->x = ct->y = ct->mass = ct->sf = ct->sm = 0.0;

                 for(k=0; k < ob->point_num; k++){

                    fz = *(fzz +j) + k;
                    ptt = (ob->pt) + k;

                    ct->sf += *fz;
                    ct->sm += *fz * ptt->val;
                    ct->mass += (fpp = ptt->val * pow(*fz, mfuz));

                    ct->x += (obj_xreal((ptt->x) + x1u - 2) * fpp);
                    ct->y += (*(gr->ygrid + (ptt->y) + y1u - 2) * fpp);

                  }

                  ct->x /= ct->mass;
                  ct->y /= ct->mass;

              }

/* compute functional */

              func = 0.0;

              for(j=0; j < ob->point_num; j++){

                 fun = 0.0;
                 ptt = (ob->pt) + j;

                 (fpts1.x).xy = obj_xreal((ptt->x) + x1u - 2);
                 (fpts1.y).xy = *(gr->ygrid + (ptt->y) + y1u - 2);

                 for(k=0; k <= i; k++){

                    fz = *(fzz+k) + j;
                    *(fuzt +k) = *fz;
                    ct = *(cent+i) + k;

                    (fpts2.x).xy = ct->x;
                    (fpts2.y).xy = ct->y;

                    dist = euclid(&fpts1, &fpts2);
                    fun += dist*pow(*fz, mfuz);

                  }

                  func += fun;

              }

/* calculate the clustering validity function */


/* calculate the minimum centroid seperation */

              dmin = DMIN;

              for(j=0; j < i; j++){

                 ct = *(cent+i)+j;
                 (fpts1.x).xy = ct->x;
                 (fpts1.y).xy = ct->y;

                 for(k=j+1; k <= i; k++){

                    ct1 = *(cent+i)+k;
                    (fpts2.x).xy = ct1->x;
                    (fpts2.y).xy = ct1->y;

                    dm = euclid(&fpts1, &fpts2);                  
                    dmin = (dm < dmin) ? dm : dmin;

                 }


              }

/*              func /= ((double)ob->point_num) * dmin *(1.0 - ((double)i/(double)ob->point_num)); */
              func /= ((double)ob->point_num * dmin);

/*              printf("%d, %e \n", i, func); */

/* check cluster validity */

             if(func < val_fnc){

               val_fnc = func;
               val_cl_id = i;

             }
              
             free(fuzt);

          }


          ff->tot_f_f_num += (ob->fet->feature_num = val_cl_id + 1);

          ob->fet->fpt = (struct feature_pts * )calloc(ob->fet->feature_num, sizeof(struct feature_pts));
          mem_er((ob->fet->fpt == NULL) ? 0 : 1, (ob->fet->feature_num) * sizeof(struct feature_pts));

/* copy centroid co-ordinates into feature point space */

          for(i=0; i <= val_cl_id; i++){

             fpts = (ob->fet->fpt) + i;
             ct = *(cent+val_cl_id) + i;
             (fpts->x).xy = ct->x;
             (fpts->y).xy = ct->y;
             fpts->str = ct->sm/ct->sf;
             fpts->track_id = 0;

          }

          for(i=1; i < ptf; i++){

            for(j=0; j <= i; j++) free(*(*(fuz+i)+j));
 
            free(*(fuz+i));
            free(*(cent+i));

          }

          free(fuz);
          free(cent);

        }


/* calculate centroid for object with only one local max */

        else if(ptf == 1){

           ob->fet->fpt = (struct feature_pts * )malloc_init(sizeof(struct feature_pts));
           mem_er((ob->fet->fpt == NULL) ? 0 : 1, sizeof(struct feature_pts));

           ob->fet->feature_num = 1;
           ++ff->tot_f_f_num;

           sct.x = sct.y = sct.mass = 0.0;
 
           for(i=0; i < ob->point_num; i++){

              ptt = (ob->pt) + i;
              sct.x += obj_xreal((ptt->x) + x1u - 2) * ptt->val;
              sct.y += *(gr->ygrid + (ptt->y) + y1u - 2) * ptt->val;
              sct.mass += ptt->val;

           }

           sct.x /= sct.mass;
           sct.y /= sct.mass;

           (ob->fet->fpt->x).xy = sct.x;
           (ob->fet->fpt->y).xy = sct.y;
           ob->fet->fpt->str = sct.mass/ob->point_num;
           ob->fet->fpt->track_id = 0;

        }

     }

     return;

}
