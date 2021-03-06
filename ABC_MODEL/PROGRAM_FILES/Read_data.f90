!==========================================================================
 SUBROUTINE Read_2dmodel_state (  filename, state, Dims,t, diags )
 
 ! To read a field of 2d toy model data
 ! t is the time to read from
 ! diags to read diagnostic data, tracer, hydro, ...
 !       diags data not available for old ensembles
 !

 USE DefConsTypes

 IMPLICIT NONE

 !NetCDF library (file format used to read/write data)
 !----------------------------------------------------
 INCLUDE '/opt/local/include/netcdf.inc'

 !Declare parameters
 !------------------
 TYPE(model_vars_type),  INTENT(INOUT)   :: state
 TYPE(Dimensions_type),  INTENT(INOUT)   :: Dims
 INTEGER,                INTENT(IN)      :: t, diags
 CHARACTER (LEN=*)                       :: filename

 !Declare local variables
 !-----------------------
 INTEGER         :: ncid, ierr
 INTEGER         :: dimidLongs_u, dimidLongs_v, dimidHalf_levs, dimidFull_levs
 INTEGER         :: varidLongs_u, varidLongs_v, varidHalf_levs, varidFull_levs
 INTEGER         :: varid_u, varid_v, varid_w, varid_rhop, varid_bp, varid_rho0
 INTEGER         :: varid_rho, varid_tracer, varid_geost, varid_hydro, varid_energy
 INTEGER         :: startA(1), countA(1), startB(3), countB(3),z
 INTEGER         :: ierr1, ierr2, ierr3, ierr4, ierr5, ierr6, ierr7, ierr8, ierr9, ierr10, ierr11
 REAL (ZREAL8)   :: temp(360), tempvert(60)	

 !PRINT*,'read field called'

 !Open the netCDF file
 !---------------------
 ierr = NF_OPEN(filename, NF_NOWRITE, ncid)
 IF ( ierr .NE. 0 ) THEN
   PRINT*, ' *** Error opening file ***'
   PRINT*, ierr, NF_STRERROR(ierr)
   PRINT*, 'FILE :: ', filename
   STOP
 ENDIF
 
 !Get the dimension ids
 !---------------------
 ierr = NF_INQ_DIMID(ncid, 'longs_u', dimidLongs_u)
 ierr1 = ierr
 ierr = NF_INQ_DIMID(ncid, 'longs_v', dimidLongs_v)
 ierr2 = ierr
 ierr = NF_INQ_DIMID(ncid, 'half_level', dimidHalf_levs)
 ierr3 = ierr
 ierr = NF_INQ_DIMID(ncid, 'full_level', dimidFull_levs)
 ierr4 = ierr

 IF ( (ierr1 .NE. 0) .OR. (ierr2 .NE. 0) .OR. (ierr3 .NE. 0) .OR. &
      (ierr4 .NE. 0) ) THEN
   PRINT*, '***Error getting dimension ids ***'
   PRINT*,'ierr1', ierr1, NF_STRERROR(ierr1)
   PRINT*,'ierr2', ierr2, NF_STRERROR(ierr2)
   PRINT*,'ierr3', ierr3, NF_STRERROR(ierr3)
   PRINT*,'ierr4', ierr4, NF_STRERROR(ierr4)
   STOP
 !ELSE
 !  PRINT*, ' Dimension ids ok'
 ENDIF

 ! Get the variable ids, for dimensions
 !-------------------------------------
 ierr = NF_INQ_VARID(ncid, 'longs_u', varidLongs_u)
 ierr1 = ierr
 ierr = NF_INQ_VARID(ncid, 'longs_v', varidLongs_v)
 ierr2 = ierr
 ierr = NF_INQ_VARID(ncid, 'half_level', varidHalf_levs)
 ierr3 = ierr 
 ierr = NF_INQ_VARID(ncid, 'full_level', varidFull_levs) 
 ierr4 = ierr



 IF ( (ierr1 .NE. 0) .OR. (ierr2 .NE. 0) .OR. (ierr3 .NE. 0) .OR.  &
      (ierr4 .NE. 0) ) THEN 
   PRINT*, '***Error getting variable dimension ids ***'
   PRINT*,'ierr1', ierr1, NF_STRERROR(ierr1)
   PRINT*,'ierr2', ierr2, NF_STRERROR(ierr2)
   PRINT*,'ierr3', ierr3, NF_STRERROR(ierr3)
   PRINT*,'ierr4', ierr4, NF_STRERROR(ierr4)
   STOP
 !ELSE
 !  PRINT*, ' Variable dimension ids ok'
 ENDIF


 !Get the main variable ids
 !-------------------------
 ierr = NF_INQ_VARID(ncid, 'u', varid_u)
 ierr1 = ierr
 ierr = NF_INQ_VARID(ncid, 'v', varid_v)
 ierr2 = ierr
 ierr = NF_INQ_VARID(ncid, 'w', varid_w)
 ierr3 = ierr
 ierr = NF_INQ_VARID(ncid, 'rho_prime', varid_rhop)
 ierr4 = ierr
 ierr = NF_INQ_VARID(ncid, 'b_prime', varid_bp)
 ierr5 = ierr
 ierr = NF_INQ_VARID(ncid, 'rho0', varid_rho0)
 ierr6 = ierr
 IF (diags .EQ. 1) THEN
   ierr = NF_INQ_VARID(ncid, 'rho', varid_rho)
   ierr7 = ierr
   ierr = NF_INQ_VARID(ncid, 'tracer', varid_tracer)
   ierr8 = ierr
   ierr = NF_INQ_VARID(ncid, 'geost', varid_geost)
   ierr9 = ierr
   ierr = NF_INQ_VARID(ncid, 'hydro', varid_hydro)
   ierr10 = ierr
   ierr = NF_INQ_VARID(ncid, 'energy', varid_energy)
   ierr11 = ierr
 END IF 

 IF ( (ierr1 .NE. 0) .OR. (ierr2 .NE. 0) .OR. (ierr3 .NE. 0) .OR. (ierr4 .NE. 0) .OR. &
      (ierr5 .NE. 0) .OR. (ierr6 .NE. 0) .OR. (ierr7 .NE. 0) .OR. (ierr8 .NE. 0) .OR. &
      (ierr9 .NE. 0) .OR. (ierr10 .NE. 0) .OR. (ierr11 .NE. 0)  ) THEN
   PRINT*, '***Error getting variable ids ***'
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
 ELSE
 !  PRINT*, ' Variable ids ok'
 ENDIF


 !Get the dimension data from the file
 !------------------------------------
 startA(1) = 1
 countA(1) = nlongs
 ierr = NF_GET_VARA_DOUBLE (ncid, varidLongs_u, startA, countA, Dims % longs_u(1:nlongs))
 ierr1 = ierr
 ierr = NF_GET_VARA_DOUBLE (ncid, varidLongs_v, startA, countA, Dims % longs_v(1:nlongs))
 ierr2 = ierr
 
 startA(1) = 1
 countA(1) = nlevs
 ierr = NF_GET_VARA_DOUBLE (ncid, varidHalf_levs, startA, countA, Dims % half_levs(1:nlevs))
 ierr3 = ierr
 
 startA(1) = 1
 countA(1) = nlevs+1
 ierr = NF_GET_VARA_DOUBLE (ncid, varidFull_levs, startA, countA, Dims % full_levs(0:nlevs))
 ierr4 = ierr
 Dims % half_levs(0) = - Dims % half_levs(1)
 Dims % half_levs(nlevs+1) = 2*Dims % half_levs(nlevs) - Dims % half_levs(nlevs - 1)
 Dims % full_levs(nlevs+1) = 2*Dims % full_levs(nlevs) - Dims % full_levs(nlevs - 1)
 
 IF ( (ierr1 .NE. 0) .OR. (ierr2 .NE. 0) .OR. (ierr3 .NE. 0) .OR. & 
      (ierr4 .NE. 0) ) THEN
   PRINT*, '*** Error getting dimension data ***'
   PRINT*,'ierr1', ierr1, NF_STRERROR(ierr1)
   PRINT*,'ierr2', ierr2, NF_STRERROR(ierr2)
   PRINT*,'ierr3', ierr3, NF_STRERROR(ierr3)
   PRINT*,'ierr4', ierr4, NF_STRERROR(ierr4)
   STOP
 !ELSE
 !  PRINT*, ' Dimension data ok'
 ENDIF


 !Get the main data from the file
 !-------------------------------
 startB(1) = 1
 countB(1) = nlongs		!longs
 startB(2) = 1
 countB(2) = 1	    	!levs
 startB(3) = t
 countB(3) = 1	    	!time

 ! Read u
 !--------
  DO z=1, nlevs 
   startB(2)=z
   ierr = NF_GET_VARA_DOUBLE (ncid, varid_u, startB, countB,  temp)
   state % u(1:nlongs,z) = temp(1:nlongs)
  ENDDO  
 ierr1 = ierr

 ! Read v
 !--------
 DO z=1, nlevs 
  startB(2)=z
  ierr = NF_GET_VARA_DOUBLE (ncid, varid_v, startB, countB, temp)
  state % v(1:nlongs, z) = temp(1:nlongs)
 END DO
 ierr2 = ierr

 ! Read w
 !--------
 DO z=1, nlevs 
  startB(2)=z
  ierr = NF_GET_VARA_DOUBLE (ncid, varid_w, startB, countB, temp)
  state % w(1:nlongs, z) = temp(1:nlongs) 
 ENDDO
 ierr3 = ierr

 ! Read rhop
 !----------
 DO z=1, nlevs
   startB(2)=z
   ierr = NF_GET_VARA_DOUBLE (ncid, varid_rhop, startB, countB, temp)     	
   state % r(1:nlongs, z) = temp(1:nlongs)
 ENDDO
 ierr4 = ierr

 ! Read bp
 !---------
 DO z=1, nlevs
   startB(2) = z
   ierr = NF_GET_VARA_DOUBLE (ncid, varid_bp, startB, countB, temp)
   state % b(1:nlongs, z) = temp(1:nlongs)
 ENDDO
 ierr5 = ierr

 IF (diags .EQ. 1) THEN
  
   ! Read rho
   !---------
   DO z=1, nlevs
     startB(2) = z
     ierr = NF_GET_VARA_DOUBLE (ncid, varid_rho, startB, countB, temp)
     state % rho (1:nlongs,z) = temp(1:nlongs)
   ENDDO
   ierr6 = ierr
 
   ! Read tracer
   !---------
   DO z=1, nlevs
     startB(2) = z
     ierr = NF_GET_VARA_DOUBLE (ncid, varid_tracer, startB, countB, temp)
     state % tracer(1:nlongs, z) = temp(1:nlongs)
   ENDDO
   ierr7 = ierr

   ! Read geostrohpic imbalance
   !-----------------------------
   DO z=1, nlevs
     startB(2) = z
     ierr = NF_GET_VARA_DOUBLE (ncid, varid_geost, startB, countB, temp)
     state % geost_imbal(1:nlongs, z) = temp(1:nlongs)
   ENDDO
   ierr8 = ierr

   ! Read hydrostatic imbalance
   !-----------------------------
   DO z=1, nlevs
     startB(2) = z
     ierr = NF_GET_VARA_DOUBLE (ncid, varid_hydro, startB, countB, temp)
     state % hydro_imbal(1:nlongs, z) = temp(1:nlongs)
   ENDDO
   ierr9 = ierr

   ! Read energy
   !--------------
   startB(1) = 1
   countB(1) = 4
   startB(2) = t
   countB(2) = 1
   ierr = NF_GET_VARA_DOUBLE (ncid, varid_energy, startB, countB, state % energy(1:4))
   ierr10 = ierr
 END IF
 
 ! Read rho0
 !----------
 startA(1) = 1
 countA(1) = nlevs
 ierr = NF_GET_VARA_DOUBLE (ncid, varid_rho0, startA, countA, state % rho0(1:nlevs))     	
 ierr11 = ierr

 

 IF ( (ierr1 .NE. 0) .OR. (ierr2 .NE. 0) .OR. (ierr3 .NE. 0) .OR. (ierr4 .NE. 0) .OR. &
      (ierr5 .NE. 0) .OR. (ierr6 .NE. 0) .OR. (ierr7 .NE. 0) .OR. (ierr8 .NE. 0) .OR. &
      (ierr9 .NE. 0) .OR. (ierr10 .NE. 0) .OR. (ierr11 .NE. 0)  ) THEN
   PRINT*, '*** Error getting main variable data ***'
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
 !  PRINT*, ' Main data ok'
 ENDIF

 !Close the netCDF file
 ierr = NF_CLOSE(ncid)
 IF ( ierr .NE. 0 ) THEN
    PRINT*, '***ERROR closing file***'
    STOP
 ENDIF

 END SUBROUTINE Read_2dmodel_state
!====================================================================================================
