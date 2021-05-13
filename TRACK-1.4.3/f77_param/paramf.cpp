C
C Parameters required for plotting processed data.
C
C FILNMF == the file for plotted, thresholded data and feature points.
C FILFEAT == file for plotted tracks for a single run.
C SPLICE == file for plotted tracks for a combined set of runs.
C SCALEX, SCALEY == scaling for plotting purposes.
C NDIN == input channel for reading input data to add to track plots
C TITLE1, TITLE2, TITLE3== titles of plots.
C DOVLAY == switch for plotting nodes.
C NU == switch for re-gridding non-uniform nodes
C
C
      INCLUDE '../f77_param/path.ptr'

      INTEGER MCTE
      PARAMETER(MCTE=20)

      CHARACTER*70 FILNAM, FILNMF, FILFET, SPLICE
      CHARACTER*50 TITLE1, TITLE2, TITLE3

      INTEGER NU, DOVLAY
      INTEGER INCT
      INTEGER IFR

      LOGICAL IZ

      REAL SCALEX, SCALEY, SOFFX, SOFFY, SSC
      REAL SUPVEC, VECSCL 
      REAL ZNCT(MCTE)
      REAL CHS

#ifdef NAMELISTS

      NAMELIST /PARAMF/ FILNAM, FILNMF, FILFET, SPLICE, TITLE1, TITLE2,
     +                  TITLE3, DOVLAY, NU, IZ, SCALEX, SCALEY, SOFFX,
     +                  SOFFY, SSC, SUPVEC, VECSCL, INCT, ZNCT, CHS, 
     +                  IFR

#else


      PARAMETER(FILNAM=PATH//'threshpl.pic')
      PARAMETER(FILNMF=PATH//'filterpl.pic')
      PARAMETER(FILFET=PATH//'featpl.pic')
      PARAMETER(SPLICE=PATH//'splicepl.pic')

      PARAMETER(TITLE1 = 'RELATIVE VORTICITY AT 850mb')

C      PARAMETER(TITLE1 ='')

      PARAMETER(TITLE2 = 
     + 'TRACKS OF RELATIVE VORTICITY AT 850mb')

      PARAMETER(TITLE3 = 
     +          'RELATIVE VORTICITY TRACKS AT 850mb')

C      PARAMETER(TITLE3 ='')

      PARAMETER(DOVLAY = 0, NU=1, IZ=.TRUE.)
C
C SCALEX=2.6, SCALEY=1.4 suitable scaling for output for Postscript
C
      PARAMETER(SCALEX=1.0, SCALEY=-1.0)
      PARAMETER(SOFFX=0.15, SOFFY=0.4)
      PARAMETER(SSC=2.0)
      PARAMETER(SUPVEC=0.001, VECSCL=0.05)
      PARAMETER(INCT=3)
      PARAMETER(IFR=0, CHS=1.0)

      DATA ZNCT /240.0, 268.0, 320.0/

#endif
