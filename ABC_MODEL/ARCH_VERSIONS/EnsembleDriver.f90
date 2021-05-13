 PROGRAM EnsembleDriver

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

 ! f90 -C -dalign -I/opt/graphics/include EnsembleDriver.f90 DefConsType.f90  Write_data.f90 Model.f90 Ensembles.f90 Allocations.f90 Functions.f90 Boundaries.f90 UM_data_proc.f90 Read_data.f90  -o e.out -M/opt/graphics/include -L/opt/graphics/lib -lnetcdf -lhdf5_hl -lhdf5 -M/opt/local/lib/nag_mod_dir -L/opt/tools/lib -lnagfl90 

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
 TYPE(dimensions_type)         :: dims
 TYPE(model_vars_type)         :: output_state,ens_state(0:nems)
 INTEGER                       :: ntimestot, ntimes, wts  

 ! Declare local variables
 !-------------------------
 INTEGER, ALLOCATABLE          :: times(:)
 ! Options and Switches
 !-----------------------
 INTEGER                       :: read_um_data
 INTEGER                       :: fwd_model, convection_switch, rescale
 INTEGER                       :: ensembles, gen_ens, ens_forecast
 INTEGER                       :: lin_analsis

 ! Loop Counters
 !---------------
 INTEGER                       :: en 
 ! Functions
 !-----------
 
 ! Filenames
 !-----------
 CHARACTER                     :: filenumber*2
 CHARACTER                     :: init_um_file*65
 CHARACTER                     :: init_model_file*57
 CHARACTER                     :: model_output_file*64 
 CHARACTER                     :: ens_memb_file*77


 
!***************************************************************************************************
! OPTIONS
!***************************************************************************************************
  gen_ens      = 0
   ens_forecast = 1

!***************************************************************************************************
! Ensembles 
!***************************************************************************************************
   
   ! Generate ensemble
   IF (gen_ens .EQ. 1) THEN
     ! Generate ensemble members
     CALL Generate_ensemble (ens_state(0:nems),'11', 1)  ! 11 is ensemble set number, 1 is method
   ELSE
     ! Read in ensemble
     DO en = 0, nems
       WRITE(filenumber,'(i2.2)')en
       ens_memb_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/INITPERTS/En_Init_Perts_10'&
                       //filenumber //'.nc'
 !      PRINT*,ens_memb_file
       CALL Read_2dmodel_state(ens_memb_file, ens_state(en), Dims,1,0) 
       !set rho0 and boundaries
       ens_state(en) % rho0(1:nlevs) = 1.0
       CALL Boundaries( ens_state(en), 1,1,1,1,1,1 )
     END DO
   END IF
   
   ! Ensemble of forecasts
   IF (ens_forecast .EQ. 1) THEN
   
     PRINT*, '    Running ensemble of foreacsts'
     
     ! Set options
     ntimestot         = 3600
     ntimes            = 10
     wts               = 360
     convection_switch = 0
     rescale           = 0
     DO en = 0, nems-1
       PRINT*, 'Ensemble Member', en  
       WRITE(filenumber,'(i2.2)')en
       ens_memb_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/FORECAST/Ensfore_10_'&
                       //filenumber //'.nc'
       CALL ModelDriver(ens_state(en), output_state, Dims, ntimestot, ntimes, wts, ens_memb_file, &
                       convection_switch, rescale, 0) 
     ENDDO

   END IF
   
   CALL Ens_variances ( ens_state(0:nems), Dims , &
                   '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/ens_10_variances.nc')
   CALL Ens_covariances (ens_state(0:nems), Dims, &
                  '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/ens_10_covars.nc', &
                  '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/ens_10_correlations.nc',&
                  180, 10)
             
 END PROGRAM EnsembleDriver



















