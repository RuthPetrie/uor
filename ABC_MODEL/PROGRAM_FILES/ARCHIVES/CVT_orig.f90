!*************************************************************************************************
 ! SUBROUTINES IN THIS FILE 
 ! 
 ! CVT : CVT testing driver
 ! Ctrl_Vec_Balance(InitState,EigVecs, std_eigvecs, Dims)
 ! Calc_implied_covs(InitState, Dims, Eigvecs, std_eigvecs)
 ! Mode_truncation(Ctrl_state, acoustic, gravity, balanced)  
 ! Calc_eigenfunctions(EigVecs, EigVals, Dims, std_eigvecs)
 ! Fwd_inv_cvt_test(InitState, Dims, EigVecs, std_eigvecs )
 ! Adjoint_test (InitState, Dims, adj_test_flag, EigVecs, std_eigvecs )
 ! Gen_eigenvecs_of_L(Dims, EigVecs, EigVals)
 ! Adj_test(statein, Aout, adjointout)
 ! Adj_test_vert (statein, Aout, adjointout)
 ! Adj_test_hoz (statein, Aout, adjointout)
 ! Adj_test_eig(statein, Aout, adjointout)
 ! Adj_test_hozeig (statein, Aout, adjointout)
!*************************************************************************************************

 
 SUBROUTINE CVT(InitState, Dims, gen_eigvecs, truncate, acoustic, gravity, balanced, inv_cvt_test, &
                adj_cvt_test, adj_test_flag, gen_imp_cov, calc_eig_func, test_ctrl_bal,  &
                eigenvects_file, eigenvals_file, st_dev_file)
 !******************************************************************************************** 
 !* Subroutine to run CVT tests
 !*
 !* Inputs
 !* ------
 !* InitState
 !* Dims - dimension data
 !*
 !* Options
 !* -------
 !* gen_eigvecs   : Set gen_eigvecs = 1 to generate eigenvectors of system matrix, 0 to read in
 !* truncate      : Set truncate = 1 to truncate wave numbers
 !* acoustic      : set acoustic = 1 to remove acoustic modes
 !* gravity       : Set gravity = 1 to remove gravity modes 
 !* balanced      : Set balanced = 1 to remove balanced mode
 !* inv_cvt_test  : Set inv_cvt_test = 1 perform forward-inverse CVT test.
 !* adj_cvt_test  : Set adj_cvt_test = 1 to perform adjoint test
 !* adj_test_flag : Set adj_test_flag: 1 = horizontal, 2 = eigenvector, 3 = hoz + eig, 4 = vert, 5 = full
 !* gen_imp_cov   : Set gen_imp_cov = 1 to generate implied covariances.
 !* calc_eig_func : Set calc_eig_func = 1 to calculate eigenfunctions
 !* test_ctrl_bal : set test_ctrl_bal = 1 to test balanced components of control vector
 !* eigenvects_file : eigenvector filename (read or write)
 !* eigenvals_file  : eigenvalues filename (read or write)
 !* st_dev_file   : standard deviations filename
 !******************************************************************************************** 
 USE DefConsTypes
 IMPLICIT NONE

 ! Declare Top lev Variables
 !-----------------------------
 TYPE(Dimensions_type),     INTENT(IN)        :: Dims
 TYPE(model_vars_type),     INTENT(IN)        :: InitState
 CHARACTER(LEN=*),          INTENT(IN)        :: eigenvects_file
 CHARACTER(LEN=*),          INTENT(IN)        :: eigenvals_file
 CHARACTER,                 INTENT(IN)        :: st_dev_file*70

 ! Declare Local Variables
 !---------------------------
 REAL(wp)                                     :: std_eigvecs(1:nvars*nlevs, 1:nlongs)
 COMPLEX(wp)                                  :: spectra(1:nvars*nlevs, 1:nlongs )
 REAL(wp)                                     :: EigVecs(1:nlongs, 1:nvars*nlevs, 1:nvars*nlevs)
 REAL(wp)                                     :: EigVals(1:nlongs, 1:nvars*nlevs) 

 ! Switches
 INTEGER                                      :: gen_eigvecs, inv_cvt_test, adj_cvt_test, test_ctrl_bal
 INTEGER                                      :: adj_test_flag, gen_imp_cov, calc_eig_func 
 INTEGER                                      :: truncate, acoustic, gravity, balanced

 ! Filenames
 CHARACTER                                    :: eigenvects_filename*80,eigenvals_filename*80

 ! Counters
 INTEGER                                      :: i,k,n


 ! Allocate/Initialise Variables
 !-------------------------------
 
 std_eigvecs(1:nvars*nlevs, 1:nlongs )         = (0.0,0.0)
 spectra(1:nvars*nlevs, 1:nlongs )             = (0.0,0.0)
 
 EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs) = 0.0
 EigVals(1:nlongs, 1:nvars*nlevs)              = 0.0

 

 !************************************************************************************************** 
 ! Read standard deviations
 !************************************************************************************************** 

 PRINT*, 'Reading Standard Deviations'
 PRINT*, st_dev_file
 OPEN(56, file = st_dev_file, form = 'unformatted')
 DO n = 1, nvars*nlevs
   DO k = 1,nlongs
     READ (56) std_eigvecs(n,k)
   END DO
 END DO
 CLOSE(56)
 
! PRINT*, std_eigvecs(180,181)
! PRINT*, std_eigvecs(241,181) 
! std_eigvecs(180,181) = 1E-9
! std_eigvecs(241,181) = 1E-9

!DO k = 1,360
! PRINT*, std_eigvecs(241,k)
! PRINT*, std_eigvecs(1:60,182)
!END DO
!STOP
  
 DO k = 1, nvars*nlevs
   DO i = 1,nlongs
     spectra(k,i) = std_eigvecs(k,i)
   END DO
 END DO

 
!************************************************************************************************** 
!  Read or generate eigenvector data
!************************************************************************************************** 
  
  IF (gen_eigvecs .EQ. 1 ) THEN

    PRINT*, 'Generating Eigenvectors'
    PRINT*, '...'
    CALL Gen_eigenvecs_of_L( Dims, EigVecs, EigVals, eigenvects_file, eigenvals_file ) 

  ELSE

    PRINT*, 'Reading Eigenvectors'
    eigenvects_filename = eigenvects_file // '.bin'
    PRINT*, eigenvects_filename
    OPEN(56, file = eigenvects_filename, form = 'unformatted')
    DO i = 1,nlongs
       DO k = 1, nvars*nlevs
         READ (56) EigVecs(i,k,1:nvars*nlevs)
      ENDDO
    ENDDO
    CLOSE (56)
    
    PRINT*, 'Reading Eigenvalues'
    eigenvals_filename = eigenvals_file//'.bin'
    PRINT*, eigenvals_filename
    OPEN(56, file = eigenvals_filename, form = 'unformatted')
    DO i = 1,nlongs
         READ (56) EigVals(i,1:nvars*nlevs)
    ENDDO
    CLOSE(56)
  END IF

!************************************************************************************************** 
! Test balance properties of control vector
!************************************************************************************************** 
 IF (test_ctrl_bal .EQ. 1) THEN
   PRINT*, ' Testing balance components of control vector'
   CALL Ctrl_Vec_Balance(InitState,EigVecs, std_eigvecs, Dims)
 END IF 
  
      
!************************************************************************************************** 
! Generate eigenfunctions
!************************************************************************************************** 
 IF (calc_eig_func  .EQ. 1) THEN
   PRINT*, ' Generating eigenfunctions in real space'
   CALL Calc_eigenfunctions(EigVecs, EigVals, Dims,std_eigvecs)
 END IF 

!************************************************************************************************** 
! Forward-Inverse test 
!************************************************************************************************** 
 IF (inv_cvt_test .EQ. 1) THEN
   PRINT*, '---------------------------------'
   PRINT*, 'Forward - Inverse test'
   PRINT*, '---------------------------------'
   CALL Fwd_inv_cvt_test(InitState, Dims, EigVecs, std_eigvecs) 
 END IF

!************************************************************************************************** 
! Adjoint test 
!************************************************************************************************** 
 IF (adj_cvt_test .EQ. 1) THEN
   CALL Adjoint_test (InitState, Dims, adj_test_flag, EigVecs, std_eigvecs )
 END IF
 
!************************************************************************************************** 
! Calculate implied covariances
!************************************************************************************************** 
 IF  (gen_imp_cov .EQ. 1) THEN
   PRINT*, '---------------------------------'
   PRINT*, 'Calculating implied covariances'
   PRINT*, '---------------------------------'
   CALL Calc_implied_covs(InitState, Dims, Eigvecs, std_eigvecs, &
                          truncate, acoustic, gravity, balanced)
 END IF


 END SUBROUTINE CVT
!===================================================================================================
!***************************************************************************************************
!===================================================================================================
 
