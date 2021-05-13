! This file contains routines related to ensembles
! Diagnostics to calculate - ensemble variance
!                          - ensemble covariance, correlation
! Generate ensemble routine 
! SUBROUTINE Ens_covariances (ensemble, Dims , cov_file, cor_file, i,j)
! SUBROUTINE Ens_variances ( ensemble, Dims , filename)
! SUBROUTINE Generate_ensemble (ensemble,dims,ensnum, method)
! SUBROUTINE GenPerts(Control, Dims, perturb)
! SUBROUTINE GenEigStd(ensemble,dims,ensnum)
! SUBROUTINE TestCVT(ensemble,dims,ensnum)
!
!***************************************************************************************************

!===================================================================================================
!***************************************************************************************************
!===================================================================================================
 SUBROUTINE Ens_covariances (ensemble, Dims , cov_file, cor_file, i,j)

 !********************************************
 !* Subroutine to calculate the gridpoint    *
 !* variance of an ensemble of ensemble      *
 !********************************************

 USE DefConsTypes
 IMPLICIT NONE

 TYPE(model_vars_type), INTENT(IN)       :: ensemble(0:nems)
 TYPE(model_vars_type)                   :: en_av
 TYPE(Dimensions_type), INTENT(IN)       :: Dims
 INTEGER,               INTENT(IN)       :: i,j
 CHARACTER(LEN=*)                        :: cov_file, cor_file
 TYPE(model_vars_type)                   :: std_dev, cov, cor, ens_perts(1:nems)
 INTEGER                                 :: x,z,en
 
 CALL Initialise_model_vars(en_av)

 PRINT*,'--- Calculating ensemble covariances'

 ! Calculate ensemble average 
 !-----------------------------
! PRINT*,' Calculate ensemble average'
 DO z = 1, nlevs
   DO x = 1, nlongs
     DO en = 1, nems
       en_av % u(x,z) = en_av % u(x,z) + ensemble(en) % u(x,z)
       en_av % v(x,z) = en_av % v(x,z) + ensemble(en) % v(x,z)
       en_av % w(x,z) = en_av % w(x,z) + ensemble(en) % w(x,z)
       en_av % r(x,z) = en_av % r(x,z) + ensemble(en) % r(x,z)
       en_av % b(x,z) = en_av % b(x,z) + ensemble(en) % b(x,z)       
     END DO
     en_av % u(x,z) = en_av % u(x,z) / nems
     en_av % v(x,z) = en_av % v(x,z) / nems
     en_av % w(x,z) = en_av % w(x,z) / nems
     en_av % r(x,z) = en_av % r(x,z) / nems
     en_av % b(x,z) = en_av % b(x,z) / nems
   END DO
 END DO


 ! The zeroth member of the structure ensemble(0:nems) is the ensemble average
 ! Calculate ensemble of perturbations from ensemble mean
 !---------------------------------------------------------
 DO en = 1, nems
   DO z = 1, nlevs
     DO x = 1, nlongs
       ens_perts(en) % u(x,z) = ( ensemble(en) % u(x,z) - en_av % u(x,z) )
       ens_perts(en) % v(x,z) = ( ensemble(en) % v(x,z) - en_av % v(x,z) )
       ens_perts(en) % w(x,z) = ( ensemble(en) % w(x,z) - en_av % w(x,z) )
       ens_perts(en) % r(x,z) = ( ensemble(en) % r(x,z) - en_av % r(x,z) )
       ens_perts(en) % b(x,z) = ( ensemble(en) % b(x,z) - en_av % b(x,z) )
     ENDDO
   ENDDO
 ENDDO
 
 ! Calculate standard deviations
 !--------------------------------  
  DO z = 1, nlevs
    DO x = 1, nlongs
      DO en = 1, nems  
        std_dev % u(x,z) = std_dev % u(x,z) + ( ens_perts(en) % u(x,z) ) ** 2
        std_dev % v(x,z) = std_dev % v(x,z) + ( ens_perts(en) % v(x,z) ) ** 2
        std_dev % w(x,z) = std_dev % w(x,z) + ( ens_perts(en) % w(x,z) ) ** 2
        std_dev % r(x,z) = std_dev % r(x,z) + ( ens_perts(en) % r(x,z) ) ** 2
        std_dev % b(x,z) = std_dev % b(x,z) + ( ens_perts(en) % b(x,z) ) ** 2
      END DO
      std_dev % u(x,z) = sqrt( std_dev % u(x,z) / nems )
      std_dev % v(x,z) = sqrt( std_dev % v(x,z) / nems )
      std_dev % w(x,z) = sqrt( std_dev % w(x,z) / nems )
      std_dev % r(x,z) = sqrt( std_dev % r(x,z) / nems )
      std_dev % b(x,z) = sqrt( std_dev % b(x,z) / nems )
    END DO 
  END DO
  
!  PRINT*, std_dev % u(i,j), std_dev % v(i,j), std_dev % w(i,j), std_dev % r(i,j), std_dev % b(i,j)
 
  
 OPEN(56, file = '/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/stdevs.bin', form = 'unformatted')
 DO x = 1,nlongs
  DO z = 1, nlevs
   WRITE (56) std_dev % u(x,z),std_dev % v(x,z),std_dev % w(x,z),std_dev % r(x,z),std_dev % b(x,z)   
  ENDDO
 ENDDO
 CLOSE(56)
 
 ! Calculate covariance and correlation
 !---------------------------------------
 DO z = 2, nlevs-1  ! internal points only, no variance due to boundary conditions
   DO x = 1, nlongs
     DO en = 1, nems
     cov % u(x,z) = cov % u(x,z) + &
                       ( ens_perts(en) % u(x,z) * ens_perts(en) % r(i,j) ) / nems
     cov % v(x,z) = cov % v(x,z) + &
                       ( ens_perts(en) % v(x,z) * ens_perts(en) % r(i,j) ) / nems
     cov % w(x,z) = cov % w(x,z) + &
                       ( ens_perts(en) % w(x,z) * ens_perts(en) % r(i,j) ) / nems
     cov % r(x,z) = cov % r(x,z) + &
                       ( ens_perts(en) % r(x,z) * ens_perts(en) % r(i,j) ) / nems
     cov % b(x,z) = cov % b(x,z) + &
                       ( ens_perts(en) % b(x,z) * ens_perts(en) % r(i,j) ) / nems
     END DO
     ! Calulate correlation by scaling covariance
     cor % u(x,z) = cov % u(x,z) / ( std_dev % u(x,z) * std_dev % r(i,j) )
     cor % v(x,z) = cov % v(x,z) / ( std_dev % v(x,z) * std_dev % r(i,j) )
     cor % w(x,z) = cov % w(x,z) / ( std_dev % w(x,z) * std_dev % r(i,j) )
     cor % r(x,z) = cov % r(x,z) / ( std_dev % r(x,z) * std_dev % r(i,j) )
     cor % b(x,z) = cov % b(x,z) / ( std_dev % b(x,z) * std_dev % r(i,j) )
   END DO
 END DO  

 !PRINT*, cov % r(i,j), std_dev % r(i,j),std_dev % r(i,j)**2
 PRINT*, '-------------------------'
 PRINT*,'TEST CORRELATION .EQ. 1'
 PRINT*, cor % r(i,j)
 PRINT*, '-------------------------'

 ! Write covariance and correlation data
 CALL Write_state_2d (cov_file, cov, Dims, 1, 0, 0)
 CALL Write_state_2d (cor_file, cor, Dims, 1, 0, 0)

 
 END SUBROUTINE Ens_covariances 
!===================================================================================================
!***************************************************************************************************
!===================================================================================================



!===================================================================================================
!***************************************************************************************************
!===================================================================================================
 SUBROUTINE Ens_variances ( ensemble, Dims , filename)

 !********************************************
 !* Subroutine to calculate the gridpoint    *
 !* variance of an ensemble of ensemble        *
 !********************************************

 USE DefConsTypes
 IMPLICIT NONE

 TYPE(model_vars_type), INTENT(IN)       :: ensemble(0:nems)
 TYPE(Dimensions_type), INTENT(IN)       :: Dims
 CHARACTER(LEN=*)                        :: filename
 TYPE(model_vars_type)                   :: variance, ens_perts(1:nems)
 INTEGER                                 :: x,z,en

 
 ! The zeroth member of the structure ensemble(0:nems) is the ensemble average 
 ! Calculate ensemble of perturbations from ensemble mean
 !---------------------------------------------------------
 DO en = 1, nems
   DO z = 1, nlevs
     DO x = 1, nlongs
       ens_perts(en) % u(x,z) = ( ensemble(en) % u(x,z) - ensemble(0) % u(x,z) )**2
       ens_perts(en) % v(x,z) = ( ensemble(en) % v(x,z) - ensemble(0) % v(x,z) )**2
       ens_perts(en) % w(x,z) = ( ensemble(en) % w(x,z) - ensemble(0) % w(x,z) )**2
       ens_perts(en) % r(x,z) = ( ensemble(en) % r(x,z) - ensemble(0) % r(x,z) )**2
       ens_perts(en) % b(x,z) = ( ensemble(en) % b(x,z) - ensemble(0) % b(x,z) )**2
     ENDDO
   ENDDO
 ENDDO

 ! Calculate grid point variances
 !---------------------------------
 DO z = 1, nlevs
   DO x = 1, nlongs
     DO en = 1, nems
       variance % u(x,z) = variance % u(x,z) + ens_perts(en) % u(x,z)
       variance % v(x,z) = variance % v(x,z) + ens_perts(en) % v(x,z)
       variance % w(x,z) = variance % w(x,z) + ens_perts(en) % w(x,z)
       variance % r(x,z) = variance % r(x,z) + ens_perts(en) % r(x,z)
       variance % b(x,z) = variance % b(x,z) + ens_perts(en) % b(x,z)
     ENDDO
     variance % u(x,z) = variance % u(x,z) / (nems + 1) 
     variance % v(x,z) = variance % v(x,z) / (nems + 1) 
     variance % w(x,z) = variance % w(x,z) / (nems + 1) 
     variance % r(x,z) = variance % r(x,z) / (nems + 1) 
     variance % b(x,z) = variance % b(x,z) / (nems + 1)  
   ENDDO
 ENDDO  

 ! Write Variances
 !-----------------
 CALL Write_state_2d (filename, variance, Dims, 1, 0, 0)
 

 END SUBROUTINE Ens_variances 
