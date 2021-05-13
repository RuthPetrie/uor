#include <Stdio.h>
#include "grid.h"
#include "st_fo.h" 
#include "st_obj.h"
#include "proj.h"

/* function to convert object feature points to the chosen projection */


extern GRID *gr;
extern PROJ *pp;

void correct_fpt(struct frame_objs *fr, int fnum)
{

    int i, j, k;

    PRFP prj;

    struct frame_objs *ft=NULL;
    struct feature_pts *fpts=NULL;
    struct object *ob=NULL;

    prj = pp->prj2;

    for(i=0; i < fnum; i++){

        ft = fr + i;

        for(j=0; j < ft->obj_num; j++){

           ob = ft->objs + j;

           for(k=0; k < ob->fet->feature_num; k++){

               fpts = ob->fet->fpt + k;
/* printf("%f %f\n", (fpts->x).xy, (fpts->y).xy); */
               switch(gr->prgr){

                  case 0:
                    (*prj)(&((fpts->x).xy), 'x', 1);
                    (*prj)(&((fpts->y).xy), 'y', 1);
                    break;
                  case 1:

                    azimuthal(&((fpts->y).xy), &((fpts->x).xy) , gr->alat, gr->alng, 1, gr->prty);

                    break;

               }

/* printf("%f %f\n\n", (fpts->x).xy, (fpts->y).xy); */

           }

        }

    }



    return;

}
