!===================================================================================================
! In this file are functions and ancillary subroutines
!
! Functions
! ----------
! FUNCTION INT_FH (varl, varu, k, Dims)
! FUNCTION INT_HF (varl,varu, k, Dims)
!===================================================================================================
!===================================================================================================
 REAL(ZREAL8) FUNCTION STDEV (field)
 !********************************************
 !* Function to calculate standard deviation *
 !* of a 2d field that has dimension         *
 !* 1:nlongs, 1:nlevs                      *
 !********************************************

 USE DefConsTypes
 IMPLICIT NONE

 !Declare parameters
 REAL(ZREAL8), INTENT(IN)          :: field(1:nlongs, 1:nlevs)
 REAL(ZREAL8)                      :: ave,std
 INTEGER                           :: i,k
 
 ave = 0.0
 DO k = 1, nlevs
   DO i = 1, nlongs
     ave = ave + field(i,k)
   END DO
   ave = ave / (nlongs * nlevs)
 END DO  
 
 std = 0.0
 DO k = 1, nlevs
   DO i = 1, nlongs
     std = std + (field(i,k) - ave)**2 
   END DO
 END DO   
 
 std = std /(nlongs * nlevs)
 STDEV = sqrt(std)

END FUNCTION STDEV
!===================================================================================================

!===================================================================================================
 REAL(ZREAL8) FUNCTION GAUSS (std)
 !********************************************
 !* Function to calculate a gaussian         *
 !* distributed random variable using the    *
 !* Box-Mueller algorithm where the          *
 !* distribution has a variance of std^2     *
 !********************************************

 USE DefConsTypes
 IMPLICIT NONE

 !Declare parameters
 REAL(ZREAL8), INTENT(IN)         :: std
 REAL                              :: RAND
 REAL(ZREAL8)                      :: u1, u2, gauss
 
 u1 = RAND(0)
 u2 = RAND(0)
 
 gauss = sqrt(-2*log(u1))*cos(2*pi*u2)*std;

 END FUNCTION GAUSS
!===================================================================================================

!===================================================================================================
 REAL(ZREAL8) FUNCTION RMS (state)

 !********************************************
 !* Function to calculate rms of a 2d-state  *
 !* of dims (1:nlongs, 1:nlevs)              *
 !********************************************

 USE DefConsTypes
 IMPLICIT NONE

 ! Declare parameters
 !------------------
 REAL(ZREAL8), INTENT(IN)    :: state(1:nlongs, 1:nlevs)

 ! Declare variables
 !-------------------
 REAL(ZREAL8)                :: rms_sum, eps
 INTEGER                     :: i, k

 !PRINT*, 'rms'
 eps = 10E-19

 ! Calculate rmse
 !-----------------
 rms_sum = 0.0   
 
 DO i = 1, nlongs
   DO k = 1, nlevs
     rms_sum = rms_sum + ( (state(i,k) )**2 )
   ENDDO
 ENDDO
 
 RMS = sqrt( (rms_sum/(nlongs*nlevs) ) ) 
 
 IF (RMS .LT. eps) THEN
  PRINT*, 'RMS SMALL'
 ! STOP
 END IF
 
 END FUNCTION RMS

!===================================================================================
 SUBROUTINE Energy(state)
  
 ! To calculate components of energy
 
 USE DefConsTypes
 IMPLICIT NONE

 TYPE(model_vars_type),       INTENT(INOUT)   :: state


INTEGER	                               :: x, z
REAL(ZREAL8)                           :: u, v, w, rho, bp, rhop
REAL(ZREAL8)                           :: E_k, E_b, E_e


  ! Initialise
  E_k = 0.0
  E_e = 0.0
  E_b = 0.0

  ! Calculate energy
  DO z = 1, nlevs
    DO x = 1, nlongs
       rhop = state % r(x,z)
       u    = state % u(x,z)
       v    = state % v(x,z)
       w    = state % w(x,z)
       bp   = state % b(x,z)
       rho  = state % rho(x,z)
       E_k  = E_k + rho * (u*u + v*v + w*w) / 2.0
       E_e  = E_e + Cz * rhop*rhop / (2.0 * B)
       E_b  = E_b + rho * bp*bp / (2.0 * A*A)
    END DO
  END DO

  state % energy(1) = E_k
  state % energy(2) = E_e
  state % energy(3) = E_b
  state % energy(4) = E_k + E_e + E_b

 END SUBROUTINE Energy

