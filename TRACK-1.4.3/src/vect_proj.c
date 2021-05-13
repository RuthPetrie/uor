#include <Stdio.h>
#include <stdlib.h>
#include <Math.h>
#include "statistic.h"
#include "mem_er.h"
#include "proj.h"
#include "grid.h"

#define  VECFRAC   0.1
#define  TOLVEC    1.0e-5

/* function to perform transformation of vectors to non-cylyndrical 
   projections.                                                        */

int proj_point(PROJ , float * , float * , int , int , int , int , ...);

extern GRID *gr, *gr1, *gr2;


void vect_proj(float xss, float yss, float *xcmp, float *ycmp, PROJ proj, int pgr, int tpr, int ptyp)

{

    float x1, y1, x2, y2, xc, yc;
 
    double vlen1, vlen2, vrat;


    if(!gr->prgr){
       printf("***ERROR***, incorrect projection group type\n\n");
       exit(1);
    }

    xc = *xcmp;
    yc = *ycmp;
    vlen1 = sqrt(xc*xc + yc*yc);

    if(vlen1 <= TOLVEC) return;

    x1 = xss;
    y1 = yss;
    x2 = x1 + (xc * VECFRAC / vlen1);
    y2 = y1 + (yc * VECFRAC / vlen1);

    if(!ptyp){

       proj_point(proj, &x1, &y1, pgr, tpr, gr->prgr, gr->prty, &gr1->alat, &gr1->alng);
       if(!proj_point(proj, &x2, &y2, pgr, tpr, gr->prgr, gr->prty, &gr1->alat, &gr1->alng))
          {x2 = x1; y2 = y1;}


     }

     else if(gr2){

       proj_point(proj, &x1, &y1, pgr, tpr, gr->prgr, gr->prty, &gr2->alat, &gr2->alng);
       if(!proj_point(proj, &x2, &y2, pgr, tpr, gr->prgr, gr->prty, &gr2->alat, &gr2->alng))
          {x2 = x1; y2 = y1;}

     }

     *xcmp = x2 - x1;
     *ycmp = y2 - y1;

     vlen2 = sqrt(*xcmp * *xcmp + *ycmp * *ycmp);

     if(vlen2 > 0.) vrat = vlen1 / vlen2;
     else vrat = 0.;

     *xcmp *= vrat;
     *ycmp *= vrat;

       
     return;

}
