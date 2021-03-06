 PROGRAM GenB

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
 ! f90 -C -dalign -I/opt/graphics/include GenB.f90 DefConsType.f90 CVT.f90 Transforms.f90 Linear_Analysis.f90 Write_data.f90 Model.f90 Ensembles.f90  Functions.f90 Boundaries.f90 Read_data.f90 UM_data_proc.f90 -o GenB.out -M/opt/graphics/include -L/opt/graphics/lib -lnetcdf -lhdf5_hl -lhdf5 -M/opt/local/lib/nag_mod_dir -L/opt/tools/lib -lnagfl90 

 ! Standard
 !-----------
 ! f90  -dalign -I/opt/graphics/include GenB.f90 DefConsType.f90 CVT.f90  Transforms.f90 Linear_Analysis.f90 Write_data.f90 Model.f90 Ensembles.f90  Functions.f90 Boundaries.f90 Read_data.f90 UM_data_proc.f90 -o GenB.out -M/opt/graphics/include -L/opt/graphics/lib -lnetcdf -lhdf5_hl -lhdf5 -M/opt/local/lib/nag_mod_dir -L/opt/tools/lib -lnagfl90 

 ! Optimized
 !------------
 ! f90  -fast -I/opt/graphics/include GenB.f90 DefConsType.f90 CVT.f90 Transforms.f90 Linear_Analysis.f90 Write_data.f90 Model.f90 Ensembles.f90  Functions.f90 Boundaries.f90 Read_data.f90 UM_data_proc.f90 -o GenB.out -M/opt/graphics/include -L/opt/graphics/lib -lnetcdf -lhdf5_hl -lhdf5 -M/opt/local/lib/nag_mod_dir -L/opt/tools/lib -lnagfl90 


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
 INTEGER                       :: read_spinup_data, balance_diags, read_time
 ! Loop Counters
 !---------------
 INTEGER                       :: en, i, k, x, z 
 
 ! Functions
 !-----------
 
 ! Filenames
 !-----------
 CHARACTER                     :: filenumber*2 
 CHARACTER                     :: dataset*2
 CHARACTER                     :: ens_filenumber*3
 CHARACTER                     :: init_um_file*65
 CHARACTER                     :: init_model_file*57
 CHARACTER                     :: init_model_read_file*68
 CHARACTER                     :: model_output_file*68 
 CHARACTER                     :: ens_memb_file*78
 CHARACTER                     :: ens_no*2, wavespeed_setno*4
 CHARACTER                     :: eigenvects_file*46, eigenvects_filename*50
 CHARACTER                     :: eigenvals_file*46,  imp_covs_file*70
 CHARACTER                     :: st_dev_file*70
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
 ! Read in some initial data to fill dimensions array.
 init_model_read_file = &
       '/export/carrot/raid2/wx019276/DATA/MODEL/INITCONDS/InitCons20.nc'
  PRINT*, '    Read in spin-up model data dummy data to fill dims array '
  PRINT*, init_model_read_file
  CALL Read_2dmodel_state(init_model_read_file, init_state, dims, 1 ,0)  !11 is read time
      

!***************************************************************************************************
! OPTIONS
!***************************************************************************************************
   ! Set ensemble number 
   ens_no = '65'
   read_time = 4
   !*****Must also be reset for forecast ensemble number if a different forecast is required
   ! this means you can use different forecast ensembles for the same
   !bred vectors.  If you need to change forecast ensemble make sure you change
   !in Ensemble of forecasts section



 ! gen_eigvecs = 1 or read in = 0 using CVT routines
   gen_eigvecs    = 1
   eigenvects_file= '/export/carrot/raid2/wx019276/DATA/CVT/EVecs'//ens_no
   eigenvals_file = '/export/carrot/raid2/wx019276/DATA/CVT/EVals'//ens_no
   PRINT*, 'eigenvals_file:',eigenvals_file
   !must re-declare length of eigenvcts_file or eigenvals_file if changed
   !!! MUST CHANGE THIS ALSO
   eigenvects_filename = '/export/carrot/raid2/wx019276/DATA/CVT/EVecs'//ens_no//'.bin'
   st_dev_file    = '/export/carrot/raid2/wx019276/DATA/CVT/eigvect_stds_'//ens_no//'.bin' 

 !************************************************************************************************** 
 !* Inputs to CVT
 !* ------------------
 !* InitState
 !* Dims - dimension data
 !*
 !* Options
 !* -------
 !* gen_eigvecs   : Set gen_eigvecs = 1 to generate eigenvectors of system matrix, 0 to read in
 !* Other inputs set to zero in this routine only
 !************************************************************************************************** 

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
   
   
! Ensembles
   gen_ens       = 0  ! Generate ensemble
   ens_forecast  = 0  ! Forecast of ensemble
   en_diags      = 0  ! Perform Ensemble diagnostics, variance, covariance
   gen_eig_std   = 1  ! generate the standard deviation of eigenvectors for scaling in CVT
 