!===================================================================================================
 SUBROUTINE Calc_hydro(state, Dims)

 ! Calculate hydrostatic imbalance in real space
 
 USE DefConsTypes
 IMPLICIT NONE

 ! Declare parameters
 !---------------------
 TYPE(model_vars_type), INTENT(INOUT)       :: state
 TYPE(Dimensions_type), INTENT(IN)          :: Dims

 ! Declare variables
 !---------------------
 INTEGER                                    :: x,z
 REAL(ZREAL8)                               :: norm, eps, rms_tmp

 ! Functions
 REAL(ZREAL8)                               :: RMS

  eps = 10E-16
  rms_tmp = RMS(state % b(1:nlongs,1:nlevs))
  IF (rms_tmp .LE. eps) THEN
    rms_tmp = 1.0
    PRINT*, 'Not normalized due to small rms'
   norm = 1.0/ rms_tmp
   ELSE
   norm = 1.0/ rms_tmp 
  END IF

 
 DO x = 1, nlongs
   DO z = 1, nlevs
     state % hydro_imbal(x,z) =                                               &    
                    (                                                         &
                       (                                                      &
                         Cz * ( state % r(x,z) - state % r(x,z-1) )           &
                         /                                                    & 
                         ( Dims % half_levs(z) - Dims % half_levs(z-1) )      &
                       )                                                      &
                       -                                                      &   
                       state % b(x,z)                                         &                  
                    )                                                         & 
                    * norm                               
   ENDDO
 ENDDO

 END SUBROUTINE Calc_hydro
!===================================================================================================

!=================================================================================================== 
 SUBROUTINE Calc_geost(state, Dims)
 
 ! Calculate geostrophic imbalance in real space
 USE DefConsTypes
 IMPLICIT NONE

 ! Declare parameters
 !---------------------
 TYPE(model_vars_type), INTENT(INOUT)       :: state
 TYPE(Dimensions_type), INTENT(IN)          :: Dims
 
 INTEGER                                    :: x,z
 REAL(ZREAL8)                               :: norm, eps, rms_tmp
 ! Functions
 REAL(ZREAL8)                               :: RMS
  
  eps = 10E-16
  rms_tmp = RMS(state % v(1:nlongs,1:nlevs))
  IF (rms_tmp .LE. eps) THEN
    rms_tmp = 1.0
    PRINT*, 'Not normalized due to small rms'
    norm = 1/ rms_tmp
   ELSE
    rms_tmp = f0* RMS(state % v(1:nlongs,1:nlevs))
    norm = 1/ rms_tmp
  END IF
 
 
 DO z = 1,nlevs
   DO x = 1,nlongs
      state % geost_imbal(x,z) =                                                  & 
                     (                                                            &
                        (                                                         & 
                          Cz * ( state % r(x+1,z) - state % r(x-1,z) )            &
                               /                                                  &
                               (2 *dx )                                           &
                        )                                                         &
                        -                                                         &   
                        f0 * state % v(x,z)                                       &  
                     ) * norm
                                                            
     ENDDO
 ENDDO
! PRINT*, state % geost_imbal(170, 25)

 END SUBROUTINE Calc_geost
!==================================================================================================

!!==================================================================================================
 SUBROUTINE Convection(state, x, z, xscale, zscale)
 
 ! Convection forcing at x, z
 ! with lengthscales xscale, zscale
 USE DefConsTypes
 IMPLICIT NONE

 !Declare global parameters
 !------------------
 TYPE(model_vars_type), INTENT(INOUT) :: state
 INTEGER,               INTENT(IN)    :: x,z, xscale, zscale
 REAL(ZREAL8)                         :: temp1, temp2, zscale2, xscale2
 REAL(ZREAL8)                         :: tempfield(1:nlongs, 1:nlevs)
 INTEGER                              :: i,k

 zscale2 = zscale * zscale
 xscale2 = xscale * xscale 
 tempfield(:,:) = 0.0
 DO i = 1, nlongs
    DO k = 1, nlevs
     temp1 = (x - i) * (x - i)
     temp2 = (z - k) * (z - k)
     tempfield(i,k) = 0.00001 * EXP (-(temp1/xscale2) - (temp2/zscale2)) * ABS(COS(REAL(4*i)))
     state % b(i,k) = state % b(i,k) + tempfield(i,k)
   END DO 
 END DO

 END SUBROUTINE CONVECTION