!===================================================================================================
!***************************************************************************************************
!===================================================================================================



!===================================================================================================
!***************************************************************************************************
!===================================================================================================
 SUBROUTINE Generate_ensemble (ensemble,dims,ensnum, method)
 
 !********************************************
 !* Subroutine to generate ensemble          *
 !*                                          *
 !********************************************
 USE DefConsTypes
 IMPLICIT NONE

 ! Declare global variables
 !--------------------------
 TYPE(model_vars_type), INTENT(INOUT)    :: ensemble(0:nems)
 TYPE(dimensions_type), INTENT(INOUT)    :: dims
 CHARACTER(LEN=*),      INTENT(IN)       :: ensnum
 INTEGER,               INTENT(IN)       :: method

 ! Declare local variables
 !-------------------------
 TYPE(model_vars_type)                   :: InitState, ctrl, Perturb, stateout, temp_state
 TYPE(model_vars_type)                   :: Control(0:nbreedcyc), Bred(0:nbreedcyc)
 TYPE(model_vars_type)                   :: ensemble_tmp(0:nems) 
 TYPE(um_data_type)                      :: init_um_data
 INTEGER                                 :: ntimestot, ntimes  
 REAL(ZREAL8)                            :: gama(1:5), alpha(1:5)
 CHARACTER                               :: init_um_file*65
 CHARACTER                               :: init_model_file*57
 CHARACTER                               :: ens_file*76
 CHARACTER                               :: filenumber*2
 CHARACTER                               :: ens_filenumber*3 
 CHARACTER                               :: breed_cyc_no*2
 CHARACTER                               :: ctrl_file*68 
 CHARACTER                               :: bredname*73
 CHARACTER                               :: init_model_read_file*68

 REAL(ZREAL8)                            :: u_scale, v_scale, w_scale, r_scale, b_scale
 REAL(ZREAL8)                            :: max_rms_u, max_rms_v, max_rms_w
 REAL(ZREAL8)                            :: max_rms_r, max_rms_b
 REAL(ZREAL8)                            :: rms_u(1:nems), rms_v(1:nems), rms_w(1:nems)
 REAL(ZREAL8)                            :: rms_r(1:nems), rms_b(1:nems)

 INTEGER                                 :: idealised, enmb, slice, gravity_wave_switch
 INTEGER                                 :: x_scale, z_scale
 INTEGER                                 :: xscale, zscale, numrandseeds, temp_off
 INTEGER                                 :: convection_switch, rescale, ctrl_off

 ! Functions
 REAL(ZREAL8)                            :: RMS, STDEV, GAUSS
 INTEGER                                 :: i,j,k,en,bb,nr,t, x,z,bc, rs
 ! Loop counters 
 

 !*************
 ! INITIALISE *
 !*************
 CALL Initialise_model_vars(InitState)
 CALL Initialise_model_vars(ctrl)
 CALL Initialise_model_vars(Perturb)
 CALL Initialise_model_vars(stateout)
 CALL Initialise_um_data(init_um_data)
 DO i = 0, nbreedcyc
   CALL Initialise_model_vars(Control(i))
   CALL Initialise_model_vars(Bred(i))
 END DO

 
 
 PRINT*, '--- Generating Ensemble ---'
 
 
 SELECT CASE(method)
!===================================================================================================
 CASE(11)
   PRINT*, ' Case 1 selected'
   PRINT*, ' Set each ensemble member to different latitude slice'
   ! CASE 1:: Select each member to be a different latitude slice of um_data     
   
   init_model_file = '/home/wx019276/DATA/MODEL/INITCONDS/InitModelConds01.nc' ! dummy arg::temp file not used
  
   PRINT*, ' Read and process um data' 
   init_um_file =  '/export/carrot/raid2/wx019276/DATA/MODEL/INITCONDS/InitConds.nc'
   DO en = 1, nems  
     CALL Read_um_data_2d (init_um_data, init_um_file, (en * 5) + 10)  ! *5 + 10 chooses slices
     
     ! Regularize grid
     CALL Regularize_grid(init_um_data, dims, 1)
      
     ! Calculate model variables
     gravity_wave_switch  = 0
     CALL Process_um_data (init_um_data, ensemble(en), dims, init_model_file ,gravity_wave_switch, 0 )
    
     ! Apply boundary conditions
     CALL Boundaries(ensemble(en), 1, 1, 1, 1, 1, 1 )
  
   END DO 
   
 
! END CASE 1   
!===================================================================================================
!===================================================================================================
 CASE(1)
   PRINT*, ' Case 1 selected'
   PRINT*, ' Set each ensemble member to different latitude slice'
   ! CASE 1:: Select each member to be a different latitude slice of um_data     
   
   init_model_file = '/home/wx019276/DATA/MODEL/INITCONDS/InitModelConds01.nc' ! dummy arg::temp file not used
  
   PRINT*, ' Read and process um data' 
   init_um_file =  '/export/carrot/raid2/wx019276/DATA/MODEL/INITCONDS/InitConds.nc'
   DO en = 1, nems  
     CALL Read_um_data_2d (init_um_data, init_um_file, (en * 5) + 10)  ! *5 + 10 chooses slices
     
     ! Regularize grid
     CALL Regularize_grid(init_um_data, dims, 1)
      
     ! Calculate model variables
     gravity_wave_switch  = 0
     CALL Process_um_data (init_um_data, ensemble(en), dims, init_model_file ,gravity_wave_switch, 0 )
    
     ! Apply boundary conditions
     CALL Boundaries(ensemble(en), 1, 1, 1, 1, 1, 1 )
  
   END DO 
   
 
! END CASE 1   
!===================================================================================================
 CASE(2) ! CASE 2: Run a breeding cycle on a single initial state.     
   
   ! Set idealised = 1 to use a set of idealised inital conditions, then set intial condtions below
   idealised = 0
   
   ! Read in model data
   !---------------------------- 
   init_model_file = '/home/wx019276/DATA/MODEL/INITCONDS/InitModelConds01.nc'
   CALL Read_2dmodel_state ( init_model_file, InitState, Dims, 1, 1 )
  
   IF ( idealised .EQ. 1) THEN
     ! Set initial ensemble to be an idealised perturbation
    
     ! Initalise all field to zero
     InitState % b (:,:) = 0.0
     InitState % w (:,:) = 0.0
     InitState % v (:,:) = 0.0 
     InitState % u (:,:) = 0.0
     InitState % r (:,:) = 0.0
     InitState % geost_imbal(:,:) = 0.0 
     InitState % hydro_imbal(:,:) = 0.0
 
     ! Set source location and size
     x = 180
     z = 30
     x_scale = 250
     z_scale = 16

     CALL Convection(InitState, x, z, xscale, zscale)
  
   END IF  
 
   CALL Boundaries(InitState, 1, 1, 1, 1, 1, 1 )
   
   PRINT*,' Run a control forecast'
   !------------------------ 
   ntimestot = 18000
   ntimes = nbreedcyc
  
   ctrl_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/Control'&
   //ensnum//'.nc'
   CALL ModelDriver(InitState, ctrl, Dims, ntimestot, ntimes, ctrl_file, 0,gama,0) 
   numrandseeds = nems * 0.5
   DO en = 0, numrandseeds 
     CALL  Read_2dmodel_state ( ctrl_file, Control(en), Dims, en+1, 1 )
   END DO
  
   !***********************
   !**** BREEDING CYCLE ***
   !***********************
 
   PRINT*, 'Breeding cycles'
   numrandseeds = (nems - 1) * 0.5
   DO bc = 1, numrandseeds 

     CALL GenPerts(Control(0), Dims, Perturb)

     !*** CALCULATE GAMMA ***
     !-----------------------
     gama(1) = RMS(Control(0) % u ) / RMS(perturb % u ) 
     gama(2) = RMS(Control(0) % v ) / RMS(perturb % v ) 
     gama(3) = RMS(Control(0) % w ) / RMS(perturb % w ) 
     gama(4) = RMS(Control(0) % r ) / RMS(perturb % r ) 
     gama(5) = RMS(Control(0) % b ) / RMS(perturb % b ) 

     PRINT*, 'Gama calculated'
 
     ntimestot = 180
     ntimes = nbreedcyc
   
     WRITE(filenumber,'(i2.2)') bc
     bredname = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/Bred'&
     //ensnum//filenumber //'.nc'
   
     PRINT*,'***RUNNING FORWARD MODEL***'
     CALL ModelDriver(Perturb, StateOut, Dims, ntimestot, ntimes, bredname,idealised,1,gama) 
   ENDDO

   !****************************
   !**** INITIALISE ENSEMBLE ***
   !****************************

     
   DO rs = 1, numrandseeds
  
     WRITE (filenumber,'(i2.2)') rs
     bredname = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/Bred'&
     //ensnum//filenumber //'.nc'
     DO en = 0, numrandseeds 
       CALL  Read_2dmodel_state ( bredname, Bred(en), Dims, en+1, 1 )
     END DO
 
     j = nbreedcyc
     en = rs*2 - 1 
     DO k = 1, nlevs
       DO i = 1, nlongs      
         ensemble(en) % u(i,k)   = Control(0) % u(i,k) + (Bred(j) % u(i,k) - Control(j) % u(i,k))*gama(1)
         ensemble(en) % v(i,k)   = Control(0) % v(i,k) + (Bred(j) % v(i,k) - Control(j) % v(i,k))*gama(2)
         ensemble(en) % w(i,k)   = Control(0) % w(i,k) + (Bred(j) % w(i,k) - Control(j) % w(i,k))*gama(3)
         ensemble(en) % r(i,k)   = Control(0) % r(i,k) + (Bred(j) % r(i,k) - Control(j) % r(i,k))*gama(4)
         ensemble(en) % b(i,k)   = Control(0) % b(i,k) + (Bred(j) % b(i,k) - Control(j) % b(i,k))*gama(5)
         ensemble(en) % rho0(k)  = 1.0
         ensemble(en) % rho(i,k) = ensemble(en) % rho0(k) + ensemble(en) % r(i,k)
       ENDDO          
     ENDDO
     CALL Boundaries( ensemble(en), 1, 1, 1, 1, 1, 1 )
   
     en = rs*2 
     DO k = 1, nlevs
       DO i = 1, nlongs      
         ensemble(en) % u(i,k)   = Control(0) % u(i,k) - (Bred(j) % u(i,k) - Control(j) % u(i,k))*gama(1)
         ensemble(en) % v(i,k)   = Control(0) % v(i,k) - (Bred(j) % v(i,k) - Control(j) % v(i,k))*gama(2)
         ensemble(en) % w(i,k)   = Control(0) % w(i,k) - (Bred(j) % w(i,k) - Control(j) % w(i,k))*gama(3)
         ensemble(en) % r(i,k)   = Control(0) % r(i,k) - (Bred(j) % r(i,k) - Control(j) % r(i,k))*gama(4)
         ensemble(en) % b(i,k)   = Control(0) % b(i,k) - (Bred(j) % b(i,k) - Control(j) % b(i,k))*gama(5)
         ensemble(en) % rho0(k)  = 1.0
         ensemble(en) % rho(i,k) = ensemble(en) % rho0(k) + ensemble(en) % r(i,k)
       ENDDO          
     ENDDO     
     CALL Boundaries( ensemble(en), 1, 1, 1, 1, 1, 1 )
   
   ENDDO