!===================================================================================================
!***************************************************************************************************
!===================================================================================================
 SUBROUTINE Ctrl_Vec_Balance(InitState,EigVecs, std_eigvecs, Dims)
 
 !----------------------------------------------------
 ! Subroutine to determine the balance properties of 
 ! different components of the control vector 
 !
 ! 31/5/2011
 ! R. Petrie
 ! 0.01
 !----------------------------------------------------
 
 USE DefConsTypes
 IMPLICIT NONE

 ! Declare Top lev Variables
 !-----------------------------
 TYPE(model_vars_type),     INTENT(INOUT)     :: InitState
 TYPE(Dimensions_type),     INTENT(IN)        :: Dims
 REAL(wp),                  INTENT(IN)        :: EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs)
 REAL(wp),                  INTENT(INOUT)     :: std_eigvecs(1:nvars*nlevs, 1:nlongs )
 
 ! Declare local variables
 !-------------------------
 TYPE(model_vars_type)                        :: OutputState
 TYPE(Transform_type)                         :: HozCtrl, VertCtrl  ! intermediate control variables
 COMPLEX(wp)                                  :: Ctrl_vect(1:nvars*nlevs, 1:nlongs )
 COMPLEX(wp)                                  :: Ctrl_vect_tmp(1:nvars*nlevs, 1:nlongs )
 REAL(wp)                                     :: x_scale, z_scale, temp1, temp2
 INTEGER                                      :: i,k, x,z
 
 
 !Structure of Eigvecs (k,i,j)
 !k = horizontal wave number, i = row index, j = column index  (eigenvectors are columns)
 !300 eigenvectors in j for each horizontal wave number

 ! Generate a control vector
 !===========================
 
 CALL Initialise_transform_vars(InitState)
  
 ! Define a perturbation to examine
 !----------------------------------------------------------
  x = 180
  z = 30
  x_scale = 100.0
  z_scale = 25.0
 
  DO i = 1, nlongs
    DO k = 1, nlevs
     temp1 = (x - i) * (x - i)
     temp2 = (z - k) * (z - k)
     InitState % r(i,k) = 1.0 * EXP (-(temp1/x_scale) - (temp2/z_scale) ) 
    END DO
  END DO
  
  ! dx' = U T U^{-1} dx (where T is truncation)
  !----------------------------------------------
 
  ! Perform inverse CVT: model - control
  !--------------------------------------
  CALL Hoz_Inv  (InitState, HozCtrl)
  CALL Vert_Inv (HozCtrl, VertCtrl, Dims)
  CALL Eig_Inv  (VertCtrl, Ctrl_vect, EigVecs, 0, std_eigvecs) 
  ! zero option in eig inv: scaling switched off
  
  PRINT*, '-------------------------------'
  PRINT*, 'Control vector generated'
  PRINT*, '-------------------------------'

 
  ! Perform forward CVT: control - model 
  !--------------------------------------
  CALL Eig_for (Ctrl_vect, VertCtrl, EigVecs, std_eigvecs)
  CALL Vert_For(VertCtrl, HozCtrl, Dims)
  CALL Hoz_for (HozCtrl, OutputState, Dims)
 
  PRINT*, '-------------------------------'
  PRINT*, 'Completed projection to model variables'
  PRINT*, '-------------------------------'
  
  ! Calculate balance
  !---------------------- 
  CALL Calc_geost(OutputState, Dims)
  CALL Calc_hydro(OutputState, Dims)

  ! Dump test data
  !----------------
  OPEN(55, file = '/home/wx019276/DATA/CVT/BalTest_u.dat')
  OPEN(56, file = '/home/wx019276/DATA/CVT/BalTest_v.dat')
  OPEN(57, file = '/home/wx019276/DATA/CVT/BalTest_w.dat')
  OPEN(58, file = '/home/wx019276/DATA/CVT/BalTest_b.dat')
  OPEN(59, file = '/home/wx019276/DATA/CVT/BalTest_r.dat')
  OPEN(60, file = '/home/wx019276/DATA/CVT/BalTest_g.dat')
  OPEN(61, file = '/home/wx019276/DATA/CVT/BalTest_h.dat')
  
  DO k = 1, nlevs
    WRITE (55, *) OutputState % u(1:nlongs,k)
    WRITE (56, *) OutputState % v(1:nlongs,k)
    WRITE (57, *) OutputState % w(1:nlongs,k)
    WRITE (58, *) OutputState % b(1:nlongs,k)
    WRITE (59, *) OutputState % r(1:nlongs,k)
    WRITE (60, *) OutputState % geost_imbal(1:nlongs,k)
    WRITE (61, *) OutputState % hydro_imbal(1:nlongs,k)
  ENDDO 

  CLOSE(55)
  CLOSE(56)
  CLOSE(57)
  CLOSE(58)
  CLOSE(59)
  CLOSE(60)
  CLOSE(61)
 
 END SUBROUTINE Ctrl_Vec_Balance
!===================================================================================================
!***************************************************************************************************
!===================================================================================================
 
 
!===================================================================================================
!***************************************************************************************************
!===================================================================================================
 SUBROUTINE Calc_eigenfunctions(EigVecs, EigVals, Dims, std_eigvecs)
 
 !----------------------------------------------------
 ! Subroutine to calculate the eigenfunctions
 !  of the the system matrix in real space
 !
 ! 31/5/2011
 ! R. Petrie
 ! 0.01
 !----------------------------------------------------
 
 USE DefConsTypes
 IMPLICIT NONE

 ! Declare Top lev Variables
 !-----------------------------
 REAL(wp),     INTENT(IN)                     :: EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs)
 !Structure of Eigvecs (k,i,j)
 !k = horizontal wave number, i = row index, j = column index (eigenvectors are columns)
 !300 eigenvectors in j for each horizontal wave number

 REAL(wp),     INTENT(IN)                     :: EigVals(1:nlongs, 1:nvars*nlevs) 
 TYPE(Dimensions_type),     INTENT(IN)        :: Dims
 REAL(wp),                  INTENT(IN)        :: std_eigvecs(1:nvars*nlevs, 1:nlongs )

 ! Declare Local Variables
 !---------------------------
 TYPE(model_vars_type)                        :: OutputState
 TYPE(Transform_type)                         :: HozCtrl, VertCtrl
 COMPLEX(wp)                                  :: eigen_vects(1:nvars*nlevs, 1:nlongs )
 COMPLEX(wp)                                  :: EigVectFltArry(1:nvars*nlevs, 1:nlongs)
 COMPLEX(wp)                                  :: imag, negimag
 REAL(wp)                                     :: rho0, sqrtb, recipdom
 CHARACTER                                    :: filenumber*3

 ! Declare Local Variables
 !-------------------------
 ! Counters
 INTEGER                                      :: i,j,k, ev, m, ktemp, herm, kk


 negimag  = (0.0,-1.0)
 imag     = (0.0, 1.0) 
 rho0     = 1.0
 sqrtb    = sqrt(B * Cz * rho0)  
 recipdom = 1.0 / domain

 CALL Initialise_transform_vars(HozCtrl) 
 CALL Initialise_transform_vars(VertCtrl) 
 CALL Initialise_model_vars(OutputState)
 
 ! Set Control vector
 !-------------------
 
 DO ev = 1,300
 
 print*, 'eigenvectors: ',ev

 DO k = 1,nlongs
   ! eigenvector ev for all k horizontal wavenumbers
   DO j = 1,nvars*nlevs
    eigen_vects(j, k) = EigVecs(k,j,ev)
   END DO
 END DO
 
 !OPEN  (66, file = '/export/carrot/raid2/wx019276/DATA/CVT/ev10.dat')		
 !  WRITE (66,*) REAL(Ctrl_vect(1:nvars*nlevs,10))
 !CLOSE (62) 

 ! STOP

 ! Forward CVT control to model space
 !-------------------------------------
 
  DO k = 1, nlongs
    DO  m = 1, nlevs
      VertCtrl % u(m,k) = eigen_vects(m, k)              
      VertCtrl % v(m,k) = eigen_vects(m + nlevs,k)   
      VertCtrl % w(m,k) = eigen_vects(m + 2*nlevs,k) 
      VertCtrl % r(m,k) = eigen_vects(m + 3*nlevs,k) 
      VertCtrl % b(m,k) = eigen_vects(m + 4*nlevs,k)
    END DO
  END DO

  herm = 1
 
 IF (herm .EQ. 1) THEN
   
   ! ENSURE EXACT HERMITIAN SEQUENCE
   !----------------------------------------- 

   DO m = 1, nlevs
    VertCtrl % u(m,1)   = REAL(VertCtrl % u(m,1))
    VertCtrl % u(m,181) = REAL(VertCtrl % u(m,181))
    VertCtrl % v(m,1)   = imag * (AIMAG(VertCtrl % v(m,1)))
    VertCtrl % v(m,181) = imag * (AIMAG(VertCtrl % v(m,181)))
    VertCtrl % w(m,1)   = imag * (AIMAG(VertCtrl % w(m,1)))
    VertCtrl % w(m,181) = imag * (AIMAG(VertCtrl % w(m,181)))
    VertCtrl % r(m,1)   = REAL(VertCtrl % r(m,1))
    VertCtrl % r(m,181) = REAL(VertCtrl % r(m,181))
    VertCtrl % b(m,1)   = REAL(VertCtrl % b(m,1))
    VertCtrl % b(m,181) = REAL(VertCtrl % b(m,181))
   ENDDO     


   DO m = 1, nlevs
   kk = 360
     DO k = 2,nlongs/2
      VertCtrl % u(m,kk) = -1.0 * CONJG(VertCtrl % u(m,k))
      VertCtrl % v(m,kk) =        CONJG(VertCtrl % v(m,k))
      VertCtrl % w(m,kk) =        CONJG(VertCtrl % w(m,k))
      VertCtrl % r(m,kk) = -1.0 * CONJG(VertCtrl % r(m,k))
      VertCtrl % b(m,kk) = -1.0 * CONJG(VertCtrl % b(m,k))
      kk = kk-1
     ENDDO
   ENDDO
  
 END IF


 ! Forward symmetric scaling transform
 !--------------------------------------------------------
 PRINT*, 'Forward symmetric scaling'
 DO k = 1, nlongs
     ktemp = k - 1 - (nlongs/2)
    IF (ktemp .EQ. 0) THEN
       VertCtrl % u(1:nlevs,k) = VertCtrl % u(1:nlevs,k) * imag
       VertCtrl % w(1:nlevs,k) = VertCtrl % w(1:nlevs,k) * imag
       VertCtrl % r(1:nlevs,k) = VertCtrl % r(1:nlevs,k) * sqrtb 
       VertCtrl % b(1:nlevs,k) = VertCtrl % b(1:nlevs,k) * sqrt(Nsq)
    ELSE
       VertCtrl % u(1:nlevs,k) = VertCtrl % u(1:nlevs,k) * imag
       VertCtrl % w(1:nlevs,k) = VertCtrl % w(1:nlevs,k)  *                  &
                                    2.0 * imag * REAL(ktemp) * pi * recipdom  
       VertCtrl % r(1:nlevs,k) = VertCtrl % r(1:nlevs,k) *                   &
                                    2.0 * pi * REAL(ktemp) * sqrtb * recipdom
       VertCtrl % b(1:nlevs,k) = VertCtrl % b(1:nlevs,k) *                   &
                                    2.0 * pi * REAL(ktemp) * sqrt(Nsq) * recipdom
   ENDIF
 ENDDO

 CALL Vert_For(VertCtrl, HozCtrl, Dims)
 
