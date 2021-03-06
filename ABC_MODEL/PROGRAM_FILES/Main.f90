 PROGRAM Main

 !*****************************************************
 !*   Main Driver program to run all programs         *  
 !*   related to the NHT model and the VAR            * 
 !*   including: Initialisation, Diagnostics,         *
 !*              and ensembles.                       *  
 !*                                                   *  
 !*   R. Petrie                                       *  
 !*   Version 2.0                                     * 
 !*   06/06/2011                                      *
 !*****************************************************

 ! Compile Statement
 !===================
 
 ! Out of bounds checking: debug mode
 !------------------------------------
 ! f90 -C -dalign -I/opt/graphics/include Main.f90 DefConsType.f90 CVT.f90 Transforms.f90 Linear_Analysis.f90 Write_data.f90 Model.f90 Ensembles.f90  Functions.f90 Boundaries.f90 Read_data.f90 UM_data_proc.f90 -o Main.out -M/opt/graphics/include -L/opt/graphics/lib -lnetcdf -lhdf5_hl -lhdf5 -M/opt/local/lib/nag_mod_dir -L/opt/tools/lib -lnagfl90 

 ! Standard
 !-----------
 ! f90 -C -dalign -I/opt/graphics/include Main.f90 DefConsType.f90 CVT.f90  Transforms.f90 Linear_Analysis.f90 Write_data.f90 Model.f90 Ensembles.f90  Functions.f90 Boundaries.f90 Read_data.f90 UM_data_proc.f90 -o Main.out -M/opt/graphics/include -L/opt/graphics/lib -lnetcdf -lhdf5_hl -lhdf5 -M/opt/local/lib/nag_mod_dir -L/opt/tools/lib -lnagfl90 

 ! Optimized
 !------------
 ! f90  -fast -I/opt/graphics/include Main.f90 DefConsType.f90 CVT.f90 Transforms.f90 Linear_Analysis.f90 Write_data.f90 Model.f90 Ensembles.f90  Functions.f90 Boundaries.f90 Read_data.f90 UM_data_proc.f90 -o Main.out -M/opt/graphics/include -L/opt/graphics/lib -lnetcdf -lhdf5_hl -lhdf5 -M/opt/local/lib/nag_mod_dir -L/opt/tools/lib -lnagfl90 


 ! Use Statements
 !=================

 USE DefConsTypes    
 USE nag_sym_lin_sys
 USE nag_sym_eig, ONLY : nag_sym_eig_all

 IMPLICIT NONE

 !Include netcdfProg2dModel.
 !==========================
 INCLUDE '/opt/local/include/netcdf.inc'
 
 ! Declare Top Level Variables
 !==============================
 TYPE(um_data_type)            :: init_um_data
 TYPE(dimensions_type)         :: dims
 TYPE(model_vars_type)         :: init_state, output_state, ens_state(0:nems)
 INTEGER                       :: ntimestot, ntimes  

 ! Declare local variables
 !-------------------------
 INTEGER, ALLOCATABLE          :: times(:)
 REAL(ZREAL8)                  :: Asqd_temp, B_temp, C_temp,  temp1, temp2
 INTEGER                       :: x_scale, z_scale, x_scale_length, z_scale_length
 
 ! Options and Switches
 !-----------------------
 INTEGER                       :: read_um_data
 INTEGER                       :: fwd_model, convection_switch, rescale, pressure_pert
 INTEGER                       :: ensembles, gen_ens, ens_forecast, en_diags
 INTEGER                       :: lin_analysis, cvt_testing, inv_cvt_test
 INTEGER                       :: gen_eigvecs, truncation, acoustic, gravity, balanced
 INTEGER                       :: adj_cvt_test, adj_test_flag, gen_imp_cov, calc_eig_func 
 INTEGER                       :: test_ctrl_bal, gen_eig_std, ens_method, test_cvt_I
 INTEGER                       :: read_spinup_data, balance_diags, read_data,read_um_etkf_data
 INTEGER                       :: read_um_etkf_data_multiple 
 ! Loop Counters
 !---------------
 INTEGER                       :: en, i, k, x, z, j, mbr
 
 ! Functions
 !-----------
 
 ! Filenames
 !-----------
 CHARACTER                     :: filenumber*2 
 CHARACTER                     :: dataset*2
 CHARACTER                     :: ens_filenumber*3,ens_filenumber_2*2
 CHARACTER                     :: init_um_file*65
 CHARACTER                     :: init_model_file*57
 CHARACTER                     :: init_model_read_file*68
 CHARACTER                     :: model_output_file*68 
 CHARACTER                     :: ens_memb_file*78
 CHARACTER                     :: ens_no*2, wavespeed_setno*4
 CHARACTER                     :: eigenvects_file*46
 CHARACTER                     :: eigenvals_file*46,  imp_covs_file*70
 CHARACTER                     :: st_dev_file*70
 CHARACTER                     :: eigenvects_filename*52, eigenvals_filename*52

