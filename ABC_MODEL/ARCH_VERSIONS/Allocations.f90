 SUBROUTINE Allocate_um_data_type ( umdata )
 
 !******************************
 !* Subroutine to allocate     *
 !* um data type array         * 
 !******************************

 USE DefConsTypes 
 IMPLICIT NONE

 !Declare parameters
 !------------------
 TYPE(um_data_type),  INTENT(INOUT)   :: umdata

 !Include halo points in arrays to account for global boundary conditions
 ALLOCATE  ( umdata % longs_u(1:nlongs) )
 ALLOCATE  ( umdata % longs_v(1:nlongs) )
 ALLOCATE  ( umdata % half_levs(1:nlevs+1) )
 ALLOCATE  ( umdata % full_levs(0:nlevs) )
 ALLOCATE  ( umdata % u(1:nlongs,1:nlevs) )
 ALLOCATE  ( umdata % v(1:nlongs,1:nlevs) )
 ALLOCATE  ( umdata % w(1:nlongs,0:nlevs) )
 ALLOCATE  ( umdata % density(1:nlongs,1:nlevs) )
 ALLOCATE  ( umdata % theta(1:nlongs,1:nlevs) )
 ALLOCATE  ( umdata % exner_pressure(1:nlongs,1:nlevs+1) )
 ALLOCATE  ( umdata % orog_height(1:nlongs) )

 umdata % longs_u(1:nlongs) = 0.0
 umdata % longs_v(1:nlongs) = 0.0
 umdata % half_levs(1:nlevs+1) = 0.0
 umdata % full_levs(0:nlevs) = 0.0
 umdata % u(1:nlongs,1:nlevs) = 0.0
 umdata % v(1:nlongs,1:nlevs) = 0.0
 umdata % w(1:nlongs,0:nlevs) = 0.0
 umdata % density(1:nlongs,1:nlevs) = 0.0
 umdata % theta(1:nlongs,1:nlevs) = 0.0
 umdata % exner_pressure(1:nlongs,1:nlevs+1) = 0.0
 umdata % orog_height(1:nlongs) = 0.0

 END SUBROUTINE Allocate_um_data_type
!===================================================================================================
 SUBROUTINE Allocate_dimensions_type ( dims )
 
 !******************************
 !* Subroutine to allocate     *
 !* dimensions type array      * 
 !******************************

 USE DefConsTypes 
 IMPLICIT NONE

 !Declare parameters
 !------------------
 TYPE(dimensions_type),  INTENT(INOUT)   :: dims

 ALLOCATE( dims % longs_u(0:nlongs+1) )
 ALLOCATE( dims % longs_v(0:nlongs+1) )
 ALLOCATE( dims % half_levs(0:nlevs+1) )
 ALLOCATE( dims % full_levs(0:nlevs+1) )
 
 dims % longs_u(0:nlongs+1)  = 0.0
 dims % longs_v(0:nlongs+1)  = 0.0
 dims % half_levs(0:nlevs) = 0.0
 dims % full_levs(0:nlevs) = 0.0 
 
 END SUBROUTINE Allocate_dimensions_type
!===================================================================================================

!===================================================================================================
 SUBROUTINE Allocate_model_vars_type ( state )
 
 !******************************
 !* Subroutine to allocate     *
 !* dimensions type array      * 
 !******************************

 USE DefConsTypes 
 IMPLICIT NONE

 !Declare parameters
 !------------------
 TYPE(model_vars_type),  INTENT(INOUT)   :: state

! ALLOCATE  ( state % u(0:nlongs+1, 0:nlevs+1) )
! ALLOCATE  ( state % v(0:nlongs+1, 0:nlevs+1) ) 
! ALLOCATE  ( state % w(0:nlongs+1, 0:nlevs+1) )
! ALLOCATE  ( state % r(0:nlongs+1, 0:nlevs+1) )    ! density perturbation  
! ALLOCATE  ( state % rho0(1:nlevs) )               ! density basic state
! ALLOCATE  ( state % rho(0:nlongs+1, 0:nlevs+1) )  ! density full field
! ALLOCATE  ( state % b(0:nlongs+1, 0:nlevs+1) )    ! buoyancy perturbation
! ALLOCATE  ( state % tracer(0:nlongs+1, 0:nlevs+1) )
! ALLOCATE  ( state % hydro_imbal(0:nlongs+1, 0:nlevs+1) )  
! ALLOCATE  ( state % geost_imbal(0:nlongs+1, 0:nlevs+1) )
! ALLOCATE  ( state % energy(1:4) )

 state % u(0:nlongs+1, 0:nlevs+1)           = 0.0
 state % v(0:nlongs+1, 0:nlevs+1)           = 0.0 
 state % w(0:nlongs+1, 0:nlevs+1)           = 0.0
 state % r(0:nlongs+1, 0:nlevs+1)           = 0.0  
 state % rho0(:)                            = 0.0
 state % rho(0:nlongs+1, 0:nlevs+1)         = 0.0
 state % b(0:nlongs+1, 0:nlevs+1)           = 0.0
 state % tracer(0:nlongs+1, 0:nlevs+1)      = 0.0
 state % hydro_imbal(0:nlongs+1, 0:nlevs+1) = 0.0  
 state % geost_imbal(0:nlongs+1, 0:nlevs+1) = 0.0
 state % energy(1:4)                        = 0.0
 
 END SUBROUTINE Allocate_model_vars_type 