! END CASE 2  
!===================================================================================================
!==================================================================================================
 CASE(3) ! CASE 3: Run a  breeding cycle on a selection of different initial states.

   PRINT*, 'case 3'
   ntimestot = 9000  ! 9000 = 10 hrs at dt = 4
   ntimes = nbreedcyc  
   
   nlats = 6                   ! number of latitiude slices, declared in module
   j = nems /nlats
   
   !-----------------------------
   ! Set different initial states
   !============================== 
   ! use 'nlats' latitude slices
   !-----------------------------

 
   DO en = 1, nlats
 
     slice = en * 30          ! total number of lat slices is 288, 8 * 30 = 240 is max lat slice no.
  
     ! Read in inital um data
     !------------------------
     init_um_file =  '/export/carrot/raid2/wx019276/DATA/MODEL/INITCONDS/InitConds.nc'
     CALL Read_um_data_2d (init_um_data, init_um_file, slice)
    
     ! Process um data
     !-----------------
   
     ! Regularize grid ?- Set final arg to 1 to dims array on a regular grid 0 uses Charney-Philips
     CALL Regularize_grid(init_um_data, dims, 1)
   
     ! Calculate model variables
     init_model_file = '/home/wx019276/DATA/MODEL/INITCONDS/InitModelConds01.nc' ! dummy arg::temp file not used
     gravity_wave_switch = 0
     CALL Process_um_data (init_um_data, InitState, dims, init_model_file, gravity_wave_switch, 1)
     ! penultimate argument in process_um_data is gravity_wave_switch, set to 1 to set inital u = 0
     ! final argument in process_um_data is dump, set to zero to not output a file.

     CALL Boundaries(InitState, 1, 1, 1, 1, 1, 1 )

     !***********************
     !**** BREEDING CYCLE ***
     !***********************
 
     ! Run a control forecast
     !------------------------
     PRINT*, 'Running control forecast on slice ',en,' of ',nlats,'.' 

     ctrl_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/Control'&
     //ensnum//'.nc'
     
     convection_switch = 0
     rescale           = 0
     alpha(1:5)        = 0
     ctrl_off          = 0 ! remove and enter Control as last in list to pass Control
     
     
     CALL ModelDriver(InitState, ctrl, Dims, ntimestot, ntimes, ctrl_file, &
                      convection_switch, rescale, alpha, ctrl_off) 
     
     DO enmb = 0, ntimes 
       CALL  Read_2dmodel_state ( ctrl_file, Control(enmb), Dims, enmb+1, 1 )
     END DO

 !    PRINT*,'maxval control 0 u: ', maxval(Control(0) % u(:,:)) 
 !    PRINT*,'maxval control 1 v: ', maxval(Control(1) % v(:,:)) 
 !    PRINT*,'maxval control 2 w: ', maxval(Control(2) % w(:,:)) 
 !    PRINT*,'maxval control 3 r: ', maxval(Control(3) % b(:,:)) 
 !    PRINT*,'maxval control 4 b: ', maxval(Control(4) % r(:,:)) 


     PRINT*, 'Breeding cycles'
     numrandseeds = j * 0.5
     DO bc = 1, numrandseeds

       ! Generate perturbed state
       !--------------------------   
       CALL GenPerts(Control(0), Dims, Perturb)

      
       !*** CALCULATE ALPHA ***
       ! alpha is the rms of the initial perturbation
       !-----------------------------------------------
       
       PRINT*, 'rms perturb u: ', RMS(Perturb % u(1:nlongs, 1:nlevs))
       PRINT*, 'rms perturb v: ', RMS(Perturb % v(1:nlongs, 1:nlevs))
       PRINT*, 'rms perturb w: ', RMS(Perturb % w(1:nlongs, 1:nlevs))
       PRINT*, 'rms perturb r: ', RMS(Perturb % r(1:nlongs, 1:nlevs))
       PRINT*, 'rms perturb b: ', RMS(Perturb % b(1:nlongs, 1:nlevs))
       
       temp_state % u(1:nlongs,1:nlevs) = &
                Perturb % u(1:nlongs, 1:nlevs) - Control(0) % u(1:nlongs, 1:nlevs)
       temp_state % v(1:nlongs,1:nlevs) = &
                Perturb % v(1:nlongs, 1:nlevs) - Control(0) % v(1:nlongs, 1:nlevs)
       temp_state % w(1:nlongs,1:nlevs) = &
                Perturb % w(1:nlongs, 1:nlevs) - Control(0) % w(1:nlongs, 1:nlevs)
       temp_state % r(1:nlongs,1:nlevs) = &
                Perturb % r(1:nlongs, 1:nlevs) - Control(0) % r(1:nlongs, 1:nlevs)
       temp_state % b(1:nlongs,1:nlevs) = &
                Perturb % b(1:nlongs, 1:nlevs) - Control(0) % b(1:nlongs, 1:nlevs)
       
       alpha (1) = RMS( temp_state % u(1:nlongs, 1:nlevs) )
       alpha (2) = RMS( temp_state % v(1:nlongs, 1:nlevs) )
       alpha (3) = RMS( temp_state % w(1:nlongs, 1:nlevs) )
       alpha (4) = RMS( temp_state % r(1:nlongs, 1:nlevs) )
       alpha (5) = RMS( temp_state % b(1:nlongs, 1:nlevs) )   
  
       PRINT*, 'alpha calculated'
       PRINT*, 'alpha -u', alpha(1)
       PRINT*, 'alpha -v', alpha(2)
       PRINT*, 'alpha -w', alpha(3)
       PRINT*, 'alpha -r', alpha(4)
       PRINT*, 'alpha -b', alpha(5)
       
 
       ! Set parameters for ModelDriver

       convection_switch = 0
       rescale           = 1

       WRITE(ens_filenumber,'(i3.3)') bc
       WRITE (breed_cyc_no, '(i2.2)') en
       PRINT*, ens_filenumber
       bredname = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/Bred_'&
       //ensnum//'_'//breed_cyc_no//'_'//ens_filenumber//'.nc'
       PRINT*, bredname

       PRINT*,'maxval control u: ', maxval(Control(1) % u(:,:)) 
       PRINT*,'maxval control v: ', maxval(Control(1) % v(:,:)) 
       PRINT*,'maxval control w: ', maxval(Control(1) % w(:,:)) 
       PRINT*,'maxval control r: ', maxval(Control(1) % b(:,:)) 
       PRINT*,'maxval control b: ', maxval(Control(1) % r(:,:)) 

       PRINT*,'***RUNNING FORWARD MODEL***'  


       CALL ModelDriver(Perturb, StateOut, Dims, ntimestot, ntimes, bredname,&
                        convection_switch, rescale, alpha, Control(0:nbreedcyc)) 
    
     END DO

     !****************************
     !**** INITIALISE ENSEMBLE ***
     !****************************
    
     DO rs = 1, numrandseeds
 
       WRITE (ens_filenumber,'(i3.3)') rs
       WRITE (breed_cyc_no, '(i2.2)') en
       bredname = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/Bred_'&
       //ensnum//'_'//breed_cyc_no//'_'//ens_filenumber//'.nc'
       DO enmb = 0, numrandseeds 
         CALL  Read_2dmodel_state ( bredname, Bred(enmb), Dims, enmb+1, 1 )
       END DO
 
       enmb = (en-1)*j + rs*2 - 1  
       DO k = 1, nlevs
         DO i = 1, nlongs      
           ensemble(enmb) % u(i,k)   = Control(0) % u(i,k) + &
                                      (Bred(nbreedcyc) % u(i,k) - Control(nbreedcyc) % u(i,k))*alpha(1)
           ensemble(enmb) % v(i,k)   = Control(0) % v(i,k) + &
                                      (Bred(nbreedcyc) % v(i,k) - Control(nbreedcyc) % v(i,k))*alpha(2)
           ensemble(enmb) % w(i,k)   = Control(0) % w(i,k) + &
                                      (Bred(nbreedcyc) % w(i,k) - Control(nbreedcyc) % w(i,k))*alpha(3)
           ensemble(enmb) % r(i,k)   = Control(0) % r(i,k) + &
                                      (Bred(nbreedcyc) % r(i,k) - Control(nbreedcyc) % r(i,k))*alpha(4)
           ensemble(enmb) % b(i,k)   = Control(0) % b(i,k) + &
                                      (Bred(nbreedcyc) % b(i,k) - Control(nbreedcyc) % b(i,k))*alpha(5)
           ensemble(enmb) % rho0(k)  = 1.0
           ensemble(enmb) % rho(i,k) = ensemble(enmb) % rho0(k) + ensemble(enmb) % r(i,k)
         END DO          
       END DO
      
       CALL Boundaries( ensemble(enmb), 1, 1, 1, 1, 1, 1 )
 
       enmb = (en-1)*j + rs*2  
       DO k = 1, nlevs
         DO i = 1, nlongs      
           ensemble(enmb) % u(i,k)   = Control(0) % u(i,k) - &
                                      (Bred(nbreedcyc) % u(i,k) - Control(nbreedcyc) % u(i,k))*alpha(1)
           ensemble(enmb) % v(i,k)   = Control(0) % v(i,k) - &
                                      (Bred(nbreedcyc) % v(i,k) - Control(nbreedcyc) % v(i,k))*alpha(2)
           ensemble(enmb) % w(i,k)   = Control(0) % w(i,k) - &
                                      (Bred(nbreedcyc) % w(i,k) - Control(nbreedcyc) % w(i,k))*alpha(3)
           ensemble(enmb) % r(i,k)   = Control(0) % r(i,k) - &
                                      (Bred(nbreedcyc) % r(i,k) - Control(nbreedcyc) % r(i,k))*alpha(4)
           ensemble(enmb) % b(i,k)   = Control(0) % b(i,k) - &
                                      (Bred(nbreedcyc) % b(i,k) - Control(nbreedcyc) % b(i,k))*alpha(5)
           ensemble(enmb) % rho0(k)  = 1.0
           ensemble(enmb) % rho(i,k) = ensemble(enmb) % rho0(k) + ensemble(enmb) % r(i,k)
         END DO          
       END DO     
       CALL Boundaries( ensemble(enmb), 1, 1, 1, 1, 1, 1 )
   
     END DO ! initalise ensemble
     
  END DO  ! Loop over slices loop counter is:: en
     