!***************************************************************************************************
! INITIALISE
!***************************************************************************************************
 CALL Initialise_um_data(init_um_data)
 CALL Initialise_dims(dims)
 CALL Initialise_model_vars(init_state)
 CALL Initialise_model_vars(output_state)
 DO en = 0, nems
   CALL Initialise_model_vars(ens_state(en))
 END DO 

!***************************************************************************************************
! OPTIONS
!***************************************************************************************************
!================================================
 read_um_data       = 1
  read_data         = 0
  !---------------------
  read_spinup_data = 0
  dataset          = '80' ! spin up data set to load
!================================================
 fwd_model         = 0
 !---------------------
 !  model_output_file = '/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/UnbalReg_02.nc'  
  !  model_output_file = '/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/Energycons2.nc'  
!    model_output_file = '/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/GeoAdjst_68.nc'  
!    model_output_file = '/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/Convect_090.nc'  
!   model_output_file = '/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/Buoy_pert_1.nc'  
  model_output_file = '/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/CtrlRegm_95.nc'  
 
   ntimestot         = 100   !3 hours 
   ntimes            = 10     !every 5 mins
!   ntimestot         = 9000  !10 hours
!   ntimes            = 40    ! every 15 mins
   convection_switch = 0
   rescale           = 0
   pressure_pert     = 0
!================================================
 balance_diags     = 0
!================================================
 ensembles         = 0
  ! Set ensemble number 
   ens_no = '62'
!================================================
 lin_analysis      = 0
 !---------------------
   Asqd_temp     = 0.00004
   B_temp        = 0.005
   C_temp        = 100000.0
   wavespeed_setno = 'c_63'
!================================================
 cvt_testing       = 0
!================================================
!***************************************************************************************************
!
!***************************************************************************************************
   
 PRINT*, '------------------------------------'
 PRINT*, '    RUNNING MAIN   '
 PRINT*, '------------------------------------'
 
 !IF (balance_diags .EQ. 1) THEN
 !   init_model_read_file = '/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/Convect_078.nc'
 !   CALL Read_2dmodel_state(init_model_read_file, init_state, dims, 7 ,0)  !11 is read time
 !  CALL Balance_diagnostics(init_state)
 !END IF
 
!***************************************************************************************************
! Generate initial data
!***************************************************************************************************
 IF (read_um_data .EQ. 1) THEN
   PRINT*, ' Read and process um data' 
  
     ! RAW UM DATA   
     init_um_file =  '/export/carrot/raid2/wx019276/DATA/MODEL/INITCONDS/InitConds.nc'
