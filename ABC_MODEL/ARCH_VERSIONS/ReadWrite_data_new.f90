!  File includes

!  SUBROUTINE Read_state_2d
!  SUBROUTINE Write_state_2d


!==========================================================================
SUBROUTINE Read_state_2d (filename, state, Dims, t)

!********************************************************
!* Subroutine to read a field of 2d toy model data      *
!*        of model_vars_type                            *
!*                                                      *
!* t is the read time    t                              *
!*                                                      *
!* R. Petrie, 2.0 10-6-11                               *
!* R. Petrie, 3.0 30-7-13                               *
!*                                                      *
!*                                                      *
!********************************************************


USE DefConsTypes, ONLY :   &
  ZREAL8,                  &
  model_vars_type,         &
  Dimensions_type,         &
  nlongs,                  &
  nlevs

INCLUDE '/opt/graphics/64/include/netcdf-4.0.inc'

IMPLICIT NONE

!NetCDF library (file format used to read/write data)
!----------------------------------------------------
! Ubuntu:
!INCLUDE '/usr/include/netcdf.inc'
! Carrot:
!INCLUDE '/opt/local/include/netcdf.inc'
!INCLUDE '/opt/graphics/64/include/netcdf-4.0.inc'

!Declare parameters
!------------------
TYPE(model_vars_type),  INTENT(INOUT) :: state
TYPE(Dimensions_type),  INTENT(INOUT) :: Dims
INTEGER,                INTENT(IN)    :: t
CHARACTER(LEN=*)                      :: filename

!Declare local variables
!-----------------------
INTEGER         :: ncid, ierr, dd(3)
INTEGER         :: dimidLongs_u, varidLongs_u
INTEGER         :: dimidLongs_v, varidLongs_v
INTEGER         :: dimidHalf_levs, varidHalf_levs
INTEGER         :: dimidFull_levs, varidFull_levs
INTEGER         :: dimid_time, varid_time
INTEGER         :: dimidEnergy, varidEnergy
INTEGER         :: varid_u, varid_v, varid_w
INTEGER         :: varid_b, varid_beff
INTEGER         :: varid_r, varid_rho
INTEGER         :: varid_tracer, varid_hydro, varid_geost
INTEGER         :: varid_ke, varid_be, varid_ee, varid_te
INTEGER         :: startA(1), countA(1), startC(3), countC(3)
INTEGER         :: ierr1, ierr2, ierr3, ierr4, ierr5, ierr6, ierr7
INTEGER         :: ierr8, ierr9, ierr10, ierr11, ierr12, ierr13, ierr14
INTEGER         :: ierr15, ierr16
INTEGER         :: z
REAL(ZREAL8)    :: temp(360), tempvert(60)

!PRINT*,'read field called'

