!================================================================================
 SUBROUTINE Write_state_2d (filename, state, Dims, ntimes, t, wts)
 
 !********************************************************
 !* Subroutine to write a 2d field of model_vars_type    *
 !*                                                      *
 !* ntimes is the total number of output times for       *
 !* the file pass in plus 1 for initial conditions       *
 !* t is the time of output                              *
 !* wts is the number of timesteps between               * 
 !*      output times                                    *
 !*                                                      *
 !* R. Petrie                                            *
 !* Version 2                                            *
 !* 10/6/2011                                            *
 !********************************************************
 
 USE DefConsTypes
 IMPLICIT NONE

 ! NetCDF library (file format used to read/write data)
 !----------------------------------------------------
 INCLUDE '/opt/local/include/netcdf.inc'

 !Declare parameters
 !------------------
 TYPE(model_vars_type), INTENT(INOUT)   :: state
 TYPE(Dimensions_type), INTENT(INOUT)   :: Dims
 CHARACTER (LEN=*)                      :: filename
 INTEGER                                :: ntimes, t, wts
 
 !Declare local variables
 !------------------------
 INTEGER, ALLOCATABLE   :: times(:)
 INTEGER                :: ncid, ierr
 INTEGER                :: dimidLongs_u, varidLongs_u
 INTEGER                :: dimidLongs_v, varidLongs_v
 INTEGER                :: dimidHalf_levs, varidHalf_levs
 INTEGER                :: dimidFull_levs, varidFull_levs
 INTEGER                :: dimidFull_levs_1, varidFull_levs_1
 INTEGER                :: dimid_time, varid_time
 INTEGER                :: dimidEnergy, varidEnergydim
 INTEGER                :: Energy_dims(4), i
 INTEGER                :: varid_u, varid_v, varid_w,  varid_b
 INTEGER                :: varid_r, varid_rho0, varid_rho
 INTEGER                :: varid_tracer, varid_hydro, varid_geost, varid_energy
 INTEGER                :: dd(3), startA(1), countA(1), startB(3), countB(3), wlongs, wlevs
 INTEGER                :: ierr1, ierr2, ierr3, ierr4, ierr5, ierr6, ierr7, ierr8, ierr9, ierr10, ierr11

 !*****************************************************************************************
 ! PRINT*, 'Write 2d data' 
 !*****************************************************************************************
 
 ! Allocation of times array
 !----------------------------
 
  
