#include <stdio.h>
#include <stdlib.h>
#include "mem_er.h"

#define MAXCHR 500

int main()
{

   int i, j, k;
   int ntr=0;
   int idim=0;
   int trnum=0, ntheta=0, nr=0, nwfld=0;
   int nntheta=0, nnr=0, nnwfld=0;
   int idir=0, nidir=0;
   int ndsmth=0, nndsmth;
   int ifcnt=0, itpadd=0, iprojd=0;
   int nifcnt=0, nitpadd=0, niprojd=0;

   int nfil=0;

   long int ptnum=0, nptnum=0;

   float *ff=NULL;
   float *flat=NULL, *flng=NULL;

   FILE *fin=NULL, *fout=NULL;

   char filnam[MAXCHR];
   char line[200];

   printf("How many regional files are there to combine?\n\n");
   scanf("%d", &nfil);

   fout = fopen("combined_reg", "w");
   if(!fout){
      printf("****ERROR****, can't open file 'combined_reg' for write.\n\n");
      exit(1);
   }

   fprintf(fout, "%6d %10ld %6d %6d %2d %2d %3d %2d %2d %2d\n", trnum, ptnum, ntheta, nr, nwfld, idir, ndsmth, ifcnt, itpadd, iprojd);

   for(i=0; i < nfil; i++){
       printf("What is the next file to read?\n\n");
       scanf("%s", filnam);
       fin = fopen(filnam, "r");
       if(!fin){
          printf("****ERROR****, can't open file %s for read.\n\n", filnam);
          exit(1);
       }

       fgets(line, 100, fin);
       sscanf(line, "%d %ld %d %d %d %d %d %d %d %d", &trnum, &ptnum, &ntheta, &nr, &nwfld, &idir, &ndsmth, &ifcnt, &itpadd, &iprojd);

       if(!i) {
          idim = nr * ntheta;
          ff = (float *)calloc(idim, sizeof(float));
          mem_er((ff == NULL) ? 0 : 1, idim*sizeof(float));

          flng = (float *)calloc(ntheta, sizeof(float));
          mem_er((flng == NULL) ? 0 : 1, ntheta*sizeof(float));

          flat = (float *)calloc(nr, sizeof(float));
          mem_er((flat == NULL) ? 0 : 1, nr*sizeof(float));

       }
       else{
          if(ntheta != nntheta || nr != nnr || nwfld != nnwfld || idir != nidir || 
             ndsmth != nndsmth || nifcnt != ifcnt || nitpadd != itpadd || niprojd != iprojd){
             printf("****ERROR****, incompatable data for this file.\n\n");
             exit(1);
          }
       }

       fread(flng, ntheta * sizeof(float), 1, fin);
       fscanf(fin, "%*c");
       fread(flat, nr * sizeof(float), 1, fin);
       fscanf(fin, "%*c");

       if(!i){
          fwrite(flng, ntheta * sizeof(float), 1, fout);
          fprintf(fout, "\n");
          fwrite(flat, nr * sizeof(float), 1, fout);
          fprintf(fout, "\n");
       }

       for(j=0; j < ptnum; j++){
           for(k=0; k < nwfld; k++){
              fread(ff, idim * sizeof(float), 1, fin);
              fscanf(fin, "%*c");
              fwrite(ff, idim * sizeof(float), 1, fout);
              fprintf(fout, "\n");
           }

       }

       fclose(fin);
       fin = NULL;

       ntr += trnum;
       nptnum += ptnum;

       nntheta = ntheta;
       nnr = nr;
       nnwfld = nwfld;
       nidir = idir;
       nndsmth = ndsmth;
       nifcnt = ifcnt;
       nitpadd = itpadd;
       niprojd = iprojd;
       
   }

   fseeko(fout, 0L, SEEK_SET);

   fprintf(fout, "%6d %10ld %6d %6d %2d %2d %3d %2d %2d %2d\n", ntr, nptnum, nntheta, nnr, nnwfld, idir, ndsmth, ifcnt, itpadd, iprojd);   

   fclose(fout);

   free(ff);

   return 0;

}
