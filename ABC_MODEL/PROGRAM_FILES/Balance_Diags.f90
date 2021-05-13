 SUBROUTINE Balance_diagnostics(state, Dims)
 
 USE DefConsTypes
 USE nag_fft
 USE nag_sym_fft
 IMPLICIT NONE

 ! Declare variables
 TYPE(model_vars_type),       INTENT(INOUT)   :: state
 TYPE(Dimensions_type),       INTENT(IN)      :: Dims

 REAL(wp)                                     :: trig(2*nlongs),
 REAL(wp)                                     :: ztop, sin_fact
 
 INTEGER                                      :: i,k,j,m,z
 COMPLEX (wp)                                 :: hydro_spectral(1:nlevs, 1:nlongs)
 REAL (wp)                                    :: hydro_spect_real(1:nlevs, 1:nlongs)
 CALL nag_fft_trig(trig)
 ztop = 1.0/ Dims % full_levs(nlevs) 


 ! Calculate hydrostatic balance in spectral space
 !==================================================
 ! Horizontal transform
 !-----------------------
  hydro_spectral(1:nlevs, 1:nlongs) = nag_fft_1d_real &
                      (TRANSPOSE(state % hydro(1:nlongs, 1:nlevs)), inverse = .false., trig=trig)
 ! Vertical transform
 !-----------------------
 DO k = 1, nlongs                    
 ! For each horizontal wave number, k
  
   DO m = 1, nlevs                 
     mm = m - 1
     ! For each verical wave number, mm
          
     DO z = 1, nlevs             
     ! Integrate over levs
     ! Set factors
     sin_fact   = SIN( ( (mm + 0.5) *  pi * Dims % half_levs(z) * ztop ) ) 
     ! Summation
     hydro_spectral(1:nlevs, 1:nlongs) = ctrl_state_out % u(m,k) + 2.0 * ztop *                        &
                  (                                                                          &
                    (  ctrl_state_in % u(z,k)  )   *                                         &
                    sin_fact * ( Dims % full_levs(z) - Dims % full_levs(z-1))                & 
                  )          
     END DO
   END DO
 END DO

 ! Calculate absolute value
 !----------------------------
 DO k= 1,nlongs
   DO m = 1, nlevs
     hydro_spect_real(m,k) = ABS(hydro_spectral(m,k)
   END DO
 END DO
 
 ! Dump data
 !-----------
 
 
 
 ! Calculate geostrophic balance in spectral space
 !==================================================
!  geost_spectral(1:nlevs, 1:nlongs) = nag_fft_1d_real &
 !                     (TRANSPOSE(state % geost(1:nlongs, 1:nlevs)), inverse = .false., trig=trig)





 END SUBROUTINE Balance_diagnostics