!***************************************************************************************************
! END OPTIONS
!***************************************************************************************************



!***************************************************************************************************
! GENERATE NORMAL MODES FOR A GIVEN SET OF TUNABLE PARAMETERS OR READ IN CORREESPONDING NORMAL MODES
!***************************************************************************************************

 CALL CVT(init_state, Dims, gen_eigvecs, truncation, acoustic, gravity, balanced, inv_cvt_test, &
           adj_cvt_test, adj_test_flag, gen_imp_cov, calc_eig_func, test_ctrl_bal,              &
           eigenvects_file, eigenvals_file,st_dev_file, ens_no)
   gen_eigvecs    = 0

!***************************************************************************************************
! END GENERATE NORMAL MODES 
!***************************************************************************************************



!***************************************************************************************************
! GENERATE ENSEMBLE
!***************************************************************************************************
 
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
        
     ens_method = 1
     
     CALL Generate_ensemble (ens_state(0:nems),dims,ens_no, ens_method)  ! final argument is method

   ELSE
     ! Read in ensemble initial perturbations
 !    DO en = 0, nems
 !      WRITE(ens_filenumber,'(i3.3)')en    
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
       CALL Read_2dmodel_state(ens_memb_file, ens_state(en), Dims,read_time,0)
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
    ! Set ensemble number set if ensemble is read in and not generated as part of this routine
!       ens_no = '33'
      DO en = 0, nems
        ! empty ensemble files  
        CALL Initialise_model_vars(ens_state(en))
        
        WRITE(ens_filenumber,'(i3.3)')en
        ens_memb_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/FORECAST/En_fore_'&
                        //ens_no//ens_filenumber //'.nc'
        CALL Read_2dmodel_state(ens_memb_file, ens_state(en), Dims,11,0)
        ! penultimate argument is the time index
      END DO 

       !reset ensemble number 
!      ens_no = '40'
    ! generate phase space standard deviations 
 !"     CALL GenPhaseStd(ens_state(0:nems),dims,ens_no)

      CALL GenEigStd(ens_state(0:nems),dims,ens_no,eigenvects_filename)
      
 
    END IF
  
 

!***************************************************************************************************
! END GENERATE ENSEMBLE
!***************************************************************************************************

!***************************************************************************************************
! GENERATE IMPLIED COVARIANCES
!***************************************************************************************************
  gen_imp_cov    = 1
  truncation     = 0   
  imp_covs_file = '/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_'//ens_no//&
                  '_full.nc'
 CALL CVT(init_state, Dims, gen_eigvecs, truncation, acoustic, gravity, balanced, inv_cvt_test, &
           adj_cvt_test, adj_test_flag, gen_imp_cov, calc_eig_func, test_ctrl_bal, &
           eigenvects_file, eigenvals_file,st_dev_file, imp_covs_file, ens_no )

  gen_imp_cov    = 1
  truncation     = 1   
  acoustic       = 1
  gravity        = 1
  balanced       = 0
  imp_covs_file = '/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_'//ens_no//&
                  '_bal.nc'
 CALL CVT(init_state, Dims, gen_eigvecs, truncation, acoustic, gravity, balanced, inv_cvt_test, &
           adj_cvt_test, adj_test_flag, gen_imp_cov, calc_eig_func, test_ctrl_bal, &
           eigenvects_file, eigenvals_file,st_dev_file, imp_covs_file, ens_no )

  gen_imp_cov    = 1
  truncation     = 1   
  acoustic       = 1
  gravity        = 0
  balanced       = 1
  imp_covs_file = '/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_'//ens_no//&
                  '_grav.nc'
 CALL CVT(init_state, Dims, gen_eigvecs, truncation, acoustic, gravity, balanced, inv_cvt_test, &
           adj_cvt_test, adj_test_flag, gen_imp_cov, calc_eig_func, test_ctrl_bal, &
           eigenvects_file, eigenvals_file,st_dev_file, imp_covs_file, ens_no )

  gen_imp_cov    = 1
  truncation     = 1   
  acoustic       = 0
  gravity        = 1
  balanced       = 1
  imp_covs_file = '/export/carrot/raid2/wx019276/DATA/MODEL/IMPCOVS/NM/impcovs_'//ens_no//&
                  '_ac.nc'
 CALL CVT(init_state, Dims, gen_eigvecs, truncation, acoustic, gravity, balanced, inv_cvt_test, &
           adj_cvt_test, adj_test_flag, gen_imp_cov, calc_eig_func, test_ctrl_bal, &
           eigenvects_file, eigenvals_file,st_dev_file, imp_covs_file, ens_no )

!***************************************************************************************************
! END GENERATE IMPLIED COVARIANCES
!***************************************************************************************************



 END PROGRAM GenB




