! DO k = 1, nlevs
!   DO m = 1, nlongs 
!     OutputState % u(m,k) = (ABS(HozCtrl % u(k,m)))
!     OutputState % v(m,k) = (ABS(HozCtrl % v(k,m)))
!     OutputState % w(m,k) = (ABS(HozCtrl % w(k,m)))
!     OutputState % r(m,k) = (ABS(HozCtrl % r(k,m)))
!     OutputState % b(m,k) = (ABS(HozCtrl % b(k,m)))
!   END DO
! END DO 

 
 CALL Hoz_For(HozCtrl, OutputState) 
 
! DO k = 1, nlevs
!   PRINT*, HozCtrl % w(k,5)
! END DO
 
 ! Convert u and v to velocity potential and streamfunction
 !------------------------------------------------------------
! DO k = 1, nlevs
!   DO i = 1,nlongs-1
!     OutputState % u(i,k) = 750*(OutputState % u(i,k) + OutputState % u(i+1,k))
!     OutputState % v(i,k) = 750*(OutputState % v(i,k) + OutputState % v(i+1,k))
!   END DO
! END DO
! OutputState % u(360,1:nlevs) = 1500*(OutputState % u(360,1:nlevs))
! OutputState % v(360,1:nlevs) = 1500*(OutputState % v(360,1:nlevs))
 
 WRITE(filenumber,'(i3.3)')ev  
 CALL Write_state_2d ('/export/carrot/raid2/wx019276/DATA/CVT/eigenfuncts_4_'//filenumber//'.nc',&
                     Outputstate, Dims, 1, 0, 1)
                     
                     
 PRINT*, 'xconv /export/carrot/raid2/wx019276/DATA/CVT/eigenfuncts.nc &' 
 PRINT*, '----------------------------------------------------'
 PRINT*, ' Eigenfunctions in real space calculated'
 PRINT*, '----------------------------------------------------'

 END DO 
  
 END SUBROUTINE Calc_eigenfunctions
!===================================================================================================
!***************************************************************************************************
!=================================================================================================== 
 SUBROUTINE Calc_implied_covs(InitState, Dims, Eigvecs, std_eigvecs, &
                              truncate, acoustic, gravity, balanced)

 !****************************************************
 ! Subroutine to calculate the implied covariances   *
 ! of the control variable transform                 *
 !                                                   *
 ! 31/5/2011                                         * 
 ! R. Petrie                                         *  
 ! 0.01                                              *  
 !****************************************************
 
 USE DefConsTypes
 IMPLICIT NONE

 ! Declare Top lev Variables
 !-----------------------------
 TYPE(Dimensions_type),     INTENT(IN)        :: Dims
 TYPE(model_vars_type),     INTENT(IN)        :: InitState
 REAL(wp),                  INTENT(INOUT)     :: EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs)
 REAL(wp),                  INTENT(IN)        :: std_eigvecs(1:nvars*nlevs, 1:nlongs )

 ! Switches
 INTEGER,                   INTENT(IN)        :: truncate, acoustic, gravity, balanced
 
 ! Declare Local Variables
 !---------------------------
 TYPE(model_vars_type)                        :: OutputState, TempState
 TYPE(Transform_type)                         :: HozCtrl, VertCtrl
 COMPLEX(wp)                                  :: Ctrl_vect(1:nvars*nlevs, 1:nlongs )

 ! Declare Local Variables
 !-------------------------
 REAL(wp)                                     :: ztop, m
 REAL(wp)                                     :: x_scale, z_scale, temp1, temp2
 CHARACTER                                    :: imp_covs_file*66 
 CHARACTER                                    :: ctrl_vect_no*3
 CHARACTER                                    :: ctrl_vect_file*66
! Counters
 INTEGER                                      :: i,j,k, x,z, dump_ctrl_vec
 

 !==============================================================================================
 ! Allocate/Initialise Variables
 !-------------------------------
 CALL Initialise_transform_vars ( HozCtrl )
 CALL Initialise_transform_vars ( VertCtrl )
 CALL Initialise_transform_vars ( OutputState )
 CALL Initialise_transform_vars ( TempState ) 
   
 Ctrl_vect(1:nvars*nlevs, 1:nlongs ) = (0.0,0.0)
 !==============================================================================================

 
 !==============================================================================================
 ! Define a perturbation to examine implied covariances of
 !----------------------------------------------------------
 x = 180
 z = 30
 x_scale = 25.0
 z_scale = 9.0
! 
 DO i = 1, nlongs
   DO k = 1, nlevs
    temp1 = (x - i) * (x - i)
    temp2 = (z - k) * (z - k)
    TempState % r(i,k) = 1.0 * EXP (-(temp1/x_scale) - (temp2/z_scale) ) 
   END DO
 END DO
 !==============================================================================================
 
! TempState % r (180, 30) = 1.0
 
!  TempState % r = TempState % r * Cz

 !==============================================================================================
 ! Adjoint of CVT: model to control space 
 !----------------------------------------------
 PRINT*, ''
 PRINT*, 'Adjoint cvt'
 PRINT*, '---------------'
 CALL Hoz_For_Adj(TempState, HozCtrl) 
 CALL Vert_For_Adj(HozCtrl, VertCtrl, Dims)
 CALL Eig_For_Adj(VertCtrl, Ctrl_vect, EigVecs, std_eigvecs)
 !==============================================================================================

 
 !==============================================================================================
 ! Truncation of modes
 !---------------------- 
 IF ( truncate .EQ. 1 ) THEN
   PRINT*, ''
   PRINT*, 'Truncating modes'
   PRINT*, '---------------'
   CALL Mode_truncation(EigVecs,acoustic, gravity, balanced)
  ELSE
   PRINT*, ''
   PRINT*, 'No truncation'
   PRINT*,'----------------'
 END IF
 !==============================================================================================


 !==============================================================================================
 ! Forward CVT: control to model space
 !-------------------------------------
 PRINT*, ''
 PRINT*, 'Forward cvt'
 PRINT*, '---------------'
 CALL Eig_For(Ctrl_vect, VertCtrl, EigVecs, std_eigvecs)
 CALL Vert_For(VertCtrl, HozCtrl, Dims)
 CALL Hoz_For(HozCtrl, OutputState) 
 !==============================================================================================

 !OutputState % r = OutputState % r / Cz
 !==============================================================================================
 ! Write data
 !-----------
 imp_covs_file = '/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs.nc'
 CALL Write_state_2d (imp_covs_file,Outputstate, Dims, 1, 0, 1)
 PRINT*, '----------------------------------------------------'
 PRINT*, 'IMPLIED COVARAINCES CALCULATED'
 PRINT*, 'xconv ',imp_covs_file,'&'
 PRINT*, '----------------------------------------------------'
 !==============================================================================================
   
 END SUBROUTINE Calc_implied_covs
!===================================================================================================
!***************************************************************************************************
!=================================================================================================== 


!===================================================================================================
!***************************************************************************************************
!=================================================================================================== 
 SUBROUTINE Mode_truncation(EigVecs, acoustic, gravity, balanced)  
 USE DefConsTypes
 IMPLICIT NONE

 ! Declare Top lev Variables
 !-----------------------------
! REAL(wp),                  INTENT(INOUT)     :: Ctrl_state(1:nvars*nlevs, 1:nlongs )
 REAL(wp),                  INTENT(INOUT)     :: EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs)
 INTEGER,                   INTENT(IN)        :: acoustic, gravity, balanced
 ! Declare Local Variables
 !---------------------------
 
 ! Counters
 INTEGER                                      :: k 

  ! remove  acoustic modes    
   IF ( acoustic .EQ. 1 ) THEN
     PRINT*,'Acoustic modes removed'
