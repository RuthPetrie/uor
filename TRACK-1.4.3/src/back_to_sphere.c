#include <Stdio.h>
#include "grid.h"
#include "st_fo.h" 
#include "st_obj.h"
#include "proj.h"

/* function to project feature points back onto sphere for tracking */

extern int x1u, y1u;
extern GRID *gr;

void back_to_sphere(struct frame_objs *fo, int *tf, int frn, PRFP prj)

{

    int i, j, k;

    float xa, ya;

    struct frame_objs *ft=NULL;
    struct object *ob=NULL;
    struct feature_pts *fpts=NULL;

    for(i=0; i < frn; i++){

        ft = fo + i;

        for(j=0; j < ft->obj_num; j++){

            ob = (ft->objs) + j;

            if(!(ob->fet)) continue;

            for(k=0; k < ob->fet->feature_num; k++){

               fpts = (ob->fet->fpt) + k;

               if(*tf == 3){

                  xa = *(gr->xgrid + ((fpts->x).ixy)+x1u-2);
                  ya = *(gr->ygrid + ((fpts->y).ixy)+y1u-2);
                  switch(gr->prgr){
                    case 0:
                      (*prj)(&xa, 'x', 0);
                      (*prj)(&ya, 'y', 0);
                      break;
                    case 1:
                      azimuthal(&ya, &xa, gr->alat, gr->alng, 0, gr->prty);
                      break;
                  }
                  (fpts->x).xy = xa;
                  (fpts->y).xy = ya;
                  *tf = 4;

                }

                else{

                  switch(gr->prgr){
                    case 0:
                      (*prj)(&((fpts->x).xy), 'x', 0);
                      (*prj)(&((fpts->y).xy), 'y', 0);
                      break;
                    case 1:

                      azimuthal(&((fpts->y).xy), &((fpts->x).xy) , gr->alat, gr->alng, 0, gr->prty);

                      break;
                  }


                }


            }

        }

    }



    return;

}