!!==================================================================================================



!!==================================================================================================
 REAL(ZREAL8) FUNCTION INT_FH (varl, varu, z, Dims)
 ! Function interpolates variable from half to full levs
 ! at a given grid point
 ! varl at (i,k-1)
 ! varu at (i,k)
 USE DefConsTypes
 IMPLICIT NONE

 !Declare global parameters
 !------------------
 REAL(ZREAL8)                  :: varl 
 REAL(ZREAL8)                  :: varu 
 TYPE(Dimensions_type)         :: dims	
 REAL(ZREAL8)                  :: a1, b1
 INTEGER	                     :: z 
 
 !Vertical interpolation formulae, calculate constants
 !-------------------------------------
 	a1 = (Dims % half_levs(z) - Dims % full_levs(z-1))/(Dims % full_levs(z)-Dims % full_levs(z-1))
 	b1 = (Dims % full_levs(z) - Dims % half_levs(z))/(Dims % full_levs(z)-Dims % full_levs(z-1))
 
 ! Calculate variable interpolated to full levs
 !----------------------------
 INT_FH = a1*varu + b1*varl

 END FUNCTION INT_FH
!!==================================================================================================
 REAL(ZREAL8) FUNCTION INT_HF (varl,varu, z, Dims)
 ! Function interpolates variable from full to half levs
 ! at a given grid point
 ! varl at (i,k)
 ! varu at (i,k+1)

 USE DefConsTypes
 IMPLICIT NONE

 !Declare parameters
 !------------------
 REAL(ZREAL8)            :: varl
 REAL(ZREAL8)            :: varu
 TYPE(Dimensions_type)   :: Dims	
 INTEGER                 :: z
 REAL(ZREAL8)            :: a2, b2

 !Vertical interpolation formulae, calculate constants
 !-------------------------------------
	a2 = (Dims % full_levs(z) - Dims % half_levs(z)) / (Dims % half_levs(z+1) - Dims % half_levs(z))
	b2 = (Dims % half_levs(z+1) - Dims % full_levs(z))/ (Dims % half_levs(z+1) - Dims % half_levs(z))

 !Calculate variable interpolated to half levs
 !----------------------------
 INT_HF = a2*varu + b2* varl
 
 END FUNCTION INT_HF
!===================================================================================================

!==========================================================================
 SUBROUTINE InterpolationTest(state, Dims) 

 ! Subroutine to test interpolation functions
 
 USE DefConsTypes
 IMPLICIT NONE

 !Declare parameters
 !------------------
 TYPE(model_vars_type)   :: state
 TYPE(Dimensions_type)   :: Dims	
 INTEGER	               :: x,z
 REAL(ZREAL8)            :: variable_test(1:nlongs, 1:nlevs)
 REAL(ZREAL8)            :: INT_HF, INT_FH

 PRINT*, ' File directory not known'
 PRINT*, 'STOP'
 STOP
 
 ! change file output locations 

 !Output original data
 OPEN(51, file ='/home/wx019276/Modelling/Matlab/Data/varorig.dat')
 DO z = 1, nlevs
   WRITE (51, *) state % w(1:nlongs,z)
 ENDDO
 CLOSE(51)

 ! Perform full to half lev interpolation 
 DO z = 1, nlevs
   DO x = 1, nlongs
    variable_test(x,z) =  INT_FH(state % w(x,z-1), state % w(x,z),z, Dims)
   ENDDO
 ENDDO

 ! Perform half to full lev interpolation
 DO z = 2, nlevs-1
   DO x = 1, nlongs
     variable_test(x,z) =  INT_HF(state % w(x,z), state % w(x,z+1),z, Dims)
   ENDDO
 ENDDO

 !Output interpolated data
 OPEN (52, file ='/home/wx019276/Modelling/Matlab/Data/varnew.dat')
 DO z = 1, nlevs-1
   WRITE (52, *) variable_test(1:nlongs, z)
 ENDDO
 CLOSE(52)
 
 END SUBROUTINE InterpolationTest
!==========================================================================