! END CASE 3
!===================================================================================================
CASE(5) ! CASE 5: Ensemble rescaling breeding method.

   PRINT*, 'case 5'
    
   !-----------------------------
   ! Set different initial states
   !============================== 
   ! use 'nlats' latitude slices
   !-----------------------------

 
 !  DO en = 1, nlats
 
!     slice = en * 30          ! total number of lat slices is 288, 8 * 30 = 240 is max lat slice no.
  
     ! Read in inital um data
     !------------------------
 !    init_um_file =  '/export/carrot/raid2/wx019276/DATA/MODEL/INITCONDS/InitConds.nc'
 !    CALL Read_um_data_2d (init_um_data, init_um_file, slice)
    
     ! Process um data
     !-----------------
   
 !    ! Regularize grid ?- Set final arg to 1 to dims array on a regular grid 0 uses Charney-Philips
 !    CALL Regularize_grid(init_um_data, dims, 1)
   
     ! Calculate model variables
 !    init_model_file = '/home/wx019276/DATA/MODEL/INITCONDS/InitModelConds01.nc' ! dummy arg::temp file not used
 !    gravity_wave_switch = 0
 !    CALL Process_um_data (init_um_data, InitState, dims, init_model_file, gravity_wave_switch, 1)
     ! penultimate argument in process_um_data is gravity_wave_switch, set to 1 to set inital u = 0
     ! final argument in process_um_data is dump, set to zero to not output a file.

 !    CALL Boundaries(InitState, 1, 1, 1, 1, 1, 1 )

!***************************************************************************************************

     ! READ IN SPIN-UP DATA
!             '/export/carrot/raid2/wx019276/DATA/MODEL/INITCONDS/InitCons'//dataset//'.nc'

       init_model_read_file = &
             '/export/carrot/raid2/wx019276/DATA/MODEL/INITCONDS/InitCons20.nc'
       CALL Read_2dmodel_state(init_model_read_file, InitState, dims, 21 ,0)  !21 is read time

      !  THIS IS THE CONTROL MEMBER OR ENSEMBLE AVERAGE AND IS EN(0) INDEX
!***************************************************************************************************

 
 
 
!***************************************************************************************************
     ! Run a control forecast
     !------------------------
     PRINT*, 'Running control forecast on slice ',en,' of ',nlats,'.' 

     ctrl_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/Control'&
     //ensnum//'.nc'
     ntimestot = 13500  ! 24hrs @ dt = 10s = 8640
     ntimes = nbreedcyc  ! number of output times in control run = the number of breeding rescales
   
   !  nlats = 1                   ! number of latitiude slices, declared in module
   !  j = nems /nlats
    
     convection_switch = 0
     rescale           = 0
     alpha(1:5)        = 0
     ctrl_off          = 0 ! remove and enter Control as last in list to pass Control
     
     
     CALL ModelDriver(InitState, ctrl, Dims, ntimestot, ntimes, ctrl_file, &
                      convection_switch, rescale, alpha, ctrl_off) 
  
 
  ! READ IN CONTROL DATA

    DO enmb = 0, ntimes 
       CALL  Read_2dmodel_state ( ctrl_file, Control(enmb), Dims, enmb+1, 1 )
    END DO

    
!***************************************************************************************************



!***************************************************************************************************

! SET INITIAL STATE OF EACH ENSEMBLE MEMBER

 
 DO en = 1, nems
    
    ! Generate perturbed state
    !--------------------------   
    CALL GenPerts(InitState, Dims, ensemble(en))
    
 END DO

!***************************************************************************************************

!***************************************************************************************************
!***************************************************************************************************
! BREEDING

!  TIME LOOP

 DO t = 1, nbreedcyc

 PRINT*, ' Breeeding cycle: ',t

!***************************************************************************************************

! RUN FORWARD MODEL TO RESCALE TIMES

 DO en = 1, nems

   PRINT*, ' Ensemble member: ', en

  
   WRITE (ens_filenumber,'(i2.2)') en
   bredname = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/Bred_'&
   //ensnum//'_'//ens_filenumber//'.nc'
   ntimestot         = 2700   ! 1hr = 360 timesteps at dt = 10s
   ntimes            = 1 
   convection_switch = 0
   rescale           = 0
   CALL ModelDriver(ensemble(en), ensemble_tmp(en), Dims, ntimestot, ntimes, bredname,&
                        convection_switch, rescale, 0,0) 

   rms_u(en) = RMS(ensemble_tmp(en) % u(1:nlongs, 1:nlevs))
   rms_v(en) = RMS(ensemble_tmp(en) % v(1:nlongs, 1:nlevs))
   rms_w(en) = RMS(ensemble_tmp(en) % w(1:nlongs, 1:nlevs))
   rms_r(en) = RMS(ensemble_tmp(en) % r(1:nlongs, 1:nlevs))
   rms_b(en) = RMS(ensemble_tmp(en) % b(1:nlongs, 1:nlevs))

 END DO     
     
   max_rms_u = maxval(rms_u(1:nems))
   max_rms_v = maxval(rms_v(1:nems))
   max_rms_w = maxval(rms_w(1:nems))
   max_rms_r = maxval(rms_r(1:nems))
   max_rms_b = maxval(rms_b(1:nems))
   
 DO en = 1, nems
    
  ! SUBTRACT CONTROL FROM EACH MEMBER
  
  ensemble(en) % u(1:nlongs, 1:nlevs) = ensemble_tmp(en) % u(1:nlongs, 1:nlevs) - Control(t) % u(1:nlongs, 1:nlevs)
  ensemble(en) % v(1:nlongs, 1:nlevs) = ensemble_tmp(en) % v(1:nlongs, 1:nlevs) - Control(t) % v(1:nlongs, 1:nlevs)
  ensemble(en) % w(1:nlongs, 1:nlevs) = ensemble_tmp(en) % w(1:nlongs, 1:nlevs) - Control(t) % w(1:nlongs, 1:nlevs)
  ensemble(en) % r(1:nlongs, 1:nlevs) = ensemble_tmp(en) % r(1:nlongs, 1:nlevs) - Control(t) % r(1:nlongs, 1:nlevs)
  ensemble(en) % b(1:nlongs, 1:nlevs) = ensemble_tmp(en) % b(1:nlongs, 1:nlevs) - Control(t) % b(1:nlongs, 1:nlevs)
 
  ! ADD ON RANDOM PERTURBATION SCALED TO PERCENTAGE OF MAX RMS 
     
  u_scale = 0.25
  v_scale = 0.25
  w_scale = 0.25
  r_scale = 0.25
  b_scale = 0.25

  PRINT*, ' Generating Random Seeds '
  PRINT*, '----------------------------'

  DO k = 1, nlevs
    DO i = 1, nlongs
     ensemble(en) % u(i,k) = Control(t) % u(i,k) + GAUSS(u_scale * max_rms_u )
     ensemble(en) % v(i,k) = Control(t) % v(i,k) + GAUSS(v_scale * max_rms_v )
     ensemble(en) % w(i,k) = Control(t) % w(i,k) + GAUSS(w_scale * max_rms_w ) 
     ensemble(en) % r(i,k) = Control(t) % r(i,k) + GAUSS(r_scale * max_rms_r ) 
     ensemble(en) % b(i,k) = Control(t) % b(i,k) + GAUSS(b_scale * max_rms_b ) 
    ENDDO
  ENDDO
     

 ! Set other perturb variables
 !-----------------------------
 ensemble(en) % rho0(:)     = Control(t) % rho0(:)
 ensemble(en) % tracer(:,:) = 0.0
 DO k = 1, nlevs
   DO i = 1, nlongs
     ensemble(en) % rho(i,k) = ensemble(en) % rho0(k) + ensemble(en) % r(i,k)
   ENDDO
 ENDDO 
     
 CALL Boundaries(ensemble(en), 1, 1, 1, 1, 1, 1 )

   
 END DO ! ensemble loop
 
 END DO ! time / breeding cycle loop
   
   
      
! END CASE 5

 


