#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "st_fo.h"
#include "st_obj.h"
#include "boundary.h"
#include "mem_er.h"

#define  MAXCHR   150


int aniso='n';
int objwr=0, fptwrt=1;

void objectd(struct frame_objs * , FILE * , int , int );

int main(int argc, char **argv)
{

    int i;
    int ifst=0;
    int fnum=0;
    int ivar=0;
    int dvar=0;
    int curtim=-1, tmptim;

    int vstrpos[25] = {18, 20, 23, 28, 29, 30, 31, 32, 33, 34, 43, 44, 45, 46, 47, 48, 49, 52, 53, 54, 55, 56, 57, 58, 59};

    float scale[25] = {0.1, 1.0e-6, 1.0e-6, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.01, 0.01, 0.01, 0.01, 1.0e-7, 1.0e-7, 1.0e-7, 1.0e-7, 1.0e-7};

    FILE *fin=NULL;
    FILE *fout=NULL;


    char *ih=NULL;
    char *tok[127];
    char ctim[20];
    char infile[MAXCHR];
    char outfil[MAXCHR];
    char headf[MAXCHR], tailf[MAXCHR];
    char line[10*MAXCHR];
    char usage[] = "Usage: convhew -i <input file> -o <output file>";

    struct frame_objs *fo=NULL;
    struct object *ob=NULL;
    struct feature_pts *fp=NULL;

    for(i=0; i < 127; i++) tok[i] = (char *)calloc(20, sizeof(char));

    if(argc != 5){
       printf("%s\n", usage);
       exit(1);
    }

    if(!strncmp(argv[1], "-i", 2)) {
       strcpy(infile, argv[2]);
       if(!strncmp(argv[3], "-o", 2)) strcpy(outfil, argv[4]);
       else {
          printf("%s\n", usage);
          exit(1);
       }

       strcpy(tailf, argv[4]);
       strcpy(headf, argv[4]); 

    }

    else if(!strncmp(argv[1], "-o", 2)) {
       strcpy(outfil, argv[2]);
       if(!strncmp(argv[3], "-i", 2)) strcpy(infile, argv[4]);
       else {
          printf("%s\n", usage);
          exit(1);
       }

       strcpy(tailf, argv[2]);
       strcpy(headf, argv[2]); 

    }     
    else {
      printf("%s\n", usage);
      exit(1);
    }

    strcat(tailf, ".tail");
    strcat(headf, ".head");

/* Choose intensity measure */

    printf("What intensity values are required:-    \r\n"
           " 0 ---  MSLP                            \r\n"
           " 1 ---  1Km Relative Vorticity          \r\n"
           " 2 ---  1Km Geostropic Relative Vortcity\r\n"
           " 3 ---  Temperature at 900mb            \r\n"
           " 4 ---  Theta-W at 900mb                \r\n"
           " 5 ---  Theta-W at 700mb                \r\n"
           " 6 ---  Theta-W at 500mb                \r\n"
           " 7 ---  Potential Temperature at 900mb  \r\n"
           " 8 ---  Potential Temperature at 700mb  \r\n"
           " 9 ---  Potential Temperature at 500mb  \r\n"
           "10 ---  U component at 700mb            \r\n"
           "11 ---  V component at 700mb            \r\n"
           "12 ---  U component at 500mb            \r\n"
           "13 ---  V component at 500mb            \r\n"
           "14 ---  U component at 300mb            \r\n"
           "15 ---  V component at 300mb            \r\n"
           "16 ---  1Km Potential Vorticity         \r\n"
           "17 ---  Vertical velocity at 900mb      \r\n"
           "18 ---  Vertical velocity at 700mb      \r\n"
           "19 ---  Vertical velocity at 500mb      \r\n"
           "20 ---  Divergence at 1000mb            \r\n"
           "21 ---  Divergence at 900mb             \r\n"
           "22 ---  Divergence at 800mb             \r\n"
           "23 ---  Divergence at 500mb             \r\n"
           "24 ---  Divergence at 300mb             \n\n");

    scanf("%d", &ivar);


    if(ivar < 0 || ivar > 25){
       printf("****ERROR****, no variable exists for ID=%d\n", ivar);
       exit(1);
    }

    fin = fopen(infile, "r");
    if(!fin){
       printf("****ERROR****, can't open file %s\n", infile);
       exit(1);
    }

    fout = fopen(outfil, "w");
    if(!fout){
       printf("****ERROR****, can't open file %s\n", outfil);
       exit(1);
    }


    fprintf(fout, "%d %d\n", 4, 0);

    fprintf(fout, "PROJ_DETAILS\n");
    fprintf(fout, "%d %d\n", 0, 0);
    fprintf(fout, "REGION_DETAILS\n");
    fprintf(fout, "%d %d %d %d\n", 0, 0, 0, 0);

/* read summary line */

    fo=(struct frame_objs *)malloc(sizeof(struct frame_objs));
    mem_er((fo == NULL) ? 0 : 1, sizeof(struct frame_objs));
    memset(fo, NULL, sizeof(struct frame_objs));
    fo->obj_num=0;
    fo->objs = NULL;
    fo->b_state = -1;
    fo->tot_f_f_num = 0;
    fnum = 1;

    fgets(line, 10*MAXCHR, fin);

    if(! (strstr(line, "MODEL") && strstr(line, "REGION"))) fseek(fin, 0L, SEEK_SET);

    while(fgets(line, 10*MAXCHR, fin) != NULL){

       

       ih = strtok(line, "\t");
/*       printf("%s\n", ih); */
       sprintf(tok[0], "%s", ih);
       for(i=0; i < 126; i++){
          ih = strtok(NULL, "\t");
          sprintf(tok[i+1], "%s\n", ih);
       }


       sscanf(tok[9], "%d", &tmptim);



       if((strncmp(ctim, tok[7], 8) || curtim != tmptim) && ifst){
          objectd(fo, fout, fnum, 4);

          ++fnum;
/*          for(i=0; i < fo->obj_num; i++) {
              ob = (fo->objs) + fo->obj_num - 1;
              free(ob->fet->fpt);
              free(ob->fet);
          } */
          free(fo->objs);
          fo->obj_num = 0;
          fo->tot_f_f_num = 0;
       }

       curtim = tmptim;

       ifst = 1;

       if(!(fo->obj_num)){
          fo->objs=(struct object *)malloc(sizeof(struct object));
          mem_er((fo->objs == NULL) ? 0 : 1, sizeof(struct object));
          memset(fo->objs, NULL, sizeof(struct object));
          fo->obj_num = 1;
       }
       else {
          ++(fo->obj_num);
          fo->objs=(struct object *)realloc_n(fo->objs, fo->obj_num * sizeof(struct object));
          mem_er((fo->objs == NULL) ? 0 : 1, fo->obj_num*sizeof(struct object));

       }

       ob = (fo->objs) + fo->obj_num - 1;
       ob->pt = NULL;
       ob->ext = NULL;
       ob->bound = NULL;
       ob->fet = NULL;
       ob->point_num = 0;
       ob->bound_num = 0;

       ob->fet = (struct features *)malloc(sizeof(struct features));
       mem_er((ob->fet == NULL) ? 0 : 1, sizeof(struct features));

       ob->fet->fpt = (struct feature_pts *)malloc(sizeof(struct feature_pts));
       mem_er((ob->fet->fpt == NULL) ? 0 : 1, sizeof(struct feature_pts));

       ob->fet->feature_num = 1;

       fp = ob->fet->fpt;
       sscanf(tok[11], "%d", &dvar);
       (fp->y).xy = (float) dvar * 0.1;
       sscanf(tok[12], "%d", &dvar);
       (fp->x).xy = (float) dvar * 0.1;
       if(dvar < 0) (fp->x).xy = 360.0 + (float) dvar * 0.1;
       sscanf(tok[vstrpos[ivar]-1], "%d", &dvar);
       fp->str = (float) dvar * scale[ivar];
       strncpy(ctim, tok[7], 8);
       ctim[8] = '\0';
       ++(fo->tot_f_f_num);

    }

    objectd(fo, fout, fnum, 4);

    fclose(fout);
    fclose(fin);

    return 0;

}
