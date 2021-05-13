#include <Stdio.h>
#include <stdlib.h>
#include <string.h>
#include <Math.h>
#include "grid.h"
#include "mem_er.h"
#include "utf.h"

#define  INV      -1.0

void read_chr_field(FILE * , int , int , char * , int );

extern int tl, gof;
extern float offs, ilat;

extern GRID *gr;
extern int eqsw;
extern int whemi;
extern int nhp;

char *chrfld=NULL;


/* function to read in each field of data and apply an offset if required */

int utf4_read_field(float *ap, float *ata, float scl, FILE *fdatin, int sign, int as, int of, int hemi, int tscl)

{

    int i, j, k;
    int pp=0, plus;
    int ic[CHMX];
    int iyh=0;
    int isum=0;
    int dum;
    static int nchr=0;
    static int iwmis=0;
    int ixx=0, iyy=0;
    int nx=0;

    float fmx, fmn, fsc;
    float scale;
    float arng=ARNG;
    float ffmx, ffmn, frng, fmax;

    char ii[CHMX];
    char *icp;
    char text[MAXCHR];

    float *at;
    float yy;

    if(gr->gcen){
       printf("****WARNING****, no field translation currently implemented for UTF\n\n");
       gr->gcen = 0;

    }

    if(eqsw) {

       iyh = (gr->iy - 1) / 2;

       if(whemi){

          if(whemi == 1) iyh = gr->iy;
          else iyh = 0;


       }

    }

    if(!fgets(text, MAXCHR, fdatin)) return 1;

    if(REPORT) printf("\n%s\n", text);


    if(strstr(text, EOD)){
      printf("***WARNING***, encountered end of data statement\n\n");
      return 1;
    }
    fgets(text, MAXCHR, fdatin);

    if(REPORT) printf("\n%s\n", text);

    for(i=0; i < MHD; i++){
         
       fscanf(fdatin, "%d", &dum);
       switch(i){
            case 0:
              ixx = dum;
              break;
            case 1:
              iyy = dum;
              break;
            case 9:

              if(dum > CHMX){
                 printf("***ERROR***, to many charcters per number at decoding.\n");
                 exit(1);
              }

              if(!chrfld){

                 chrfld = (char *)calloc((ixx*iyy+1)*dum, sizeof(char));
                 mem_er((chrfld == NULL) ? 0 : 1);

              }

              else if(dum != nchr){
                 chrfld = (char *)realloc_n(chrfld, (ixx*iyy+1)*dum*sizeof(char));
                 mem_er_realloc((chrfld == NULL) ? 0 : 1, (ixx*iyy+1)*dum*sizeof(char));
              }
              nchr = dum;

            break;
       }
       fscanf(fdatin, "\n");

    }

    icp = chrfld;


    arng = pow((float)CNUM, (float)nchr) - 1.0;

    fscanf(fdatin, "%e %e %e\n", &fmn, &fmx, &fsc);

    read_chr_field(fdatin, ixx, iyy, chrfld, nchr);

    ffmx = fabs(fmx);
    ffmn = fabs(fmn);

    fmax = (ffmx > ffmn) ? ffmx : ffmn;

    frng = fmx - fmn;

    if(frng <= fmax*FTOL)
       scale = 0.;
    else
       scale = frng/arng;

    if(nhp == 'n') icp += nx*nchr;

    nx = (gr->igc) ? gr->ix -1 : gr->ix;

    
    for(j=0; j < gr->iy; j++){

       if(gr->h_inv) pp = j * gr->ix;
       else pp = (gr->iy - j - 1) * gr->ix;
       yy = *(gr->ygrid + j) * (-1.0);

       if(j == iyh && eqsw) icp += (nx*nchr);

       for(i=0; i < nx; i++) {

          if(tl == 'n') plus = pp + i;

          else if(gof >= 0){

             k = i + gof;
             if(k >= gr->ix) k -= nx;
             plus = pp + k;

          }

          else{

             k = i + gof;
             if(k < 0) k += nx;
             plus = pp + k;

          }

          at = ap+plus;



          strncpy(ii, icp, nchr);
          icp += nchr;
          isum = 0;

          for(k=0; k<nchr; k++) {

             if(ii[k] == CMISS){
                isum = -1; 
                if(!iwmis){
                   printf("****WARNING****, missing data values have been encountered in this data.\n\n");
                   iwmis = 1;
                }        
                break;
             }

             isum *= CNUM;

             ic[k] = (int)strchr(lkup, ii[k])-(int) lkup;

             if(ic[k] > CNUM || ic[k] < 0){

               printf("***error***, illegal character in data field, character %c\n", ic[k]);
               exit(1);

             }

             isum += ic[k];

          }

          if(isum < 0) *at = VMISS;
          else *at = (float)isum * scale + fmn;       

          if(tscl == 'y') *at *= scl;

          if(as == 'y') *at = *at - *(ata+plus); 

          if(of == 'y') *at -= offs;

          *at *= sign;

          if(hemi == 'n' && yy > ilat) *at *= INV;
          else if(hemi == 's' && yy < ilat) *at *= INV;

       }


       if(gr->igc) {

          if(gof > 0) *(ap + pp) = *(ap + pp + gr->ix - 1);
          else if (gof <= 0) *(ap + pp + gr->ix - 1) = *(ap + pp); 

       }

       if(!gr->igtyp) icp += nchr;


    }

    return 0;

}

void read_chr_field(FILE *fdatin, int ix, int iy, char *chrf, int nchr)

{

     int dim=ix*iy*nchr;
     int iff=0, slen=0;
     int mxchr=2*RECL, rlen=RECL;
     static int rltst=-1;

     char buff[2*RECL];

     *chrf = '\0';

     if((rlen % nchr)){
        printf("***ERROR***, data record does not contain a complete set of encoded numbers.\n\n");
        exit(1);

     } 

     while(iff < dim){

         iff += rlen;

         fgets(buff, mxchr, fdatin);

         slen = strlen(buff) - 1;

         if(rltst < 0 && slen != rlen && iff < dim) rltst = 1;

         if(rltst > 0){

            printf("***WARNING***, the data field may have an incorrect record length.\n");
            rltst = 0;

         }

         if(iff < dim) slen = rlen;
 
         strncat(chrf, buff, slen);


     }

     return;

}
