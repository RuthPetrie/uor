!===================================================================================================
! This file contains all subroutines to process inital data taken from 
! the um and convert it to be consistent with the requirements of
! the toy model. 
!
! In this file are subroutines
! SUBROUTINE Process_um_data (um_data, state, dims, fileout, gravity_wave_switch, dump)
! SUBROUTINE Regularize_grid(init_um_data, dims,regularize)
! SUBROUTINE Read_um_data_2d ( umdata, filename, latitude )
!===================================================================================================
 SUBROUTINE Process_um_data (um_data, state, dims, fileout, gravity_wave_switch, dump)

 !*******************************
 !* Subroutine to process um    * 
 !* data for toy model          * 
 !*                             *
 !*                             *
 !*                             *
 !*                             *
 !* R. Petrie                   *
 !* version 1.0                 *
 !* 6/6/2011                    *
 !******************************* 
 
 USE DefConsTypes
 IMPLICIT NONE

 ! Declare Top level variables
 TYPE(um_data_type),    INTENT(IN)     :: um_data
 TYPE(model_vars_type), INTENT(INOUT)  :: state
 TYPE(dimensions_type), INTENT(IN)     :: dims
 INTEGER,               INTENT(IN)     :: gravity_wave_switch 
 CHARACTER(LEN=*),      INTENT(IN)     :: fileout
 INTEGER,      OPTIONAL,INTENT(IN)     :: dump
 
 ! Declare local variables
 REAL(ZREAL8)                          :: cons(1:nlongs, 1:nlevs)cons, Re2
 REAL(ZREAL8)                          :: rhosum,rhopsumtemp, rhopsum(1:nlevs)
 REAL(ZREAL8)                          :: rhobound(1:nlevs)
 REAL(ZREAL8)                          :: diff(1:nlongs,1:nlevs+1)
 REAL(ZREAL8)                          :: theta_sum, theta_r, theta_z(1:nlevs)
 
 REAL(ZREAL8)                          :: INT_HF
 INTEGER                               :: rescalerho, datadump
 INTEGER                               :: x,z, i,j,k
 INTEGER, ALLOCATABLE                  :: times(:)
 
 
 IF (PRESENT(dump)) THEN
   datadump = dump
 ELSE
   datadump = 1
 END IF
 
 ! Set u
 !-------
 state % u(1:nlongs, 1:nlevs) = um_data % u(1:nlongs, 1:nlevs)
 CALL Boundaries ( state, 1,0,0,0,0,0 )
 
 ! Set v: enforce integral of v dx to be zero on each vertical level 
 !        to satisfy periodic boundary conditions
 !----------------------------------
 state % v(1:nlongs, 1:nlevs) = um_data % v(1:nlongs, 1:nlevs)
 CALL Boundaries ( state, 0,1,0,0,0,0 )

 ! Calculate constant to add to vraw.
 !----------------------------------
 DO z =1, nlevs	
   DO x = 1,nlongs
      cons(x,z) = (-dx/(nlongs * dx)) * (state % v(x-1,z) + state % v(x,z))
   ENDDO
 ENDDO

 ! Add constant to vraw
 !-------------------
 DO z = 1,nlevs	
   DO x = 1, nlongs
      state % v (x,z) = cons(x,z) + state % v(x,z)
   ENDDO
 ENDDO
 CALL Boundaries ( state, 0,1,0,0,0,0 )

 ! Calculate rho0
 !----------------
 DO z = 1, nlevs
   rhosum = 0.0
   DO x = 1,nlongs
      rhosum = rhosum + (um_data % density(x,z)/Re**2)
   ENDDO
   state % rho0(z) = rhosum/nlongs
 ENDDO

 ! Calculate rhop
 !----------------
    
    !Calculate boundary condition for left hand boundary.
    !-----------------------------------------------------
    DO z = 1,nlevs
      rhobound(z) = 0.0001* state % rho0(z)
    ENDDO

    DO z = 1, nlevs
      DO x = 1, nlongs
        state % r(x,z) = (f0/(10*Cz))*(dx)*( state % v(x-1,z) + state % v(x+1,z) ) !+ rhobound(z)
      ENDDO
    ENDDO
    CALL Boundaries ( state, 0,0,0,1,0,0 )

    ! Enforce integral of rhop dx to be zero on each vertical level 
    ! to satisfy periodic boundary conditions
    !---------------------------------------------------------------------
    ! Calculate constant to add to rraw.
    cons(:,:) = 0.0
    DO z =1, nlevs	
      DO x = 1,nlongs
        cons(x,z) = (-dx/(nlongs*dx)) * (state % r(x-1,z) + state % r(x,z))
      ENDDO
    ENDDO

    ! Add cons to vraw
    !---------------
    !DO k = 1,nlevs	
    ! DO i =1, nlongs
    !    state % r (i,k) = cons(i,k) + state % r(i,k)
    ! ENDDO
    !ENDDO

    ! Calculate horizontal integral and print out to check it sums to zero
    !-----------------------------------------------------------------------
    rhopsum(:) = 0
    DO z = 1,nlevs
      rhopsumtemp = 0
      DO x = 1,nlongs
        rhopsumtemp = rhopsumtemp + (dx/(nlongs*dx)) * (state % r(x-1,z) + state % r(x,z))
      ENDDO
      rhopsum(z) = rhopsumtemp/nlongs
    ENDDO
    !PRINT*, 'test rhop', rhopsum(:)
    
    ! Calculate full rho
    !--------------------
    DO z = 1, nlevs
      DO x = 1, nlongs
       state % rho(x,z) = state % r(x,z) + state % rho0(z)
      ENDDO
    ENDDO
    CALL Boundaries ( state, 0,0,0,0,0,1 )

    ! RESCALE state % rho AND state % rhoP   
    !-----------------------
    rescalerho = 1
    IF (rescalerho .EQ. 1) THEN

      ! PRINT*, 'RESCALE state % rho'  
      DO z = 1, nlevs
        DO x = 1, nlongs
          state % rho(x,z) = state % rho(x,z) / state % rho0(z)
          state % r(x,z)   = state % r(x,z) / state % rho0(z)
        ENDDO
        state % rho0(z) = 1.0
      ENDDO  
      CALL Boundaries ( state, 0,0,0,0,0,1 )
      CALL Boundaries ( state, 0,0,0,1,0,0 )
    ENDIF

 ! Calculate bp from the hydrostatic relationship
 !------------------------------------------------
 DO z = 1,nlevs
   DO x = 1, nlongs
      state % b(x,z) = 10 * Cz *                                                  &
                         (                                                        &
                           ( state % r(x,z+1) -  state % r(x,z) )                 &
                           /                                                      &
                           ( Dims % half_levs(z+1) - Dims % half_levs(z) )        &
                         )                                                        
   ENDDO
 ENDDO
 CALL Boundaries ( state, 0,0,0,0,1,0 )

 ! Calculate w 
 !--------------
 !---------------------

 DO z = 1,nlevs
   DO x = 1, nlongs
      diff(x,z) = INT_HF(state % rho(x,z), state % rho(x,z+1), z, Dims)   *       &
                   (                                                              &
                      INT_HF(state % u(x, z), state % u(x,z+1), z, Dims) -        &
                      INT_HF(state % u(x-1, z), state % u(x-1,z+1), z, Dims)      &
                   ) /dx +                                                        &
                   (                                                              &
               0.5 *  (                                                           & 
                      INT_HF(state % u(x,z), state % u(x,z+1), z, Dims) +         &
                      INT_HF(state % u(x-1, z), state % u(x-1,z+1), z, Dims)      &
                      )*                                                          &
                      (                                                           &
                      INT_HF(state % rho(x+1,z), state % rho(x+1,z+1), z, Dims) - &
                      INT_HF(state % rho(x-1,z), state % rho(x-1,z+1), z, Dims)   &
                      ) / dx                                                      &
                   )                                                          
   END DO
 END DO

 !linear interpolation of diff to nlevs + 1
 DO x = 1, nlongs
	diff(x, nlevs+1) = diff(x,nlevs) - diff(x, nlevs-2) + diff(x,nlevs-1)
 ENDDO