!     Ctrl_state(  1:60,1:nlongs)  = (0.0,0.0)
!     Ctrl_state(241:300,1:nlongs) = (0.0,0.0)
      EigVecs(1:nlongs,1:nvars*nlevs,1:60)    = (0.0,0.0)
      EigVecs(1:nlongs,1:nvars*nlevs,241:300) = (0.0,0.0)
   END IF
 
   ! remove gravity modes    
   IF ( gravity .EQ. 1 ) THEN
     PRINT*,'Gravity modes removed'
!     Ctrl_state( 61:120,1:nlongs) = (0.0,0.0)
!     Ctrl_state(181:240,1:nlongs) = (0.0,0.0)
      EigVecs(1:nlongs,1:nvars*nlevs,61:120)  = (0.0,0.0)
      EigVecs(1:nlongs,1:nvars*nlevs,181:240) = (0.0,0.0)
   END IF
    
   IF ( balanced .EQ. 1 ) THEN
   ! Remove balanced mode    
     PRINT*,'Balanced mode removed'
!     Ctrl_state(121:180,1:nlongs) = (0.0,0.0)
      EigVecs(1:nlongs,1:nvars*nlevs,121:180) = (0.0,0.0)
   END IF
    
 
 END SUBROUTINE Mode_truncation

!===================================================================================================
!***************************************************************************************************
!=================================================================================================== 
 SUBROUTINE Fwd_inv_cvt_test(InitState, Dims, EigVecs, std_eigvecs )
 
 !*******************************************
 !* Subroutine to perform forward -inverse  *
 !* cvt test                                * 
 !*******************************************
 
 USE DefConsTypes
 IMPLICIT NONE
 
 ! Declare Top lev Variables
 !-----------------------------

 TYPE(model_vars_type),     INTENT(IN)        :: InitState
 TYPE(Dimensions_type),     INTENT(IN)        :: Dims
 REAL(wp),                  INTENT(IN)        :: EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs)
 REAL(wp),                  INTENT(IN)        :: std_eigvecs(1:nvars*nlevs, 1:nlongs )

 ! Declare Local Variables
 !---------------------------
 TYPE(model_vars_type)                        :: OutputState
 TYPE(Transform_type)                         :: HozCtrl, VertCtrl  ! intermediate control variables
 COMPLEX(wp)                                  :: Ctrl_vect(1:nvars*nlevs, 1:nlongs )
 COMPLEX(wp)                                  :: Ctrl_vect_tmp(1:nvars*nlevs, 1:nlongs )

 ! Counters
 INTEGER                                      :: k,m

 CALL Initialise_transform_vars ( HozCtrl )
 CALL Initialise_transform_vars ( VertCtrl )
 CALL Initialise_model_vars ( OutputState )
 CALL Initialise_model_vars ( OutputState )
    
 ! Dump Initial Data
 !------------------- 
 OPEN(55, file = '/home/wx019276/DATA/CVT/orig_u.dat')
 OPEN(56, file = '/home/wx019276/DATA/CVT/orig_v.dat')
 OPEN(57, file = '/home/wx019276/DATA/CVT/orig_w.dat')
 OPEN(58, file = '/home/wx019276/DATA/CVT/orig_b.dat')
 OPEN(59, file = '/home/wx019276/DATA/CVT/orig_r.dat')
 DO k = 1, nlevs
   WRITE (55, *) InitState % u(:,k)
   WRITE (56, *) InitState % v(:,k)
   WRITE (57, *) InitState % w(:,k)
   WRITE (58, *) InitState % b(:,k)
   WRITE (59, *) InitState % r(:,k)
 END DO
 CLOSE(55)
 CLOSE(56)
 CLOSE(57)
 CLOSE(58)
 CLOSE(59)

 ! Perform inverse CVT: model - control
 !--------------------------------------
 CALL Hoz_Inv  (InitState, HozCtrl)
 CALL Vert_Inv (HozCtrl, VertCtrl, Dims)
!---------------------------------------------- 
! PRINT*,'  TESTING'

! PRINT*, 'u, v, w, r, b' 
! DO m = 1, 60
!   PRINT*, VertCtrl % r(m,181)
! END DO
! STOP
!---------------------------------------------- 
 CALL Eig_Inv  (VertCtrl, Ctrl_vect, EigVecs, 0, std_eigvecs)
 ! zero option in eig inv switched to off to allow scaling.
 PRINT*, '-------------------------------'
 PRINT*, 'COMPLETED INVERSE PROJECTION TO CONTROL VARIABLES'
 PRINT*, '-------------------------------'
 PRINT*, '                               '
 PRINT*, '-------------------------------'
 
 ! TRUNCATE SMALL WAVE NUMBERS
 !-----------------------------
! std_eigvecs (41   :60 ,:)        = (0.0, 0.0)   !q1
! std_eigvecs (1+60 :60+60 ,:)     = (0.0, 0.0)   !q2
! std_eigvecs (1+120:60+120,:)     = (0.0, 0.0)   !q3
! std_eigvecs (1+180:60+180,:)     = (0.0, 0.0)   !q4
! std_eigvecs (1+240:21+240,:)     = (0.0, 0.0)   !q5

 
 ! Perform forward CVT: control - model
 !--------------------------------------
 CALL Eig_for (Ctrl_vect, VertCtrl, EigVecs, std_eigvecs)
 CALL Vert_For(VertCtrl, HozCtrl, Dims)
 CALL Hoz_for (HozCtrl, OutputState, Dims)
 PRINT*, '-------------------------------'
 PRINT*, 'COMPLETED FORWARD PROJECTION TO MODEL VARIABLES'

 ! Dump test data
 !----------------
 OPEN(55, file = '/home/wx019276/DATA/CVT/InvTest_u.dat')
 OPEN(56, file = '/home/wx019276/DATA/CVT/InvTest_v.dat')
 OPEN(57, file = '/home/wx019276/DATA/CVT/InvTest_w.dat')
 OPEN(58, file = '/home/wx019276/DATA/CVT/InvTest_b.dat')
 OPEN(59, file = '/home/wx019276/DATA/CVT/InvTest_r.dat')
   
 DO k = 1, nlevs
   WRITE (55, *) OutputState % u(:,k)
   WRITE (56, *) OutputState % v(:,k)
   WRITE (57, *) OutputState % w(:,k)
   WRITE (58, *) OutputState % b(:,k)
   WRITE (59, *) OutputState % r(:,k)
 ENDDO 
 CLOSE(55)
 CLOSE(56)
 CLOSE(57)
 CLOSE(58)
 CLOSE(59)
    
 END SUBROUTINE Fwd_inv_cvt_test 
!===================================================================================================
!***************************************************************************************************
!=================================================================================================== 
 SUBROUTINE Adjoint_test (InitState, Dims, adj_test_flag, EigVecs, std_eigvecs )
 USE DefConsTypes
 IMPLICIT NONE

 !----------------------------------------------------
 ! Subroutine to perform testing of adjoint routines
 ! of the control variable transform 
 !
 ! 31/5/2011
 ! R. Petrie
 ! 0.01
 !----------------------------------------------------

 ! Declare Top lev Variables
 !-----------------------------

 TYPE(model_vars_type),     INTENT(IN)        :: InitState
 TYPE(Dimensions_type),     INTENT(IN)        :: Dims
 INTEGER,                   INTENT(IN)        :: adj_test_flag
 REAL(wp),                  INTENT(IN)        :: EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs)
 REAL(wp),                  INTENT(IN)        :: std_eigvecs(1:nvars*nlevs, 1:nlongs )


 ! Declare Local Variables
 !---------------------------
 TYPE(model_vars_type)                              :: OutputState, TempState
 TYPE(transform_type)                         :: HozCtrl, VertCtrl, TempCtrl, TempCtrl2
 COMPLEX(wp)                                  :: Ctrl_vect(1:nvars*nlevs, 1:nlongs )
 COMPLEX(wp)                                  :: Ctrl_vect_tmp(1:nvars*nlevs, 1:nlongs )

 ! Counters
 INTEGER                                      :: k


 CALL Initialise_transform_vars ( HozCtrl )
 CALL Initialise_transform_vars ( VertCtrl )
 CALL Initialise_transform_vars ( TempCtrl ) 
 CALL Initialise_transform_vars ( TempCtrl2 ) 
 CALL Initialise_model_vars ( OutputState )
 CALL Initialise_model_vars ( TempState ) 

 Ctrl_vect(1:nvars*nlevs, 1:nlongs ) = (0.0,0.0)
 Ctrl_vect_tmp(1:nvars*nlevs, 1:nlongs ) = (0.0,0.0)

