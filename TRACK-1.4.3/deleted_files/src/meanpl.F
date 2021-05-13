
/* fortran preprocessor file for stats. plot using uniras */

#ifndef     HAVEUNIRAS

      SUBROUTINE MEANPL()

      IMPLICIT NONE

C
C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$C
C                                                                     C
C  Dummy routine for MEANPL if no UNIRAS available.                   C
C                                                                     C
C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$C
C
      INCLUDE 'paramc.ptr'

      WRITE(NUT, 900)

      RETURN
  900 FORMAT('/***ERROR***, no plotting possible without UNIRAS/')

      END

#else

      SUBROUTINE MEANPL(XGRID, YGRID, IX, IY, XP, YP, ZP, TID, DFIL, CMI
     +                  ,CMXG, CMYG, DCM, IZM, XMN, YMN, XMX, YMX
     +                  ,DELB, PNT, PT, LL) 
      IMPLICIT NONE
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                       C
C Program to plot the feature points.                                   C
C                                                                       C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
      INTEGER IX, IY, DFIL, DCM, CMI(DCM), DELB, IZM
      INTEGER ICM, I, TID(DFIL), IDEF, PT
      REAL XP(DFIL), YP(DFIL), ZP(DFIL), PNT(2,5), LL
      REAL CMXG(DCM), CMYG(DCM), PERIOD, CTOL, SCY
      REAL XMN, YMN, XMX, YMX, PTX, PTY, XD, YD, RAT, XS
      CHARACTER YN*1

C
C------------------------------------------------------------------------
C
C Include the parameter file.
C
      INCLUDE 'paramm.ptr'
      INCLUDE 'paramc.ptr'
C
      REAL XGRID(IX), YGRID(IY)
      REAL XMIN, XMAX, YMIN, YMAX, XSI, YSI, XM, 
     +     XOFF, YOFF, XSIZE, YSIZE, HEIGHT, ZL(2)
      DOUBLE PRECISION DIRM, BASEX, BASEY, RATIO
      LOGICAL FSTAT, SWTCH1, SWTCH2, SWTCH
      CHARACTER ANS*3, TITSUB*50
      FSTAT= .TRUE. 
      ZL(1) = ZINIT
      ZL(2) = STEP
      PERIOD = XGRID(IX) - XGRID(1)
      CTOL = PERIOD / 4.0    
C
C
C------------------------------------------------------------------------
C
C Set max. and min. values of the grid.
C
      IF(IZM .EQ. 0) THEN
        XMIN=XGRID(1)
        XMAX=XGRID(IX)
        YMIN=YGRID(1)
        YMAX=YGRID(IY)
      ELSE IF(IZM .EQ. 1) THEN
        XD = XMX-XMN
        YD = YMX-YMN
        RAT = REAL(DELB)/REAL(IX)
        XMIN=XMN-RAT*XD
        XMAX=XMX+RAT*XD
        RAT = REAL(DELB)/REAL(IY)
        YMIN=YMN-RAT*YD
        YMAX=YMX+RAT*YD
      ENDIF
C
C------------------------------------------------------------------------
C
C Put data into the plotting array
C
      DO 10 I=1, DFIL
        ZP(I) = SCALE*ZP(I)
   10 CONTINUE
C
C=========================================================================
C
C Plot data using UNIRAS.
C
      CALL GROUTE(DEVICE)
      IF(PT .EQ. 0 .OR. PT .EQ. 1) THEN
        CALL GOPEN
      ELSE IF(PT .GT. 1) THEN
        INQUIRE(FILE=FILNMM, EXIST=FSTAT)
        CALL GFILE(10, NOUT, FILNMM)
        CALL GOPEN
        IF(FSTAT)  CALL GSEGWK(0)
        CALL GSEGCR(0)
      ENDIF
      CALL GRPSIZ(XSI,YSI)
      XM=MIN(XSI,YSI)
      XSIZE=0.8*XM
      YSIZE=XSIZE
      XOFF=0.3*(XSI-XSIZE)
      YOFF=(YSI-YSIZE)

      IF(SCALEY .LE. 0.) THEN
         SCY = SCALEX * (YMAX - YMIN) / (XMAX - XMIN)
      ELSE
         SCY = SCALEY
      ENDIF

      CALL GVPORT(XOFF, YOFF, SCALEX*XSIZE, SCY*YSIZE)
      CALL GLIMIT(XMIN, XMAX, YMIN, YMAX, 0.0, 0.0)
      IF(IZM .EQ. 1)CALL GWBOX(SCALEX*XSIZE, SCY*YSIZE, 0.0)
      CALL GSCALE
      HEIGHT = 0.02*MIN(XSIZE,YSIZE)
      CALL RRECT(XMIN, YMIN, XMAX, YMAX, 0, 0)
      CALL RRECT(XMN, YMN, XMX, YMX, 1, 0)