!    init_um_file = '/export/carrot/raid2/wx019276/DATA/MODEL/INITCONDS/Member00.nc'

   CALL Read_um_data_2d (init_um_data, init_um_file, 144) ! final argument is a latitude of um data
   
   PRINT*, ' um data read'
   ! Process um data
   !-----------------
   
   ! Regularize grid
   CALL Regularize_grid(init_um_data, dims, 1) ! 1 as final arg to regularize vertical grid
   PRINT*, 'regularized grid'
   
   
   ! Calculate model variables
   ! Initial model write files
   init_model_file = '/export/carrot/raid2/wx019276/DATA/MODEL/INITCONDS/Adjusted_ICS_00.nc'

   CALL Process_um_data (init_um_data, init_state, dims, init_model_file ,0,1)
   PRINT*, 'um data processed' 
  
 ELSE IF ( read_data .EQ. 1) THEN
   PRINT*, '    Read in model data '
   
     IF (read_spinup_data .EQ. 1) THEN
              
       init_model_read_file = &
             '/export/carrot/raid2/wx019276/DATA/MODEL/INITCONDS/InitCons'//dataset//'.nc'
       PRINT*, '    Read in spin-up model data: ',dataset
       PRINT*, init_model_read_file
       CALL Read_2dmodel_state(init_model_read_file, init_state, dims, 11 ,0)  !11 is read time
      
     ELSE
         
       PRINT*, '    ', init_model_file
       ! Initial model write files
       init_model_file = '/home/wx019276/DATA/MODEL/INITCONDS/InitCondstemp_24.nc'
       CALL Read_2dmodel_state(init_model_file, init_state, dims, 1 ,0) 
       CALL Boundaries ( init_state, 1,1,1,1,1,1 )
       ! Test read is ok by outputting data read in.
       ! CALL Write_state_2d ('/home/wx019276/DATA/MODEL/INITCONDS/InitModelConds12.nc',&
       !                       init_state, Dims,1,times,1)
 
     END IF
   
 END IF 

!***************************************************************************************************
! Run forward model
!***************************************************************************************************
 
 IF ( fwd_model .EQ. 1) THEN
  
   PRINT*, ' Run forward model' 
  
   ! Set parameters
    !2 hrs at dt =3 : 2400 ;; at dt=4 :1800 ;; at dt = 5 :1440 ;; 2hrs @dt 10s = 
    !12 hrs = 4320 @ dt 10s
    !2700 = 3hrs @ dt = 4s, 36 outputs = plot every 5 mins
    !1800 = 2hrs @ dt = 4s, 24 outputs = slice every 5 mins
 
 !   model_output_file = '/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/idealised_002.nc'  
!   model_output_file = '/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/balance_002.nc'  
!   model_output_file = '/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/convection1.nc'  
!     model_output_file = '/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/nohup_test.nc'  
!    model_output_file = '/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/grav_wave_7.nc'  
!     model_output_file = '/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/eff_stab_14.nc'  
!    model_output_file = '/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/geost_adjmt.nc'  
!    model_output_file = '/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/convect_010.nc'  
!    model_output_file = '/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/stabilitytes.nc'  
!    model_output_file = '/home/wx019276/DATA/MODEL/INITCONDS/InitModelCondsBal.nc'
!    model_output_file = '/export/carrot/raid2/wx019276/DATA/MODEL/MODELOUT/coriolis_18.nc'  
!     model_output_file = '/export/carrot/raid2/wx019276/DATA/MODEL/INITCONDS/InitCons80.nc'

  IF (convection_switch .EQ. 1) THEN
     init_state % b (:,:) = 0.0
     init_state % w (:,:) = 0.0
     init_state % v (:,:) = 0.0 
     init_state % u (:,:) = 0.0
     init_state % r (:,:) = 0.0
     init_state % geost_imbal(:,:) = 0.0 
     init_state % hydro_imbal(:,:) = 0.0
  END IF
  IF (pressure_pert .EQ. 1) THEN
 
     ! Initalise all field to zero
     init_state % b (:,:) = 0.0
     init_state % w (:,:) = 0.0
     init_state % v (:,:) = 0.0 
     init_state % u (:,:) = 0.0
     init_state % r (:,:) = 0.0
     init_state % geost_imbal(:,:) = 0.0 
     init_state % hydro_imbal(:,:) = 0.0
 
     ! Set source location 
     i = 180
     k = 30
 
     ! Set source size 
!     x_scale_length = !in meters
!     z_scale_length = !in meters
     x_scale = 80  ! * dx (1.5km) for meters if C = f this is the scale length
     z_scale = 3    ! * dz (~250) for meters

     DO x = 1, nlongs
       DO z = 1, nlevs
         temp1 = (i - x) * (i - x)
         temp2 = (k - z) * (k - z)
         init_state % r(x,z) = 0.01 * EXP (- (temp1/(x_scale**2)) &
                                           - (temp2/(z_scale**2)) )
       END DO 
     END DO
     
   END IF
    
     
   CALL ModelDriver(init_state, output_state, Dims, ntimestot, ntimes, model_output_file, &
                       convection_switch, rescale,0, 0) 
  END IF