!Open the netCDF file
!---------------------
 CALL check(nf90_open(filename, nf90_nowrite, ncid))

 !Get the dimension data
 !---------------------

 CALL check(nf90_inq_varid(ncid, 'longs_u', dimidLongs_u))
 CALL check(nf90_inq_varid(ncid, 'longs_v', dimidLongs_v))
 CALL check(nf90_inq_varid(ncid, 'half_level', dimidHalf_levs))
 CALL check(nf90_inq_varid(ncid, 'full_level', dimidFull_levs))

 CALL check(nf90_get_var(ncid, dimidLongs_u, Dims % longs_u(1:nlongs)))
 CALL check(nf90_get_var(ncid, dimidLongs_v, Dims % longs_v(1:nlongs)))
 CALL check(nf90_get_var(ncid, dimidHalf_levs, Dims % half_levs(1:nlevs)))
 CALL check(nf90_get_var(ncid, dimidFull_levs, Dims % full_levs(1:nlevs)))

 !Get the Variable data
 !---------------------

 CALL check(nf90_inq_varid(ncid, 'u', varid_u))
 CALL check(nf90_inq_varid(ncid, 'v', varid_v))
 CALL check(nf90_inq_varid(ncid, 'w', varid_w))
 CALL check(nf90_inq_varid(ncid, 'r_prime', varid_r))
 CALL check(nf90_inq_varid(ncid, 'b_prime', varid_b))
 CALL check(nf90_inq_varid(ncid, 'rho', varid_rho))
 CALL check(nf90_inq_varid(ncid, 'b_effective', varid_beff))
 CALL check(nf90_inq_varid(ncid, 'tracer', varid_tracer))
 CALL check(nf90_inq_varid(ncid, 'geo_imbal', varid_geost))
 CALL check(nf90_inq_varid(ncid, 'hydro_imbal', varid_hydro))
 CALL check(nf90_inq_varid(ncid, 'ke', varid_ke))
 CALL check(nf90_inq_varid(ncid, 'be', varid_be))
 CALL check(nf90_inq_varid(ncid, 'ee', varid_ee))
 CALL check(nf90_inq_varid(ncid, 'te', varid_te))

 CALL check(nf90_get_var(ncid, varid_u, state % u(1:nlongs, 1:nlevs) ))
 CALL check(nf90_get_var(ncid, varid_v, state % v(1:nlongs, 1:nlevs)))
 CALL check(nf90_get_var(ncid, varid_w, state % w(1:nlongs, 1:nlevs)))
 CALL check(nf90_get_var(ncid, varid_r, state % r(1:nlongs, 1:nlevs)))
 CALL check(nf90_get_var(ncid, varid_b, state % b(1:nlongs, 1:nlevs)))
 CALL check(nf90_get_var(ncid, varid_rho, state % rho(1:nlongs, 1:nlevs) ))
 CALL check(nf90_get_var(ncid, varid_beff, state % b_ef(1:nlongs, 1:nlevs)))
 CALL check(nf90_get_var(ncid, varid_tracer, state % tracer(1:nlongs, 1:nlevs) ))
 CALL check(nf90_get_var(ncid, varid_geost, state % geost_imbal(1:nlongs, 1:nlevs)))
 CALL check(nf90_get_var(ncid, varid_hydro, state % hydro_imbal(1:nlongs, 1:nlevs)))
 CALL check(nf90_get_var(ncid, varid_ke, state % Kinetic_Energy))
 CALL check(nf90_get_var(ncid, varid_be, state % Buoyant_Energy))
 CALL check(nf90_get_var(ncid, varid_ee, state % Elastic_Energy))
 CALL check(nf90_get_var(ncid, varid_te, state % Total_Energy))


 !Close the netCDF file
 CALL check( nf90_close(ncid))

END SUBROUTINE Read_state_2d
!====================================================================================================

!================================================================================
SUBROUTINE Write_state_2d (filename, state, Dims, ntimes, t, wts)

!********************************************************
!* Subroutine to write a 2d field of model_vars_type    *
!*                                                      *
!* ntimes is the total number of output times           *
!*    should include one extra for inital conds         *
!* t is the time of output                              *
!*                                                      *
!* wts is the number of timesteps between output times  *
!*                                                      *
!*                                                      *
!* R. Petrie, 2.0 10-6-11                               *
!* R. Petrie, 3.0 30-7-13                               *
!*                                                      *
!********************************************************
USE DefConsTypes, ONLY :   &
  ZREAL8,                  &
  model_vars_type,         &
  Dimensions_type,         &
  nlongs,                  &
  nlevs,                   &
  dt
INCLUDE '/opt/graphics/64/include/netcdf-4.0.inc'

IMPLICIT NONE

! NetCDF library (file format used to read/write data)
!----------------------------------------------------
! Ubuntu:
!INCLUDE '/usr/include/netcdf.inc'
! Carrot:
!INCLUDE '/opt/local/include/netcdf.inc'
!INCLUDE '/opt/graphics/64/include/netcdf-4.0.inc'
!Declare parameters
!------------------
TYPE(model_vars_type), INTENT(INOUT)   :: state
TYPE(Dimensions_type), INTENT(INOUT)   :: Dims
CHARACTER(LEN=*)                       :: filename
INTEGER                                :: ntimes, t, wts