C
C------------------------------------------------------------------------
C
C Plot country map.
C
      ICM = 1
      XS = 0.001*XSIZE
   40 CONTINUE
      IF(ICM+1 .LE. DCM) THEN 
       PTX = (CMXG(ICM) - XMN)*(XMX - CMXG(ICM))
       PTY = (CMYG(ICM) - YMN)*(YMX - CMYG(ICM))
       IF((PTX .GE. 0.0) .AND. (PTY .GE. 0.0)) THEN
         SWTCH1 = .TRUE.
       ELSE
         SWTCH1 = .FALSE.
       ENDIF

   50  CONTINUE   

       PTX = (CMXG(ICM+1) - XMN)*(XMX - CMXG(ICM+1))
       PTY = (CMYG(ICM+1) - YMN)*(YMX - CMYG(ICM+1))
       IF((PTX .GE. 0.0) .AND. (PTY .GE. 0.0)) THEN
         SWTCH2 = .TRUE.
       ELSE
         SWTCH2 = .FALSE.
       ENDIF
       IF(SWTCH1 .AND. SWTCH2) THEN
         SWTCH = .TRUE.
       ELSE 
         SWTCH = .FALSE.
       ENDIF
       IF(CMI(ICM) .EQ. CMI(ICM+1) .AND.
     +    ABS(CMXG(ICM)-CMXG(ICM+1)) .LT. CTOL) THEN
          IF(IZM .EQ. 1) THEN
             IF(SWTCH)THEN
               CALL GWICOL(XS, 0)
               CALL GVECT(CMXG(ICM), CMYG(ICM), 0)
               CALL GVECT(CMXG(ICM+1), CMYG(ICM+1), 1)
             ENDIF
          ELSE
             IF(SWTCH) THEN
               CALL GWICOL(XS, 0)
               CALL GVECT(CMXG(ICM), CMYG(ICM), 0)
               CALL GVECT(CMXG(ICM+1), CMYG(ICM+1), 1)
             ELSE
               CALL GWICOL(XS, 1)
               CALL GVECT(CMXG(ICM), CMYG(ICM), 0)
               CALL GVECT(CMXG(ICM+1), CMYG(ICM+1), 1)
             ENDIF
          ENDIF
          ICM = ICM+1
          SWTCH1 = SWTCH2
          GOTO 50
       ELSE
          ICM = ICM+1
          GOTO 40
        ENDIF
      ENDIF

C
C-----------------------------------------------------------------------
C
C Plot feature points.
C
      CALL GWICOL(0.001*XSIZE, 27)
      ICM = 1
  200 CONTINUE
      IF(ICM .LE. DFIL) THEN

       CALL GVECT(XP(ICM), YP(ICM), 0)

  300  CONTINUE
       IF(ICM+1 .LE. DFIL) THEN 
         IF(TID(ICM) .EQ. TID(ICM+1)) THEN

            CALL GVECT(XP(ICM+1), YP(ICM+1), 1)
            ICM = ICM+1
            GOTO 300
         ELSE
            ICM = ICM+1
            GOTO 200
         ENDIF
       ENDIF
      ENDIF

      IF(IZM .EQ. 1 .AND. PT .GT. 1) THEN

        CALL GWICOL(0.003*XSIZE, 9999)
        CALL RCLASS(ZL,ICNUM,-5)
        CALL RSHADE(1,0)
        CALL GPOI2Z(XP, YP, ZP, DFIL)

        CALL GCOSCL(XMAX+0.1*(XMAX-XMIN), YMIN)

      ENDIF

