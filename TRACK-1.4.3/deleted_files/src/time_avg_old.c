#include <Stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "grid.h"
#include "files_out.h"
#include "file_handle.h"
#include "mem_er.h"
#include "utf.h"

/* function to compute time average */

extern GRID *gr;
extern int frnum;
extern int form;
extern int eqsw;
extern int utfv;
extern int i_utf4x, i_utf4y;

extern float *abuf;

float ssc;

static char *chrfld=NULL;

int rf(FILE * ,FILE * , int , int );

void time_avg(FILE *fdat, int fr1, int fri, int frl)

{

   int i, nf=0, ad=0;
   int dim=0;
   int ic1, ic2;
   int ifv;
   int nft=NFT;

   int wf='a';

   float tmax, tmin;
   float scl, fscl;
   float fv;

   float *ata=NULL;

   long int chrnum=0, place1, place2;

   FILE *ftav=NULL;

   if(form < 2) dim = gr->ix * gr->iy;
   else if (form == 2){
      if(utfv == 3) dim=gr->ix * ((eqsw) ? gr->iy + 1 : gr->iy);
      else if(utfv == 4) dim = i_utf4x * i_utf4y;

   }

   printf("Do you want all frames in data file to contribute to the \r\n"
          "time average, or just those frames selected, 'a' or 's'. \n\n");
 

   scanf("\n");
   wf = getchar();

   if(wf == 'a' ){fr1 = 1; fri = 1; frl = frnum;}

   else if (wf != 's'){

      printf("***WARNING***, incorrect decriptor for time average calculation\r\n"
             "               defaulting to 'a' (all).                        \n\n");

      wf = 'a';
      fr1 = 1; fri = 1; frl = frnum;

   }


   printf("***INFORMATON***, Computing Time Average of Data....\r\n\n"
          "                                                    \r\n\n"
          " Please Wait, this may take some time ..............  \n\n");

   ata = (float *)calloc(dim, sizeof(float));
   mem_er((ata == NULL) ? 0 : 1);


/* initialize time average */

   for(i=0; i<dim; i++) *(ata + i) = 0.0;


/* open file for writing the time average */

   ftav = open_file(TAVGE, "w");

/* read in field data */

   while(nf < frnum){

        if(!nf) {

           place1 = ftell(fdat);
           rf(fdat, ftav, dim, 1);

           if(fr1 == 1){
              for(i=0; i<dim; i++) *(ata + i) += *(abuf+i);

              ++nf;
           }

           place2 = ftell(fdat);
           chrnum = place2 - place1;

           if(fr1 > 1){

              fseek(fdat, (fr1-2)*chrnum, ORIGIN);
              rf(fdat, ftav, dim, 0);
              for(i=0; i<dim; i++) *(ata + i) += *(abuf+i);
              nf = fr1;             

           }

           continue;

        }

        fseek(fdat, (fri-1)*chrnum, ORIGIN);

        if(rf(fdat, ftav, dim, 0)) break;          
        for(i=0; i<dim; i++) *(ata + i) += *(abuf+i);

        nf += fri;

        if(nf > frl) break;

   }



/* average the field */
   
   for(i=0; i<dim; i++) *(ata + i) /= nf;

/* write to file */

   if(form == 0){

      if(fwrite(ata, sizeof(float), dim, ftav) != dim){
         printf("***ERROR***, writing time average data, aborting\n");
         exit(1);
      }
      fprintf(ftav, "\n");

   }

   else if(form == 1){

      ad = 0;

      for(i=0; i<dim; i++){

          fprintf(ftav, "%12.5e ", *(ata + i));
          if((++ad) == 10){fprintf(ftav, "\n"); ad = 0;}

      }

      fprintf(ftav, "\n");

   }

   else if(form == 2){

/* compute max and min values of field */

       tmax = tmin = *ata;

       for(i=0; i< dim; i++){

           fv = *(ata + i);
           if(fv > tmax) tmax = fv;
           if(fv < tmin) tmin = fv;

       }

       fprintf(ftav, "%14.7e %17.7e %14.7e\n", tmin, tmax, ssc);

       scl = ARNG/ (tmax - tmin);

       ad = 0;

       for(i=0; i<dim; i++){


          fscl = (*(ata + i) - tmin) * scl;
          ifv = (int) (fscl >= 0.) ? fscl + 0.5 : fscl - 0.5;
          if(ifv > ARNG) ifv = ARNG;
          if(ifv < 0) ifv = 0;
          ic1 = (ifv / CNUM);
          ic2 = (ifv % CNUM);
          fprintf(ftav, "%c%c", lkup[ic1], lkup[ic2]);

          if((++ad) == nft){fprintf(ftav, "\n"); ad = 0;}



      }

      fprintf(ftav, "\n");

   }

   close_file(ftav, "TAVGE");

   if(chrfld) free(chrfld);

   free(ata);

   printf("\n");

   return;

}