!***************************************************************************************************
! Ensembles 
!***************************************************************************************************
 IF (ensembles .EQ. 1) THEN

   ! Switches :: 1 is on 0 is off
   
   gen_ens       = 0  ! Generate ensemble
   ens_forecast  = 0  ! Forecast of ensemble
   en_diags      = 1  ! Perform Ensemble diagnostics, variance, covariance
   gen_eig_std   = 0  ! generate the standard deviation of eigenvectors for scaling in CVT
   test_cvt_I    = 0  ! test <d chi d chi^T> =? I
 
 
    !*****Must also be reset for forecast ensemble number if a different forecast is required
   ! this means you can use different forecast ensembles for the same
   !bred vectors.  If you need to change forecast ensemble make sure you change
   !in Ensemble of forecasts section

   PRINT*, '------------------------------------'
   PRINT*, ' ENSEMBLES :: ',ens_no 
   PRINT*, '------------------------------------'
  
!===================================================================================================
!===================================================================================================
   ! Generate ensemble
   IF (gen_ens .EQ. 1) THEN
     PRINT*, '------------------------------------'
     PRINT*, ' GENERATING ENSEMBLE'
     PRINT*, '------------------------------------'
    
     !------------------------------------------------------------
     ! Generate ensemble members
     !------------------------------------------------------------
     ! Ensemble Methods
     ! 1:: allocate each member to a latitude slice
     ! 2:: run a breeding cycle on a single state
     ! 3:: composite of latitude slices and breeding cycles
     ! 4:: test breeding for convergence
     ! 5:: ensemble breeding rescalign method
     !------------------------------------------------------------
        
     ens_method = 3
     
     CALL Generate_ensemble (ens_state(0:nems),dims,ens_no, ens_method)  ! final argument is method

   ELSE
 
     read_um_etkf_data = 0
     
     IF (read_um_etkf_data .EQ. 1) THEN
     
     
     ! Read in ensemble initial perturbations
 
 ! Read in ETKF Ensemble members, i.e. select slice and perform preprocessing on each member
 !-------------------------------------------------------------------------------------------
     DO en = 0, nems
       WRITE(ens_filenumber_2,'(i2.2)')en    
     
       ! Each ETKF ensemble member
       init_um_file =  '/export/carrot/raid2/wx019276/DATA/MODEL/INITCONDS/Member'&
                       //ens_filenumber_2//'.nc'
       CALL Read_um_data_2d (init_um_data, init_um_file, 144)
   
      PRINT*, ' Read ETKF Member: ', en
      ! Process ETKF Member: 
      !-----------------
      CALL Regularize_grid(init_um_data, dims, 1)
      PRINT*, 'regularized grid'
   
      ! Calculate model variables
      ! Initial model write files
      init_model_file = '/home/wx019276/DATA/MODEL/INITCONDS/temp.nc'

      CALL Process_um_data (init_um_data, ens_state(en), dims, init_model_file ,0,1)
      PRINT*, 'um data processed' 
      !set rho0 and boundaries
      ens_state(en) % rho0(1:nlevs) = 1.0
      CALL Boundaries( ens_state(en), 1,1,1,1,1,1 )
 
     END DO        
    
     ELSE
 !     PRINT*, ' Reading processed etkf ensemble data'
 !     DO en = 0, nems
 !      WRITE(ens_filenumber,'(i3.3)')en    
 !        ens_memb_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/FORECAST/En_fore_'&
 !                      //ens_no//ens_filenumber //'.nc'
 !      CALL Read_2dmodel_state(ens_memb_file, ens_state(en), dims, 11 ,0) 
 !       ens_state(en) % rho0(1:nlevs) = 1.0
 !     CALL Boundaries( ens_state(en), 1,1,1,1,1,1 )