!***************************************************************************************************
! ADJOINT TEST 
!***************************************************************************************************
 
  SELECT CASE(adj_test_flag)
 
  CASE(1)
   ! Horizontal Transform Adjoint Test
   !-----------------------------------
   PRINT*, 'TESTING ADJOINT OF HORIZONTAL TRANSFORM'
   PRINT*,'--------------------------------------------------'
   CALL Hoz_Inv(InitState, HozCtrl)
   TempCtrl = HozCtrl
   CALL Hoz_for(HozCtrl, OutputState)
   CALL Hoz_for_Adj(OutputState, HozCtrl) 
   CALL Adj_test_hoz(TempCtrl, OutputState, HozCtrl)
 
  CASE(2)
   ! Eigenvector Transform Adjoint Test
   !------------------------------------
   PRINT*, 'TESTING ADJOINT OF EIGENVECTOR TRANSFORM'
   PRINT*,'--------------------------------------------------'
   CALL Hoz_Inv(InitState, HozCtrl)
   CALL Eig_inv(HozCtrl, Ctrl_vect, EigVecs, 0, std_eigvecs)
   Ctrl_vect_tmp = Ctrl_vect
   CALL Eig_for(Ctrl_vect, VertCtrl, EigVecs, std_eigvecs)
   TempCtrl = VertCtrl
   CALL Eig_For_Adj(VertCtrl, Ctrl_vect, EigVecs, std_eigvecs)
   CALL Adj_test_eig(Ctrl_vect_tmp, TempCtrl, Ctrl_vect)

  CASE(3)
   ! Horizontal and Eigenvector Adjoint Test
   !-----------------------------------------
   PRINT*, 'TESTING ADJOINT OF HORIZONTAL AND EIGENVECTOR TRANSFORM'
   PRINT*,'--------------------------------------------------'
   CALL Hoz_Inv(InitState, HozCtrl)
   CALL Eig_inv(HozCtrl, Ctrl_vect, EigVecs, 0, std_eigvecs)
   Ctrl_vect_tmp = Ctrl_vect !INITIAL DATA
   CALL Eig_for(Ctrl_vect, HozCtrl, EigVecs, std_eigvecs)
   CALL Hoz_for(HozCtrl, OutputState)
   TempState = OutputState
   CALL Hoz_for_Adj(OutputState, TempCtrl) 
   CALL Eig_For_Adj(TempCtrl, Ctrl_vect, EigVecs, std_eigvecs)
   CALL Adj_test_hozeig(Ctrl_vect_tmp, TempState, Ctrl_vect)

  CASE(4)
   ! Vertical Transform Adjoint Test
   !------------------------------------
   PRINT*, 'TESTING ADJOINT OF Vertical TRANSFORM'
   PRINT*,'--------------------------------------------------'
   CALL Hoz_Inv(InitState, HozCtrl)
   CALL Vert_inv(HozCtrl, VertCtrl, Dims)
 !   VertCtrl % r (:,:) = (1.0, 1.0)
   TempCtrl = VertCtrl
   CALL Vert_for(VertCtrl, HozCtrl, Dims)
   TempCtrl2 = HozCtrl
   CALL Vert_for_adj(HozCtrl, VertCtrl, Dims)
   CALL Adj_test_vert(TempCtrl, TempCtrl2, VertCtrl)   


  CASE(5)
   ! Full Adjoint Test
   !------------------------------------
   PRINT*, 'TESTING ADJOINT CONTROL VARIABLE TRANSFORM'
   PRINT*,'--------------------------------------------------'
 
   ! Generate initial data for adjoint test
   PRINT*, ' INVERSE TRANSFORM '
   CALL Hoz_Inv(InitState, HozCtrl)
   CALL Vert_Inv(HozCtrl, VertCtrl, Dims)
   CALL Eig_Inv(VertCtrl, Ctrl_vect, EigVecs, 0,std_eigvecs)
   
   ! Initial Conditions Ctrl_vect
   Ctrl_vect_tmp = Ctrl_vect

   PRINT*, '=========================================='
   PRINT*, ' FORWARD TRANSFORM '
   CALL Eig_For(Ctrl_vect, VertCtrl, EigVecs, std_eigvecs)
   CALL Vert_For(VertCtrl, HozCtrl, Dims)
   CALL Hoz_For(HozCtrl, OutputState) 
   
   ! Aout
   TempState = OutputState
   
   PRINT*, '=========================================='
   PRINT*, ' ADJOINT TRANSFORM ' 
   CALL Hoz_For_Adj(OutputState, HozCtrl) 
   CALL Vert_For_adj(HozCtrl, VertCtrl, Dims)
   CALL Eig_For_Adj(VertCtrl, Ctrl_vect, EigVecs, std_eigvecs)
   
   CALL Adj_Test(Ctrl_vect_tmp, TempState, Ctrl_vect)   


  END SELECT

 END SUBROUTINE Adjoint_test 
!===================================================================================================
!***************************************************************************************************
!=================================================================================================== 



!===================================================================================================
!***************************************************************************************************
!=================================================================================================== 
 SUBROUTINE Gen_eigenvecs_of_L(Dims, EigVecs, EigVals, eigenvects_file, eigenvals_file)
 
 !******************************************
 ! Subroutine to calculate eigenvectors of *
 !     the system matrix (L)               *
 !******************************************
 USE DefConsTypes
 USE nag_sym_eig, ONLY : nag_sym_eig_all
 USE nag_mat_inv
 IMPLICIT NONE

 ! Declare Top lev Variables
 !-----------------------------
 TYPE(Dimensions_type), INTENT(IN)     :: Dims
 REAL(wp),              INTENT(INOUT)  :: EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs)
 REAL(wp),              INTENT(INOUT)  :: EigVals(1:nlongs, 1:nvars*nlevs) 
 CHARACTER(LEN=*),      INTENT(IN)     :: eigenvects_file
 CHARACTER(LEN=*),      INTENT(IN)     :: eigenvals_file

 ! Declare Local Variables
 !-----------------------------

 REAL(wp)                              :: Lmat(1:nlongs, 1:nvars*nlevs, 1:nvars*nlevs )
 REAL(wp)                              :: Lsub3(1:3*nlevs, 1:3*nlevs )
 REAL(wp)                              :: EVs3(1:3*nlevs, 1:3*nlevs )
 REAL(wp)                              :: lambda3(1:3*nlevs)
 REAL(wp)                              :: zt3(1:3*nlevs, 1:3*nlevs )
 REAL(wp)                              :: zt2(1:2*nlevs, 1:2*nlevs )
 REAL(wp)                              :: gama(1:nlevs, 1:nlevs)
 REAL(wp)                              :: alpha, beta, sqrtb, rho0, nof, Nbv
 REAL(wp)                              :: lambda(1:nvars*nlevs)
 REAL(wp)                              :: zt(1:nvars*nlevs,1:nvars*nlevs)
 REAL(wp)                              :: InvEigVecs(1:nlongs, 1:nvars*nlevs, 1:nvars*nlevs ) 
 CHARACTER (1)                         :: uplo
 INTEGER                               :: l, k, i, j, m, n,mm,nn, kk, ii, jj
 
 ! Filenames
 CHARACTER                             :: eigenvects_filename*70, eigenvals_filename*70

 ! Calculate local parameters
 !----------------------------
 rho0  = 1.0 !0.827137008601474
 sqrtb = sqrt(B * Cz * rho0) 
 alpha = (-4.0 * pi * sqrtb) / (Dims % full_levs(nlevs) * f0 * dx * nlongs)  
 beta  = (pi * sqrtb)/(Dims % full_levs(nlevs) * f0)
 Nbv   = sqrt(Nsq)
 nof   = Nbv / f0
 uplo  = 'u'
 
 
 PRINT*, '-----------------------------------------------------------------------'
 PRINT*, ' Calculating Eigenvectors of system matrix for'
 PRINT*, 'A: ',Nsq 
 PRINT*, 'B: ',B 
 PRINT*, 'C: ',Cz 
 PRINT*, '-----------------------------------------------------------------------'

 ! Calculate gama
 !-----------------
 DO m = 1, nlevs
    DO n = 1, nlevs
    mm = m-1
    nn = n-1
    gama(m,n) = ( 2.0 * Dims % full_levs(nlevs) * (2.0*(REAL(mm)) + 1.0) )/&
             (pi *((4.0*(REAL(mm)) * (REAL(mm)) + 4.0  * (REAL(mm)) - 4.0*((REAL(nn))*(REAL(nn))) +1.0)))
    ENDDO
  ENDDO
 PRINT*, 'gama DONE'

 ! ********************
 ! *** SET L MATRIX ***
 ! ********************

 ! k not equal to 0
 !------------------

 ! Initialise L matrix to zero
 !-----------------------------
 Lmat(:,:,:) = 0.0 
 
 ! Set alpha*k*gama
 !-------------------

 DO k = 1, nlongs
   kk = k - 1 - (nlongs/2) 
   Lmat(k,1:nlevs,3*nlevs+1:4*nlevs) = gama(1:nlevs, 1:nlevs)
   DO j = 3*nlevs+1, 4*nlevs
     DO i = 1, nlevs
       Lmat(k,i,j) = REAL(kk) * alpha * Lmat(k,i,j) 
     ENDDO
   ENDDO
   Lmat(k,3*nlevs+1:4*nlevs, 1:nlevs) = TRANSPOSE(gama(1:nlevs, 1:nlevs))
   DO j = 1, nlevs
     DO i = 3*nlevs+1, 4*nlevs
	     Lmat(k,i,j) = REAL(kk) * alpha * Lmat(k,i,j)
     ENDDO
   ENDDO
 ENDDO

 ! Set Identity sub matrices
 !---------------------------
 j = nlevs + 1
 DO i = 1, nlevs
    Lmat(1:nlongs,i,j) = 1.0
    j = j+1
 ENDDO 

 j = 1
 DO i = nlevs+1, 2*nlevs
    Lmat(1:nlongs,i,j) = 1.0
    j = j+1
 ENDDO 

 ! Set N/fo I submatrices
 !------------------------
 j = 4*nlevs + 1
 DO i = 2*nlevs+1, 3*nlevs
    Lmat(1:nlongs,i,j) = nof
    j = j+1
 ENDDO
 
 j = 2*nlevs+1
 DO i =  4*nlevs + 1, 5*nlevs
    Lmat(1:nlongs,i,j) = nof
    j = j+1
 ENDDO
 
 ! Set beta N submatrices
 !------------------------
 j = 3*nlevs+1
 !m = minvertwaveno
 m = 0
 DO i = 2*nlevs+1, 3*nlevs
   Lmat(1:nlongs,i,j) = beta * (REAL(m))
   j = j+1
   m = m+1
 ENDDO
 
 j = 2*nlevs+1
 !m = minvertwaveno
 m = 0
 DO i = 3*nlevs+1, 4*nlevs
   Lmat(1:nlongs,i,j) = beta * (REAL(m))
   j = j+1
   m = m+1
 ENDDO

 ! Dump L matrix
 !--------------
 OPEN(56, file = '/home/wx019276/DATA/CVT/Lmattest.dat')
 DO i = 1,nlongs
   DO k = 1,nlevs*nvars
     WRITE (56, *) Lmat(i,1:nvars*nlevs,k)
   ENDDO
 ENDDO
 CLOSE(56) 