!Declare local variables
!------------------------
INTEGER, ALLOCATABLE                   :: times(:)
INTEGER                                :: ncid, ierr, i, ddA(1), ddC(3)
INTEGER                                :: dimidLongs_u, varidLongs_u
INTEGER                                :: dimidLongs_v, varidLongs_v
INTEGER                                :: dimidHalf_levs, varidHalf_levs
INTEGER                                :: dimidFull_levs, varidFull_levs
INTEGER                                :: dimid_time, varid_time
INTEGER                                :: dimidEnergy, varidEnergy
INTEGER, SAVE                          :: varid_u, varid_v, varid_w
INTEGER, SAVE                          :: varid_b, varid_beff
INTEGER, SAVE                          :: varid_r, varid_rho
INTEGER, SAVE                          :: varid_tracer, varid_hydro, varid_geost
INTEGER, SAVE                          :: varid_ke, varid_be, varid_ee, varid_te
INTEGER                                :: startA(1), countA(1), startC(3), countC(3)
INTEGER                                :: ierr1, ierr2, ierr3, ierr4, ierr5, ierr6, ierr7
INTEGER                                :: ierr8, ierr9, ierr10, ierr11, ierr12, ierr13, ierr14
INTEGER                                :: ierr15, ierr16

!*****************************************************************************************
!PRINT*, 'Write 2d data'
!*****************************************************************************************

 ! At initial time of run create a new NetCDF output file
 IF (t .EQ. 0) THEN

  ! Create netCDF file
  !-------------------------------------
  CALL check(nf90_create(filename, nf90_clobber, ncid))

  ! Allocate array for time stamps
  IF (ntimes .EQ. 1) THEN
    ALLOCATE (times(1))  ! output times in seconds
    times(1) = 0
  ELSE
    ALLOCATE (times(0:ntimes-1))  ! output times in seconds
    DO i = 0, ntimes-1
      times(i) = i * wts * dt
    END DO
  END IF

! Define the dimensions.
 CALL check( nf90_def_dim( ncid, 'longs_u', nlongs, dimidLongs_u), 'define, longs_u')
 CALL check( nf90_def_dim( ncid, 'longs_v', nlongs, dimidLongs_v), 'define, longs_v')
 CALL check( nf90_def_dim( ncid, 'full_level', nlevs, dimidFull_levs), 'define, full_level')
 CALL check( nf90_def_dim( ncid, 'half_level', nlevs, dimidHalf_levs), 'define, half_level')
 CALL check( nf90_def_dim( ncid, 'time', ntimes, dimid_time), 'define, time')

 !Define the variables (include variables giving the dim. values)
 !---------------------------------------------------------------
 CALL check(nf90_def_var(ncid, 'u',           NF90_double, (/ dimidLongs_u, dimidHalf_levs, dimid_time /), varid_u), 'define u')
 CALL check(nf90_def_var(ncid, 'v',           NF90_double, (/ dimidLongs_v, dimidHalf_levs, dimid_time /), varid_v), 'define v')
 CALL check(nf90_def_var(ncid, 'w',           NF90_double, (/ dimidLongs_v, dimidFull_levs, dimid_time /), varid_w), 'define w')
 CALL check(nf90_def_var(ncid, 'r_prime',     NF90_double, (/ dimidLongs_v, dimidHalf_levs, dimid_time /), varid_r), 'define r_prime')
 CALL check(nf90_def_var(ncid, 'b_prime',     NF90_double, (/ dimidLongs_v, dimidFull_levs, dimid_time /), varid_b), 'define b_prime')
 CALL check(nf90_def_var(ncid, 'rho',         NF90_double, (/ dimidLongs_v, dimidHalf_levs, dimid_time /), varid_rho), 'define rho')
 CALL check(nf90_def_var(ncid, 'b_effective', NF90_double, (/ dimidLongs_v, dimidFull_levs, dimid_time /), varid_beff), 'define b_effective')
 CALL check(nf90_def_var(ncid, 'tracer',      NF90_double, (/ dimidLongs_v, dimidHalf_levs, dimid_time /), varid_tracer), 'define tracer')
 CALL check(nf90_def_var(ncid, 'geo_imbal',   NF90_double, (/ dimidLongs_v, dimidHalf_levs, dimid_time /), varid_geost), 'define geost_imbal')
 CALL check(nf90_def_var(ncid, 'hydro_imbal', NF90_double, (/ dimidLongs_v, dimidFull_levs, dimid_time /), varid_hydro), 'define hydro_imbal')

 CALL check(nf90_def_var(ncid, 'ke', NF90_double, varid_ke ),'define ke' ) !Scalar
 CALL check(nf90_def_var(ncid, 'be', NF90_double, varid_be ),'define be') !Scalar
 CALL check(nf90_def_var(ncid, 'ee', NF90_double, varid_ee ),'define ee') !Scalar
 CALL check(nf90_def_var(ncid, 'te', NF90_double, varid_te ),'define te') !Scalar

 ! Come out of definition mode.
 !---------------------------------------------------------------
 CALL check( nf90_enddef(ncid) )

 ! Go into put mode.
 !---------------------------------------------------------------
 CALL check(nf90_put_var(ncid, varidLongs_u,   Dims % longs_u(1:nlongs) ), 'dumping, longs_u ')
 CALL check(nf90_put_var(ncid, varidLongs_v,   Dims % longs_v(1:nlongs) ),'dumping, longs_v')
 CALL check(nf90_put_var(ncid, varidHalf_levs, Dims % half_levs(1:nlevs) ),'dumping, half_levs')
 CALL check(nf90_put_var(ncid, varidFull_levs, Dims % full_levs(1:nlevs) ),'dumping, full_levs')
 
 IF (ntimes .EQ. 1) THEN
   CALL check(nf90_put_var(ncid, varid_time, times(1) ), 'dumping, time')
 ELSE
   CALL check(nf90_put_var(ncid, varid_time, times(0:ntimes-1) ),'dumping, time')
 ENDIF

 DEALLOCATE (times)

 ELSE  ! If time not equal to 0

  PRINT*, t
  !PRINT*, 'opening file'
  !Open the existing output file
  CALL check(nf90_open(filename, nf90_clobber, ncid),'opening existing output file')
  
