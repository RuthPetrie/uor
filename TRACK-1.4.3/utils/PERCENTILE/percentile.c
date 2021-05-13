#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define  MAXCHR   200

void main(void)
{

  int i, j, k;
  int dim=0;
  int nbin=0, ntim=0;
  int nfil=0;
  int ib, ii;

  int itim, ix, iy;

  float *xgr=NULL, *ygr=NULL;
  float *arr=NULL;
  float **bins=NULL, *binb=NULL;
  float *perc=NULL;

  float rng1, rng2, binw;
  float scl, perct;

  float sum=0.0;

  FILE *fin=NULL, *fout=NULL;

  char infil[MAXCHR];
  char line[MAXCHR];

  printf("How many files are there?\n\n");
  scanf("%d", &nfil);

  printf("What is the first file to use?\n\n");
  scanf("%s", infil);

  printf("What is the range to use?\n\n");
  scanf("%f %f", &rng1, &rng2);

  printf("How many bins should be used?\n\n");
  scanf("%d", &nbin);

  binw = (rng2 - rng1) / (float) nbin;

  binb = (float *)calloc(nbin, sizeof(float));

  for(i=0; i < nbin; i++){
     *(binb + i) = rng1 + 0.5 * binw + i * binw;
     printf("%f\n", *(binb+i));
  }

  printf("What scaling factor is required?\n\n");
  scanf("%f", &scl);

  printf("What percentile is required?\n\n");
  scanf("%f", &perct);

  fin = fopen(infil, "r");
  if(!fin){
     printf("****ERROR****, can't open file %s for read.\n\n", infil);
     exit(1);
  }
  
  fgets(line, MAXCHR, fin);
  sscanf(line, "%d %d %d", &ix, &iy, &itim);
  dim = ix * iy;

  xgr = (float *)calloc(ix, sizeof(float));
  ygr = (float *)calloc(iy, sizeof(float));
  arr = (float *)calloc(dim, sizeof(float));
  perc = (float *)calloc(dim, sizeof(float));
  bins = (float **)calloc(dim, sizeof(float *));

  for(i=0; i < dim; i++){
     *(bins + i) = (float *)calloc(nbin, sizeof(float));
  }

  for(i=0; i < ix; i++) fscanf(fin, "%f", xgr + i);
  fgets(line, MAXCHR, fin);
  for(i=0; i < iy; i++) fscanf(fin, "%f", ygr + i);
  fgets(line, MAXCHR, fin);

  fclose(fin);


  for(i=0; i < nfil; i++){

      printf("What is the new file?\n\n");
      scanf("%s", infil);
      fin = fopen(infil, "r");
      if(!fin){
         printf("****ERROR****, can't open file %s for read.\n\n", infil);
         exit(1);
      }

      fgets(line, MAXCHR, fin);
      sscanf(line, "%d %d %d", &ix, &iy, &itim);
      for(j=0; j < ix; j++) fscanf(fin, "%f", xgr + j);
      fgets(line, MAXCHR, fin);
      for(j=0; j < iy; j++) fscanf(fin, "%f", ygr + j);
      fgets(line, MAXCHR, fin);

      for(j=0; j < itim; j++){
          fgets(line, MAXCHR, fin);
          fread(arr, dim*sizeof(float), 1, fin);
          fgets(line, MAXCHR, fin);
          for(k=0; k < dim; k++){
              ib = (int)((*(arr + k) * scl - rng1) / binw);
              *(*(bins + k) + ib) += 1.0;
              if(ib < 0 || ib > nbin - 1){
                 printf("****WARNING****, bin out of range for value %f at time step %d\n\n", *(arr + k) * scl, j+1);
              }
          }

      }

      fclose(fin);

      ntim += itim;

  }

  for(i=0; i < dim; i++){
      for(j=0; j < nbin; j++){
          *(*(bins + i) + j) /= ntim;
      }
  }

  for(i=0; i < dim; i++){
      sum = 0.0;
      for(j=nbin-1; j >= 0; j--){
         if(sum > perct){
           ib = j;
           break;
         }
         sum += *(*(bins + i) + j);
      }
      *(perc + i) = *(binb + ib);
  }

  fout = fopen("perc.dat", "w");
  fprintf(fout, "%4d %4d %2d\n", ix, iy, 1);

  ii = 0;
  for(i=0; i < ix; i++){
      fprintf(fout, "%10.4f ", *(xgr + i));
      ++ii;
      if(ii == 10){fprintf(fout, "\n"); ii = 0;}
  }
  if(ii) fprintf(fout, "\n");

  ii = 0;

  for(i=0; i < iy; i++){
      fprintf(fout, "%10.4f ", *(ygr + i));
      ++ii;
      if(ii == 10){fprintf(fout, "\n"); ii = 0;}
  }
  if(ii) fprintf(fout, "\n");

  fprintf(fout, "FRAME     1\n");
  fwrite(perc, dim * sizeof(float), 1, fout);

  fclose(fout);

  return;
}
