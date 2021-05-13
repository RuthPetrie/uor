#include <Stdio.h>
#include <stdlib.h>
#include <string.h>
#include <Math.h>
#include <sys/types.h>
#include "mem_er.h"
#include "grid.h"
#include "file_handle.h"
#include "files_out.h"
#include "pp.h"
#include "utf.h"
#include "netcdf_info.h"
#include "m_values.h"

#define TOLGAUSS   1.0e-3
#define  NCHRB  30

/* function to perform spatial spectral filtering on an instantaneous field using the
   fast spectral transform, including conversion from non-gaussian grid to gaussian
   grid prior to applying the transform.                                              */

#ifdef  FFTLIB

#ifdef  NOUNDERSCORE

void setgpfa(double * , int * , int * );
void gpfa(double * , double * , double * , int * , int * , int * , int * , int *, int * );

#else

void setgpfa_(double * , int * , int * );
void gpfa_(double * , double * , double * , int * , int * , int * , int * , int *, int * );

#endif

#endif

int powi(int , int );
double legendre_node(int , int , double * );
int create_spherical_basis(GRID * , int );
int read_field(float * ,float * , float , FILE * , int , int , int , int , int );
void write_header(GRID * , FILE * );
double hoskins_filt(float , double );
GRID *gauss_grid(int );
int temptest(int * , int );

extern GRID *gr;
extern int form;   
extern complex *yt;
extern int iext;
extern char *fext;

