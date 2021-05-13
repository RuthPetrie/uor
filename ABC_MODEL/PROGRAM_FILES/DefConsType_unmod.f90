 MODULE DefConsTypes

 !*****************************************************
 !*   Definition of all global constants              *  
 !*   and variable types                              * 
 !*                                                   *
 !*                                                   *  
 !*                                                   *  
 !*   R. Petrie                                       *  
 !*   Version 2                                       * 
 !*   02-08-10                                        *
 !*****************************************************

 !Definition of some new data types

 IMPLICIT NONE

 !Define an integer that describes a unified double precision
 !------------------------------------------------------------
 INTEGER, PARAMETER   :: ZREAL8 = SELECTED_REAL_KIND(15,307)
 INTEGER, PARAMETER   :: wp = KIND(1.0D0)

 ! Model parameters
 !-------------------
 INTEGER, PARAMETER        :: nlongs     = 360            ! total number of longitude points
 INTEGER, PARAMETER        :: nlevs      = 60             ! total number of vertical levels
 INTEGER, PARAMETER        :: nems       = 23             ! number of ensemble members (add 1 to count ctrl mb)
 INTEGER, PARAMETER        :: nvars      = 5              ! number of variables
 INTEGER, PARAMETER        :: nbreedcyc  = 20             ! number of rescale points
 INTEGER, PARAMETER        :: nems_1     = nems-1         ! number of ensemble members - 1 control
 INTEGER, PARAMETER        :: minvertwaveno = -1 * nlevs/2 
 INTEGER, PARAMETER        :: maxvertwaveno = -1 + nlevs/2 
 INTEGER                   :: nlats
 REAL(ZREAL8), PARAMETER   :: dt = 4
 REAL(ZREAL8), PARAMETER   :: deltat = 2  !deltat = 1/2 dt


 ! Mathematical and physical constants
 !------------------------------------
 REAL(ZREAL8), PARAMETER   :: Nsq = 0.0004   !A parameter
 REAL(ZREAL8), PARAMETER   :: B = 0.005
 REAL(ZREAL8), PARAMETER   :: Cz = 100000.0
 REAL(ZREAL8), PARAMETER   :: f0 = 0.001
 REAL(ZREAL8), PARAMETER   :: kappa = 0.286
 REAL(ZREAL8), PARAMETER   :: R  = 287.0  
 REAL(ZREAL8), PARAMETER   :: p00 = 100000.0
 REAL(ZREAL8), PARAMETER   :: g = 9.81
 REAL(ZREAL8), PARAMETER   :: dx = 1500.0
 REAL(ZREAL8), PARAMETER   :: time = 36000.0
 REAL(ZREAL8), PARAMETER   :: pi = 3.141592654
 REAL(ZREAL8), PARAMETER   :: H = 14862.01
 REAL(ZREAL8), PARAMETER   :: dz = H/nlevs !247
 REAL(ZREAL8), PARAMETER   :: A = 1.0
 REAL(ZREAL8), PARAMETER   :: Rd  = 287.058     ! Gas constant for dry air
 REAL(ZREAL8), PARAMETER	 :: Re = 6.371E6      ! Mean radius of the earth	
 REAL(ZREAL8), PARAMETER   :: Cp = 1005.7
 REAL(ZREAL8), PARAMETER   :: Cv = 719.0

 ! Useful constants
 !-------------------
 REAL(ZREAL8), PARAMETER   :: recipdx2 = 1.0 / (dx * dx)
 REAL(ZREAL8), PARAMETER   :: recipdx  = 1.0 / dx
 REAL(ZREAL8), PARAMETER   :: recip2dx = 1.0 / ( 2.0 * dx )
 REAL(ZREAL8), PARAMETER   :: third = 1.0/3.0
 REAL(ZREAL8), PARAMETER   :: recippi = 1.0/pi
 REAL(ZREAL8), PARAMETER   :: domain = dx * nlongs
 REAL(ZREAL8), PARAMETER   :: alpha_f = 1.0 + ( (deltat * deltat * f0*f0 )/4.0 )
 REAL(ZREAL8), PARAMETER   :: alpha_N = 1.0 + ( (deltat * deltat * Nsq )/4.0 )
 REAL(ZREAL8), PARAMETER   :: beta_f = 1.0 - ( (deltat * deltat *  f0*f0)/4.0 )
 REAL(ZREAL8), PARAMETER   :: beta_N = 1.0 - ( (deltat * deltat * Nsq )/4.0 )
 REAL(ZREAL8), PARAMETER   :: recip_alpha_f = 1.0 / alpha_f
 REAL(ZREAL8), PARAMETER   :: recip_alpha_N = 1.0 / alpha_N
 REAL(ZREAL8), PARAMETER   :: bdiva_f = beta_f / alpha_f
 REAL(ZREAL8), PARAMETER   :: bdiva_N = beta_N / alpha_N
 REAL(ZREAL8), PARAMETER   :: adivb_N = alpha_N / beta_N 
  
