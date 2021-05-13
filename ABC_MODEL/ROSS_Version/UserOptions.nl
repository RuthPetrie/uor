! Define namelist
! ---------------
&UserOptions

! Reading and processing UM data
! ------------------------------
  make_ics_from_um         = .FALSE.
  datadirUM                = '/net/carrot/export/carrot/raid2/wx019276/InitialData'
  init_um_file             = 'InitConds.nc'
  model_ics_data_out_file  = 'Processed_Quince.nc'
  latitude                 = 144
  Regular_vert_grid        = .TRUE.
  gravity_wave_switch      = .FALSE.
  f                        = 1.0E-4
  A                        = 0.02
  B                        = 5.0E-3
  C                        = 1.0E5
  BoundSpread              = 100.
  Tracer_level             = 20
! Run the forward model
! ------------------------------
  run_toy_model            = .FALSE.
  datadirMODEL             = '../Tests'
  model_ics_data_read_file = 'Processed)Quince.nc'
  model_output_file        = 'ModelOutput_Quince.nc'
  diagnostics_file         = 'Diagnostics_Quince.dat'
  dt                       = 0.1
  runlength                = 600.0
  ndumps                   = 10
  convection_switch        = .FALSE.
  pressure_pert            = .FALSE.
  press_source_i           = 180
  press_source_k           = 30
  x_scale                  = 80
  z_scale                  = 3
  press_amp                = 0.01
  Adv_tracer               = .TRUE.
! Linear analysis
! ------------------------------
  do_linear_analysis       = .TRUE.
  wavespeed_experiment     = 'TestExp'
/