void fast_spectral_filter(FILE *fdat, int fr1, int fri, int frl)
{
    int i, j, k, n;
    int nf=0, nx=0, nxx=0, nxmax=0, nln=0;
    int ncof=0;
    int ifr=0;

    int nj[3], nj_n[3];
    int inc=1, lot=1, idir=1, indir=-1;
    int jump=0;
    int dimtrg=0, dimtrg_n=0;

    int fres='n';
    int gty=0;
    int ng='n';
    int nmax=0;

    int ngauss=0;
    int dim=gr->ix * gr->iy, dimn=0;
    int nlat2=0, nlng=0;
    int ntrunc=0, ntrunc_n=0, ntr1=0;
    int nttmp1=0, nttmp2=0;

    int nband=0;
    int *bands=NULL;

    off_t place1, place2, chrnum=0;

    char filename[MAXCHR], band_id[NCHRB];

    FILE **filspec=NULL, *fg=NULL;

    GRID *newg=NULL;

    float *ap=NULL, *app=NULL;
    float fmax, fval;
    float cut;

    float **ifilt=NULL;
    float *hf=NULL;

    double legnod=0.0;
    double *freal=NULL, *fimag=NULL;
    double *trigs=NULL, *trigs_n=NULL;
    double *legwt=NULL;
    double pin=0.0, pin1=0.0, pin2=0.0;
    double nsq, cutf;

    complex *cfft1=NULL, *cfft2=NULL, *cff=NULL;
    complex *cof=NULL, *ctmp=NULL;
    complex plf1, plf2, coft;

    printf("****WARNING****, data must currentely be defined on a global domain\r\n"
           "                 and have no missing data values.                  \n\n");

    if(form == 4){

       if(((NETCDF_INFO *)fdat)->imiss){
          printf("****WARNING****, there are possible missing values in the data.\n\n");
       }

    }

/* normalization for foreward Legendre-FFT */
    pin1 = ((double)(gr->ix) * sqrt(2.0 * FPI2));
/* normalization for backward Legendre-FFT */
    pin2 = FPI2 / pin1;


    ap=(float *)calloc(dim, sizeof(float));
    mem_er((ap == NULL) ? 0: 1, dim * sizeof(float));

/* check if grid is gaussian */

    if(gr->ixfrm){
       printf("****ERROR****, grid is not uniform in X.\n\n");
       exit(1);
    }

    if(gr->igtyp > 1){
       printf("****ERROR****, not a global grid, can only handle global grids at the moment.\n\n");
       exit(1);
    }

    ngauss = gr->ix / 2;
 
    if(ngauss == gr->iy && !(ngauss % 2) && gr->iyfrm){

       legwt = (double *)calloc(ngauss, sizeof(double));
       mem_er((legwt == NULL) ? 0 : 1, ngauss*sizeof(double));

/* possible gaussian grid */
       nlat2 = gr->iy / 2;
       for(i=0; i < nlat2; i++){
           legnod = (FP_PI2 - acos(legendre_node(nlat2 - i, gr->iy, legwt + nlat2 - i - 1))) / FP_PI;
           if(fabs(*(gr->ygrid + nlat2 + i) - legnod) > TOLGAUSS){
              printf("****ERROR****, currently only gaussian grids are supported.\n\n");
              exit(1);   
           }
       }

       for(i=0; i < nlat2; i++) *(legwt + ngauss - i - 1) = *(legwt + i);
    }
    else {
       printf("****ERROR****, currently only gaussian grids are supported.\n\n");
       exit(1);
    }

/* check for gaussian grid type */

    nlng = 4;
    nttmp1 = 1;
    while(nlng != gr->ix){
         ++nttmp1;
         nlng = (2 * nttmp1 + 1);
         if(nlng % 2) nlng += 1;
         if(nlng % 4) nlng += 2;
         if(nlng == gr->ix){
            printf("****INFORMATION****, grid looks like a T%d linear gaussian grid.\n\n", nttmp1);
            break;
         }
         else if(nlng > gr->ix) {
            nttmp1 = -1;
            break;
         }
    }

    nlng = 4;
    nttmp2 = 1;
    while(nlng != gr->ix){
          ++nttmp2;
          nlng = (3 * nttmp2 + 1);
          if(nlng % 2) nlng += 1;
          if(nlng % 4) nlng += 2;
          if(nlng == gr->ix){
             printf("****INFORMATION****, grid looks like a T%d quadratic gaussian grid.\n\n", nttmp2);
             break;
          }
          else if(nlng > gr->ix){
            nttmp2 = -1;
            break;
       }
    }

    if(nttmp1 < 0 || nttmp2 < 0){
       printf("****ERROR****, grid incompatable with a gaussian Legendre transform.\n\n");
       exit(1);
    }


    printf("What spectral truncation is required?\n\n");
    scanf("%d", &ntrunc);

    ntr1 = ntrunc + 1;

    if(ntrunc < 0){
       printf("****ERROR****, truncation must be positive.\n\n");
       exit(1);
    }

    if(ntrunc > nttmp1){
       printf("****WARNING****, truncation may not be compatable with the grid.\n\n");
       exit(1);
    }

    create_spherical_basis(gr, ntrunc);
    free(gr->sico);

/* only store one half of triangular truncation since transform is real */

    ncof = ((ntrunc + 1) * (ntrunc + 2)) / 2;

    cof = (complex *)calloc(ncof, sizeof(complex));
    mem_er((cof == NULL) ? 0 : 1, ncof * sizeof(complex));

    cfft1 = (complex *)calloc(dim, sizeof(complex));
    mem_er((cfft1 == NULL) ? 0 : 1, dim * sizeof(complex));

/* setup output grid */

   printf("Do you want to output filtered data on a new grid? 'y' or 'n'\n\n");
   scanf("\n");
   if((ng = getchar()) == 'y') {

       printf("Read grid from file, input '0', or create a Gaussian grid, input '1'\n");
       scanf("%d", &gty);

       if(!gty){

          newg = (GRID *)malloc_initl(sizeof(GRID));
          mem_er((newg == NULL) ? 0 : 1, sizeof(GRID));

          printf("What is the filname for the grid data?\n");
          scanf("%s", filename);

          fg = open_file(filename, "r");

          fscanf(fg, "%d %d", &(newg->ix), &(newg->iy));

          newg->xgrid = (float *)calloc(newg->ix, sizeof(float));
          mem_er((newg->xgrid == NULL) ? 0 : 1, newg->ix * sizeof(float));

          newg->ygrid = (float *)calloc(newg->iy, sizeof(float));
          mem_er((newg->ygrid == NULL) ? 0 : 1, newg->iy * sizeof(float));

          for(i=0; i < newg->ix; i++) fscanf(fg, "%f", newg->xgrid + i);
          for(i=0; i < newg->iy; i++) fscanf(fg, "%f", newg->ygrid + i);

          close_file(fg, filename);
          ntrunc_n = ntrunc;

       }

       else {
          printf("What is the spectral truncation (triangular) for the output gaussian grid?\n");
          scanf("%d", &ntrunc_n);

          if(ntrunc_n < 0){
             printf("****ERROR****, truncation must be positive, exiting.\n\n");
             exit(1);
          }
          if(ntrunc_n > nttmp1){
             printf("****ERROR****, truncation not compatable with the grid.\n\n");
             exit(1);
          }
          newg = gauss_grid(ntrunc_n);

          --(newg->ix);
       }

       create_spherical_basis(newg, ntrunc);
       free(newg->sico);

       dimn = newg->ix * newg->iy;

       app=(float *)calloc(dimn, sizeof(float));
       mem_er((app == NULL) ? 0: 1, dimn * sizeof(float)); 

       cfft2 = (complex *)calloc(dimn, sizeof(complex));
       mem_er((cfft2 == NULL) ? 0 : 1, dimn * sizeof(complex));

   }

   else {newg = gr; dimn = dim; app = ap; ntrunc_n = ntrunc; cfft2 = cfft1;}

/* setup filters */

   printf("How many filter bands are required?\n\n");
   scanf("%d", &nband);

   if(nband <= 0){
      printf("****ERROR****, number of bands must be greater than zero\n\n");
      exit(1);
   }

/* hoskins filter */

   hf = (float *)calloc(ntr1, sizeof(float));
   mem_er((hf == NULL) ? 0 : 1, ntr1 * sizeof(float));

   for(i=0; i<ntr1; i++) *(hf + i) = 1.0;

   printf("Do you want to apply further filtering in the form of the Hoskins filter, 'y' or 'n'\n");
   scanf("\n");

   if(getchar() == 'y'){

      printf("What is the cutoff constant value?\r\n"
             "Typicaly a value of 0.1 is used.  \n\n");

      scanf("%f", &cut);

      nsq = (float) ntrunc * (float) ntr1;
      nsq *= nsq;

      cutf = - log((double) cut) / nsq;

      for(i=0; i<ntr1; i++) *(hf + i) = hoskins_filt((float) i, cutf);

   }

   bands = (int *)calloc(nband+1, sizeof(int));
   mem_er((bands == NULL) ? 0 : 1, (nband+1) * sizeof(int));

   ifilt = (float **)calloc(nband, sizeof(float *));
   mem_er((ifilt == NULL) ? 0 : 1, nband * sizeof(float *));


   printf("Input the band boundaries in terms of total wavenumber.\n");

   for(i=0; i <= nband; i++){

      printf("Boundary %d = ", i+1);
      scanf("%d", bands+i);
      printf("\n");

      if(*(bands+i) < 0) {
         printf("****WARNING****, band boundary cannot be negative, resetting to zero.\n\n");
         *(bands + i) = 0;
      }
      else if(*(bands+i) > ntrunc) {
         printf("****WARNING****, maximum band boundary cannot be greater than truncation, resetting to truncation.\n\n");
         *(bands + i) = ntrunc;
      }

   }

   for(i=0; i < nband; i++){

      *(ifilt + i) = (float *)calloc(ntr1, sizeof(float));
      mem_er((*(ifilt + i) == NULL) ? 0 : 1, ntr1 * sizeof(float));
      memset(*(ifilt + i), 0, ntr1 * sizeof(float));

      for(j=*(bands + i)+((i)?1:0); j<= *(bands + i + 1); j++) *(ifilt[i] + j) = *(hf + j);

   }



/* restrict field values */

   printf("If field values are likely to be large, do you wish to restrict\r\n"
           "them before filtering, 'y' or 'n'?                             \n\n");

   scanf("\n");
   if((fres = getchar()) == 'y'){

      printf("Input the upper bound value in the same units as the current field.\n\n");
      scanf("%f", &fmax);

      printf("What value to do you want to reset large values to?\n");
      scanf("%f", &fval);

   }


/* setup arrays for FFT coefficients */

   nxmax = (gr->ix > newg->ix) ? gr->ix : newg->ix;


#ifdef  FFTLIB

/* test for valid number of longitude points for Temperton */

    if(!temptest(nj, gr->ix)) exit(1);
    if(ng == 'y') {if(!temptest(nj_n, newg->ix)) exit(1);}
    else {nj_n[0] = nj[0]; nj_n[1] = nj[1]; nj_n[2] = nj[2];}

    dimtrg = powi(2, nj[0]) + powi(3, nj[1]) + powi(5, nj[2]);
    dimtrg *= 2;

    freal = (double *)calloc(nxmax, sizeof(double));
    mem_er((freal == NULL) ? 0 : 1, nmax*sizeof(double));

    fimag = (double *)calloc(nxmax, sizeof(double));
    mem_er((fimag == NULL) ? 0 : 1, nmax*sizeof(double));

    trigs = (double *)calloc(dimtrg, sizeof(double));
    mem_er((trigs == NULL) ? 0 : 1, dimtrg*sizeof(double));

    if(ng == 'y'){
       dimtrg_n = powi(2, nj_n[0]) + powi(3, nj_n[1]) + powi(5, nj_n[2]);
       dimtrg_n *= 2;

       trigs_n = (double *)calloc(dimtrg_n, sizeof(double));
       mem_er((trigs == NULL) ? 0 : 1, dimtrg_n*sizeof(double));
    }

#ifdef  NOUNDERSCORE

    setgpfa(trigs, &(gr->ix), nj);
    if(ng == 'y')setgpfa(trigs_n, &(newg->ix), nj_n);
#else

    setgpfa_(trigs, &(gr->ix), nj);
    if(ng == 'y')setgpfa_(trigs_n, &(newg->ix), nj_n);

#endif

    if(! (ng == 'y')){
       dimtrg_n = dimtrg;
       trigs_n = trigs;
    }

#else
    printf("****WARNING****, must build and link fft library to use temperton FFT.\n\n");
    exit(1);
 
#endif

    nx = gr->ix;
    nxx = newg->ix;

/* assign memory for output file pointers */

    filspec = (FILE **)calloc(nband, sizeof(FILE *));
    mem_er((filspec == NULL) ? 0 : 1, nband * sizeof(FILE *));

/* open files for writing filtered fields */

   for(i=0; i < nband; i++){
       sprintf(band_id, "_band%03d", i);
       strncpy(filename, SPECTRAL, MAXCHR);
       if(iext) strcpy(strstr(filename, EXTENSION), fext);
       strcat(filename, band_id);

       filspec[i] = open_file(filename, "w");

/* write header */

       write_header(newg, filspec[i]);

   }

    nf = 0;

    while(nf <= frl){

         if(form != 4){

            if(!nf) {

               place1 = ftello(fdat); 
 
               if(read_field(ap, NULL, 1.0, fdat, 1.0, 'n', 'n', '0', 'n'))break;        

               if(fr1 == 1) ++nf;;
 
               place2 = ftello(fdat);
               chrnum = place2 - place1;

               if(fr1 > 1){

                  fseeko(fdat, (fr1-2)*chrnum, ORIGIN);
                  if(read_field(ap, NULL, 1.0, fdat, 1.0, 'n', 'n', '0', 'n'))break;

                  nf = fr1;           

               }

               nf += fri;

/* need to reset header strings for new grid */

            }

            else {

               fseeko(fdat, (fri-1)*chrnum, ORIGIN);
               if(read_field(ap, NULL, 1.0, fdat, 1.0, 'n', 'n', '0', 'n'))break;
          
               nf += fri;

            }

         }

         else {

           if(!nf) nf = fr1;
           ((NETCDF_INFO *)fdat)->iframe = nf - 1;
           if(read_field(ap, NULL, 1.0, fdat, 1.0, 'n', 'n', '0', 'n'))break;
           nf += fri;

         }

/* apply upper bound field value if required */

         if(fres == 'y'){

            for(i=0; i < dim; i++){

                if(*(ap + i) > fmax) *(ap + i) = fval;

            }

         }

/* perform FFT */


#ifdef  FFTLIB

         for(i=0; i < gr->iy; i++){
             cff = cfft1 + i * gr->ix;
             memset(fimag, 0, nxmax*sizeof(double));
             memset(freal, 0, nxmax*sizeof(double));
             for(j=0; j < gr->ix; j++) *(freal + j) = *(ap + i * gr->ix + j);

#ifdef  NOUNDERSCORE

             gpfa(freal, fimag, trigs, &inc, &jump, &(gr->ix), &lot, &idir, nj);

#else

             gpfa_(freal, fimag, trigs, &inc, &jump, &(gr->ix), &lot, &idir, nj);

#endif

             for(j=0; j < gr->ix; j++) comp(*(freal + j), -*(fimag + j), (cff + j));


         }

#endif


/* foreward legendre transform */

         ctmp = cof;
         nln = 0;
         for(i=0; i <= ntrunc; i++){
             pin = pin2 * pow(-1.0, (double) i);
             for(j=i; j <= ntrunc; j++){
                 ctmp->real = ctmp->imag = 0.0;
                 for(k=0; k < gr->iy; k++){       /* Gauss-Legendre */
                     cmx(*(gr->aleng + k * gr->nleng + nln), *(cfft1 + k * nx + i), &plf1);
                     cmx(*(legwt + k), plf1,  &plf2);
                     cadd(plf2, *ctmp, ctmp);
                 }

                 cmx(pin, *ctmp, ctmp);

                 ++nln;
                 ++ctmp;

             }
         }

/* loop over filters */

         for(n=0; n < nband; n++){

/* inverse legendre transform */

            for(i=0; i < newg->iy; i++) {
                cff = cfft2 + i * nxx;
                nln = 0;
                ctmp = cof;
                memset(cff, 0, nxx * sizeof(complex));
                for(j=0; j <= ntrunc; j++){
                    pin = pin1 * pow(-1.0, (double) j);
                    for(k=j; k <= ntrunc; k++){
                        cmx(*(ifilt[n] + k), *(ctmp + nln), &coft);
                        cmx(*(newg->aleng + i * newg->nleng + nln), coft, &plf1);
                        cadd(plf1, *(cff + j), cff + j);
                        ++nln;
                    }
                    cmx(pin, *(cff + j), (cff + j));

                }

            }

            memset(ap, 0, dim * sizeof(float));

#ifdef  FFTLIB

            for(i=0; i < newg->iy; i++){
                cff = cfft2 + i * newg->ix;
                memset(fimag, 0, nxmax*sizeof(double));
                memset(freal, 0, nxmax*sizeof(double));
                *freal = cff->real;
                *fimag = cff->imag;
                for(j=1; j <= newg->ix/2; j++) {
                    *(freal + j) =  (cff + j)->real;
                    *(fimag + j) =  -(cff + j)->imag;
                    *(freal + newg->ix - j) = (cff + j)->real;
                    *(fimag + newg->ix - j) = (cff + j)->imag;
                }

#ifdef  NOUNDERSCORE

                gpfa(freal, fimag, trigs_n, &inc, &jump, &(newg->ix), &lot, &indir, nj_n);

#else

                gpfa_(freal, fimag, trigs_n, &inc, &jump, &(newg->ix), &lot, &indir, nj_n);

#endif


/* for inverse transform need to normalise by dividing by number of longitudes */

                for(j=0; j < newg->ix; j++) *(app + i * newg->ix + j) = *(freal + j) / (double)(gr->ix);

            }

#endif

            fprintf(filspec[n], "FRAME %5d\n", ifr+1);
            fwrite(app, dimn * sizeof(float), 1, filspec[n]);
            fprintf(filspec[n], "\n");

         }

         ++ifr;

         if(nf > frl) break;

    }

    for(i=0; i < nband; i++){

       sprintf(band_id, "_band%03d", i);
       strncpy(filename, SPECTRAL, MAXCHR);
       if(iext) strcpy(strstr(filename, EXTENSION), fext);
       strcat(filename, band_id);

       fseeko(filspec[i], (off_t)0, FSTART);
       fprintf(filspec[i], "%5d %5d %5d\n", newg->ix, newg->iy, ifr);

       close_file(filspec[i], filename);

    }

    free(bands);
    for(i=0; i < nband; i++) free(*(ifilt+i));

    free(freal); free(fimag); free(trigs);
    if(ng == 'y'){ free(trigs_n);}
    free(legwt);
    free(cfft1);
    free(cof);
    free(gr->aleng);

    if(ng == 'y'){
       free(cfft2);
       free(newg->aleng);
       free(newg->sico);
       free(newg->xgrid);
       free(newg->ygrid);
       free(newg);

       free(app);
    }

    free(gr->aleng);
    free(gr->sico);

    free(ap);
    free(hf);

    free(filspec);

    return;
}

/* checks for Temperton */

int temptest(int *nj, int nn)
{
    int i;
    int kk=0, ifac=2;
    int itype = 1;

    for(i=1; i <= 3; i++){
       kk = 0;
       while(!(nn % ifac)){
          ++kk;
          nn /= ifac;
       }
       nj[i-1] = kk;
       ifac += i;
    }

    if(nn != 1){
       printf("****WARNING****, value of number of longitudes is not valid for Temperton.\n\n");
       itype = 0;    
    }

    return itype;
}