!==================================================================================================
 CASE(4) ! CASE 4: test length of breeding cycle
   
   PRINT*, 'case 4'
   ntimestot = 25920
   ntimes = nbreedcyc

   nlats = 1                   ! number of latitiude slices, declared in module
   j = nems /nlats
   
   ! Set different initial states
   !============================== 
   ! use 'nlats' latitude slices
   !-----------------------------

 
   DO en = 1, nlats
 
     slice = en * 25          ! total number of lat slices is 288, 8 * 30 = 240 is max lat slice no.
  
     ! Read in inital um data
     !------------------------
     init_um_file =  '/export/carrot/raid2/wx019276/DATA/MODEL/INITCONDS/InitConds.nc'
     CALL Read_um_data_2d (init_um_data, init_um_file, slice)
    
     ! Process um data
     !-----------------
   
     ! Regularize grid ?- Set final arg to 1 to dims array on a regular grid 0 uses Charney-Philips
     CALL Regularize_grid(init_um_data, dims, 1)
   
     ! Calculate model variables
     init_model_file = '/home/wx019276/DATA/MODEL/INITCONDS/InitModelConds01.nc' ! dummy arg::temp file not used
     gravity_wave_switch = 0
     CALL Process_um_data (init_um_data, InitState, dims, init_model_file, gravity_wave_switch, 1)
     ! penultimate argument in process_um_data is gravity_wave_switch, set to 1 to set inital u = 0
     ! final argument in process_um_data is dump, set to zero to not output a file.

     CALL Boundaries(InitState, 1, 1, 1, 1, 1, 1 )

     !***********************
     !**** BREEDING CYCLE ***
     !***********************
 
     ! Run a control forecast
     !-----------------------------------------------------------------------------------------
     PRINT*, 'Running control forecast on slice ',en,' of ',nlats,'.' 

     ctrl_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/Control'&
     //ensnum//'.nc'
     convection_switch = 0
     rescale           = 0
     alpha(1:5)        = 0
     ctrl_off          = 0 ! remove and enter Control as last in list to pass Control
    
     CALL ModelDriver(InitState, ctrl, Dims, ntimestot, ntimes, ctrl_file, &
                      convection_switch, rescale, alpha, ctrl_off) 
     !----------------------------------------------------------------------------------------- 
    
     DO enmb = 0, numrandseeds 
       CALL  Read_2dmodel_state ( ctrl_file, Control(enmb), Dims, enmb+1, 1 )
     END DO

     PRINT*, 'Breeding cycles'
     numrandseeds = 1!j * 0.5
     DO bc = 1, numrandseeds 

       ! Generate perturbed state
       !--------------------------   
       CALL GenPerts(Control(0), Dims, Perturb)

       !*** CALCULATE alpha ***
       !-----------------------
      
           temp_state % u(1:nlongs,1:nlevs) = &
                Perturb % u(1:nlongs, 1:nlevs) - Control(0) % u(1:nlongs, 1:nlevs)
       temp_state % v(1:nlongs,1:nlevs) = &
                Perturb % v(1:nlongs, 1:nlevs) - Control(0) % v(1:nlongs, 1:nlevs)
       temp_state % w(1:nlongs,1:nlevs) = &
                Perturb % w(1:nlongs, 1:nlevs) - Control(0) % w(1:nlongs, 1:nlevs)
       temp_state % r(1:nlongs,1:nlevs) = &
                Perturb % r(1:nlongs, 1:nlevs) - Control(0) % r(1:nlongs, 1:nlevs)
       temp_state % b(1:nlongs,1:nlevs) = &
                Perturb % b(1:nlongs, 1:nlevs) - Control(0) % b(1:nlongs, 1:nlevs)
       
       alpha (1) = RMS( temp_state % u(1:nlongs, 1:nlevs) )
       alpha (2) = RMS( temp_state % v(1:nlongs, 1:nlevs) )
       alpha (3) = RMS( temp_state % w(1:nlongs, 1:nlevs) )
       alpha (4) = RMS( temp_state % r(1:nlongs, 1:nlevs) )
       alpha (5) = RMS( temp_state % b(1:nlongs, 1:nlevs) )   
 
       PRINT*, 'alpha calculated'
       PRINT*, alpha(1), alpha(2), alpha(3), alpha(4), alpha(5)
       PRINT*, '-------------------------------------------------------------------' 
 
 
      ! Set parameters for ModelDriver

       convection_switch = 0
       rescale           = 1

       WRITE(ens_filenumber,'(i3.3)') bc
       PRINT*, ens_filenumber
       bredname = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/Bred'&
       //ensnum//ens_filenumber//'.nc'
       PRINT*, bredname

       PRINT*,'***RUNNING FORWARD MODEL***'  

       CALL ModelDriver(Perturb, StateOut, Dims, ntimestot, ntimes, bredname,&
                        convection_switch, rescale, alpha, Control) 
     END DO

     !****************************
     !**** INITIALISE ENSEMBLE ***
     !****************************
    
     DO rs = 1, numrandseeds
 
       WRITE (ens_filenumber,'(i3.3)') rs
       bredname = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/Bred'&
       //ensnum//ens_filenumber //'.nc'
       DO enmb = 0, numrandseeds 
         CALL  Read_2dmodel_state ( bredname, Bred(enmb), Dims, enmb+1, 1 )
       END DO
 
       enmb = (en-1)*j + rs*2 - 1  
       DO k = 1, nlevs
         DO i = 1, nlongs      
           ensemble(enmb) % u(i,k)   = Control(0) % u(i,k) + &
                                      (Bred(nbreedcyc) % u(i,k) - Control(nbreedcyc) % u(i,k))*gama(1)
           ensemble(enmb) % v(i,k)   = Control(0) % v(i,k) + &
                                      (Bred(nbreedcyc) % v(i,k) - Control(nbreedcyc) % v(i,k))*gama(2)
           ensemble(enmb) % w(i,k)   = Control(0) % w(i,k) + &
                                      (Bred(nbreedcyc) % w(i,k) - Control(nbreedcyc) % w(i,k))*gama(3)
           ensemble(enmb) % r(i,k)   = Control(0) % r(i,k) + &
                                      (Bred(nbreedcyc) % r(i,k) - Control(nbreedcyc) % r(i,k))*gama(4)
           ensemble(enmb) % b(i,k)   = Control(0) % b(i,k) + &
                                      (Bred(nbreedcyc) % b(i,k) - Control(nbreedcyc) % b(i,k))*gama(5)
           ensemble(enmb) % rho0(k)  = 1.0
           ensemble(enmb) % rho(i,k) = ensemble(enmb) % rho0(k) + ensemble(enmb) % r(i,k)
         END DO          
       END DO
      
       CALL Boundaries( ensemble(enmb), 1, 1, 1, 1, 1, 1 )
 
       enmb = (en-1)*j + rs*2  
       DO k = 1, nlevs
         DO i = 1, nlongs      
           ensemble(enmb) % u(i,k)   = Control(0) % u(i,k) - &
                                      (Bred(nbreedcyc) % u(i,k) - Control(nbreedcyc) % u(i,k))*gama(1)
           ensemble(enmb) % v(i,k)   = Control(0) % v(i,k) - &
                                      (Bred(nbreedcyc) % v(i,k) - Control(nbreedcyc) % v(i,k))*gama(2)
           ensemble(enmb) % w(i,k)   = Control(0) % w(i,k) - &
                                      (Bred(nbreedcyc) % w(i,k) - Control(nbreedcyc) % w(i,k))*gama(3)
           ensemble(enmb) % r(i,k)   = Control(0) % r(i,k) - &
                                      (Bred(nbreedcyc) % r(i,k) - Control(nbreedcyc) % r(i,k))*gama(4)
           ensemble(enmb) % b(i,k)   = Control(0) % b(i,k) - &
                                      (Bred(nbreedcyc) % b(i,k) - Control(nbreedcyc) % b(i,k))*gama(5)
           ensemble(enmb) % rho0(k)  = 1.0
           ensemble(enmb) % rho(i,k) = ensemble(enmb) % rho0(k) + ensemble(enmb) % r(i,k)
         END DO          
       END DO     
       CALL Boundaries( ensemble(enmb), 1, 1, 1, 1, 1, 1 )
   
     END DO ! initalise ensemble
     
  END DO  ! Loop over slices
     
! END CASE 4
!===================================================================================================
 CASE DEFAULT 
   
   PRINT*, ' ERROR:: NO ENSEMBLE GENERATION METHOD SPECIFIED'
   PRINT*, ' STOP'
   STOP 
!===================================================================================================
  
 END SELECT
 
 ! Calculate ensemble average and set this to be control
 !--------------------------------------------------------
 DO k = 1, nlevs
   DO i = 1, nlongs
     DO en = 1, nems-1
       ensemble(0) % u(i,k) = ensemble(0) % u(i,k) + ensemble(en) % u(i,k)
       ensemble(0) % v(i,k) = ensemble(0) % v(i,k) + ensemble(en) % v(i,k)
       ensemble(0) % w(i,k) = ensemble(0) % w(i,k) + ensemble(en) % w(i,k)
       ensemble(0) % r(i,k) = ensemble(0) % r(i,k) + ensemble(en) % r(i,k)
       ensemble(0) % b(i,k) = ensemble(0) % b(i,k) + ensemble(en) % b(i,k)       
     END DO
     ensemble(0) % u(i,k) = ensemble(0) % u(i,k) / nems_1
     ensemble(0) % v(i,k) = ensemble(0) % v(i,k) / nems_1
     ensemble(0) % w(i,k) = ensemble(0) % w(i,k) / nems_1
     ensemble(0) % r(i,k) = ensemble(0) % r(i,k) / nems_1
     ensemble(0) % b(i,k) = ensemble(0) % b(i,k) / nems_1
   END DO
 END DO
 
 ! Write ensemble data
 !------------------------------
 DO en = 0, nems
   WRITE(ens_filenumber,'(i3.3)')en
   ens_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/En_Init_Perts_'&
             //ensnum//ens_filenumber//'.nc'
   PRINT*, ens_file
   CALL Write_state_2d (ens_file, ensemble(en), Dims,1,0,0 )
 ENDDO


 END SUBROUTINE Generate_ensemble
!===================================================================================================
!***************************************************************************************************
!===================================================================================================



