C
C Parameters for plotting statistical data.
C
C CINIT, CSTEP == UNIRAS parameters for contouring.
C FILSTAT == the file for plotted statistical data.
C TITLE == main title for statistical plot.
C SCALEX, SCALEY == scaling for plotting
C ITY == interpolation type for producing gridded data (See UNIRAS)
C CNUM == number of contour levels
C
      INCLUDE '../f77_param/path.ptr'

      INTEGER BSDIM, CMODE, ITABB

      PARAMETER (BSDIM=10, CMODE=5, ITABB=6)

      INTEGER ITY, CNUM, CNB, CDIM, IBBX
      INTEGER IRN, CONLS
      INTEGER NVX, NVY
      INTEGER CMCOL, IFR, IFILL
      INTEGER IPERC, ICOLL, CNTCOL
      INTEGER NTEXT, NUMCOL
      INTEGER NANOT, NOBND
      INTEGER NDEC

      CHARACTER*70 FILNM
      CHARACTER*50 TITLE

      REAL CINIT, CSTEP
      REAL SCALEX, SCALEY
      REAL VSCALE, SUPLEV
      REAL CHS, CSMTH
      REAL BSCALE(BSDIM, BSDIM)
      REAL COLMAX
      REAL THS1, THS2

      REAL CONLW

      LOGICAL IMASK, ARMINS

#ifdef NAMELISTS

      NAMELIST /PARAMS/ FILNM, TITLE, CINIT, CSTEP, CNB, SCALEX, SCALEY,
     +                  ITY, CNUM, VSCALE, IBBX, IMASK, CONLW, CONLS,
     +                  ARMINS, SUPLEV, CMCOL, CHS, IFR, IFILL, CSMTH,
     +                  IPERC, ICOLL, NTEXT, NUMCOL, COLMAX, BSCALE,
     +                  NANOT, NOBND, NDEC, THS1, THS2, CNTCOL

#else


      PARAMETER(FILNM=PATH//'statspl.pic')

      PARAMETER(TITLE=
     +          'STATISTICS FOR RELATIVE VORTICITY FIELD AT 850mb')

C      PARAMETER(TITLE='')

      PARAMETER(CINIT=0.0, CSTEP=0.2, CNB=3)
      PARAMETER(SCALEX=1.0, SCALEY=1.0)
      PARAMETER(ITY=1)
      PARAMETER(CNUM=10)
      PARAMETER(VSCALE=0.1)
      PARAMETER(IBBX=0)
      PARAMETER(IMASK=.FALSE.)
      PARAMETER(CONLW=0.0, CONLS=7)
      PARAMETER(ARMINS=.TRUE., SUPLEV=0.001)
      PARAMETER(CMCOL=0, CHS=0.5, IFR=0, IFILL=9999, CSMTH=5.0)
      PARAMETER(IPERC=1, ICOLL=0, NTEXT=1, NUMCOL=2)
      PARAMETER(COLMAX=50.0, NANOT=3, NOBND=0)
      PARAMETER(THS1=1.0, THS2=1.0, CNTCOL=1)
      PARAMETER(NDEC=2)

      DATA BSCALE /1.0,  0.0, 0.0, 0.0,
                   1.0, 30.0, 0.0, 0.0/

#endif


      PARAMETER(NVX=40, NVY=40)

      REAL GRDV(NVX, NVY)

      PARAMETER(CDIM=40, IRN=200)

      REAL CWI(CDIM)

      INTEGER CLSTY(CDIM)

      INTEGER IRREG(IRN)