ENDIF

!PRINT*, 'beginning output'

!--------------------------------------------
! Output the values of the main variables
! -------------------------------------------
 CALL check(nf90_put_var(ncid, varid_u,      state % u(1:nlongs, 1:nlevs) ),'dumping, u')
 CALL check(nf90_put_var(ncid, varid_v,      state % v(1:nlongs, 1:nlevs) ),'dumping, v')
 CALL check(nf90_put_var(ncid, varid_w,      state % w(1:nlongs, 1:nlevs) ),'dumping, w')
 CALL check(nf90_put_var(ncid, varid_r,      state % r(1:nlongs, 1:nlevs) ),'dumping, r')
 CALL check(nf90_put_var(ncid, varid_b,      state % b(1:nlongs, 1:nlevs) ),'dumping, b')
 CALL check(nf90_put_var(ncid, varid_rho,    state % rho(1:nlongs, 1:nlevs) ),'dumping, rho')
 CALL check(nf90_put_var(ncid, varid_beff,   state % b_ef(1:nlongs, 1:nlevs) ),'dumping, beff')
 CALL check(nf90_put_var(ncid, varid_tracer, state % tracer(1:nlongs, 1:nlevs) ),'dumping, tracer')
 CALL check(nf90_put_var(ncid, varid_hydro,  state % hydro_imbal(1:nlongs, 1:nlevs) ),'dumping, hydro')
 CALL check(nf90_put_var(ncid, varid_geost,  state % geost_imbal(1:nlongs, 1:nlevs) ),'dumping, geost')
 CALL check(nf90_put_var(ncid, varid_ke,     state % Kinetic_energy ),'dumping, ke')
 CALL check(nf90_put_var(ncid, varid_be,     state % Buoyant_energy ),'dumping, be')
 CALL check(nf90_put_var(ncid, varid_ee,     state % Elastic_energy ),'dumping, ee')
 CALL check(nf90_put_var(ncid, varid_te,     state % Total_energy ),'dumping, te')

 !Close the netCDF file
 CALL check( nf90_close(ncid)'closing file')


END SUBROUTINE Write_state_2d


!===========================================================
  SUBROUTINE check(status, errormessage)
   IMPLICIT NONE
      INCLUDE '/opt/graphics/64/include/netcdf-4.0.inc'
  integer, intent ( in) :: status
    CHARACTER(LEN=*), intent(in) :: errormessage
  
      IF(status /= nf90_noerr) then 
      PRINT*, errormessage
      PRINT*, TRIM(nf90_strerror(status))
    END IF
  END SUBROUTINE check  
!===========================================================