!===================================================================================================
!***************************************************************************************************
!===================================================================================================
 SUBROUTINE GenPerts(Control, Dims, perturb)
 
 !*********************************
 !*                               *    
 !* Subroutine to generate random *
 !* pertubations to a given state *
 !* Returns a perturbation state  *
 !*                               *    
 !*********************************

 USE DefConsTypes
 IMPLICIT NONE

 !Declare top lev variables
 TYPE(model_vars_type),INTENT(INOUT)    :: Control
 TYPE(model_vars_type),INTENT(INOUT)    :: perturb
 TYPE(Dimensions_type),INTENT(IN)       :: Dims

 !Declare Local Variables
 REAL(ZREAL8)                     :: u_scale, v_scale, w_scale, r_scale, b_scale
 
 !Functions
 REAL(ZREAL8)                     :: RMS, GAUSS
 !Loop counters
 INTEGER                          :: t,i,j,k


 u_scale = 0.25
 v_scale = 0.25
 w_scale = 0.25
 r_scale = 0.25
 b_scale = 0.25

 PRINT*, ' Generating Random Seeds '
 PRINT*, '----------------------------'

 ! u - component
 !---------------
 DO k = 1, nlevs
   DO i = 1, nlongs
     perturb % u(i,k) = Control % u(i,k) + GAUSS(u_scale * RMS( Control % u(1:nlongs,1:nlevs) ))
   ENDDO
 ENDDO
     
 PRINT*, 'u perturbation state generated'
  
 ! v - component
 !---------------
 DO k = 1, nlevs
   DO i = 1, nlongs
     perturb % v(i,k) = Control % v(i,k) + GAUSS(v_scale * RMS( Control % v(1:nlongs,1:nlevs) ))
   ENDDO
 ENDDO

 PRINT*, 'v perturbation state generated'

 ! w - component
 !---------------
 DO k = 1, nlevs
   DO i = 1, nlongs
     perturb % w(i,k) = Control % w(i,k) + GAUSS(w_scale * RMS( Control % w(1:nlongs,1:nlevs) ))
	  ENDDO
 ENDDO
 
 PRINT*, 'w perturbation state generated'

 ! r - component
 !---------------
 DO k = 1, nlevs
   DO i = 1, nlongs
     perturb % r(i,k) = Control % r(i,k) + GAUSS(r_scale * RMS( Control % r(1:nlongs,1:nlevs) ))
   ENDDO
 ENDDO
 PRINT*, 'r perturbation state generated'
  
 ! b - component
 !---------------
 DO k = 1, nlevs
   DO i = 1, nlongs
     perturb % b(i,k) = Control % b(i,k) + GAUSS(b_scale *  RMS( Control % b(1:nlongs,1:nlevs) ))
   ENDDO
 ENDDO

 PRINT*, 'b perturbation state generated'

 ! Set other perturb variables
 !-----------------------------
 perturb % rho0(:)     = Control % rho0(:)
 perturb % tracer(:,:) = 0.0
 DO k = 1, nlevs
   DO i = 1, nlongs
     perturb % rho(i,k) = perturb % rho0(k) + perturb % r(i,k)
   ENDDO
 ENDDO 
     
 CALL Boundaries(perturb, 1, 1, 1, 1, 1, 1 )
 
 END SUBROUTINE GenPerts
!===================================================================================================
!***************************************************************************************************
!===================================================================================================


 
!===================================================================================================
!***************************************************************************************************
!===================================================================================================
 SUBROUTINE GenEigStd(ensemble,dims,ensnum,eigenvects_file )
 
 !**************************************************** 
 !* Subroutine to calibrate the eigenvector scaling  *
 !* in the cvt by calculating the standard deviation *
 !* of the eigenvectors                              *
 !****************************************************
 
 USE DefConsTypes
 IMPLICIT NONE

 ! Declare global variables
 !--------------------------
 TYPE(model_vars_type), INTENT(INOUT)    :: ensemble(0:nems)
 TYPE(dimensions_type), INTENT(INOUT)    :: dims
 CHARACTER(LEN=*),      INTENT(IN)       :: ensnum
 CHARACTER(LEN=*),     INTENT(IN)        :: eigenvects_file

 ! Declare local variables
 !-------------------------
 TYPE(model_vars_type)                   :: en_av , en_pert(1:nems), en_std
 TYPE(Transform_type)                    :: HozCtrl, VertCtrl  ! intermediate control variables
 REAL(wp)                                :: EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs)
 COMPLEX(wp)                             :: Ctrl_vect(1:nvars*nlevs, 1:nlongs )
 COMPLEX(wp)                             :: en_ctrl_vect(1:nems,1:nvars*nlevs, 1:nlongs )
 REAL(wp)                                :: ctrl_std(1:nvars*nlevs, 1:nlongs)
 COMPLEX(wp)                             :: ctrl_av(1:nvars*nlevs, 1:nlongs)
 INTEGER                                 :: en
 CHARACTER                               :: ens_av_file*69
 CHARACTER                               :: ens_pert_file*68
 CHARACTER                               :: std_file*70
 CHARACTER                               :: filenumber*2
 CHARACTER                               :: ens_stds_file*62
 ! Counters
 INTEGER                                  :: k, i, j, en,n

 CALL Initialise_transform_vars ( HozCtrl )
 CALL Initialise_transform_vars ( VertCtrl )
 
 CALL Initialise_model_vars(en_av)
 CALL Initialise_model_vars(en_std)

 DO en = 1, nems  ! changed from 0:nems-1
   CALL Initialise_model_vars(en_pert(en))
 END DO
   
 Ctrl_vect(1:nvars*nlevs, 1:nlongs )             = (0.0,0.0)
 en_ctrl_vect(1:nems,1:nvars*nlevs, 1:nlongs )   = (0.0,0.0)
 EigVecs(1:nlongs, 1:nvars*nlevs, 1:nvars*nlevs) = 0.0
 ctrl_std(1:nvars*nlevs, 1:nlongs)               = 0.0
 ctrl_av(1:nvars*nlevs, 1:nlongs)                = 0.0

 PRINT*, '--------------------------------------------------------------------------'
 PRINT*, 'Calculating scaling factor for eigenvector calibration'
 PRINT*, '--------------------------------------------------------------------------'
 
 
 ! Calculate ensemble perturbations
 !==================================
   
 ! Calculate ensemble average 
 !-----------------------------
! PRINT*,' Calculate ensemble average'
 DO k = 1, nlevs
   DO i = 1, nlongs
     DO en = 1, nems
       en_av % u(i,k) = en_av % u(i,k) + ensemble(en) % u(i,k)
       en_av % v(i,k) = en_av % v(i,k) + ensemble(en) % v(i,k)
       en_av % w(i,k) = en_av % w(i,k) + ensemble(en) % w(i,k)
       en_av % r(i,k) = en_av % r(i,k) + ensemble(en) % r(i,k)
       en_av % b(i,k) = en_av % b(i,k) + ensemble(en) % b(i,k)       
     END DO
     en_av % u(i,k) = en_av % u(i,k) / nems
     en_av % v(i,k) = en_av % v(i,k) / nems
     en_av % w(i,k) = en_av % w(i,k) / nems
     en_av % r(i,k) = en_av % r(i,k) / nems
     en_av % b(i,k) = en_av % b(i,k) / nems
   END DO
 END DO
   
 ! Write ensemble average
 !------------------------------
 ens_av_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/En_'//ensnum//'_Av.nc'
 CALL Write_state_2d (ens_av_file,en_av, Dims, 1, 0, 1)

 ! Calculate perturbations
 !--------------------------   
 DO en = 1, nems
   DO k = 1, nlevs
     DO i = 1, nlongs
       en_pert(en) % u(i,k) = ensemble(en) % u(i,k) - en_av % u(i,k) 
       en_pert(en) % v(i,k) = ensemble(en) % v(i,k) - en_av % v(i,k) 
       en_pert(en) % w(i,k) = ensemble(en) % w(i,k) - en_av % w(i,k) 
       en_pert(en) % r(i,k) = ensemble(en) % r(i,k) - en_av % r(i,k) 
       en_pert(en) % b(i,k) = ensemble(en) % b(i,k) - en_av % b(i,k) 
     END DO
   END DO
 END DO
     
 ! Write ensemble perturbations
 !------------------------------
 DO en = 1, nems  !!! changed from 0,nems-1
   WRITE(filenumber,'(i2.2)')en
   ens_pert_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/PERTS/En_'//ensnum//&
                   '_pert_'//filenumber//'.nc'
   CALL Write_state_2d (ens_pert_file,en_pert(en), Dims, 1, 0, 1)
 END DO
      
 PRINT*, '------------------------------------------------'
 PRINT*, 'Calculate pvect for ensemble perturabtions'
 PRINT*, '------------------------------------------------'
 !==========================================================
 PRINT*, 'Reading Eigenvectors ...'
 PRINT*, eigenvects_file
 OPEN(56, file = eigenvects_file, form = 'unformatted')
 DO i = 1,nlongs
   DO k = 1, nvars*nlevs
     READ (56) EigVecs(i,k,1:nvars*nlevs)
   ENDDO
 ENDDO
 CLOSE (56)

  !==============================================================================================

 ! Read in phase space standard deviation
  ! Write phase space standard deviations
 !------------------------------
! ens_stds_file = '/export/carrot/raid2/wx019276/DATA/CVT/phase_space_stds'//ensnum//'.nc'
! CALL Read_2dmodel_state(ens_stds_file, en_std, Dims,1,0)
 
! DO i = 1, nlongs
!   DO k = 1, nlevs
!     IF (en_std % u(i,k) .LE. 1E-14) THEN
!         en_std % u(i,k) = 1.0
!     END IF
!     IF (en_std % v(i,k) .LE. 1E-14) THEN
!         en_std % v(i,k) = 1.0
!     END IF
!     IF (en_std % w(i,k) .LE. 1E-14) THEN
!         en_std % w(i,k) = 1.0
!     END IF
!     IF (en_std % r(i,k) .LE. 1E-14) THEN
!         en_std % r(i,k) = 1.0
!     END IF
!     IF (en_std % b(i,k) .LE. 1E-14) THEN
!         en_std % b(i,k) = 1.0
!     END IF
!   END DO
! END DO



 ! Project ensemble perturbations onto eigenvectors
 !-------------------------------------------------------

 DO en = 1, nems
   PRINT*,'---Ensemble member ',en,' ---'
