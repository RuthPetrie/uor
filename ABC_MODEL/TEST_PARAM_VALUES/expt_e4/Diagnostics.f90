! This file contains

! SUBROUTINE Effective_buoyancy
! SUBROUTINE Energy
! SUBROUTINE Calc_hydro
! SUBROUTINE Calc_geost
! SUBROUTINE Lscale_from_fft

! R. Petrie, 3.0 30-7-2013

!===================================================================================
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
!===================================================================================


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

!===================================================================================
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
!===================================================================================

!===================================================================================
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
!===================================================================================

!===================================================================================
SUBROUTINE Lscales_from_fft (dataset, nxpoints, nypoints, xlength, ylength)

! Code to estimate the lengthscale of a field of data by the FFT

USE DefConsTypes, ONLY :  &
  ZREAL8

USE nag_fft
USE nag_sym_fft

IMPLICIT NONE

REAL(ZREAL8), INTENT(IN)    :: dataset(1:nxpoints,1:nypoints)
INTEGER,      INTENT(IN)    :: nxpoints, nypoints
REAL(ZREAL8), INTENT(INOUT) :: xlength, ylength

REAL(ZREAL8)                :: fftx(1:nxpoints), ffty(1:nypoints)
REAL(ZREAL8)                :: trigx(1:2*nxpoints), trigy(1:2*nypoints)
REAL(ZREAL8)                :: Dummy_x(1:nxpoints), Dummy_y(1:nypoints)
REAL(ZREAL8)                :: mean_len_x(1:nypoints), mean_len_y(1:nxpoints), mean_len
REAL(ZREAL8)                :: this_len, nxpoints_r, nypoints_r, norm, weight
INTEGER                     :: k, xx, yy


nxpoints_r = REAL(nxpoints)
nypoints_r = REAL(nypoints)


! Deal with the x-direction
! -------------------------

CALL nag_fft_trig(trigx)

DO yy = 1, nypoints
  ! Do fft in x for this y value
  Dummy_x(1:nxpoints) = dataset(1:nxpoints,yy)
  fftx(1:nxpoints) = nag_fft_1d_real(Dummy_x(1:nxpoints), inverse=.false., trig=trigx)

  ! Treat fft^2 as a PDF - find the mean lengthscale
  mean_len = 0.0
  norm     = 0.0
  DO k = 1, nxpoints/2
    this_len = nxpoints_r / REAL(k)
    weight   = fftx(k) * fftx(k)
    mean_len = mean_len + weight * this_len
    norm     = norm + weight
  END DO
  mean_len_x(yy) = mean_len / (2.0 * norm)    ! Half wavelength
END DO

xlength = SUM(mean_len_x(1:nypoints)) / nypoints_r
  

! Deal with the y-direction
! -------------------------

CALL nag_fft_trig(trigy)

DO xx = 1, nxpoints
  ! Do fft in y for this x value
  Dummy_y(1:nypoints) = dataset(xx,1:nypoints)
  ffty(1:nypoints) = nag_fft_1d_real(Dummy_y(1:nypoints), inverse=.false., trig=trigy)

  ! Treat fft^2 as a PDF - find the mean lengthscale
  mean_len = 0.0
  norm     = 0.0
  DO k = 1, nypoints/2
    this_len = nypoints_r / REAL(k)
    weight   = ffty(k) * ffty(k)
    mean_len = mean_len + weight * this_len
    norm     = norm + weight
  END DO
  mean_len_y(xx) = mean_len / (2.0 * norm)    ! Half wavelength
END DO

ylength = SUM(mean_len_y(1:nxpoints)) / nxpoints_r


END SUBROUTINE Lscales_from_fft
!===================================================================================
