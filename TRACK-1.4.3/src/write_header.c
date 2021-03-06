#include <Stdio.h>
#include "grid.h"

void write_header(GRID *gr, FILE *fil)

{

    int i;
    int nl=0;

    fprintf(fil, "%5d %5d %5d\n", gr->ix, gr->iy, 1);

    for(i=0; i<gr->ix; i++){

        fprintf(fil, "%10.4f ", *(gr->xgrid + i));
        ++nl;
        if(nl == 10) {fprintf(fil, "\n"); nl = 0;}

    }

    if(nl) fprintf(fil, "\n");

    nl = 0;

    for(i=0; i<gr->iy; i++){

        fprintf(fil, "%10.4f ", *(gr->ygrid + i));
        ++nl;
        if(nl == 10) {fprintf(fil, "\n"); nl = 0;}

    }

    if(nl) fprintf(fil, "\n");


    return;

}
