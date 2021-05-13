#include <Stdio.h>
#include <stdlib.h>
#include <string.h>
#include "proj.h"
#include "splice.h"
#include "file_cat_out.h"
#include "grid.h"
#include "mem_er.h"

#include "file_handle.h"

struct tot_tr *mean_track(struct tot_tr * , struct tot_tr * ,int , int * );
void meantrd(FILE * , struct tot_tr * , int , int );
struct tot_tr *read_tracks(FILE * , int * , int * , int * , int , float * , float * );
void splice_plot(struct tot_tr * , int , int ,int , ...);

extern GRID *gr;

extern char *fext;

extern int iext;

void all_mean_track(struct tot_tr *all_tr, int trackn)

{

    int mtr_num=0;                  /* total number of track means */
    int tot_fet;                    /* total number of points in mean tracks */
    int i, disp;
    int tpr, gpr;

    float alat=0., alng=0,;

    FILE *meantr=NULL;

    char mntrin[MAXCHR];

    struct tot_tr *mean_trs=NULL;   /* pointer for mean track data */

    printf("do you want to display an exsiting set of mean tracks,\r\n"
           "Input '0' for yes and '1' to compute a new set of mean tracks\r\n");

    scanf("%d", &disp);

    if(disp){

       mean_trs = mean_track(all_tr, mean_trs, trackn, &mtr_num);

       strncpy(mntrin, MNTRS, MAXCHR);
       if(iext) strcpy(strstr(mntrin, EXTENSION), fext);

       meantr = open_file(mntrin, "w");

       meantrd(meantr, mean_trs, mtr_num, 's');

       close_file(meantr, mntrin);

    }

    else {

       printf("what is the name of the mean track data file required\n");

       scanf("%s", mntrin);

       meantr = open_file(mntrin, "r");

       mean_trs = read_tracks(meantr, &mtr_num, &gpr, &tpr, 's', &alat, &alng);

       close_file(meantr, mntrin);

       while(tpr != gr->prty) {

          printf("***WARNING***, map projection and data do not match\r\n"
                 "               grid will be corrected\n");


          map_project(&gr->prty, tpr);

       }

    }


    printf("do you want the mean tracks plotted, 'y' or 'n'\n");

    scanf("\n");

    if(getchar() == 'y') {

      tot_fet = 0;

      for(i=0; i < mtr_num; i++) tot_fet += (mean_trs +i)->num;

      splice_plot(mean_trs, tot_fet, mtr_num, 1, 2);

    }

    free(mean_trs);

    return;

}
