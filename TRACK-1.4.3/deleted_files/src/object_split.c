#include <Stdio.h>
#include <stdlib.h>
#include <Math.h>
#include "mem_er.h"
#include "st_im.h"
#include "st_obj.h"
#include "st_fo.h"
#include "grid.h"

#define  TOL      1.0e-2
#define  DISTOL   1.0e-10
#define  MEMT     0.5
#define  DEF      1000.0

double euclid(struct feature_pts * , struct feature_pts * );

struct centrd{
       double x;
       double y;
       double mass;
};


extern int x1u, y1u;
extern double mfuz, mf_1;

extern GRID *gr;

/* function to split up an object based on the nodal local maxima and
   compute the centroids of each sub-region.                          */

void object_split(struct object *ob, double **fuz)

{

     int i, j, k;

     double *fuzt, *fz;
     double nsum, sum, fpp, pp;
     double dist, fb, sf, sm;

     struct point *ptt;
     struct feature_pts *fpts, fpts1; 
     struct centrd ct;

/* split objects with more than one local max */

/* assign tempory storage */

     mem_er(((fuzt = (double * )calloc(ob->fet->feature_num, sizeof(double))) == NULL) ? 0 : 1);

loop:                /* start of iteration for this fuzzy partition */

/* calculate fuzzy centroids */


/* update fuzzy membership */

     nsum = 0.0;

     for(j=0; j < ob->point_num; j++){

        sum = 0.0;
        ptt = (ob->pt) + j;

        (fpts1.x).xy = obj_xreal((ptt->x) + x1u - 2);
        (fpts1.y).xy = *(gr->ygrid + (ptt->y) + y1u - 2);

        for(k=0; k < ob->fet->feature_num; k++){

           fz = *(fuz+k) + j;
           *(fuzt +k) = *fz;
           fpts = (ob->fet->fpt) + k;

           dist = euclid(fpts, &fpts1);
           if(dist <= DISTOL){

             for(i=0; i < ob->fet->feature_num; i++) *(*(fuz+i)+j) = 0.0;
             sum = *fz = 1.0;
             break;

           }

           else sum += (*fz = pow(1.0/dist, mf_1));           

        }

        for(k=0; k < ob->fet->feature_num; k++){

           fz = *(fuz+k) + j;
           *fz /= sum;

           nsum = ((fb = (fabs(*fz - *(fuzt+k)))) > nsum) ? fb : nsum;

        }


     }

     for(j=0; j < ob->fet->feature_num; j++){

        fpts = (ob->fet->fpt) + j;
        sf = ct.x = ct.y = ct.mass = 0.0;

        for(k=0; k < ob->point_num; k++){

           fz = *(fuz +j) + k;
           ptt = (ob->pt) + k;
           pp =  pow(*fz, mfuz);

           ct.mass += (fpp = ptt->val * pp);

           ct.x += (obj_xreal((ptt->x) + x1u - 2) * fpp);
           ct.y += (*(gr->ygrid + (ptt->y) + y1u - 2) * fpp);
        }

        (fpts->x).xy = (float)(ct.x / ct.mass);
        (fpts->y).xy = (float)(ct.y / ct.mass);

     }

     if(nsum > TOL) goto loop;

     for(j=0; j < ob->fet->feature_num; j++){

        fpts = (ob->fet->fpt) + j;
        sf = sm = 0.0;
        ct.mass = ct.x = ct.y = 0.0;

        for(k=0; k < ob->point_num; k++){

           fz = *(fuz +j) + k;
           ptt = (ob->pt) + k;

           if(*fz >= MEMT){

             ct.mass += (fpp = ptt->val * pow(*fz, mfuz));

             ct.x += (obj_xreal((ptt->x) + x1u - 2) * fpp);
             ct.y += (*(gr->ygrid + (ptt->y) + y1u - 2) * fpp);

             sf += *fz;
             sm += ptt->val * (*fz);

           }

         }
         if(ct.mass != 0.0){
           (fpts->x).xy = (float)(ct.x / ct.mass);
           (fpts->y).xy = (float)(ct.y / ct.mass);
           fpts->str = sm/sf;
         }
         else {

           (fpts->x).xy = DEF;
           (fpts->y).xy = DEF;
           fpts->str = -1.0;

         }

     }
             
     free(fuzt);

     return;

}