!===================================================================================================

!===================================================================================================

 SUBROUTINE Allocate_averages ( Variable )
 ! Allocate averages array for average advecting variables for prognostic model

 USE DefConsTypes

 IMPLICIT NONE

 !Declare parameters
 !------------------
 TYPE(Averages_type),  INTENT(INOUT)   :: Variable

 !Include halo points in arrays to account for global boundary conditions
 ALLOCATE ( Variable % u_1(0:nlongs+1, 0:nlevs+1) )
 ALLOCATE ( Variable % u_2(0:nlongs+1, 0:nlevs+1) )
 ALLOCATE ( Variable % u_m(0:nlongs+1, 0:nlevs+1) )
 ALLOCATE ( Variable % w_1(0:nlongs+1, 0:nlevs+1) )
 ALLOCATE ( Variable % w_2(0:nlongs+1, 0:nlevs+1) )
 ALLOCATE ( Variable % w_m(0:nlongs+1, 0:nlevs+1) )

 END SUBROUTINE Allocate_averages
!===================================================================================================

!===================================================================================================
 SUBROUTINE Deallocate_averages ( Variable )
 
 ! Deallocate averages type
 
 USE DefConsTypes

 IMPLICIT NONE

 !Declare parameters
 !------------------
 TYPE(Averages_type),  INTENT(INOUT)   :: Variable

 DEALLOCATE ( Variable % u_1)
 DEALLOCATE ( Variable % u_2)
 DEALLOCATE ( Variable % u_m)
 DEALLOCATE ( Variable % w_1)
 DEALLOCATE ( Variable % w_2)
 DEALLOCATE ( Variable % w_m)

 END SUBROUTINE Deallocate_averages

!!==============================================================================

!===================================================================================================
! SUBROUTINE Deallocate_model_vars_type ( state )
 
 !******************************
 !* Subroutine to allocate     *
 !* dimensions type array      * 
 !******************************

! USE DefConsTypes 
! IMPLICIT NONE

 !Declare parameters
 !------------------
! TYPE(model_vars_type),  INTENT(IN)   :: state

! DEALLOCATE  ( state % u ) 
! DEALLOCATE  ( state % v ) 
! DEALLOCATE  ( state % w )
! DEALLOCATE  ( state % r )   
! DEALLOCATE  ( state % rho0 )        
! DEALLOCATE  ( state % rho )
! DEALLOCATE  ( state % b )   
! DEALLOCATE  ( state % tracer ) 
! DEALLOCATE  ( state % hydro_imbal )
! DEALLOCATE  ( state % geost_imbal )
! DEALLOCATE  ( state % energy )
 
! END SUBROUTINE Deallocate_model_vars_type 
!===================================================================================================

 SUBROUTINE Deallocate_dimensions_type ( dims )
 
 !******************************
 !* Subroutine to allocate     *
 !* dimensions type array      * 
 !******************************

 USE DefConsTypes 
 IMPLICIT NONE

 !Declare parameters
 !------------------
 TYPE(dimensions_type),  INTENT(INOUT)   :: dims

 DEALLOCATE( dims % longs_u )
 DEALLOCATE( dims % longs_v )
 DEALLOCATE( dims % half_levs )
 DEALLOCATE( dims % full_levs )
  
 END SUBROUTINE Deallocate_dimensions_type
!=================================================================================================== 
 SUBROUTINE Deallocate_um_data_type ( umdata )
 !Allocate arrays inside Field3d_type 

 USE DefConsTypes 
 IMPLICIT NONE

 !Declare parameters
 !------------------
 TYPE(um_data_type),  INTENT(INOUT)   :: umdata


 !Include halo points in arrays to account for global boundary conditions
 DEALLOCATE  ( umdata % longs_u )
 DEALLOCATE  ( umdata % longs_v )
 DEALLOCATE  ( umdata % half_levs )
 DEALLOCATE  ( umdata % full_levs )
 DEALLOCATE  ( umdata % u )
 DEALLOCATE  ( umdata % v )
 DEALLOCATE  ( umdata % w )
 DEALLOCATE  ( umdata % density )
 DEALLOCATE  ( umdata % theta )
 DEALLOCATE  ( umdata % exner_pressure )
 DEALLOCATE  ( umdata % orog_height )

 END SUBROUTINE Deallocate_um_data_type
!===================================================================================================