! 
!      END DO 
!      
     END IF
     
     read_um_etkf_data_multiple = 0
     
     IF (read_um_etkf_data_multiple .EQ. 1) THEN
     
     
   DO j = 1,4
         
     ! Read in ensemble initial perturbations
 
     ! Read in ETKF Ensemble members, i.e. select slice and perform preprocessing on each member
     !-------------------------------------------------------------------------------------------
     DO en = 0, 23!nems
     
       mbr = ((j-1)* 24)-1
       PRINT*,'Ensemble Member:: ',mbr
       
       WRITE(ens_filenumber_2,'(i2.2)')en    
     
       ! Each ETKF ensemble member
       init_um_file =  '/export/carrot/raid2/wx019276/DATA/MODEL/INITCONDS/Member'&
                       //ens_filenumber_2//'.nc'
       CALL Read_um_data_2d (init_um_data, init_um_file, (136 + j*4))
   
      PRINT*, ' Read ETKF Member: ', en
      ! Process ETKF Member: 
      !-----------------
      CALL Regularize_grid(init_um_data, dims, 1)
      PRINT*, 'regularized grid'
   
      ! Calculate model variables
      ! Initial model write files
      init_model_file = '/home/wx019276/DATA/MODEL/INITCONDS/temp.nc'

      CALL Process_um_data (init_um_data, ens_state(mbr), dims, init_model_file ,0,1)
      PRINT*, 'um data processed' 
      !set rho0 and boundaries
      ens_state(mbr) % rho0(1:nlevs) = 1.0
      CALL Boundaries( ens_state(mbr), 1,1,1,1,1,1 )
 
     END DO        
      END DO 
     
 
    END IF

     
!      PRINT*, ens_state(en) % u(50,50)
!      PRINT*, ens_state(en) % v(50,50)
!      PRINT*, ens_state(en) % w(50,50)
!      PRINT*, ens_state(en) % r(50,50)
!      PRINT*, ens_state(en) % b(50,50)

 !      ens_memb_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/En_Init_Perts_'&
 !!            //filenumber//'.nc'
 !            //ens_no//ens_filenumber//'.nc'
 !      PRINT*, 'Reading in member: ',ens_memb_file
 !      CALL Read_2dmodel_state(ens_memb_file, ens_state(en), Dims,1,0) 
 !      !set rho0 and boundaries
 !      ens_state(en) % rho0(1:nlevs) = 1.0
 !      CALL Boundaries( ens_state(en), 1,1,1,1,1,1 )
 !    END DO
   END IF
 
 
!===================================================================================================
!===================================================================================================
   ! Ensemble of forecasts

   ! Set ensemble number
  ! ens_no = '26'

 
   IF (ens_forecast .EQ. 1) THEN
   
     PRINT*, '------------------------------------'
     PRINT*, '    RUNNING ENSEMBLE OF FORECASTS   '
     PRINT*, '------------------------------------'
     
     ! Set options
     ntimestot         = 2700  ! 3 hrs
     ntimes            = 10
     convection_switch = 0
     rescale           = 0 ! final two args in ModelDriver not required for rescale = 0
     DO en = 0, nems
       PRINT*, 'Ensemble Member', en  
       WRITE(ens_filenumber,'(i3.3)')en
       ens_memb_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/FORECAST/En_fore_'&
                       //ens_no//ens_filenumber //'.nc'
       PRINT*, ens_memb_file
            
       CALL ModelDriver(ens_state(en), output_state, Dims, ntimestot, ntimes, ens_memb_file, &
                       convection_switch, rescale,0, 0) 
     ENDDO

   END IF
   