!**************************************************************************************************
! Declare global arrays
!**************************************************************************************************
  REAL (ZREAL8) :: b_0(1:nlevs)                 
  
  
!**************************************************************************************************
! Declare Compound Types
!**************************************************************************************************

!===================================================================================================
 TYPE um_data_type
  REAL (ZREAL8) :: longs_u(1:nlongs)                 
  REAL (ZREAL8) :: longs_v(1:nlongs)                  
  REAL (ZREAL8) :: half_levs(1:nlevs+1)               
  REAL (ZREAL8) :: full_levs(0:nlevs)                 
  REAL (ZREAL8) :: u(1:nlongs,1:nlevs)                
  REAL (ZREAL8) :: v(1:nlongs,1:nlevs)                
  REAL (ZREAL8) :: w(1:nlongs,0:nlevs)                
  REAL (ZREAL8) :: density(1:nlongs,1:nlevs)          
  REAL (ZREAL8) :: theta(1:nlongs,1:nlevs)            
  REAL (ZREAL8) :: exner_pressure(1:nlongs,1:nlevs+1) 
  REAL (ZREAL8) :: orog_height(1:nlongs)              
 END TYPE um_data_type
!===================================================================================================

 
!===================================================================================================
 TYPE Dimensions_type
  REAL (ZREAL8) :: longs_u(0:nlongs+1)  
  REAL (ZREAL8) :: longs_v(0:nlongs+1)  
  REAL (ZREAL8) :: half_levs(0:nlevs+1)  
  REAL (ZREAL8) :: full_levs(0:nlevs+1) 
 END TYPE Dimensions_type  
!===================================================================================================

!===================================================================================================
 TYPE model_vars_type
  !Horizontal grid is Awakara C grid
  REAL (ZREAL8) :: u(0:nlongs+1,0:nlevs+1)           
  REAL (ZREAL8) :: v(0:nlongs+1,0:nlevs+1)            
  REAL (ZREAL8) :: w(0:nlongs+1,0:nlevs+1)           
  REAL (ZREAL8) :: r(0:nlongs+1,0:nlevs+1)                ! density perturbation  
  REAL (ZREAL8) :: b(0:nlongs+1,0:nlevs+1)                ! buoyancy perturbation
  REAL (ZREAL8) :: b_ef(0:nlongs+1,0:nlevs+1)             ! buoyancy perturbation
  REAL (ZREAL8) :: rho0(1:nlevs)                          ! density basic state
  REAL (ZREAL8) :: rho(0:nlongs+1,0:nlevs+1)              ! density full field
  REAL (ZREAL8) :: tracer(0:nlongs+1,0:nlevs+1)      
  REAL (ZREAL8) :: hydro_imbal(0:nlongs+1,0:nlevs+1)   
  REAL (ZREAL8) :: geost_imbal(0:nlongs+1,0:nlevs+1) 
  
  REAL (ZREAL8) :: energy(1:4)                       
 END TYPE model_vars_type
!===================================================================================================

!==================================================================================================
TYPE Averages_type

  REAL (ZREAL8) :: u_1(0:nlongs+1, 0:nlevs+1) 
  REAL (ZREAL8) :: u_2(0:nlongs+1, 0:nlevs+1) 
  REAL (ZREAL8) :: u_m(0:nlongs+1, 0:nlevs+1) 
  REAL (ZREAL8) :: w_1(0:nlongs+1, 0:nlevs+1) 
  REAL (ZREAL8) :: w_2(0:nlongs+1, 0:nlevs+1) 
  REAL (ZREAL8) :: w_m(0:nlongs+1, 0:nlevs+1) 

END TYPE Averages_type
!==================================================================================================

!==================================================================================================
TYPE transform_type
  !Fields are stored on an Arakawa 'C' grid in horizontal and Charney-Philips grid in the vertical
  COMPLEX (wp) :: u(1:nlevs,1:nlongs)  
  COMPLEX (wp) :: v(1:nlevs,1:nlongs)  
  COMPLEX (wp) :: w(1:nlevs,1:nlongs)
  COMPLEX (wp) :: r(1:nlevs,1:nlongs)
  COMPLEX (wp) :: b(1:nlevs,1:nlongs)