!--------------

 PRINT*, ' CALCULATING EIGENVECTORS'
 PRINT*, '......'
 DO k = 1,nlongs
    PRINT*, k
    CALL nag_sym_eig_all(uplo, Lmat(k,1:nvars*nlevs,1:nvars*nlevs), lambda, z=zt)
    EigVals(k,1:nvars*nlevs)   = lambda
    EigVecs(k,1:nvars*nlevs,1:nvars*nlevs) = zt(1:nvars*nlevs,1:nvars*nlevs)
 ENDDO

 !*****************************
 !* Consider case when k = 0  *
 !*****************************
 
 ! Set Eigenvector matrix to zero
 !---------------------------------
 EigVecs(181,1:nvars*nlevs,1:nvars*nlevs) = 0.0

 ! Set 3 x 3 submatrix
 !---------------------
 Lsub3(1:3*nlevs, 1:3*nlevs) = 0.0
 
 ! Set beta N submatrices
 !------------------------
 j = 1
 m = 0
 DO i =  nlevs+1, 2*nlevs
    Lsub3(i,j) = beta * (REAL(m))
    j = j+1
    m = m+1
 ENDDO
 
 j = nlevs+1
 m = 0
 DO i = 1, nlevs
    Lsub3(i,j) = beta * (REAL(m))
    j = j+1
    m = m+1
 ENDDO
 
 ! Set N/fo I submatrices
 !------------------------
 j = 2*nlevs + 1
 DO i = 1, nlevs
    Lsub3(i,j) = nof
    j = j+1
 ENDDO
 
 j = 1
 DO i =  2*nlevs + 1, 3*nlevs
    Lsub3(i,j) = nof
   j = j+1
 ENDDO

 ! Dump sub matrix
 !-------------------
 OPEN(56, file = '/home/wx019276/DATA/CVT/Lsub3test.dat')
  DO k = 1, 3*nlevs
    WRITE (56, *) Lsub3(k,1:3*nlevs)
  ENDDO
 CLOSE(56) 

 ! Calculate Eigenvectors of submatrix
 !--------------------------------------
 CALL nag_sym_eig_all(uplo, Lsub3, lambda3, z=zt3)
 EVs3 = zt3
 
 OPEN(56, file = '/home/wx019276/DATA/CVT/Eigsubmattest.dat')
  DO k = 1, 3*nlevs
    WRITE (56, *) EVs3(1:3*nlevs,k)
  ENDDO
 CLOSE(56) 
 
 
 ! Set Eigenvector matrix
 !-------------------------
 EigVecs(181,1:nvars*nlevs,1:nvars*nlevs) = 0.0

 ! Set chi and psi identity matrix
 !---------------------------------
 k =  nlevs + 1
 DO j = 1, nlevs
   EigVecs(181,j,k) = 1.0
   k = k+1
 ENDDO
 
 k = 1
 DO j = nlevs+1, 2*nlevs
   EigVecs(181,j,k) = 1.0
   k = k+1
 ENDDO
 
 
 ! Set 3x3 submatrix
 !-------------------
 EigVecs(181,2*nlevs+1:nvars*nlevs,2*nlevs+1:nvars*nlevs) = EVs3(1:3*nlevs, 1:3*nlevs)
 
 ! Dump Eigenvectors
 !--------------------
 
 PRINT*,'Writing Eigenvectors'
 PRINT*,'...'

 eigenvects_filename =  eigenvects_file//'.bin' 
 OPEN(56, file = eigenvects_filename , form = 'unformatted')
 DO i = 1,nlongs
   DO k = 1, nvars*nlevs
     WRITE (56) EigVecs(i,k,1:nvars*nlevs)
   ENDDO
 ENDDO
 CLOSE(56)

 eigenvals_filename = eigenvals_file//'.bin'
 OPEN(56, file = eigenvals_filename, form = 'unformatted')
 DO i = 1,nlongs
     WRITE (56) EigVals(i,1:nvars*nlevs)
 ENDDO
 CLOSE(56)

 eigenvects_filename =  eigenvects_file//'.dat' 
 OPEN(56, file = eigenvects_filename)
 DO i = 1,nlongs
   DO k = 1, nvars*nlevs
     WRITE (56, *) EigVecs(i,k,1:nvars*nlevs)
   ENDDO
 ENDDO
 CLOSE(56)
 
 eigenvals_filename = eigenvals_file//'.dat'
 OPEN(56, file = eigenvals_filename)
 DO i = 1,nlongs
     WRITE (56, *) EigVals(i,1:nvars*nlevs)
 ENDDO
 CLOSE(56)
 
END SUBROUTINE Gen_eigenvecs_of_L
!===================================================================================================
!***************************************************************************************************
!=================================================================================================== 
SUBROUTINE Adj_test(statein, Aout, adjointout)

 !****************************
 !* Subroutine to perform    *
 !*   an adjoint test        *
 !*                          *
 !*--------------------------*  
 !*(Ax)^T (Ax) ?= x^T A^T(Ax)*  
 !*--------------------------*  
 !*                          *
 !* statein = x              * 
 !* Aout = Ax                *
 !* adjointout = A^T (Ax)    *
 !*                          *
 !****************************

 USE DefConsTypes
 IMPLICIT NONE

 ! Declare Top lev Variables
 !-----------------------------
 TYPE(model_vars_type), INTENT(IN)     :: Aout 
 COMPLEX(wp)                           :: statein(1:nvars*nlevs, 1:nlongs )
 COMPLEX(wp)                           :: adjointout(1:nvars*nlevs, 1:nlongs )
 
 ! Declare Local Variables
 !-----------------------------
 COMPLEX(wp)                     :: LHS, RHS
 INTEGER                         :: i,k

 ! Initialise Local Variables
 !----------------------------
 LHS = 0.0
 RHS = 0.0
 
 ! Test field u
 !--------------
 
 DO k = 1, nlevs
  DO i = 1, nlongs
  !i = 7
     LHS = LHS + (Aout % u(i,k)) * ( Aout % u(i,k) ) & 
               + (Aout % v(i,k)) * ( Aout % v(i,k) ) & 
               + (Aout % w(i,k)) * ( Aout % w(i,k) ) & 
               + (Aout % r(i,k)) * ( Aout % r(i,k) ) & 
               + (Aout % b(i,k)) * ( Aout % b(i,k) ) 
   ENDDO
 ENDDO
 
 DO k = 1, nvars*nlevs
  DO i = 1, nlongs
!    i = 7
     RHS = RHS + CONJG(statein(k,i)) * adjointout(k,i)
   ENDDO
 ENDDO
 
 PRINT*,'Full Adjoint Test Result'
 PRINT*,'LHS: ', LHS
 PRINT*,'RHS: ', RHS


 END SUBROUTINE Adj_Test
!===================================================================================================
!***************************************************************************************************
!=================================================================================================== 
 SUBROUTINE Adj_test_vert (statein, Aout, adjointout)

 !****************************
 !* Subroutine to perform    *
 !*   an adjoint test        *
 !*                          *
 !*--------------------------*  
 !*(Ax)^T (Ax) ?= x^T A^T(Ax)*  
 !*--------------------------*  
 !*                          *
 !* statein = x              * 
 !* Aout = Ax                *
 !* adjointout = A^T (Ax)    *
 !*                          *
 !****************************

 USE DefConsTypes
 IMPLICIT NONE

 ! Declare Top lev Variables
 !-----------------------------
 TYPE(transform_type),      INTENT(IN)        :: statein, adjointout, Aout
 
 ! Declare Local Variables
 !-----------------------------
 COMPLEX(wp)                                  :: LHS, RHS
 INTEGER                                      :: i,k

 ! Initialise Local Variables
 !----------------------------
 LHS = 0.0
 RHS = 0.0
 
 ! Test field u
 !--------------
 
 DO k = 1, nlevs