!***************************************************************************************************
 ! Calculate w
 DO z = 1,nlevs -1
   DO x = 1, nlongs
      state % w(x,z) = (diff(x,z+1) - diff(x,z)) *                                             &
                 ((Dims % full_levs(z+1) - Dims % full_levs(z))/2)  +                          &
                 ( INT_HF( state % rho(x,z), state % rho(x,z+1), z, Dims) * state % w(x,z) )   &
                 / INT_HF( state % rho(x,z+1), state % rho(x,z+1), z+1, Dims )
  		
   ENDDO
 ENDDO
 
 x = 1
 DO z = 1,nlevs
  state %  w(x,z) = state %  w(x+1,z)
 ENDDO
 
 CALL Boundaries ( state, 0,0,1,0,0,0 )

!***************************************************************************************************
 ! Calculate b_0(z)
 !--------------------
 theta_sum = 0
 theta_r = 273.0

 DO k = 1, nlevs
   DO i = 1, nlongs
    theta_sum = theta_sum + um_data % theta(i,k) 
   END DO
   theta_z(k) = theta_sum / nlongs
   theta_sum = 0
 END DO

 DO k = 1,nlevs
  theta_z(k) = theta_z(k) - theta_r;
 END DO
 
 DO k = 1,nlevs
  b_0(k) = g * theta_z(k) / theta_r;
 END DO
