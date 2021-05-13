#include <Stdio.h>
#include <stdlib.h>
#include <Math.h>
#include "splice.h"
#include "mem_er.h"

#define  TOL  1.0e-4
#define  DEF  1.0e+10

#define PARLL(A) (float)((fabs(A) < TOL) ? 0 : A)

/* function to calculate mean tracks. */

void splice_plot(struct tot_tr * , int , int ,int , ...);

typedef struct point {
    float x;
    float y;
}point;

extern float xmn, ymn, xmx, ymx;

struct tot_tr *mean_track(struct tot_tr *all_tr, struct tot_tr *mean_trs, int trackn, int *mtr_num)

{

    point a1, a2;
    point v1, icpt1, icpt2;
    point base, intsec;
    point nv1, nv2;
    point bd, td;

    float lam, abv1, xint, abdx, xtr;

    double dirm, rat, basem;
    double scale, idx, idy;
    double grad_dir, intr_dir, inv, iidx, iidy;
    double grad_track, intr_track, gradif;

    int i, j, k, tot_fet, pt;
    int irec, div;
    int *npt, *dd;

    struct fet_pt_tr *atr1, *atr2, *matr;
    struct tot_tr *altr, *maltr;

    xint = xtr = grad_dir = intr_dir = grad_track = intr_track = 0.0;

    printf("the area of interest is for X %f to %f\r\n"
           "                        for Y %f to %f\r\n\n", xmn, xmx, ymn, ymx );

/* how many feature points are there */

    tot_fet = 0;

    for(i=0; i < trackn; i++){

        altr = all_tr + i;

        if(altr->trpt != NULL) tot_fet += altr->num;

    }

/* assign memory for mean_tracks */

   if(mean_trs == NULL){

      ++(*mtr_num);
      mean_trs = (struct tot_tr * )malloc_init(sizeof(struct tot_tr));
      mem_er((mean_trs == NULL) ? 0 : 1);

   }

   else {

      ++(*mtr_num);
      mean_trs = (struct tot_tr * )realloc_n(mean_trs, (*mtr_num)*sizeof(struct tot_tr));
      mem_er_realloc((mean_trs == NULL) ? 0 : 1, (*mtr_num)*sizeof(struct tot_tr));

   }

/* define region, rectangular on a euclidean plane at present,
   for averaging  and display */

    printf("do you want to input the rectangle data before display 'y'\r\n"
           "or from the display 'd'\n\n");

    scanf("\n");
    irec = getchar();
    if(irec == 'y'){

      printf("input the coordinates of the base line of the area of interest;\r\n"
             "Input the pairs (x1, y1), (x2, y2) \r\n");

      scanf("%f %f %f %f", &a1.x, &a1.y, &a2.x, &a2.y);

      printf("input the X co-ordinate and the scale of the orientation vector;\r\n"
             "Input as the pair (xv, lam)\n");

      scanf("%f %f", &v1.x, &lam);

      base.x = a2.x - a1.x;
      base.y = a2.y - a1.y;

      if(fabs(v1.x) <= TOL){

         v1.y = 1.0;
         v1.x = - base.y/base.x;
      }

      else v1.y = - base.x * v1.x/base.y;

      dirm = sqrt((double)(v1.x * v1.x + v1.y * v1.y));
      rat = (double)lam/dirm;

      v1.x *= rat;
      v1.y *= rat;     
   
      nv1.x = a1.x + v1.x;
      nv1.y = a1.y + v1.y;

      nv2.x = a2.x + v1.x;
      nv2.y = a2.y + v1.y;

      pt = 0;
      splice_plot(all_tr, tot_fet, trackn, 1, pt, &a1, &nv1, &nv2, &a2, &v1, &lam);

    }

    else if(irec == 'd'){

      pt = 1;
      splice_plot(all_tr, tot_fet, trackn, 1, pt, &a1, &nv1, &nv2, &a2, &v1, &lam);

    }

/* calculate base line length */

    base.x = a2.x - a1.x;
    base.y = a2.y - a1.y;

    basem = base.x * base.x + base.y * base.y;

    abv1 = fabs(v1.x);

    printf("how many divisions of the base line are required?\n");

    scanf("%d", &div);

    ++div;

/* assign memory for individual mean tracks */