!  DO i = 1, nlongs
 i =5
     LHS = LHS + CONJG(Aout % u(k,i)) * (Aout % u(k,i))
     RHS = RHS + CONJG(statein % u(k,i)) * adjointout % u(k,i)
 !  ENDDO
 ENDDO
 
 PRINT*, '  u'
 PRINT*, '------'
 PRINT*, 'LHS:', LHS
 PRINT*, 'RHS:', RHS

 ! Test field v
 !--------------
 LHS = 0.0
 RHS = 0.0

 DO k = 1, nlevs
   DO i = 1, nlongs
     LHS = LHS + CONJG(Aout % v(k,i)) * (Aout % v(k,i))
     RHS = RHS + CONJG(statein % v(k,i)) * adjointout % v(k,i)
   ENDDO
 ENDDO
  
 PRINT*, '  v'
 PRINT*, '------'
 PRINT*, 'LHS:', LHS
 PRINT*, 'RHS:', RHS


 ! Test field w
 !--------------

 LHS = 0.0
 RHS = 0.0

 DO k = 1, nlevs
 !  DO i = 1, nlongs
  i= 5
     LHS = LHS + CONJG(Aout % w(k,i)) * (Aout % w(k,i))
     RHS = RHS + CONJG(statein % w(k,i)) * adjointout % w(k,i)
  ! ENDDO
 ENDDO
  
 PRINT*, '  w'
 PRINT*, '------'
 PRINT*, 'LHS:', LHS
 PRINT*, 'RHS:', RHS


 ! Test field b
 !--------------
 LHS = 0.0
 RHS = 0.0

 DO k = 1, nlevs
!   DO i = 1, nlongs
  i= 5
     LHS = LHS + CONJG(Aout % b(k,i)) * (Aout % b(k,i))
     RHS = RHS + CONJG(statein % b(k,i)) * adjointout % b(k,i)
!   ENDDO
 ENDDO
 
  PRINT*, '  b'
 PRINT*, '------'
 PRINT*, 'LHS:', LHS
 PRINT*, 'RHS:', RHS


 ! Test field r
 !--------------
 LHS = 0.0
 RHS = 0.0

 DO k =1, nlevs
   i= 5
  !DO i = 1, nlongs
     LHS = LHS + CONJG(Aout % r(k,i)) * (Aout % r(k,i))
     RHS = RHS + CONJG(statein % r(k,i)) * adjointout % r(k,i)
 !  ENDDO
 ENDDO
 
 PRINT*, '  r'
 PRINT*, '------'
 PRINT*, 'LHS:', LHS
 PRINT*, 'RHS:', RHS


 END SUBROUTINE Adj_test_vert
!===================================================================================================
!***************************************************************************************************
!=================================================================================================== 
 SUBROUTINE Adj_test_hoz (statein, Aout, adjointout)

 !****************************
 !* Subroutine to perform    *
 !*   an adjoint test        *
 !*                          *
 !*--------------------------*  
 !*(Ax)^T (Ax) ?= x^T A^T(Ax)*  
 !*--------------------------*  
 !*                          *
 !* statein = x              * 
 !* Aout = Ax                *
 !* adjointout = A^T (Ax)    *
 !*                          *
 !****************************

 USE DefConsTypes
 IMPLICIT NONE

 ! Declare Top lev Variables
 !-----------------------------
 TYPE(model_vars_type),     INTENT(IN)        :: Aout 
 TYPE(transform_type),      INTENT(IN)        :: statein, adjointout
 
 ! Declare Local Variables
 !-----------------------------
 COMPLEX(wp)                                  :: LHS, RHS
 INTEGER                                      :: i,k

 ! Initialise Local Variables
 !----------------------------
 LHS = 0.0
 RHS = 0.0
 
 ! Test field u
 !--------------
 
! DO k = 1, nlevs
  k = 4
  DO i = 1, nlongs
     LHS = LHS + (Aout % u(i,k)) * (Aout % u(i,k))
     RHS = RHS + CONJG(statein % u(k,i)) * adjointout % u(k,i)
 !  ENDDO
 ENDDO
 
  PRINT*, '  u'
 PRINT*, '------'
 PRINT*, 'LHS:', LHS
 PRINT*, 'RHS:', RHS

 ! Test field v
 !--------------
 LHS = 0.0
 RHS = 0.0

 DO k = 1, nlevs
   DO i = 1, nlongs
     LHS = LHS + (Aout % v(i,k)) * (Aout % v(i,k))
     RHS = RHS + CONJG(statein % v(k,i)) * adjointout % v(k,i)
   ENDDO
 ENDDO
  
 PRINT*, '  v'
 PRINT*, '------'
 PRINT*, 'LHS:', LHS
 PRINT*, 'RHS:', RHS

 ! Test field w
 !--------------

 LHS = 0.0
 RHS = 0.0

 DO k = 1, nlevs
   DO i = 1, nlongs
     LHS = LHS + (Aout % w(i,k)) * (Aout % w(i,k))
     RHS = RHS + CONJG(statein % w(k,i)) * adjointout % w(k,i)
   ENDDO
 ENDDO
  
 PRINT*, '  w'
 PRINT*, '------'
 PRINT*, 'LHS:', LHS
 PRINT*, 'RHS:', RHS

 ! Test field b
 !--------------
 LHS = 0.0
 RHS = 0.0

 DO k = 1, nlevs
   DO i = 1, nlongs
     LHS = LHS + (Aout % b(i,k)) * (Aout % b(i,k))
     RHS = RHS + CONJG(statein % b(k,i)) * adjointout % b(k,i)
   ENDDO
 ENDDO
 
 PRINT*, '  b'
 PRINT*, '------'
 PRINT*, 'LHS:', LHS
 PRINT*, 'RHS:', RHS

 ! Test field r
 !--------------
 LHS = 0.0
 RHS = 0.0

 DO k = 1, nlevs
   DO i = 1, nlongs
     LHS = LHS + (Aout % r(i,k)) * (Aout % r(i,k))
     RHS = RHS + CONJG(statein % r(k,i)) * adjointout % r(k,i)
   ENDDO
 ENDDO
 
 PRINT*, '  r'
 PRINT*, '------'
 PRINT*, 'LHS:', LHS
 PRINT*, 'RHS:', RHS

 END SUBROUTINE Adj_test_hoz