!***************************************************************************************************
 
 ! Modify data at the boundary to satisfy periodic boundary conditions
 CALL Boundary_Discontinuity_Modification (state)

!***************************************************************************************************
 
 IF (gravity_wave_switch .EQ. 1) THEN
   state % u(0:nlongs+1, 0:nlevs+1) = 0.0
 END IF
 
!***************************************************************************************************

 IF ( datadump .EQ. 1 ) THEN
   CALL Write_state_2d (fileout,state, Dims,1,0,0) 

   PRINT*,'-------------------------------------------------------------------------------'
   PRINT*,'    Netcdf initstate file: '
   PRINT*,'    xconv ',fileout, '&'
   PRINT*,'-------------------------------------------------------------------------------'!
 END IF
 
!***************************************************************************************************
 
 
 END SUBROUTINE Process_um_data 
!===================================================================================================


!===================================================================================================
 SUBROUTINE Regularize_grid(init_um_data, dims,regularize)

 !*******************************
 !* Subroutine to regularize    * 
 !* vertical levs             * 
 !*                             *
 !* Set regularize = 1 to use a *
 !* regular vertical grid       *
 !*                             *
 !* R. Petrie                   *
 !* version 1.0                 *
 !* 6/6/2011                    *
 !******************************* 
 
 USE DefConsTypes
 IMPLICIT NONE

 ! Declare Top level variables
 TYPE(um_data_type),    INTENT(IN)     :: init_um_data
 TYPE(dimensions_type), INTENT(INOUT)  :: dims
 INTEGER,               INTENT(IN)     :: regularize 
 
 ! Declare local variables
 REAL(ZREAL8)                          :: level_reg_fact, half_lev_fact, halfdx
 INTEGER                               :: i 
 
 ! Set vertical dimensions
 IF (regularize .EQ. 1) THEN
   !Use regular grid
   level_reg_fact = init_um_data % full_levs(nlevs) / nlevs
   half_lev_fact = level_reg_fact * 0.5
   halfdx = dx * 0.5
   DO i = 0, nlevs
      dims % full_levs(i) = i * level_reg_fact
   ENDDO

   DO i = 1, nlevs+1
      Dims % half_levs(i) = half_lev_fact + ((i-1) * level_reg_fact) 
   ENDDO
   Dims % half_levs(0) = -1.0 * Dims % half_levs(1)
 
 ELSE
   !Use charney - phillips grid
   Dims % full_levs(0:nlevs) = init_um_data % full_levs(0:nlevs)
   Dims % half_levs(1:nlevs+1) = init_um_data % half_levs(1:nlevs+1)
   Dims % half_levs(0) = -1.0 * Dims % half_levs(1)
 END IF 

 ! Set horizontal dimension
 DO i = 0,nlongs+1 
   Dims % longs_v(i) = i * dx
 ENDDO
   
 DO i = 0,nlongs+1 
   Dims % longs_u(i) = i * dx + halfdx
 ENDDO
   

 END SUBROUTINE Regularize_grid
 !===================================================================================================
 SUBROUTINE Read_um_data_2d ( umdata, filename, latitude )
 
 !**********************************
 !* Subroutine to read a latitude  *
 !* slice of um netcdf output into * 
 !* a compound data type um_data   *
 !*                                *
 !* R. Petrie                      *
 !* version 2                      *
 !* 06/06/2011                     *  
 !**********************************
 
 USE DefConsTypes
 IMPLICIT NONE
 !Include netcdf
 !---------------
 INCLUDE '/opt/local/include/netcdf.inc'

 !Declare parameters
 !------------------
 TYPE(um_data_type),   INTENT(INOUT)     :: umdata
 CHARACTER (LEN=*),    INTENT(IN)        :: filename
 INTEGER,              INTENT(IN)        :: latitude
 
 ! Declare local variables
 !-------------------------
 INTEGER             :: ncid, ierr, latitude
 INTEGER             :: dimidLongs_u, dimidLongs_v, dimidhalf_levs, dimidfull_levs
 INTEGER             :: varidLongs_u, varidLongs_v, varidhalf_levs, varidfull_levs
 INTEGER             :: varidu, varidv, varidw, variddensity, varidtheta
 INTEGER             :: varidorog, varidexpres
 INTEGER             :: startA(1), countA(1), startB(4), countB(4),z
 INTEGER             :: ierr1, ierr2, ierr3, ierr4, ierr5, ierr6, ierr7
 REAL (ZREAL8)       :: temp(360)	

 ! Open the netCDF file
 !----------------------
 ierr = NF_OPEN(filename, NF_NOWRITE, ncid)
 IF ( ierr .NE. 0 ) THEN
   PRINT*, ' *** Error opening file ***'
   PRINT*, ierr, NF_STRERROR(ierr)
   STOP
 ENDIF

 !Get the dimension ids
 !-----------------------
 ierr = NF_INQ_DIMID(ncid, 'x', dimidLongs_u)
 ierr1 = ierr
 ierr = NF_INQ_DIMID(ncid, 'x_1', dimidLongs_v)
 ierr2 = ierr
 ierr = NF_INQ_DIMID(ncid, 'hybrid_ht_3', dimidhalf_levs)
 ierr3 = ierr
 ierr = NF_INQ_DIMID(ncid, 'hybrid_ht_2', dimidfull_levs)
 ierr4 = ierr
 IF ( (ierr1 .NE. 0) .OR. (ierr2 .NE. 0) .OR. (ierr3 .NE. 0) .OR. (ierr4 .NE. 0) ) THEN
   PRINT*, '***Error getting dimension ids ***'
   PRINT*,'ierr1', ierr1, NF_STRERROR(ierr1)
   PRINT*,'ierr2', ierr2, NF_STRERROR(ierr2)
   PRINT*,'ierr3', ierr3, NF_STRERROR(ierr3)
   PRINT*,'ierr4', ierr4, NF_STRERROR(ierr4)
   STOP
 !ELSE
 ! PRINT*, ' Dimension ids ok' 
 ENDIF

 ! Get the dimension variable ids
 !---------------------------------
 ierr = NF_INQ_VARID(ncid, 'x', varidLongs_u)
 ierr1 = ierr
 ierr = NF_INQ_VARID(ncid, 'x_1', varidLongs_v)
 ierr2 = ierr
 ierr = NF_INQ_VARID(ncid, 'hybrid_ht_3', varidhalf_levs)
 ierr3 = ierr
 ierr = NF_INQ_VARID(ncid, 'hybrid_ht_2', varidfull_levs)
 ierr4 = ierr
 IF ( (ierr1 .NE. 0) .OR. (ierr2 .NE. 0) .OR. (ierr3 .NE. 0) .OR. (ierr4 .NE. 0) ) THEN
   PRINT*, '***Error getting dimension variable ids ***'
   PRINT*,'ierr1', ierr1, NF_STRERROR(ierr1)
   PRINT*,'ierr2', ierr2, NF_STRERROR(ierr2)
   PRINT*,'ierr3', ierr3, NF_STRERROR(ierr3)
   PRINT*,'ierr4', ierr4, NF_STRERROR(ierr4)
   PRINT*,'ierr5', ierr5, NF_STRERROR(ierr5)
   STOP
 !ELSE
 !  PRINT*, ' Dimension variable ids ok'
 ENDIF 


 ! Get the variable ids
 !----------------------
 ierr = NF_INQ_VARID(ncid, 'u', varidu)
 ierr1 = ierr
 ierr = NF_INQ_VARID(ncid, 'v', varidv)
 ierr2 = ierr
 ierr = NF_INQ_VARID(ncid, 'dz_dt', varidw)
 ierr3 = ierr
 ierr = NF_INQ_VARID(ncid, 'unspecified', variddensity)
 ierr4 = ierr
 ierr = NF_INQ_VARID(ncid, 'theta', varidtheta)
 ierr5 = ierr
 ierr = NF_INQ_VARID(ncid, 'ht', varidorog)
 ierr6 = ierr
 ierr = NF_INQ_VARID(ncid, 'field7', varidexpres)
 ierr7 = ierr
 IF ( (ierr1 .NE. 0) .OR. (ierr2 .NE. 0) .OR. (ierr3 .NE. 0) .OR. (ierr4 .NE. 0) .OR. (ierr5 .NE. 0)&
       .OR. (ierr6 .NE. 0) .OR. (ierr7 .NE. 0) ) THEN
   PRINT*, '***Error getting variable ids ***'
   PRINT*,'ierr1', ierr1, NF_STRERROR(ierr1)
   PRINT*,'ierr2', ierr2, NF_STRERROR(ierr2)
   PRINT*,'ierr3', ierr3, NF_STRERROR(ierr3)
   PRINT*,'ierr4', ierr4, NF_STRERROR(ierr4)
   PRINT*,'ierr5', ierr5, NF_STRERROR(ierr5)
   PRINT*,'ierr6', ierr6, NF_STRERROR(ierr6)
   PRINT*,'ierr7', ierr6, NF_STRERROR(ierr6)
   STOP
 !ELSE
 !  PRINT*, ' Variable ids ok'
 ENDIF

 ! Get the dimension data from the file
 !---------------------------------------
 ! Longitudes
 !-------------
 startA(1) = 1
 countA(1) = nlongs

 ierr = NF_GET_VARA_DOUBLE (ncid, varidLongs_u, startA, countA, umdata % longs_u(1:nlongs))
 ierr2 = ierr
 ierr = NF_GET_VARA_DOUBLE (ncid, varidLongs_v, startA, countA, umdata % longs_v(1:nlongs))
 ierr3 = ierr

 ! Level Heights
 !----------------
 startA(1) = 1
 countA(1) = nlevs+1
 ierr = NF_GET_VARA_DOUBLE (ncid, varidfull_levs, startA, countA, umdata % full_levs(0:nlevs))
 ierr4 = ierr
 ierr = NF_GET_VARA_DOUBLE (ncid, varidhalf_levs, startA, countA, umdata % half_levs(1:nlevs+1))
 ierr5 = ierr
 
 IF ( (ierr2 .NE. 0) .OR. (ierr3 .NE. 0) .OR. &
      (ierr4 .NE. 0) .OR. (ierr5 .NE. 0) ) THEN
   PRINT*, '***Error getting dimension data ***'
   PRINT*,'ierr1', ierr1, NF_STRERROR(ierr1)
   PRINT*,'ierr2', ierr2, NF_STRERROR(ierr2)
   PRINT*,'ierr3', ierr3, NF_STRERROR(ierr3)
   PRINT*,'ierr4', ierr4, NF_STRERROR(ierr4)
   PRINT*,'ierr5', ierr5, NF_STRERROR(ierr5)
   STOP