    maltr = mean_trs + (*mtr_num) - 1;

    maltr->trpt = (struct fet_pt_tr * )calloc(div, sizeof(struct fet_pt_tr));
    mem_er((maltr->trpt == NULL) ? 0 : 1);

    maltr->num = div;

    npt = (int * )calloc(div, sizeof(int));
    mem_er((npt == NULL) ? 0 : 1);

/* find intrsections of tracks with the direction vector */

    if(abv1 > TOL) grad_dir = v1.y/v1.x;

    for(i=0; i < div; i++){

        scale = (double)i/ (double)(div-1);
        icpt1.x = a1.x + scale * base.x;
        icpt1.y = a1.y + scale * base.y;

        icpt2.x = icpt1.x + v1.x;
        icpt2.y = icpt1.y + v1.y;

/* calculate the equation of the direction vector line */

        if(abv1 > TOL) intr_dir = (icpt1.y * icpt2.x - icpt1.x * icpt2.y)/(icpt2.x - icpt1.x);

        else xint = icpt1.x;

        matr = (maltr->trpt) + i;
        dd = npt + i;

/* find intersections */

        for(j=0; j < trackn; j++){

            altr = all_tr + j;

            for(k=0; k < altr->num-1; k++){

               atr1 = (altr->trpt) + k;
               atr2 = atr1 + 1;

/* check if track section is within region of interest */

               

               idx = atr2->xf - atr1->xf;
               idy = atr2->yf - atr1->yf;
               inv = 1.0/idx;
               abdx = fabs(idx);

               if(abdx > TOL){

                 grad_track = (atr2->yf - atr1->yf) * inv;
                 intr_track = (atr1->yf * atr2->xf - atr2->yf * atr1->xf) * inv;

               }

               else xtr = atr1->xf;

               gradif = grad_dir - grad_track;

               if(abv1 > TOL && abdx > TOL && fabs(gradif) > 1.0e-6){
           
                 intsec.x = (intr_track - intr_dir)/gradif;
                 intsec.y = grad_track * intsec.x + intr_track;

               }

               else if(abv1 <= TOL){

                 intsec.x = xint;
                 intsec.y = grad_track * xint + intr_track;

               }

               else if(abdx <= TOL){

                 intsec.x = xtr;
                 intsec.y = grad_dir * xtr + intr_dir;

               }

               else intsec.x = intsec.y = DEF;

               bd.y = PARLL((icpt2.y - intsec.y) * (intsec.y - icpt1.y));
               bd.x = PARLL((icpt2.x - intsec.x) * (intsec.x - icpt1.x));

               td.y = PARLL((atr2->yf - intsec.y) * (intsec.y - atr1->yf));
               td.x = PARLL((atr2->xf - intsec.x) * (intsec.x - atr1->xf));

               if(bd.y >= 0.0 && bd.x >= 0.0 &&
                  td.y >= 0.0 && td.x >= 0.0   ){

                  matr->xf += intsec.x;
                  matr->yf += intsec.y;

                  iidx = intsec.x - atr1->xf;
                  iidy = intsec.y - atr1->yf;

/* need to check this: why does it produce negative values???? */

                  matr->zf += atr1->zf + (atr2->zf - atr1->zf) * 
                               (sqrt((double)(iidx * iidx + iidy * iidy))/
                                sqrt((double)(idx * idx + idy * idy)));

                  ++(*dd);

                }

            }

        }

    }

    for(i=0; i < div; i++){

repeat:

        matr = (maltr->trpt) + i;
        dd = npt + i;

        if(*dd > 0){

           matr->xf /= (float)*dd;
           matr->yf /= (float)*dd;
           matr->zf /= (float)*dd;

        }

        else {

           for(j=i; j < div; j++){

              matr = (maltr->trpt) + j;
              dd = npt + j;

              *matr = *(matr+1);
              *dd = *(dd+1);

           }

           --(maltr->num);
           --div;

           goto repeat;

        }

    }

    free(npt);

    printf("do you want any other mean tracks calculated, 'y' or 'n'\n");

    scanf("\n");

    if(getchar() == 'y') mean_trs = mean_track(all_tr, mean_trs, trackn, mtr_num);
 
    return mean_trs;


}
