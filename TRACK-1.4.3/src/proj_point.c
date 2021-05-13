#include <Stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "proj.h"


/* function to take point from one projection and project onto a second */


int proj_point(PROJ proj, float *xpp, float *ypp, int pgr, int tpr, int npgr,  int ntpr, ...)

{
    va_list aptr;

    int irt=1;

    va_start(aptr, ntpr);

    switch(pgr){
      case 0:
         if(proj.prj1 != NULL){
            (*proj.prj1)(xpp, 'x', 0);
            (*proj.prj1)(ypp, 'y', 0);
         }
         break;

      case 1:
         azimuthal(ypp, xpp, *va_arg(aptr, float * ), *va_arg(aptr, float * ), 0, tpr);
         break;

      default:

         printf("***ERROR***, no such projection group for use in %s\n\n", __FILE__);
         exit(1);

     }

     switch(npgr){
      case 0:
         if(ntpr > 0){
            (*proj.prj2)(xpp, 'x', 1);
            (*proj.prj2)(ypp, 'y', 1);
         }
         break;

      case 1:

         irt = azimuthal(ypp, xpp, *va_arg(aptr, float * ), *va_arg(aptr, float * ), 1, ntpr);

         break;

      default:

         printf("***ERROR***, no such projection group for use in %s\n\n", __FILE__);
         exit(1);

     }

     va_end(aptr);

     return irt;

}
