! This file contains

! SUBROUTINE Effective_buoyancy
! SUBROUTINE Energy
! SUBROUTINE Calc_hydro
! SUBROUTINE Calc_geost

! R. Petrie, 3.0 30-7-2013

!===================================================================================================
 SUBROUTINE Effective_buoyancy (state)

!**************************************************
!* Subroutine to calculate the effective buoyancy *
!**************************************************

USE DefConsTypes, ONLY :   &
    model_vars_type,       &
    nlongs, nlevs,         &
    A, dz

IMPLICIT NONE

TYPE(model_vars_type),  INTENT(INOUT)   :: state

! Declare local variables
!-------------------
INTEGER                     :: i, k

! Routine written assuming constant dz
! modification required if using Charney-Philips

! NOT NORMALIZED

DO k = 1, nlevs
  DO i = 1, nlongs

   state % b_ef(i,k) = ( ( state % b(i,k+1) - state % b(i,k-1) ) / dz ) + A*A

  END DO
END DO

END SUBROUTINE Effective_buoyancy
!==================================================================================================


!===================================================================================
SUBROUTINE Energy (state)

! To calculate components of energy

USE DefConsTypes, ONLY :  &
    model_vars_type,      &
    ZREAL8,               &
    nlongs, nlevs,        &
    A, B, C

IMPLICIT NONE

TYPE(model_vars_type),  INTENT(INOUT)   :: state
INTEGER                                 :: x, z
REAL(ZREAL8)                            :: u, v, w, rho, bp, r
REAL(ZREAL8)                            :: E_k, E_b, E_e


! Initialise
E_k = 0.0
E_e = 0.0
E_b = 0.0

! Calculate energy
DO z = 1, nlevs
  DO x = 1, nlongs
    r    = state % r(x,z)
    u    = state % u(x,z)
    v    = state % v(x,z)
    w    = state % w(x,z)
    bp   = state % b(x,z)
    rho  = state % rho(x,z)

    E_k  = E_k + rho * (u*u + v*v + w*w) / 2.0
    E_e  = E_e + C * r*r / (2. * B)
    E_b  = E_b + rho * bp*bp / (2. * A*A)
  END DO
END DO

state % Kinetic_Energy = E_k
state % Buoyant_Energy = E_b
state % Elastic_Energy = E_e
state % Total_Energy   = E_k + E_e + E_b

END SUBROUTINE Energy

!===================================================================================================
SUBROUTINE Calc_hydro (state, Dims)

! Calculate hydrostatic imbalance in real space

USE DefConsTypes, ONLY :   &
    model_vars_type,       &
    Dimensions_type,       &
    ZREAL8,                &
    nlongs, nlevs, C

IMPLICIT NONE

! Declare parameters
!---------------------
TYPE(model_vars_type), INTENT(INOUT)  :: state
TYPE(Dimensions_type), INTENT(IN)     :: Dims

! Declare variables
!---------------------
INTEGER                               :: x,z
REAL(ZREAL8)                          :: norm, eps, rms_tmp

! Functions
! ---------
REAL(ZREAL8)                          :: RMS

! Calculate normalization
eps     = 10E-16
rms_tmp = RMS(state % b(1:nlongs,1:nlevs))
IF (rms_tmp .LE. eps) THEN
  rms_tmp = 1.
  PRINT*, 'Hydro - not normalized due to small rms'
END IF
norm = 1. / rms_tmp

! Calculate normalized hydrostatic imbalance
DO x = 1, nlongs
  DO z = 1, nlevs
    state % hydro_imbal(x,z) = ( C * (state % r(x,z+1) - state % r(x,z)) /         &
                                     (Dims % half_levs(z+1) - Dims % half_levs(z)) &
                                 - state % b(x,z) ) * norm
  ENDDO
ENDDO

END SUBROUTINE Calc_hydro
!===================================================================================================

!===================================================================================================
SUBROUTINE Calc_geost (state, Dims)

! Calculate geostrophic imbalance in real space
USE DefConsTypes, ONLY :  &
  ZREAL8,                 &
  model_vars_type,        &
  Dimensions_type,        &
  nlongs, nlevs,          &
  f, C, recip2dx

IMPLICIT NONE

! Declare parameters
!-------------------
TYPE(model_vars_type), INTENT(INOUT)       :: state
TYPE(Dimensions_type), INTENT(IN)          :: Dims

! Declare local variables
! -----------------------
INTEGER                                    :: x, z
REAL(ZREAL8)                               :: norm, eps, rms_tmp

! Functions
! ---------
REAL(ZREAL8)                               :: RMS

! Calculate normalization
eps     = 10E-16
rms_tmp = f * RMS(state % v(1:nlongs,1:nlevs))
IF (rms_tmp .LE. eps) THEN
  rms_tmp = 1.
  PRINT*, 'Geo - not normalized due to small rms'
END IF
norm = 1. / rms_tmp

! Calculate normalized geostrophic imbalance
DO z = 1, nlevs
  DO x = 1, nlongs
    state % geost_imbal(x,z) =                                     &
       ( C * recip2dx * (state % r(x+1,z) - state % r(x-1,z)) -    &
         f * state % v(x,z) ) * norm
  ENDDO
ENDDO

END SUBROUTINE Calc_geost
!==================================================================================================