! PRINT*, 'ntimes', ntimes
! PRINT*, 't', t
 !PRINT*, 'Energy'
 !PRINT*, state % Energy(1), state % Energy(2),state % Energy(3),state % Energy(4)

 IF (t == 0) THEN
  
   IF (ntimes .EQ. 1) THEN
     ALLOCATE (times(1))  ! output times in seconds
     times(1) = 0
   ELSE
     ALLOCATE (times(0:ntimes-1))  ! output times in seconds
     DO i = 0, ntimes-1
       times(i) = i * wts * dt
     END DO
   END IF
 
   ! Dimension array for energy
   DO i = 1, 4
     Energy_dims(i) = i
   END DO
  
   ! At initial time create a netCDF file
   !-------------------------------------
   ierr = NF_CREATE(filename, NF_CLOBBER, ncid)
   IF ( ierr .NE. 0 ) THEN
      PRINT*, ' *** Error creating file ***'
      PRINT*, filename
      PRINT*, ierr, NF_STRERROR(ierr)
      STOP
   !ELSE
   !   PRINT*, 'FILE CREATED'
   ENDIF
	
   !Define the dimensions
   !---------------------
   ierr = NF_DEF_DIM(ncid, 'longs_u', nlongs, dimidLongs_u)
   ierr1 = ierr
   ierr = NF_DEF_DIM(ncid, 'longs_v', nlongs, dimidLongs_v)
   ierr2 = ierr
   ierr = NF_DEF_DIM(ncid, 'full_level', nlevs+1, dimidFull_levs)
   ierr3 = ierr
   ierr = NF_DEF_DIM(ncid, 'full_level_1', nlevs, dimidFull_levs_1)
   ierr4 = ierr
   ierr = NF_DEF_DIM(ncid, 'half_level', nlevs, dimidHalf_levs)
   ierr5 = ierr
   ierr = NF_DEF_DIM(ncid, 'time', ntimes, dimid_time)
   ierr6 = ierr
   ierr = NF_DEF_DIM(ncid, 'energydim',4, dimidEnergy)
   ierr7 = ierr

   IF ( (ierr1 .NE. 0) .OR. (ierr2 .NE. 0) .OR. (ierr3 .NE. 0) .OR. (ierr4 .NE. 0) .OR. &
        (ierr5 .NE. 0) .OR. (ierr6 .NE. 0) .OR. (ierr7 .NE. 0)) THEN
      PRINT*, '***Error defining dimension ids ***'
      PRINT*,'ierr1', ierr1, NF_STRERROR(ierr1)
      PRINT*,'ierr2', ierr2, NF_STRERROR(ierr2)
      PRINT*,'ierr3', ierr3, NF_STRERROR(ierr3)
      PRINT*,'ierr4', ierr4, NF_STRERROR(ierr4)
      PRINT*,'ierr5', ierr5, NF_STRERROR(ierr5)
      PRINT*,'ierr6', ierr6, NF_STRERROR(ierr6)
      PRINT*,'ierr7', ierr7, NF_STRERROR(ierr7)    
      STOP
   !ELSE
   !   PRINT*, 'Dimension ids defined'
   ENDIF

   !Define the variables (include variables giving the dim. values)
   !---------------------------------------------------------------
 
   ! Dimension variables
 
   dd(1) = dimidLongs_u
   ierr  = NF_DEF_VAR(ncid, 'longs_u', NF_DOUBLE, 1, dd, varidLongs_u)
   ierr1 = ierr

   dd(1) = dimidLongs_v
   ierr  = NF_DEF_VAR(ncid, 'longs_v', NF_DOUBLE, 1, dd, varidLongs_v)
   ierr2 = ierr

   dd(1) = dimidFull_levs
   ierr  = NF_DEF_VAR(ncid, 'full_level', NF_DOUBLE, 1, dd, varidFull_levs)
   ierr3 = ierr
 
   dd(1) = dimidFull_levs_1
   ierr  = NF_DEF_VAR(ncid, 'full_level_1', NF_DOUBLE, 1, dd, varidFull_levs_1)
   ierr4 = ierr
 
   dd(1) = dimidHalf_levs
   ierr  = NF_DEF_VAR(ncid, 'half_level', NF_DOUBLE, 1, dd, varidHalf_levs)
   ierr5 = ierr

   dd(1) = dimid_time
   ierr  = NF_DEF_VAR(ncid, 'time', NF_DOUBLE, 1, dd, varid_time)
   ierr6 = ierr
 
   dd(1) = dimidEnergy
   ierr  = NF_DEF_VAR(ncid, 'energydim', NF_DOUBLE, 1, dd, varidEnergydim)
   ierr7 = ierr

   IF ( (ierr1 .NE. 0) .OR. (ierr2 .NE. 0) .OR. (ierr3 .NE. 0) .OR. (ierr4 .NE. 0) .OR. &
        (ierr5 .NE. 0) .OR. (ierr6 .NE. 0).OR. (ierr7 .NE. 0)) THEN
      PRINT*, '***Error defining dimension variable ids ***'
      PRINT*,'ierr1', ierr1, NF_STRERROR(ierr1)
      PRINT*,'ierr2', ierr2, NF_STRERROR(ierr2)
      PRINT*,'ierr3', ierr3, NF_STRERROR(ierr3)
      PRINT*,'ierr4', ierr4, NF_STRERROR(ierr4)
      PRINT*,'ierr5', ierr5, NF_STRERROR(ierr5)
      PRINT*,'ierr6', ierr6, NF_STRERROR(ierr6)
      PRINT*,'ierr7', ierr7, NF_STRERROR(ierr7)
      STOP
   !ELSE
   !   PRINT*, 'Dimension variable ids defined'
   ENDIF

   ! Main variables

   dd(1) = dimidLongs_u
   dd(2) = dimidHalf_levs
   dd(3) = dimid_time
   ierr  = NF_DEF_VAR(ncid, 'u', NF_DOUBLE, 3, dd, varid_u)
   ierr1 = ierr
	
   dd(1) = dimidLongs_v
   dd(2) = dimidHalf_levs
   dd(3) = dimid_time
   ierr  = NF_DEF_VAR(ncid, 'v', NF_DOUBLE, 3, dd, varid_v)
   ierr2 = ierr
	 
   dd(1) = dimidLongs_v
   dd(2) = dimidFull_levs_1
   dd(3) = dimid_time
   ierr  = NF_DEF_VAR(ncid, 'w', NF_DOUBLE, 3, dd, varid_w)
   ierr3 = ierr
	
   dd(1) = dimidLongs_v
   dd(2) = dimidHalf_levs
   dd(3) = dimid_time
   ierr  = NF_DEF_VAR(ncid, 'rho_prime', NF_DOUBLE, 3, dd, varid_r)
   ierr4 = ierr

   dd(1) = dimidLongs_v
   dd(2) = dimidHalf_levs
   dd(3) = dimid_time
   ierr  = NF_DEF_VAR(ncid, 'rho', NF_DOUBLE, 3, dd, varid_rho)
   ierr5 = ierr

   dd(1) = dimidLongs_v
   dd(2) = dimidFull_levs_1
   dd(3) = dimid_time
   ierr  = NF_DEF_VAR(ncid, 'b_prime', NF_DOUBLE, 3, dd, varid_b)
   ierr6 = ierr

   dd(1) = dimidLongs_v
   dd(2) = dimidHalf_levs
   dd(3) = dimid_time
   ierr  = NF_DEF_VAR(ncid, 'tracer', NF_DOUBLE, 3, dd, varid_tracer)
   ierr7 = ierr

   dd(1) = dimidLongs_v
   dd(2) = dimidHalf_levs
   dd(3) = dimid_time
   ierr  = NF_DEF_VAR(ncid, 'geost', NF_DOUBLE, 3, dd, varid_geost)
   ierr8 = ierr

   dd(1) = dimidLongs_v
   dd(2) = dimidFull_levs_1
   dd(3) = dimid_time
   ierr  = NF_DEF_VAR(ncid, 'hydro', NF_DOUBLE, 3, dd, varid_hydro)
   ierr9 = ierr

   dd(1) = dimidEnergy
   dd(2) = dimid_time
   ierr  = NF_DEF_VAR(ncid, 'energy', NF_DOUBLE, 2, dd, varid_energy)
   ierr10 = ierr

   dd(1) = dimidHalf_levs
   ierr  = NF_DEF_VAR(ncid, 'rho0', NF_DOUBLE, 1, dd, varid_rho0)
   ierr11 = ierr
 
   IF ( (ierr1 .NE. 0) .OR. (ierr2 .NE. 0) .OR. (ierr3 .NE. 0) .OR. (ierr4 .NE. 0) .OR. &
        (ierr5 .NE. 0) .OR. (ierr6 .NE. 0) .OR. (ierr7 .NE. 0) .OR. (ierr8 .NE. 0) .OR. &
        (ierr9 .NE. 0) .OR. (ierr10 .NE. 0).OR. (ierr11 .NE. 0)  ) THEN
      PRINT*, '***Error defining main variable ids ***'
      PRINT*,'ierr1', ierr1, NF_STRERROR(ierr1)
      PRINT*,'ierr2', ierr2, NF_STRERROR(ierr2)
      PRINT*,'ierr3', ierr3, NF_STRERROR(ierr3)
      PRINT*,'ierr4', ierr4, NF_STRERROR(ierr4)
      PRINT*,'ierr5', ierr5, NF_STRERROR(ierr5)
      PRINT*,'ierr6', ierr6, NF_STRERROR(ierr6)
      PRINT*,'ierr7', ierr7, NF_STRERROR(ierr7)
      PRINT*,'ierr8', ierr8, NF_STRERROR(ierr8)
      PRINT*,'ierr9', ierr9, NF_STRERROR(ierr9)
      PRINT*,'ierr10', ierr10, NF_STRERROR(ierr10)
      PRINT*,'ierr11', ierr11, NF_STRERROR(ierr11)
      STOP
   !ELSE
   !   PRINT*, 'Main variable ids defined'
   ENDIF

   !Change mode of netCDF operation
   !-------------------------------
   ierr = NF_ENDDEF(ncid)

   IF ( ierr .NE. 0 ) THEN
     PRINT*, ' *** Error changing mode of netCDF operation ***'
     PRINT*,'ierr', ierr, NF_STRERROR(ierr)
     STOP
   !ELSE
   !   PRINT*, 'Mode Changed'
   END IF

   !Output the values of the dimension variables
   !--------------------------------------------
   startA(1) = 1
   countA(1) = nlongs
 
   !PRINT*, 'DIMS DATA'
   ierr = NF_PUT_VARA_DOUBLE(ncid, varidLongs_u, startA, countA, Dims % longs_u(1:nlongs))
   ierr1 = ierr
   !PRINT*, '1'
 
   ierr = NF_PUT_VARA_DOUBLE(ncid, varidLongs_v, startA, countA, Dims % longs_v(1:nlongs))
   ierr2 = ierr
   !PRINT*, '2'
 
   countA(1) = nlevs 
   ierr = NF_PUT_VARA_DOUBLE(ncid, varidHalf_levs, startA, countA, Dims % half_levs(1:nlevs))
   ierr3 = ierr
   !PRINT*, '3'  
 
   ierr = NF_PUT_VARA_DOUBLE(ncid, varidFull_levs_1, startA, countA, Dims % full_levs(1:nlevs))
   ierr4 = ierr
   !PRINT*, '4'    
 
   countA(1) = nlevs +1  
   ierr = NF_PUT_VARA_DOUBLE(ncid, varidFull_levs, startA, countA, Dims % full_levs(0:nlevs))
   ierr6 = ierr
   !PRINT*, '5'  
 
   IF (ntimes .EQ. 1) THEN
     countA(1) = 1
     ierr = NF_PUT_VARA_INT(ncid, varid_time, startA, countA, times(1) )
     ierr7 = ierr
   ELSE
     countA(1) = ntimes
     ierr = NF_PUT_VARA_INT(ncid, varid_time, startA, countA, times(0:ntimes-1) )
     ierr7 = ierr
   END IF

   countA(1) = 4
   ierr = NF_PUT_VARA_INT(ncid, varidEnergydim, startA, countA, Energy_dims(1:4) )
   ierr8 = ierr
   !PRINT*, '6'  
  
   ! Output 1d  main variables
   countA(1) = nlevs 
   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_rho0, startA, countA, state % rho0(1:nlevs))
   ierr5 = ierr
   !PRINT*, '7'    

   
   IF ( (ierr1 .NE. 0) .OR. (ierr2 .NE. 0) .OR. (ierr3 .NE. 0) .OR. (ierr4 .NE. 0) .OR.  &
        (ierr5 .NE. 0) .OR. (ierr6 .NE. 0) .OR. (ierr7 .NE. 0) .OR. (ierr8 .NE. 0)) THEN
      PRINT*, '***Error writing dimension data ***'
      PRINT*,'ierr1', ierr1, NF_STRERROR(ierr1)
      PRINT*,'ierr2', ierr2, NF_STRERROR(ierr2)
      PRINT*,'ierr3', ierr3, NF_STRERROR(ierr3)
      PRINT*,'ierr4', ierr4, NF_STRERROR(ierr4)
      PRINT*,'ierr5', ierr5, NF_STRERROR(ierr5)
      PRINT*,'ierr6', ierr6, NF_STRERROR(ierr6)
      PRINT*,'ierr7', ierr7, NF_STRERROR(ierr7)
      PRINT*,'ierr8', ierr8, NF_STRERROR(ierr8)
    STOP
  ! ELSE
  !    PRINT*, 'Dimension data written'
   ENDIF
	

	
   ! Output the initial values of the main data
   !--------------------------------------------
   startB(1) = 1
   countB(1) = nlongs
   startB(2) = 1
   countB(2) = nlevs
   startB(3) = t+1
   countB(3) = 1
	
   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_u, startB, countB, state % u(1:nlongs, 1:nlevs))
   ierr1 = ierr
 
   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_v, startB, countB, state % v(1:nlongs, 1:nlevs))  
   ierr2 = ierr
 
   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_r, startB, countB, state % r (1:nlongs, 1:nlevs))
   ierr3 = ierr
 
   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_rho, startB, countB, state % rho (1:nlongs, 1:nlevs))
   ierr4 = ierr
 
   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_b, startB, countB, state % b(1:nlongs, 1:nlevs))
   ierr5 = ierr
 
   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_tracer, startB, countB, state % tracer(1:nlongs, 1:nlevs))
   ierr6 = ierr
 
   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_hydro, startB, countB, state % hydro_imbal(1:nlongs, 1:nlevs))
   ierr7 = ierr
 
   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_geost, startB, countB, state % geost_imbal(1:nlongs, 1:nlevs))
   ierr8 = ierr

   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_w, startB, countB, state % w(1:nlongs,1:nlevs))
   ierr9 = ierr

   startB(1) = 1
   countB(1) = 4
   startB(2) = t+1
   countB(2) = 1

   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_energy, startB, countB, state % energy(1:4))
   ierr10= ierr

   IF ( (ierr1 .NE. 0) .OR. (ierr2 .NE. 0) .OR. (ierr3 .NE. 0) .OR. (ierr4 .NE. 0) .OR.  &
        (ierr5 .NE. 0) .OR. (ierr6 .NE. 0) .OR. (ierr7 .NE. 0) .OR. (ierr8 .NE. 0) .OR.  &
        (ierr9 .NE. 0).OR. (ierr10 .NE. 0)) THEN
      PRINT*, '***Error writing main variable data ***'
      PRINT*,'ierr1', ierr1, NF_STRERROR(ierr1)
      PRINT*,'ierr2', ierr2, NF_STRERROR(ierr2)
      PRINT*,'ierr3', ierr3, NF_STRERROR(ierr3)  
      PRINT*,'ierr4', ierr4, NF_STRERROR(ierr4)
      PRINT*,'ierr5', ierr5, NF_STRERROR(ierr5)
      PRINT*,'ierr6', ierr6, NF_STRERROR(ierr6)
      PRINT*,'ierr7', ierr7, NF_STRERROR(ierr7)
      PRINT*,'ierr8', ierr8, NF_STRERROR(ierr8)
      PRINT*,'ierr9', ierr9, NF_STRERROR(ierr9)
      PRINT*,'ierr10', ierr10, NF_STRERROR(ierr10)
      STOP
   !ELSE
   !   PRINT*, 'Main data written'
   ENDIF
 
   DEALLOCATE (times) 
 
 ELSE  ! If time not equal to 0
 

 !  PRINT*,' Open the existing output file'
   ierr = NF_OPEN(filename, NF_WRITE, ncid) 
     IF ( ierr .NE. 0 ) THEN
       PRINT*, '***ERROR opening file***', filename
       STOP
     ENDIF

   !Output the main data
   !----------------------
   startB(1) = 1
   countB(1) = nlongs
   startB(2) = 1
   startB(3) = t+1
   countB(3) = 1
	
	 countB(2) = nlevs
   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_u, startB, countB, state % u(1:nlongs, 1:nlevs))
   ierr1 = ierr
 
   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_v, startB, countB, state % v(1:nlongs, 1:nlevs))  
   ierr2 = ierr
 
   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_r, startB, countB, state % r (1:nlongs, 1:nlevs))
   ierr3 = ierr
 
   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_rho, startB, countB, state % rho (1:nlongs, 1:nlevs))
   ierr4 = ierr
 
   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_b, startB, countB, state % b(1:nlongs, 1:nlevs))
   ierr5 = ierr
 
   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_tracer, startB, countB, state % tracer(1:nlongs, 1:nlevs))
   ierr6 = ierr
 
   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_hydro, startB, countB, state % hydro_imbal(1:nlongs, 1:nlevs))
   ierr7 = ierr
 
   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_geost, startB, countB, state % geost_imbal(1:nlongs, 1:nlevs))
   ierr8 = ierr

   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_w, startB, countB, state % w(1:nlongs,1:nlevs))
   ierr9 = ierr

   startB(1) = 1
   countB(1) = 4
   startB(2) = t+1
   countB(2) = 1

   ierr = NF_PUT_VARA_DOUBLE(ncid, varid_energy, startB, countB, state % energy(1:4))
   ierr10= ierr

   IF ( (ierr1 .NE. 0) .OR. (ierr2 .NE. 0) .OR. (ierr3 .NE. 0) .OR. (ierr4 .NE. 0) .OR.  &
        (ierr5 .NE. 0) .OR. (ierr6 .NE. 0) .OR. (ierr7 .NE. 0) .OR. (ierr8 .NE. 0) .OR.  &
        (ierr9 .NE. 0).OR. (ierr10 .NE. 0)) THEN
      PRINT*, '***Error writing main variable data ***'
      PRINT*,'ierr1', ierr1, NF_STRERROR(ierr1)
      PRINT*,'ierr2', ierr2, NF_STRERROR(ierr2)
      PRINT*,'ierr3', ierr3, NF_STRERROR(ierr3)  
      PRINT*,'ierr4', ierr4, NF_STRERROR(ierr4)
      PRINT*,'ierr5', ierr5, NF_STRERROR(ierr5)
      PRINT*,'ierr6', ierr6, NF_STRERROR(ierr6)
      PRINT*,'ierr7', ierr7, NF_STRERROR(ierr7)
      PRINT*,'ierr8', ierr8, NF_STRERROR(ierr8)
      PRINT*,'ierr9', ierr9, NF_STRERROR(ierr9)
      PRINT*,'ierr10', ierr10, NF_STRERROR(ierr10)
      STOP
 ! ELSE
 !     PRINT*, 'Main data written'
   ENDIF

 ENDIF 

 !Close-up the file
 !-----------------
 ierr = NF_CLOSE(ncid)
 
 IF ( ierr .NE. 0 ) THEN
   PRINT*, ' *** Error closing netCDF file ***'
   PRINT*,'ierr', ierr, NF_STRERROR(ierr)
   PRINT*,'xconv ', filename, ' &'
   STOP
 ENDIF
 

END SUBROUTINE Write_state_2d
!===================================================================================================