!   DO i = 1, nlongs
!     DO k = 1, nlevs
!       en_pert(en) % u(i,k) = en_pert(en) % u(i,k) / en_std % u(i,k)
!       en_pert(en) % v(i,k) = en_pert(en) % v(i,k) / en_std % v(i,k)
!       en_pert(en) % w(i,k) = en_pert(en) % w(i,k) / en_std % w(i,k)
!       en_pert(en) % r(i,k) = en_pert(en) % r(i,k) / en_std % r(i,k)
!       en_pert(en) % b(i,k) = en_pert(en) % b(i,k) / en_std % b(i,k)
!    END DO
!   END DO
   CALL Hoz_Inv(en_pert(en), HozCtrl, Dims)
   CALL Vert_inv(HozCtrl,VertCtrl, Dims)
   CALL Eig_inv(VertCtrl, Ctrl_vect, EigVecs, 1, 0)  
   ! switch 1 rejects scaling in Eig_inv; 0 is a dummy argument
   en_ctrl_vect(en,1:nlevs*nvars,1:nlongs) = Ctrl_vect(1:nlevs*nvars,1:nlongs)
 END DO
  
 ! Calculate variance scaling
 !-----------------------------
! ctrl_av(:,:) = 0.0
! DO k = 1, nlongs
!   DO i = 1, nvars * nlevs
!     DO en = 1, nems 
!       ctrl_av(i,k) = ctrl_av(i,k) + en_ctrl_vect(en,i,k)
!     END DO
!     ctrl_av(i,k) = ctrl_av(i,k) / nems
!   END DO
! END DO
  
 ! dv dv^{T*} 
 DO k = 1, nlongs
   DO i = 1, nvars * nlevs   
     DO en = 1, nems 
       en_ctrl_vect(en,i,k) =  en_ctrl_vect(en,i,k) * CONJG(en_ctrl_vect(en,i,k)) 
     END DO
   END DO
 END DO

 DO k = 1, nlongs
   DO i = 1, nvars * nlevs   
     DO en = 1, nems 
       ctrl_std(i,k) = ctrl_std(i,k) + REAL(en_ctrl_vect(en,i,k))     
     END DO
     ctrl_std(i,k) = sqrt( ctrl_std(i,k) / nems )
   END DO
 END DO

 ! Dump standard deviations
 !--------------------------
 std_file = '/export/carrot/raid2/wx019276/DATA/CVT/eigvect_stds_'//ensnum//'.bin'
 
! PRINT*, ctrl_std(1:60,181)
! PRINT*, ctrl_std(1:60,182)
 
 OPEN(56, file = std_file, form = 'unformatted')
 DO n = 1, nvars*nlevs
   DO k = 1,nlongs
     WRITE (56) ctrl_std(n,k)
   END DO
 END DO
 CLOSE(56)

 std_file = '/export/carrot/raid2/wx019276/DATA/CVT/eigvect_stds_'//ensnum//'.dat'
 
  
 OPEN(56, file = std_file)
 DO n = 1, nvars*nlevs
   DO k = 1,nlongs
     WRITE (56,*) ctrl_std(n,k)
   END DO
 END DO
 CLOSE(56)


 END SUBROUTINE GenEigStd
!===================================================================================================
!***************************************************************************************************
!===================================================================================================
!===================================================================================================
!***************************************************************************************************
!===================================================================================================
 SUBROUTINE GenPhaseStd(ensemble,dims,ensnum)
 
 !**************************************************** 
 !* Subroutine to calculate the phase space          *
 !* standard deviation at each grid point            *
 !* use to find implied correlation not implied      *
 !* covariance                                       *
 !****************************************************
 
 USE DefConsTypes
 IMPLICIT NONE

 ! Declare global variables
 !--------------------------
 TYPE(model_vars_type), INTENT(INOUT)    :: ensemble(0:nems)
 TYPE(dimensions_type), INTENT(INOUT)    :: dims
 CHARACTER(LEN=*),      INTENT(IN)       :: ensnum

 ! Declare local variables
 !-------------------------
 TYPE(model_vars_type)                   :: en_av , en_pert(1:nems), en_std
 REAL(wp)                                :: EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs)
 INTEGER                                 :: en
 CHARACTER                               :: ens_av_file*69
 CHARACTER                               :: ens_stds_file*62
 CHARACTER                               :: ens_pert_file*68
 CHARACTER                               :: filenumber*2

 ! Counters
 INTEGER                                  :: k, i, j, en,n

!===================================================================================================
 ! Initialisations
 !-----------------
 CALL Initialise_model_vars(en_av)
 CALL Initialise_model_vars(en_std)
 DO en = 1, nems  ! changed from 0:nems-1
   CALL Initialise_model_vars(en_pert(en))
 END DO
!===================================================================================================
 
 PRINT*, '--------------------------------------------------------------------------'
 PRINT*, 'Calculating phase space standard deviations '
 PRINT*, '--------------------------------------------------------------------------'
 
 
 ! Calculate ensemble perturbations
 !==================================
   
 ! Calculate ensemble average 
 !-----------------------------
! PRINT*,' Calculate ensemble average'
 DO k = 1, nlevs
   DO i = 1, nlongs
     DO en = 1, nems
       en_av % u(i,k) = en_av % u(i,k) + ensemble(en) % u(i,k)
       en_av % v(i,k) = en_av % v(i,k) + ensemble(en) % v(i,k)
       en_av % w(i,k) = en_av % w(i,k) + ensemble(en) % w(i,k)
       en_av % r(i,k) = en_av % r(i,k) + ensemble(en) % r(i,k)
       en_av % b(i,k) = en_av % b(i,k) + ensemble(en) % b(i,k)       
     END DO
     en_av % u(i,k) = en_av % u(i,k) / nems
     en_av % v(i,k) = en_av % v(i,k) / nems
     en_av % w(i,k) = en_av % w(i,k) / nems
     en_av % r(i,k) = en_av % r(i,k) / nems
     en_av % b(i,k) = en_av % b(i,k) / nems
   END DO
 END DO
   
 ! Write ensemble average
 !------------------------------
 ens_av_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/En_'//ensnum//'_Av.nc'
 CALL Write_state_2d (ens_av_file,en_av, Dims, 1, 0, 1)

 ! Calculate perturbations
 !--------------------------   
 DO en = 1, nems
   DO k = 1, nlevs
     DO i = 1, nlongs
       en_pert(en) % u(i,k) = ensemble(en) % u(i,k) - en_av % u(i,k) 
       en_pert(en) % v(i,k) = ensemble(en) % v(i,k) - en_av % v(i,k) 
       en_pert(en) % w(i,k) = ensemble(en) % w(i,k) - en_av % w(i,k) 
       en_pert(en) % r(i,k) = ensemble(en) % r(i,k) - en_av % r(i,k) 
       en_pert(en) % b(i,k) = ensemble(en) % b(i,k) - en_av % b(i,k) 
     END DO
   END DO
 END DO
     
 ! Write ensemble perturbations
 !------------------------------
 DO en = 1, nems  !!! changed from 0,nems-1
   WRITE(filenumber,'(i2.2)')en
   ens_pert_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/PERTS/En_'//ensnum//&
                   '_pert_'//filenumber//'.nc'
   CALL Write_state_2d (ens_pert_file,en_pert(en), Dims, 1, 0, 1)
 END DO
      
 ! Calculate phase space standard deviation
 
 en_std % u(1:nlongs, 1:nlevs) = 0.0
 en_std % v(1:nlongs, 1:nlevs) = 0.0
 en_std % w(1:nlongs, 1:nlevs) = 0.0
 en_std % r(1:nlongs, 1:nlevs) = 0.0
 en_std % b(1:nlongs, 1:nlevs) = 0.0
 
 DO k = 1, nlevs
   DO i = 1, nlongs
     DO en = 1, nems
       en_std % u(i,k) = en_std % u(i,k) + en_pert(en) % u(i,k) * en_pert(en) % u(i,k)
       en_std % v(i,k) = en_std % v(i,k) + en_pert(en) % v(i,k) * en_pert(en) % v(i,k) 
       en_std % w(i,k) = en_std % w(i,k) + en_pert(en) % w(i,k) * en_pert(en) % w(i,k)
       en_std % r(i,k) = en_std % r(i,k) + en_pert(en) % r(i,k) * en_pert(en) % r(i,k)
       en_std % b(i,k) = en_std % b(i,k) + en_pert(en) % b(i,k) * en_pert(en) % b(i,k) 
     END DO
       en_std % u(i,k) = sqrt ( en_std % u(i,k) / nems )
       en_std % v(i,k) = sqrt ( en_std % v(i,k) / nems ) 
       en_std % w(i,k) = sqrt ( en_std % w(i,k) / nems )
       en_std % r(i,k) = sqrt ( en_std % r(i,k) / nems )
       en_std % b(i,k) = sqrt ( en_std % b(i,k) / nems ) 
   END DO
 END DO

 ! Write phase space standard deviations
 !------------------------------
 ens_stds_file = '/export/carrot/raid2/wx019276/DATA/CVT/phase_space_stds'//ensnum//'.nc'
 CALL Write_state_2d (ens_stds_file, en_std, Dims, 1, 0, 1)


 END SUBROUTINE GenPhaseStd
!===================================================================================================
!***************************************************************************************************
!===================================================================================================