END TYPE Transform_type
!==================================================================================================

END MODULE DefConsTypes

!===================================================================================
 SUBROUTINE Initialise_um_data(state)
  
 ! Initialise um-data variables
 
 USE DefConsTypes
 IMPLICIT NONE

 TYPE(um_data_type), INTENT(INOUT)   :: state

 state % longs_u(1:nlongs)                  = 0.0
 state % longs_v(1:nlongs)                  = 0.0
 state % half_levs(1:nlevs+1)               = 0.0
 state % full_levs(0:nlevs)                 = 0.0
 state % u(1:nlongs,1:nlevs)                = 0.0
 state % v(1:nlongs,1:nlevs)                = 0.0
 state % w(1:nlongs,0:nlevs)                = 0.0
 state % density(1:nlongs,1:nlevs)          = 0.0
 state % theta(1:nlongs,1:nlevs)            = 0.0
 state % exner_pressure(1:nlongs,1:nlevs+1) = 0.0
 state % orog_height(1:nlongs)              = 0.0

 END SUBROUTINE Initialise_um_data

!===================================================================================================

!===================================================================================
 SUBROUTINE Initialise_dims(state)
  
 ! Initialise dimension variables
 
 USE DefConsTypes
 IMPLICIT NONE

 TYPE(Dimensions_type), INTENT(INOUT)   :: state

 state % longs_u(0:nlongs+1)  = 0.0
 state % longs_v(0:nlongs+1)  = 0.0
 state % half_levs(0:nlevs+1) = 0.0 
 state % full_levs(0:nlevs+1) = 0.0

 END SUBROUTINE Initialise_dims

!===================================================================================================

!===================================================================================
 SUBROUTINE Initialise_model_vars(state)
  
 ! Initialise model variables
 
 USE DefConsTypes
 IMPLICIT NONE

 TYPE(model_vars_type), INTENT(INOUT)   :: state

 state % u(0:nlongs+1,0:nlevs+1)           = 0.0
 state % v(0:nlongs+1,0:nlevs+1)           = 0.0 
 state % w(0:nlongs+1,0:nlevs+1)           = 0.0
 state % r(0:nlongs+1,0:nlevs+1)           = 0.0     ! density perturbation  
 state % b(0:nlongs+1,0:nlevs+1)           = 0.0     ! buoyancy perturbation
 state % rho0(1:nlevs)                     = 0.0     ! density basic state
 state % rho(0:nlongs+1,0:nlevs+1)         = 0.0     ! density full field
 state % tracer(0:nlongs+1,0:nlevs+1)      = 0.0
 state % hydro_imbal(0:nlongs+1,0:nlevs+1) = 0.0  
 state % geost_imbal(0:nlongs+1,0:nlevs+1) = 0.0
 state % energy(1:4)                       = 0.0

 END SUBROUTINE Initialise_model_vars

!===================================================================================================

!===================================================================================
 SUBROUTINE Initialise_Averages(state)
  
 ! Initialise averages variables
 
 USE DefConsTypes
 IMPLICIT NONE

 TYPE(Averages_type), INTENT(INOUT)   :: state

 state % u_1(0:nlongs+1, 0:nlevs+1) = 0.0
 state % u_2(0:nlongs+1, 0:nlevs+1) = 0.0
 state % u_m(0:nlongs+1, 0:nlevs+1) = 0.0
 state % w_1(0:nlongs+1, 0:nlevs+1) = 0.0
 state % w_2(0:nlongs+1, 0:nlevs+1) = 0.0
 state % w_m(0:nlongs+1, 0:nlevs+1) = 0.0


 END SUBROUTINE Initialise_Averages

!===================================================================================================


!==================================================================================================
SUBROUTINE Initialise_transform_vars(state)
  
 ! Initialise transform variables, these are the control variables
 
 USE DefConsTypes
 IMPLICIT NONE

 TYPE(transform_type), INTENT(INOUT)   :: state
 
 state % u(1:nlevs,1:nlongs) = (0.0, 0.0) 
 state % v(1:nlevs,1:nlongs) = (0.0, 0.0)  
 state % w(1:nlevs,1:nlongs) = (0.0, 0.0)
 state % r(1:nlevs,1:nlongs) = (0.0, 0.0)
 state % b(1:nlevs,1:nlongs) = (0.0, 0.0)

END SUBROUTINE
!==================================================================================================