!===================================================================================================
!***************************************************************************************************
!=================================================================================================== 
 SUBROUTINE Adj_test_eig(statein, Aout, adjointout)

 !****************************
 !* Subroutine to perform    *
 !*   an adjoint test        *
 !*                          *
 !*--------------------------*  
 !*(Ax)^T (Ax) ?= x^T A^T(Ax)*  
 !*--------------------------*  
 !*                          *
 !* statein = x              * 
 !* Aout = Ax                *
 !* adjointout = A^T (Ax)    *
 !*                          *
 !****************************

 USE DefConsTypes
 IMPLICIT NONE

 ! Declare Top lev Variables
 !-----------------------------
 TYPE(transform_type), INTENT(IN)        :: Aout
 COMPLEX(wp), INTENT(IN)                 :: statein(1:nvars*nlevs, 1:nlongs )
 COMPLEX(wp), INTENT(IN)                 :: adjointout(1:nvars*nlevs, 1:nlongs )

 ! Declare Local Variables
 !-----------------------------
 COMPLEX(wp)                             :: LHS, RHS
 INTEGER                                 :: i,k

 ! Initialise Local Variables
 !----------------------------
 LHS = (0.0,0.0)
 RHS = (0.0,0.0)
 
 DO k = 1, nlevs
  DO i = 131, 131
     LHS = LHS + CONJG(Aout % u(k,i)) * ( Aout % u(k,i) ) & 
               + CONJG(Aout % v(k,i)) * ( Aout % v(k,i) ) & 
               + CONJG(Aout % w(k,i)) * ( Aout % w(k,i) ) & 
               + CONJG(Aout % r(k,i)) * ( Aout % r(k,i) ) & 
               + CONJG(Aout % b(k,i)) * ( Aout % b(k,i) ) 
 ENDDO
 ENDDO
 
 DO k = 1, nlevs*nvars
   DO i = 131, 131
 
     RHS = RHS + CONJG(statein(k,i)) * (adjointout(k,i))
 ENDDO
 ENDDO
 
 PRINT*,'Eigenvector Adjoint test 131'
 PRINT*,'LHS: ', LHS
 PRINT*,'RHS: ', RHS
 LHS = (0.0,0.0)
 RHS = (0.0,0.0)


 DO k = 1, nlevs
  DO i = 132, 132
  
     LHS = LHS + CONJG(Aout % u(k,i)) * ( Aout % u(k,i) ) & 
               + CONJG(Aout % v(k,i)) * ( Aout % v(k,i) ) & 
               + CONJG(Aout % w(k,i)) * ( Aout % w(k,i) ) & 
               + CONJG(Aout % r(k,i)) * ( Aout % r(k,i) ) & 
               + CONJG(Aout % b(k,i)) * ( Aout % b(k,i) ) 
 ENDDO
 ENDDO
 
 DO k = 1, nlevs*nvars
   DO i = 132, 132
 
     RHS = RHS + CONJG(statein(k,i)) * (adjointout(k,i))
 ENDDO
 ENDDO
  LHS = (0.0,0.0)
 RHS = (0.0,0.0)

 PRINT*,'Eigenvector Adjoint test 132'
 PRINT*,'LHS: ', LHS
 PRINT*,'RHS: ', RHS

 DO k = 1, nlevs
  DO i = 133, 133
     LHS = LHS + CONJG(Aout % u(k,i)) *( Aout % u(k,i) ) & 
               + CONJG(Aout % v(k,i)) *( Aout % v(k,i) ) & 
               + CONJG(Aout % w(k,i)) *( Aout % w(k,i) ) & 
               + CONJG(Aout % r(k,i)) *( Aout % r(k,i) ) & 
               + CONJG(Aout % b(k,i)) *( Aout % b(k,i) ) 
 ENDDO
 ENDDO
 
 DO k = 1, nlevs*nvars
   DO i = 133, 133
 
     RHS = RHS + CONJG(statein(k,i)) * (adjointout(k,i))
 ENDDO
 ENDDO
 
 PRINT*,'Eigenvector Adjoint test 133'
 PRINT*,'LHS: ', LHS
 PRINT*,'RHS: ', RHS
 LHS = (0.0,0.0)
 RHS = (0.0,0.0)

 DO k = 1, nlevs
  DO i = 134, 134
     LHS = LHS + CONJG(Aout % u(k,i)) *( Aout % u(k,i) ) & 
               + CONJG(Aout % v(k,i)) *( Aout % v(k,i) ) & 
               + CONJG(Aout % w(k,i)) *( Aout % w(k,i) ) & 
               + CONJG(Aout % r(k,i)) *( Aout % r(k,i) ) & 
               + CONJG(Aout % b(k,i)) *( Aout % b(k,i) ) 
 ENDDO
 ENDDO
 
 DO k = 1, nlevs*nvars
   DO i = 134, 134
 
     RHS = RHS + CONJG(statein(k,i)) * (adjointout(k,i))
 ENDDO
 ENDDO
 
 PRINT*,'Eigenvector Adjoint test 134'
 PRINT*,'LHS: ', LHS
 PRINT*,'RHS: ', RHS
 LHS = (0.0,0.0)
 RHS = (0.0,0.0)

 DO k = 1, nlevs
  DO i = 135, 135
     LHS = LHS + CONJG(Aout % u(k,i)) *( Aout % u(k,i) ) & 
               + CONJG(Aout % v(k,i)) *( Aout % v(k,i) ) & 
               + CONJG(Aout % w(k,i)) *( Aout % w(k,i) ) & 
               + CONJG(Aout % r(k,i)) *( Aout % r(k,i) ) & 
               + CONJG(Aout % b(k,i)) *( Aout % b(k,i) ) 
 ENDDO
 ENDDO
 
 DO k = 1, nlevs*nvars
   DO i = 135, 135
 
     RHS = RHS + CONJG(statein(k,i)) * (adjointout(k,i))
 ENDDO
 ENDDO
 
 PRINT*,'Eigenvector Adjoint test 135'
 PRINT*,'LHS: ', LHS
 PRINT*,'RHS: ', RHS
 LHS = (0.0,0.0)
 RHS = (0.0,0.0)

 DO k = 1, nlevs
  DO i = 136, 136
     LHS = LHS + CONJG(Aout % u(k,i)) *( Aout % u(k,i) ) & 
               + CONJG(Aout % v(k,i)) *( Aout % v(k,i) ) & 
               + CONJG(Aout % w(k,i)) *( Aout % w(k,i) ) & 
               + CONJG(Aout % r(k,i)) *( Aout % r(k,i) ) & 
               + CONJG(Aout % b(k,i)) *( Aout % b(k,i) ) 
 ENDDO
 ENDDO
 
 DO k = 1, nlevs*nvars
   DO i = 136, 136 
     RHS = RHS + CONJG(statein(k,i)) * (adjointout(k,i))
 ENDDO
 ENDDO
 
 PRINT*,'Eigenvector Adjoint test 136'
 PRINT*,'LHS: ', LHS
 PRINT*,'RHS: ', RHS
 LHS = (0.0,0.0)
 RHS = (0.0,0.0)

 DO k = 1, nlevs
  DO i = 137, 137
     LHS = LHS + CONJG(Aout % u(k,i)) *( Aout % u(k,i) ) & 
               + CONJG(Aout % v(k,i)) *( Aout % v(k,i) ) & 
               + CONJG(Aout % w(k,i)) *( Aout % w(k,i) ) & 
               + CONJG(Aout % r(k,i)) *( Aout % r(k,i) ) & 
               + CONJG(Aout % b(k,i)) *( Aout % b(k,i) ) 
 ENDDO
 ENDDO
 
 DO k = 1, nlevs*nvars
   DO i = 137, 137
 
     RHS = RHS + CONJG(statein(k,i)) * (adjointout(k,i))
 ENDDO
 ENDDO
 
 PRINT*,'Eigenvector Adjoint test 137'
 PRINT*,'LHS: ', LHS
 PRINT*,'RHS: ', RHS
 LHS = (0.0,0.0)
 RHS = (0.0,0.0)

 DO k = 1, nlevs
  DO i = 138,138
     LHS = LHS + CONJG(Aout % u(k,i)) *( Aout % u(k,i) ) & 
               + CONJG(Aout % v(k,i)) *( Aout % v(k,i) ) & 
               + CONJG(Aout % w(k,i)) *( Aout % w(k,i) ) & 
               + CONJG(Aout % r(k,i)) *( Aout % r(k,i) ) & 
               + CONJG(Aout % b(k,i)) *( Aout % b(k,i) ) 
 ENDDO
 ENDDO
 
 DO k = 1, nlevs*nvars
   DO i = 138,138
 
     RHS = RHS + CONJG(statein(k,i)) * (adjointout(k,i))
 ENDDO
 ENDDO
 
 PRINT*,'Eigenvector Adjoint test 138'
 PRINT*,'LHS: ', LHS
 PRINT*,'RHS: ', RHS
 LHS = (0.0,0.0)
 RHS = (0.0,0.0)

 DO k = 1, nlevs
  DO i = 139, 139
     LHS = LHS + CONJG(Aout % u(k,i)) *( Aout % u(k,i) ) & 
               + CONJG(Aout % v(k,i)) *( Aout % v(k,i) ) & 
               + CONJG(Aout % w(k,i)) *( Aout % w(k,i) ) & 
               + CONJG(Aout % r(k,i)) *( Aout % r(k,i) ) & 
               + CONJG(Aout % b(k,i)) *( Aout % b(k,i) ) 
 ENDDO
 ENDDO
 
 DO k = 1, nlevs*nvars
   DO i = 139, 139
 
     RHS = RHS + CONJG(statein(k,i)) * (adjointout(k,i))
 ENDDO
 ENDDO
 
 PRINT*,'Eigenvector Adjoint test 139'
 PRINT*,'LHS: ', LHS
 PRINT*,'RHS: ', RHS
 LHS = (0.0,0.0)
 RHS = (0.0,0.0)

 DO k = 1, nlevs
  DO i = 140, 140
     LHS = LHS + CONJG(Aout % u(k,i)) *( Aout % u(k,i) ) & 
               + CONJG(Aout % v(k,i)) *( Aout % v(k,i) ) & 
               + CONJG(Aout % w(k,i)) *( Aout % w(k,i) ) & 
               + CONJG(Aout % r(k,i)) *( Aout % r(k,i) ) & 
               + CONJG(Aout % b(k,i)) *( Aout % b(k,i) ) 
 ENDDO
 ENDDO
 
 DO k = 1, nlevs*nvars
   DO i = 140, 140
 
     RHS = RHS + CONJG(statein(k,i)) * (adjointout(k,i))
 ENDDO
 ENDDO
 
 PRINT*,'Eigenvector Adjoint test 140'
 PRINT*,'LHS: ', LHS
 PRINT*,'RHS: ', RHS

 END SUBROUTINE Adj_test_eig
!===================================================================================================
!***************************************************************************************************
!=================================================================================================== 
 SUBROUTINE Adj_test_hozeig (statein, Aout, adjointout)

 !****************************
 !* Subroutine to perform    *
 !*   an adjoint test        *
 !*                          *
 !*--------------------------*  
 !*(Ax)^T (Ax) ?= x^T A^T(Ax)*  
 !*--------------------------*  
 !*                          *
 !* statein = x              * 
 !* Aout = Ax                *
 !* adjointout = A^T (Ax)    *
 !*                          *
 !****************************

 USE DefConsTypes
 IMPLICIT NONE

 ! Declare Top lev Variables
 !-----------------------------
 TYPE(model_vars_type), INTENT(IN)  :: Aout 
 COMPLEX(wp)                        :: statein(1:nvars*nlevs, 1:nlongs )
 COMPLEX(wp)                        :: adjointout(1:nvars*nlevs, 1:nlongs )
 
 ! Declare Local Variables
 !-----------------------------
 COMPLEX(wp)                        :: LHS, RHS
 INTEGER                            :: i,k

 ! Initialise Local Variables
 !----------------------------
 LHS = 0.0
 RHS = 0.0
 
 ! Test field u
 !--------------
 
 DO k = 1, nlevs
  DO i = 1, nlongs
     LHS = LHS + (Aout % u(i,k)) * ( Aout % u(i,k) ) & 
               + (Aout % v(i,k)) * ( Aout % v(i,k) ) & 
               + (Aout % w(i,k)) * ( Aout % w(i,k) ) & 
               + (Aout % r(i,k)) * ( Aout % r(i,k) ) & 
               + (Aout % b(i,k)) * ( Aout % b(i,k) ) 
   ENDDO
 ENDDO
 
 DO k = 1, nvars*nlevs
  DO i = 1, nlongs
     RHS = RHS + CONJG(statein(k,i)) * adjointout(k,i)
   ENDDO
 ENDDO
 
 PRINT*,'  ', '          LHS         ', '             RHS                  '
 PRINT*,'u:', LHS, RHS


 END SUBROUTINE Adj_test_hozeig
!===================================================================================================
!***************************************************************************************************
!=================================================================================================== 