! ELSE
!  PRINT*, ' Dimension data ok'
 ENDIF

 ! Get the main data from the file
 !----------------------------------
 startB(1) = 1
 countB(1) = 360       ! All longitude points
 startB(2) = latitude  ! Selected latitude slice
 countB(2) = 1         !lats	
 startB(3) = 1
 countB(3) = 1         !levs
 startB(4) = 1
 countB(4) = 1         !time

 ! u
 !----
 DO z=1, nlevs
   startB(3)=z
   ierr = NF_GET_VARA_DOUBLE (ncid, varidu, startB, countB,  temp)
   umdata % u(1:nlongs,z) = temp(1:nlongs)
 END DO				   
 ierr1 = ierr

 ! v
 !----
 DO z=1, nlevs
   startB(3)=z
   ierr = NF_GET_VARA_DOUBLE (ncid, varidv, startB, countB, temp)
   umdata % v(1:nlongs, z) = temp(1:nlongs)
 END DO
 ierr2 = ierr

 ! w
 !----
 DO z=1, nlevs+1
   startB(3) = z
   ierr = NF_GET_VARA_DOUBLE (ncid, varidw, startB, countB, temp)
   umdata % w(1:nlongs, z-1) = temp(1:nlongs)
 ENDDO
 ierr3 = ierr

 ! density
 !---------
 DO z=1, nlevs
   startB(3)=z
   ierr = NF_GET_VARA_DOUBLE (ncid, variddensity, startB, countB, temp)
   umdata % density(1:nlongs, z) = temp(1:nlongs)
 ENDDO
 ierr4 = ierr

 ! theta
 !-------
 DO z=1, nlevs
   startB(3)= z
   ierr = NF_GET_VARA_DOUBLE (ncid, varidtheta, startB, countB, temp)     	
   umdata % theta(1:nlongs, z) = temp(1:nlongs)
 ENDDO
 ierr5 = ierr

 ! exner presure
 !----------------
 DO z=1, nlevs + 1
   startB(3) = z 
   ierr = NF_GET_VARA_DOUBLE (ncid, varidexpres, startB, countB, temp)
   umdata % exner_pressure(1:nlongs, z) = temp(1:nlongs)
 ENDDO
 ierr6 = ierr

 ! orographic height
 !--------------------
 DO z=1,1
   startB(3)=z
   ierr = NF_GET_VARA_DOUBLE (ncid, varidorog, startB, countB, umdata % orog_height(1:nlongs))     	
 ENDDO
 ierr7 = ierr

 IF ( (ierr1 .NE. 0) .OR. (ierr2 .NE. 0) .OR. (ierr3 .NE. 0) .OR. &
      (ierr4 .NE. 0) .OR. (ierr5 .NE. 0) .OR. (ierr6 .NE. 0) .OR. (ierr7 .NE. 0) ) THEN
   PRINT*, '***Error getting main variable data ***'
   PRINT*,'ierr1', ierr1, NF_STRERROR(ierr1)
   PRINT*,'ierr2', ierr2, NF_STRERROR(ierr2)
   PRINT*,'ierr3', ierr3, NF_STRERROR(ierr3)
   PRINT*,'ierr4', ierr4, NF_STRERROR(ierr4)
   PRINT*,'ierr5', ierr5, NF_STRERROR(ierr5)
   PRINT*,'ierr6', ierr6, NF_STRERROR(ierr6)
   PRINT*,'ierr7', ierr6, NF_STRERROR(ierr6)
   STOP
! ELSE
!  PRINT*, ' Main variable data ok'
 ENDIF

 !Close the netCDF file
 ierr = NF_CLOSE(ncid)
 IF ( ierr .NE. 0 ) THEN
   PRINT*, '***ERROR closing file***'
   STOP
 ENDIF

 END SUBROUTINE Read_um_data_2d
!===================================================================================================