C
C-----------------------------------------------------------------------
C
C PLOT AND LABEL AXES
C
      CALL RAXDIS(6, 1, 0)
      CALL RAXDIS(4, 0, 0)
      CALL RAXTEA(6, 2, 2, RDEF, IDEF, IDEF, RDEF)
      CALL RAXTEX(6, -1, XLAB, RDEF, RDEF, 0.6*HEIGHT)
      CALL RAXIS(1, YMIN, HEIGHT, 1)
      CALL RAXTEX(6, -1, YLAB, RDEF, RDEF, 0.6*HEIGHT)
      CALL RAXIS(2, XMIN, HEIGHT, 1)

C
C----------------------------------------------------------------------
C
C Calculate Rectangle for Mean Track Calculation
C
  100 CONTINUE

      CALL GEMPTY

      IF(PT .EQ. 0 .OR. PT .EQ. 1) THEN

         IF(PT .EQ. 1) THEN

           WRITE(NUT,900)
           READ(NIN, *)PNT(1,1), PNT(2,1), PNT(1,4), PNT(2,4)
           WRITE(NUT, 910)
           READ(NIN, *)PNT(1,5), LL

           BASEX = PNT(1,4) - PNT(1,1)
           BASEY = PNT(2,4) - PNT(2,1)

           IF(ABS(PNT(1,5)) .LE. 0.0) THEN
              PNT(2,5) = 1.0
              PNT(1,5) = - BASEY/BASEX
           ELSE 
              PNT(2,5) = - BASEX * PNT(1,5)/BASEY
           ENDIF

           DIRM = SQRT(PNT(1,5)*PNT(1,5) + PNT(2,5)*PNT(2,5))
           RATIO = LL/DIRM

           PNT(1,5) = PNT(1,5) * RATIO
           PNT(2,5) = PNT(2,5) * RATIO

           PNT(1,2) = PNT(1,1) + PNT(1,5)
           PNT(2,2) = PNT(2,1) + PNT(2,5)
           PNT(1,3) = PNT(1,4) + PNT(1,5)
           PNT(2,3) = PNT(2,4) + PNT(2,5)

        ENDIF
C
C Plot Rectangle
C
        CALL GWICOL(0.002*XSIZE, 2)
        CALL GVECT(PNT(1,1), PNT(2,1), 0)
        CALL GVECT(PNT(1,2), PNT(2,2), 1)
        CALL GVECT(PNT(1,3), PNT(2,3), 1)
        CALL GVECT(PNT(1,4), PNT(2,4), 1)
        CALL GVECT(PNT(1,1), PNT(2,1), 1)
        CALL GEMPTY

        WRITE(NUT, 920)
        READ(NIN, *) YN
        IF(YN .EQ. 'N' .OR. YN .EQ. 'n') THEN

           CALL GWICOL(0.002*XSIZE, 1)
           CALL GVECT(PNT(1,1), PNT(2,1), 0)
           CALL GVECT(PNT(1,2), PNT(2,2), 1)
           CALL GVECT(PNT(1,3), PNT(2,3), 1)
           CALL GVECT(PNT(1,4), PNT(2,4), 1)
           CALL GVECT(PNT(1,1), PNT(2,1), 1)
           CALL GEMPTY
           PT = 1
           GO TO 100

        ENDIF

      ENDIF
C
C----------------------------------------------------------------------
C
C For Title
C
      IF(PT .GT. 1) THEN
        CALL RTXCOL(2,2)
        CALL RTXHEI(3.0)
        CALL RTX(-2, TITLE, XMIN, YMAX + 0.2*(YMAX - YMIN))
      ENDIF

      CALL GEMPTY
      WRITE(NUT, 930)
      READ(NIN, *) ANS
      IF(ANS(1:1) .EQ. "Y" .OR. ANS(1:1) .EQ. "y") THEN
         WRITE(NUT, 940)
         READ(NIN, '(A50)') TITSUB
         CALL RTXHEI(2.5)
         CALL RTX(-2, TITSUB, XMIN, YMAX+0.1*(YMAX-YMIN))
      ENDIF 
        
      CALL GEMPTY
      IF(PT .GT. 1) CALL GSEGCL(0)
      CALL GCLOSE
      RETURN
  900 FORMAT('input the coordinates of the area of interest'/
     +       'Input the pairs (x1, y1), (x2, y2)'/)
  910 FORMAT('input the X co-ordinate and the scale of the' /
     +       'orientation vector as the pair (xv, lam)'/)
  920 FORMAT('is this the required region Yes or No'/)
  930 FORMAT('do you want to use a subsidary title to the default')
  940 FORMAT('input the subsidary title')
      END


#endif


   