!===================================================================================================
!===================================================================================================
   ! Ensemble Diagnostics - variance and covariance
   !------------------------------------------------
   IF (en_diags .EQ. 1) THEN
  
     PRINT*, '------------------------------------'
     PRINT*, '   ENSEMBLE DIAGNOSTICS  '
     PRINT*, '------------------------------------'

     ! Read in ensemble at specified lead time
     !-----------------------------------------
     DO en = 0, nems
       CALL Initialise_model_vars(ens_state(en))
       WRITE(ens_filenumber,'(i3.3)')en
       ens_memb_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/FORECAST/En_fore_'&
                       //ens_no//ens_filenumber //'.nc'
       CALL Read_2dmodel_state(ens_memb_file, ens_state(en), Dims,11,0)
       ! penultimate argument is the time index
     END DO 

     ! Perform ensemble diagnostics
     !-------------------------------
     CALL Ens_variances ( ens_state(0:nems), Dims , &
                   '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/En_'&
                   //ens_no//'_variances.nc')
     CALL Ens_covariances (ens_state(0:nems), Dims, &
        '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/En_'//ens_no//'_covars.nc', &
        '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/En_'//ens_no//'_correlations.nc',&
         180, 30)

     ! Display filenames
     !-------------------
     PRINT*, '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/En_'//ens_no//'_variances.nc'
     PRINT*,'/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/En_'//ens_no//'_covars.nc'
     PRINT*,'/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/En_'//ens_no//'_correlations.nc'
   END IF   

!===================================================================================================
!===================================================================================================

    IF (gen_eig_std .EQ. 1) THEN
    
      ! Read in ensemble at specified lead time
      !-----------------------------------------
      DO en = 0, nems
        ! empty ensemble files  
        CALL Initialise_model_vars(ens_state(en))
        
        WRITE(ens_filenumber,'(i3.3)')en
        ens_memb_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/FORECAST/En_fore_'&
                        //ens_no//ens_filenumber //'.nc'
        CALL Read_2dmodel_state(ens_memb_file, ens_state(en), Dims,11,0)
        ! penultimate argument is the time index
      END DO 

      !!! MUST CHANGE THIS ALSO
      eigenvects_filename = '/export/carrot/raid2/wx019276/DATA/CVT/EVecs31.bin'
      CALL GenEigStd(ens_state(0:nems),dims,ens_no,eigenvects_filename)
      CALL GenPhaseStd(ens_state(0:nems),dims,ens_no)
   
    END IF
  
!===================================================================================================
!===================================================================================================
   IF (test_cvt_I .EQ. 1) THEN
   
     ! read in ensemble
     DO en = 0, nems
       WRITE(ens_filenumber,'(i3.3)')en    
        ens_memb_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/FORECAST/En_fore_'&
                       //ens_no//ens_filenumber //'.nc'
!      ens_memb_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/En_Init_Perts_'&
!                        //ens_no//ens_filenumber//'.nc'
       PRINT*, 'Reading in member: ',ens_memb_file
       CALL Read_2dmodel_state(ens_memb_file, ens_state(en), Dims,11,0) 
       !set rho0 and boundaries
      ens_state(en) % rho0(1:nlevs) = 1.0
       CALL Boundaries( ens_state(en), 1,1,1,1,1,1 )
     END DO

     eigenvects_filename = '/export/carrot/raid2/wx019276/DATA/CVT/EVecs'//ens_no//'.bin'
     st_dev_file         = '/export/carrot/raid2/wx019276/DATA/CVT/eigvect_stds_'//ens_no//'.bin' 
   CALL TestCVT(ens_state(0:nems),dims, eigenvects_filename, st_dev_file,ens_no )

   END IF
    !-----------------------------------------------------------------------------------------------  
  
!===================================================================================================
!===================================================================================================
  END IF

!***************************************************************************************************
! Linear Anlaysis 
!***************************************************************************************************
 IF (lin_analysis .EQ. 1) THEN
  
  CALL Linear_Analysis(Asqd_temp, B_temp, C_temp,wavespeed_setno)

 END IF

!***************************************************************************************************
! Test CVT
!***************************************************************************************************
 IF (cvt_testing .EQ. 1) THEN

  PRINT*, '------------------------------------'
  PRINT*, '   CVT TESTING  '
  PRINT*, '------------------------------------'
 !************************************************************************************************** 
 !* Inputs to CVT
 !* ------------------
 !* InitState
 !* Dims - dimension data
 !*
 !* Options
 !* -------
 !* gen_eigvecs   : Set gen_eigvecs = 1 to generate eigenvectors of system matrix, 0 to read in
 !* gen_imp_cov   : Set gen_imp_cov = 1 to generate implied covariances.
 !* truncation    : Set truncation = 1 to truncate wave numbers in implied covs
 !* acoustic      : set acoustic = 1 to remove acoustic modes
 !* gravity       : Set gravity = 1 to remove gravity modes 
 !* balanced      : Set balanced = 1 to remove balanced mode
 !* inv_cvt_test  : Set inv_cvt_test = 1 perform forward-inverse CVT test.
 !* adj_cvt_test  : Set adj_cvt_test = 1 to perform adjoint test
 !* adj_test_flag : Set adj_test_flag: 1 = horiz, 2 = eigenvector, 3 = hoz + eig, 4 = vert, 5 = full
 !* calc_eig_func : Ser calc_eig_func = 1 to calculate eigenfunctions in real space
 !* test_ctrl_bal : set test_ctrl_bal = 1 to test balanced components of control vector
 !************************************************************************************************** 
 gen_eigvecs    = 0
   eigenvects_file= '/export/carrot/raid2/wx019276/DATA/CVT/EVecs31'
   eigenvals_file = '/export/carrot/raid2/wx019276/DATA/CVT/EVals31'
   !must re-declare length of eigenvcts_file or eigenvals_file if changed
   st_dev_file    = '/export/carrot/raid2/wx019276/DATA/CVT/eigvect_stds_31.bin' 
 gen_imp_cov    = 0
 truncation     = 0   
 acoustic       = 0
 gravity        = 0
 balanced       = 0
 inv_cvt_test   = 0
 adj_cvt_test   = 0 
 adj_test_flag  = 0
 calc_eig_func  = 0
 test_ctrl_bal  = 0
 imp_covs_file = '/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs.nc'
 
 eigenvects_filename = '/export/carrot/raid2/wx019276/DATA/CVT/EVecs'//ens_no//'.bin'
 eigenvals_filename = '/export/carrot/raid2/wx019276/DATA/CVT/EVals'//ens_no//'.bin'
 st_dev_file    = '/export/carrot/raid2/wx019276/DATA/CVT/eigvect_stds_'//ens_no//'.bin' 

 
  CALL CVT(init_state, Dims, gen_eigvecs, truncation, acoustic, gravity, balanced, inv_cvt_test, &
           adj_cvt_test, adj_test_flag, gen_imp_cov, calc_eig_func, test_ctrl_bal, &
           eigenvects_filename, eigenvals_filename,st_dev_file, imp_covs_file, ens_no )



!***************************************************************************************************
! GENERATE IMPLIED COVARIANCES
!***************************************************************************************************
  gen_imp_cov    = 1
  truncation     = 0   
  imp_covs_file = '/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_'//ens_no//&
                  '_full.nc'
 CALL CVT(init_state, Dims, gen_eigvecs, truncation, acoustic, gravity, balanced, inv_cvt_test, &
           adj_cvt_test, adj_test_flag, gen_imp_cov, calc_eig_func, test_ctrl_bal, &
           eigenvects_filename, eigenvals_filename,st_dev_file, imp_covs_file, ens_no )

  gen_imp_cov    = 1
  truncation     = 1   
  acoustic       = 1
  gravity        = 1
  balanced       = 0
  imp_covs_file = '/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_'//ens_no//&
                  '_bal.nc'
 CALL CVT(init_state, Dims, gen_eigvecs, truncation, acoustic, gravity, balanced, inv_cvt_test, &
           adj_cvt_test, adj_test_flag, gen_imp_cov, calc_eig_func, test_ctrl_bal, &
           eigenvects_filename, eigenvals_filename,st_dev_file, imp_covs_file, ens_no )

  gen_imp_cov    = 1
  truncation     = 1   
  acoustic       = 1
  gravity        = 0
  balanced       = 1
  imp_covs_file = '/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_'//ens_no//&
                  '_grav.nc'
 CALL CVT(init_state, Dims, gen_eigvecs, truncation, acoustic, gravity, balanced, inv_cvt_test, &
           adj_cvt_test, adj_test_flag, gen_imp_cov, calc_eig_func, test_ctrl_bal, &
           eigenvects_filename, eigenvals_filename,st_dev_file, imp_covs_file, ens_no )

  gen_imp_cov    = 1
  truncation     = 1   
  acoustic       = 0
  gravity        = 1
  balanced       = 1
  imp_covs_file = '/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_'//ens_no//&
                  '_ac.nc'
 CALL CVT(init_state, Dims, gen_eigvecs, truncation, acoustic, gravity, balanced, inv_cvt_test, &
           adj_cvt_test, adj_test_flag, gen_imp_cov, calc_eig_func, test_ctrl_bal, &
           eigenvects_filename, eigenvals_filename,st_dev_file, imp_covs_file, ens_no )

!***************************************************************************************************
! END GENERATE IMPLIED COVARIANCES
!***************************************************************************************************






 END IF




 END PROGRAM Main




















