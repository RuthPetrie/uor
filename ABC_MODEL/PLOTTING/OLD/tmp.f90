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
     ntimestot = 8640  ! 24hrs @ dt = 10s = 8640
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
   //ensnum//'_'//ens_filenumber //'.nc'
   ntimestot         = 360   ! 1hr = 360 timesteps at dt = 10s
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
     
  u_scale = 0.1 
  v_scale = 0.1
  w_scale = 0.05
  r_scale = 0.02
  b_scale = 0.05

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