!===================================================================================================
!***************************************************************************************************
!===================================================================================================
 SUBROUTINE TestCVT(ensemble,dims, eigenvects_file, st_dev_file, ens_no)
 
 !**************************************************** 
 !* Subroutine to test the property of the CVT       *
 !* <d chi d chi^T = I> *
 !* of the eigenvectors                              *
 !****************************************************
 
 USE DefConsTypes
 IMPLICIT NONE

 ! Declare global variables
 !--------------------------
 TYPE(model_vars_type), INTENT(INOUT)    :: ensemble(0:nems)
 TYPE(dimensions_type), INTENT(INOUT)    :: dims
 CHARACTER(LEN=*),      INTENT(IN)       :: eigenvects_file
 CHARACTER,             INTENT(IN)       :: st_dev_file*70
 CHARACTER(LEN=*),      INTENT(IN)       :: ens_no

 ! Declare local variables
 !-------------------------
 REAL(wp)                                :: EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs)
 REAL(wp)                                :: std_eigvecs(1:nvars*nlevs, 1:nlongs )
 TYPE(model_vars_type)                   :: OutputState, TempState
 TYPE(Transform_type)                    :: HozCtrl, VertCtrl
 COMPLEX(wp)                             :: Ctrl_vect(1:nvars*nlevs, 1:nlongs )
 COMPLEX(wp)                             :: En_Ctrl_vect(1:nems,1:nvars*nlevs, 1:nlongs )
 COMPLEX(wp)                             :: dcv(1:nems,1:nvars*nlevs, 1:nlongs )
 COMPLEX(wp)                             :: cv_av(1:nvars*nlevs, 1:nlongs )
 REAL(wp)                                :: cov_cv(1:nvars*nlevs, 1:nlongs )
 REAL(wp)                                :: cor_cv(1:nvars*nlevs, 1:nlongs )
 REAL(wp)                                :: std_cv(1:nvars*nlevs, 1:nlongs )
 REAL(wp)                                :: x_scale, z_scale, temp1, temp2, eps
 CHARACTER                               :: imp_covs_file*66 
 CHARACTER                               :: ens_filenumber*3,mu*3,hwn*3 
 CHARACTER                               :: ctrl_vect_file*68, ens_ctrl_vect_file*70
! Counters
 INTEGER                                 :: i,j,k, x,z,en,n,m,gen_en_ctrl_vecs
  
 PRINT*, ' Testing correlation of normal modes'
  
 !==============================================================================================
 ! Allocate/Initialise Variables
 !-------------------------------
 CALL Initialise_transform_vars ( HozCtrl )
 CALL Initialise_transform_vars ( VertCtrl )
 CALL Initialise_transform_vars ( OutputState )
 CALL Initialise_transform_vars ( TempState ) 
 std_eigvecs(1:nvars*nlevs, 1:nlongs )         = (0.0,0.0)
 EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs) = 0.0
 En_Ctrl_vect(1:nems,1:nvars*nlevs, 1:nlongs ) = (0.0,0.0)
 dcv(1:nems,1:nvars*nlevs, 1:nlongs ) = (0.0,0.0)
 cv_av(1:nvars*nlevs, 1:nlongs ) = (0.0,0.0)
 cov_cv(1:nvars*nlevs, 1:nlongs ) = (0.0,0.0)
 cor_cv(1:nvars*nlevs, 1:nlongs ) = (0.0,0.0)
 std_cv(1:nvars*nlevs, 1:nlongs ) = (0.0,0.0)
 eps     = 2E-18

 
 !==============================================================================================

 PRINT*, 'Reading Standard Deviations'
 PRINT*, st_dev_file
 OPEN(56, file = st_dev_file, form = 'unformatted')
 DO n = 1, nvars*nlevs
   DO k = 1,nlongs
     READ (56) std_eigvecs(n,k)
   END DO
 END DO
 CLOSE(56)
 

 PRINT*, 'Reading Eigenvectors'
 PRINT*, eigenvects_file
 OPEN(56, file = eigenvects_file, form = 'unformatted')
 DO i = 1,nlongs
   DO k = 1, nvars*nlevs
     READ (56) EigVecs(i,k,1:nvars*nlevs)
   END DO
 END DO
 CLOSE (56)

 
 !==============================================================================================
 ! Define a perturbation to examine implied covariances of
 !----------------------------------------------------------
! x = 180
! z = 30
! x_scale = 25.0
! z_scale = 9.0
! 
! DO i = 1, nlongs
!   DO k = 1, nlevs
!    temp1 = (x - i) * (x - i)
!    temp2 = (z - k) * (z - k)
!    TempState % r(i,k) = 1.0 * EXP (-(temp1/x_scale) - (temp2/z_scale) ) 
!   END DO
! END DO
 !==============================================================================================

 gen_en_ctrl_vecs = 1
!*************************************************************************************************** 
 IF ( gen_en_ctrl_vecs .EQ. 1) THEN
 
  PRINT*, ' Generate ensemble of control vectors'

  ens_ctrl_vect_file = '/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/ens_ctrl_vecs'//ens_no//'.bin'
  OPEN(56, file = ens_ctrl_vect_file, form = 'unformatted')
 
  DO en = 1,nems
   ! set each ensemble member 'en' to be tempstate
   TempState = ensemble(en)
   !Clear control vector
   Ctrl_vect(1:nvars*nlevs, 1:nlongs ) = (0.0,0.0)

   !==============================================================================================
   ! Inverse of CVT: model to control space 
   !----------------------------------------------
   PRINT*, ''
   PRINT*, 'Inverse cvt'
   PRINT*, '---------------'
   CALL Hoz_inv(TempState, HozCtrl) 
   CALL Vert_inv(HozCtrl, VertCtrl, Dims)
   CALL Eig_inv(VertCtrl, Ctrl_vect, EigVecs, 0, std_eigvecs)
   !==============================================================================================
   En_Ctrl_vect(en,1:nvars*nlevs, 1:nlongs ) = Ctrl_vect(1:nvars*nlevs, 1:nlongs )
   !==============================================================================================
   ! Dump ensemble of control vectors
   !--------------------------------------------------------------
   DO k = 1,nlongs
     DO i = 1,nvars*nlevs
        WRITE (56) En_Ctrl_vect(en,i,k)!), AIMAG(En_Ctrl_vect(en,i,k))
     END DO
   END DO
 
  END DO
  CLOSE(56)
 
  !*****
  ELSE
  !*****
  
  ! IF haven't generated then need to read them in
  PRINT*, 'Reading ensemble of control vectors'
  ens_ctrl_vect_file = '/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/ens_ctrl_vecs_'&
                       //ens_no//'.bin'
  OPEN(56, file = ens_ctrl_vect_file, form = 'unformatted')
  DO en = 1, nems
   DO k = 1,nlongs
     DO i = 1,nvars*nlevs
        READ (56) En_Ctrl_vect(en,i,k)!REAL(En_Ctrl_vect(en,i,k)), AIMAG(En_Ctrl_vect(en,i,k))
     END DO
   END DO
  END DO
  CLOSE (56)
 END IF
!*************************************************************************************************** 

   PRINT*, 'Calculate average'
   ! Calcualte average over the ensemble of the control vectors for k and mu
   DO m = 1,nvars*nlevs
     DO k = 1,nlongs
       DO en = 1, nems
         cv_av(m,k) =  cv_av(m,k) + En_Ctrl_vect(en,m,k)
       END DO
       cv_av(m,k) = cv_av(m,k)/nems
     END DO
   END DO

    PRINT*, 'Calculate perturbations'
  ! Calculate perturbations from the mean
   DO en = 1, nems
     DO m = 1,nvars*nlevs
       DO k = 1,nlongs
         dcv(en,m,k) =   En_Ctrl_vect(en,m,k) - cv_av(m,k)
       END DO
     END DO
   END DO

    PRINT*, 'Calculate standard deviations'
  ! Calculate standard deviations
   DO m = 1,nvars*nlevs
     DO k = 1,nlongs
       DO en = 1, nems
        std_cv(m,k) = std_cv(m,k) + ( dcv(en,m,k)*CONJG(dcv(en,m,k)))
       END DO
       std_cv(m,k) = sqrt( std_cv(m,k) /nems_1)
     END DO
   END DO

  
  
  PRINT*, 'Calculate covariances and correlations'
  !________________________________________________________________________ 
  ! i and j are the points to calculate the correlations with
  ! i is the eigenindex 
  ! j is the horizontal wave number
  ! cov_cv(m,k) and cor_cv(m,k) give all the correlations with this point.
  !________________________________________________________________________ 
!  i = 178 !eigenindex
!  j = 3  !horizontal wavenumber
 
  ! Loop over all i and j to calculate all correlations.


  DO j = 2,2 ! horizontal wavenumber
  
    DO i = 1,300 !eigenindex 
 
   ! Calculate covariances
    DO m = 1,nvars*nlevs
     DO k = 1,180
       DO en = 1, nems
        cov_cv(m,k) =  cov_cv(m,k) + ( dcv(en,m,k)*CONJG(dcv(en,i,j)) )
       END DO
       cov_cv(m,k) = cov_cv(m,k)/nems_1
       ! Calculate correlations
       IF (std_cv(m,k) .LE. eps) THEN
        cor_cv(m,k) = cov_cv(m,k)
       ELSE
        cor_cv(m,k) = cov_cv(m,k) / (std_cv(m,k) * std_cv(i,j))    
       END IF
     END DO
    END DO
    ! Dump correlations
   WRITE(hwn,'(i3.3)')j
   OPEN(57, file = '/export/carrot/raid2/wx019276/DATA/CVT/CORRELATIONS/nm_cor_' &
                    //ens_no//'_'//hwn//'_t_3hrs.dat')
   DO k = 1,180
    WRITE(57,*) cor_cv(1:nvars*nlevs, k)
   END DO

   END DO
   PRINT*, j
 END DO
 
!   PRINT*, 'Write covariances and correlations'
 ! Write correlation and covariance data
  !---------------------------------------
!  OPEN(56, file = '/export/carrot/raid2/wx019276/DATA/CVT/CORRELATIONS/nm_cov.dat')
!  OPEN(57, file = '/export/carrot/raid2/wx019276/DATA/CVT/CORRELATIONS/nm_cor.dat')
!  DO k = 1,nlongs
!    WRITE(56,*) cov_cv(1:nvars*nlevs, k)
!    WRITE(57,*) cor_cv(1:nvars*nlevs, k)
!  END DO
  


 !==============================================================================================
 END SUBROUTINE TestCVT
 
 
!===================================================================================================
!***************************************************************************************************
!===================================================================================================

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