void read_chr_field(FILE * , int , int , char * , int );
 

int rf(FILE *fdat, FILE *ftav, int dim, int hf)

{

   int i, k, ad=0;
   int br=0;
   int dum;
   int ic[CHMX];
   int isum;

   static int nchr=0;
   static int ixx=0, iyy=0;

   float scl;
   float tmax, tmin;
   float arng = ARNG;
   float ffmx, ffmn, frng, fmax;

   char text[MAXCHR];
   char *ih=NULL;
   char *icp=NULL;
   char ii[CHMX];

   if(form == 0 || form == 1){

      fscanf(fdat, "%s %*d\n", text);
      if(hf)fprintf(ftav, "%s  %d\n", text, 1);
      if(form == 0) {
         if(fread(abuf, sizeof(float), dim, fdat) != dim){
            printf("***ERROR***, reading field data in %s at %d\n", __FILE__, __LINE__);
            exit(1); 

         }
      }
      else {for(i=0; i<dim; i++)fscanf(fdat, "%e", (abuf+i));}
      fscanf(fdat, "\n");


   }

   else if(form == 2){


          for(i=0; i<3; i++){

             if(!fgets(text, MAXCHR, fdat)) {br = 1; break;}
             if(strstr(text, "***END OF DATA***")) {br = 1; break;}
             if(hf){

                if(i < 2) fprintf(ftav, "%s", text);
                else{

                   ih = strtok(text, " ");

                   while(ih){

                     if(sscanf(ih, "%d", &dum)){

                       ++ad;
                       switch(ad){
                          case 1:
                             ixx = dum;
                             break;
                          case 2:
                             iyy = dum;
                             break;
                          case 10:
                             nchr = dum;
if(nchr == 0) nchr = 2;
                             if(nchr > CHMX){
                                printf("***ERROR***, to many charcters per number at decoding.\n");
                                exit(1);
                             }
                             break;
                       }
                       if(ad == 10) fprintf(ftav, "%d  ", 2);
                       else fprintf(ftav, "%d  ", dum);


                     }

                     ih = strtok(NULL, " ");


                   }
                   ad = 0;
                   fprintf(ftav, "\n");

                }

             }


          }

          if(br) return 1;

          if(!chrfld){

             chrfld = (char *)calloc((ixx*iyy+1)*nchr, sizeof(char));
             mem_er((chrfld == NULL) ? 0 : 1);

          }

          arng = pow((float)CNUM, (float)nchr) - 1.0;

          fscanf(fdat, "%e %e %e\n", &tmin, &tmax, &ssc);  

          ffmx = fabs(tmax);
          ffmn = fabs(tmin);

          fmax = (ffmx > ffmn) ? ffmx : ffmn;

          frng = tmax - tmin;

          if(frng <= fmax*FTOL)
             scl = 0.;
          else
             scl = frng/arng;        

          read_chr_field(fdat, ixx, iyy, chrfld, nchr);

          icp = chrfld;

          for(i=0; i<dim; i++){

            strncpy(ii, icp, nchr);
            icp += nchr;
            isum = 0;
            for(k=0; k < nchr; k++) {

               isum *= CNUM;

               ic[k] = (int)strchr(lkup, ii[k])-(int) lkup;
               if(ic[k] > CNUM){

                 printf("***error***, illegal character in data field\n");
                 exit(1);

               }

               isum += ic[k];

            }

            

            *(abuf + i) = (float)isum * scl + tmin;

         }

   }

   printf("#");

   return 0;



}
