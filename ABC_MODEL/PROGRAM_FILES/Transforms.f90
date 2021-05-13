!===================================================================================================
! IN THIS FILE : Foward, inverse and adjoint transforms
!
! SUBROUTINE Hoz_Inv(statein, ctrl_state_out)
! SUBROUTINE Hoz_for(ctrl_state_in, stateout)
! SUBROUTINE Hoz_for_Adj(stateout_hat, ctrl_state_in_hat)
! SUBROUTINE Vert_Inv(ctrl_state_in, ctrl_state_out, Dims)
! SUBROUTINE Vert_For(ctrl_state_in, ctrl_state_out, Dims)
! SUBROUTINE Vert_For_Adj(ctrl_state_out_hat, ctrl_state_in_hat, Dims)
! SUBROUTINE Eig_inv(ctrl_state_in, ctrl_vect_out, EigVecs, gen_scale, std_eigvecs)
! SUBROUTINE Eig_for(ctrl_vect_in, ctrl_state_out, EigVecs, std_eigvecs)
! SUBROUTINE Eig_for_Adj(ctrl_state_out_hat, ctrl_vect_in_hat, EigVecs, std_eigvecs)
!
!===================================================================================================

!===================================================================================================
!***************************************************************************************************
!===================================================================================================

 SUBROUTINE Hoz_Inv(statein, ctrl_state_out)

 USE DefConsTypes
 USE nag_fft
 USE nag_sym_fft
 USE nag_gen_lin_sys
 USE nag_sym_lin_sys
 USE nag_sym_eig, ONLY : nag_sym_eig_all 

 IMPLICIT NONE

 ! Declare Top Level Variables
 !-----------------------------
 TYPE(model_vars_type),     INTENT(IN)        :: statein
 TYPE(transform_type),      INTENT(INOUT)     :: ctrl_state_out

 ! Declare Local Variables
 !-----------------------------
 REAL(wp)                                     :: trig(2*nlongs), phase, piovern
 COMPLEX(wp)                                  :: temp(1:nlevs, 1:nlongs) , negimag, imag
 INTEGER                                      :: k, ktemp,i,m,z

 ! Define some useful parameters
 !-------------------------------
 negimag = (0.0,-1.0)
 piovern = pi / REAL(nlongs) 
 imag = (0.0, 1.0) 
  

 ! Set trig for nag fft
 !----------------------
 CALL nag_fft_trig(trig)

 PRINT*, 'Inverse horizontal transform'

 ! H^{-1}-transform : Horizontal transform from model to control space 
 !----------------------------------------------------------------------
 ctrl_state_out % u = nag_fft_1d_real(TRANSPOSE(statein % u(1:nlongs, 1:nlevs)), inverse = .false., trig=trig)
 ctrl_state_out % v = nag_fft_1d_real(TRANSPOSE(statein % v(1:nlongs, 1:nlevs)), inverse = .false., trig=trig)
 ctrl_state_out % w = nag_fft_1d_real(TRANSPOSE(statein % w(1:nlongs, 1:nlevs)), inverse = .false., trig=trig)
 ctrl_state_out % r = nag_fft_1d_real(TRANSPOSE(statein % r(1:nlongs, 1:nlevs)), inverse = .false., trig=trig)
 ctrl_state_out % b = nag_fft_1d_real(TRANSPOSE(statein % b(1:nlongs, 1:nlevs)), inverse = .false., trig=trig)

 ! Swap left and right domains of transformed variables to have a symmetric function
 !-----------------------------------------------------------------------------------
 temp(1:nlevs, 1:nlongs)                          = (0.0, 0.0)
 temp(1:nlevs, 1:nlongs)                          = ctrl_state_out % u(1:nlevs, 1:nlongs)
 ctrl_state_out % u(1:nlevs, 1:nlongs)            = (0.0, 0.0)
 ctrl_state_out % u(1:nlevs, 1:(nlongs/2))        = temp(1:nlevs, (nlongs/2)+1:nlongs)
 ctrl_state_out % u(1:nlevs, (nlongs/2)+1:nlongs) = temp(1:nlevs, 1:(nlongs/2) )

 temp(1:nlevs, 1:nlongs)                          = (0.0, 0.0)
 temp(1:nlevs, 1:nlongs)                          = ctrl_state_out % v(1:nlevs, 1:nlongs)
 ctrl_state_out % v(1:nlevs, 1:nlongs)            = (0.0, 0.0)
 ctrl_state_out % v(1:nlevs, 1:(nlongs/2))        = temp(1:nlevs, (nlongs/2)+1:nlongs)
 ctrl_state_out % v(1:nlevs, (nlongs/2)+1:nlongs) = temp(1:nlevs, 1:(nlongs/2) )

 temp(1:nlevs, 1:nlongs)                          = (0.0, 0.0)
 temp(1:nlevs, 1:nlongs)                          = ctrl_state_out % w(1:nlevs, 1:nlongs)
 ctrl_state_out % w(1:nlevs, 1:nlongs)            = (0.0, 0.0)
 ctrl_state_out % w(1:nlevs, 1:(nlongs/2))        = temp(1:nlevs, (nlongs/2)+1:nlongs)
 ctrl_state_out % w(1:nlevs, (nlongs/2)+1:nlongs) = temp(1:nlevs, 1:(nlongs/2) )

 temp(1:nlevs, 1:nlongs)                          = (0.0, 0.0)
 temp(1:nlevs, 1:nlongs)                          = ctrl_state_out % r(1:nlevs, 1:nlongs)
 ctrl_state_out % r(1:nlevs, 1:nlongs)            = (0.0, 0.0)
 ctrl_state_out % r(1:nlevs, 1:(nlongs/2))        = temp(1:nlevs, (nlongs/2)+1:nlongs)
 ctrl_state_out % r(1:nlevs, (nlongs/2)+1:nlongs) = temp(1:nlevs, 1:(nlongs/2) )
 
 temp(1:nlevs, 1:nlongs)                          = (0.0, 0.0)
 temp(1:nlevs, 1:nlongs)                          = ctrl_state_out % b(1:nlevs, 1:nlongs)
 ctrl_state_out % b(1:nlevs, 1:nlongs)            = (0.0, 0.0)
 ctrl_state_out % b(1:nlevs, 1:(nlongs/2))        = temp(1:nlevs, (nlongs/2)+1:nlongs)
 ctrl_state_out % b(1:nlevs, (nlongs/2)+1:nlongs) = temp(1:nlevs, 1:(nlongs/2) )


 ! Convert to R, streamfunction and velocity potential
 !-----------------------------------------------------
 
 PRINT*, 'Inverse Helmholtz (variable transform)'

 ! M^{-1} transform: Inverse Helmholtz transform
 
 ! Multiply r
 !---------------
 ctrl_state_out % r = Cz * ctrl_state_out % r
 

 
 ! Convert u to velocity potential
 !----------------------------------
 
 DO k = 1, nlongs
    ktemp = k - 1 - (nlongs/2)
    phase = negimag * piovern * REAL(ktemp)
    IF (ktemp .EQ. 0) THEN
       ctrl_state_out % u(1:nlevs,k) = negimag * ctrl_state_out % u(1:nlevs,k)
     ELSE
       ctrl_state_out % u(1:nlevs,k) =  exp(phase) *                                           &
                                       ( negimag * ctrl_state_out % u(1:nlevs,k) * domain )    & 
                                        / (2.0*REAL(ktemp)*pi)   
    ENDIF
 ENDDO


 ! Convert v to streamfunction, include phase change to account for grid staggering
 !---------------------------------------------------------------------------------

 DO k = 1, nlongs
    ktemp = k - 1 - (nlongs/2)
    phase = negimag * piovern * REAL(ktemp)
    IF (ktemp .EQ. 0) THEN
       ctrl_state_out % v(:,k) = negimag *  ctrl_state_out % v(:,k)
 !      ctrl_state_out % v(:,k) =  ctrl_state_out % v(:,k)
    ELSE
 !      ctrl_state_out % v(:,k) = (negimag * ctrl_state_out % v (:,k)* domain ) / (2.0*(REAL(ktemp))*pi) 
       ctrl_state_out % v(:,k) = exp(phase) * (negimag * ctrl_state_out % v (:,k)* domain ) &
                                               / (2.0*(REAL(ktemp))*pi) 
    ENDIF
 ENDDO


END SUBROUTINE Hoz_Inv

!===================================================================================================
!***************************************************************************************************
!===================================================================================================

 SUBROUTINE Hoz_for(ctrl_state_in, stateout)

 USE DefConsTypes
 USE nag_fft
 USE nag_sym_fft
 USE nag_gen_lin_sys
 USE nag_sym_lin_sys
 USE nag_sym_eig, ONLY : nag_sym_eig_all


 IMPLICIT NONE

 ! Declare Top Level Variables
 !-----------------------------
 TYPE(transform_type),      INTENT(INOUT)     :: ctrl_state_in
 TYPE(model_vars_type),     INTENT(INOUT)     :: stateout
 
 ! Declare Local Variables
 !-----------------------------
 REAL(wp)                                     :: trig(2*nlongs), phase, piovern
 COMPLEX(wp)                                  :: temp(1:nlevs, 1:nlongs), imag
 COMPLEX(wp)                                  :: negimag, temp2(1:nlongs, 1:nlevs)
 INTEGER                                      :: k, ktemp,i,m,z, tmp,j
 
 negimag = (0.0,-1.0)
 piovern = pi / REAL(nlongs)
 imag = (0.0, 1.0) 
 
 !********************************************
 !***** STEP 7: CONVERT TO r, u and v *****
 !********************************************

 PRINT*, 'Forward Helmholtz transform'
 
 ! M-transform, forward Helmholtz transform
  
 ! Multiply r
 !---------------
 ctrl_state_in % r = ctrl_state_in % r / Cz
 
 ! Convert divergence to u
 !-------------------------
 DO k = 1, nlongs
     ktemp = k - 1 - (nlongs/2)
   phase = imag * piovern * REAL(ktemp)
   IF (ktemp .EQ. 0) THEN
     ctrl_state_in % u(1:nlevs,k) =  imag * ctrl_state_in % u(1:nlevs,k) 
  ELSE
     ctrl_state_in % u(1:nlevs,k) = exp(phase) * imag * 2.0 * (REAL(ktemp)) * pi * &
                                    ctrl_state_in % u(1:nlevs,k) / domain  
   ENDIF
 ENDDO

 ! Convert streamfunction to v
 !-------------------------------
 DO k = 1, nlongs
   ktemp = k - 1 - (nlongs/2)
   phase = imag * piovern * REAL(ktemp)
 IF (ktemp .EQ. 0) THEN
     ctrl_state_in % v(1:nlevs,k) =  imag * ctrl_state_in % v(1:nlevs,k) 
   ELSE
     ctrl_state_in % v(1:nlevs,k) = exp(phase) * imag * 2.0 *(REAL(ktemp))* pi * &
                                  ctrl_state_in % v(1:nlevs,k) / ( domain ) 
   ENDIF
 ENDDO

 !************************************************
 !***** STEP 8: FORWARD HORIZONTAL TRANSFORM *****
 !*****           CONTROL TO MODEL SPACE     *****
 !************************************************
 
 tmp = 0
  
 ! Swap domains
 !---------------
 temp(1:nlevs, 1:nlongs)                         = (0.0, 0.0)
 temp(1:nlevs, 1:nlongs)                         = ctrl_state_in % u(1:nlevs, 1:nlongs)
 ctrl_state_in % u(1:nlevs, 1:nlongs)            = (0.0, 0.0)
 ctrl_state_in % u(1:nlevs, 1:(nlongs/2))        = temp(1:nlevs, (nlongs/2)+1:nlongs)
 ctrl_state_in % u(1:nlevs, (nlongs/2)+1:nlongs) = temp(1:nlevs, 1:(nlongs/2) )

 temp(1:nlevs, 1:nlongs)                         = (0.0, 0.0)
 temp(1:nlevs, 1:nlongs)                         = ctrl_state_in % v(1:nlevs, 1:nlongs)
 ctrl_state_in % v(1:nlevs, 1:nlongs)            = (0.0, 0.0)
 ctrl_state_in % v(1:nlevs, 1:(nlongs/2))        = temp(1:nlevs, (nlongs/2)+1:nlongs)
 ctrl_state_in % v(1:nlevs, (nlongs/2)+1:nlongs) = temp(1:nlevs, 1:(nlongs/2) )

 temp(1:nlevs, 1:nlongs)                         = (0.0, 0.0)
 temp(1:nlevs, 1:nlongs)                         = ctrl_state_in % w(1:nlevs, 1:nlongs)
 ctrl_state_in % w(1:nlevs, 1:nlongs)            = (0.0, 0.0)
 ctrl_state_in % w(1:nlevs, 1:(nlongs/2))        = temp(1:nlevs, (nlongs/2)+1:nlongs)
 ctrl_state_in % w(1:nlevs, (nlongs/2)+1:nlongs) = temp(1:nlevs, 1:(nlongs/2) )

 temp(1:nlevs, 1:nlongs)                         = (0.0, 0.0)
 temp(1:nlevs, 1:nlongs)                         = ctrl_state_in % r(1:nlevs, 1:nlongs)
 ctrl_state_in % r(1:nlevs, 1:nlongs)            = (0.0, 0.0)
 ctrl_state_in % r(1:nlevs, 1:(nlongs/2))        = temp(1:nlevs, (nlongs/2)+1:nlongs)
 ctrl_state_in % r(1:nlevs, (nlongs/2)+1:nlongs) = temp(1:nlevs, 1:(nlongs/2) )
 
 temp(1:nlevs, 1:nlongs)                         = (0.0, 0.0)
 temp(1:nlevs, 1:nlongs)                         = ctrl_state_in % b(1:nlevs, 1:nlongs)
 ctrl_state_in % b(1:nlevs, 1:nlongs)            = (0.0, 0.0)
 ctrl_state_in % b(1:nlevs, 1:(nlongs/2))        = temp(1:nlevs, (nlongs/2)+1:nlongs)
 ctrl_state_in % b(1:nlevs, (nlongs/2)+1:nlongs) = temp(1:nlevs, 1:(nlongs/2) )
 
 CALL nag_fft_trig(trig)
 
 !j = 10
  
 !DO k = 1,180
 !  PRINT*, k, ctrl_state_in % r(j, k), 360 - k,  ctrl_state_in % r(j,360-k) 
 !END DO 
 
 
 PRINT*, 'Forward horizontal transform; k to x'
 ! H- transform: Forward horizontal transform.
 stateout % u(1:nlongs, 1:nlevs) = TRANSPOSE( nag_fft_1d_real((ctrl_state_in % u), inverse = .true., trig = trig))
! PRINT*, 'u'
 stateout % v(1:nlongs, 1:nlevs) = TRANSPOSE( nag_fft_1d_real((ctrl_state_in % v), inverse = .true., trig = trig))
! PRINT*, 'v'
 stateout % w(1:nlongs, 1:nlevs) = TRANSPOSE( nag_fft_1d_real((ctrl_state_in % w), inverse = .true., trig = trig))
! PRINT*, 'w'
 stateout % r(1:nlongs, 1:nlevs) = TRANSPOSE( nag_fft_1d_real((ctrl_state_in % r), inverse = .true., trig = trig))
! PRINT*, 'r'
 stateout % b(1:nlongs, 1:nlevs) = TRANSPOSE( nag_fft_1d_real((ctrl_state_in % b), inverse = .true., trig = trig))
! PRINT*, 'b'

END SUBROUTINE Hoz_for

!===================================================================================================
!***************************************************************************************************
!===================================================================================================

SUBROUTINE Hoz_for_Adj(stateout_hat, ctrl_state_in_hat)

USE DefConsTypes
USE nag_fft
USE nag_sym_fft
USE nag_gen_lin_sys
USE nag_sym_lin_sys
USE nag_sym_eig, ONLY : nag_sym_eig_all


IMPLICIT NONE

 ! Declare Top Level Variables
 !-----------------------------
 TYPE(transform_type),      INTENT(INOUT)     :: ctrl_state_in_hat
 TYPE(model_vars_type),     INTENT(INOUT)     :: stateout_hat
 
 ! Declare Local Variables
 !-----------------------------
 REAL(wp)      :: trig(2*nlongs), phase, piovern
 COMPLEX(wp)   :: temp(1:nlevs, 1:nlongs), imag, negimag
 INTEGER       :: k, ktemp,i,m,z
 
 negimag = (0.0,-1.0)
 piovern = pi / REAL(nlongs)
 imag = (0.0, 1.0) 
 
 ! Initialise Adjoint variables to zero
 !--------------------------------------
 CALL Initialise_transform_vars(ctrl_state_in_hat)
 
 PRINT*, 'Adjoint horizontal transform'
 
 CALL nag_fft_trig(trig)
 
 ! H^{T}- transform: Adjoint horizontal transform.
 !---------------------------------------------
 ctrl_state_in_hat % u(1:nlevs, 1:nlongs) = &
        nag_fft_1d_real(TRANSPOSE(stateout_hat % u(1:nlongs, 1:nlevs)), inverse = .false., trig=trig)
 ctrl_state_in_hat % v(1:nlevs, 1:nlongs) = &
        nag_fft_1d_real(TRANSPOSE(stateout_hat % v(1:nlongs, 1:nlevs)), inverse = .false., trig=trig)
 ctrl_state_in_hat % w(1:nlevs, 1:nlongs) = &
        nag_fft_1d_real(TRANSPOSE(stateout_hat % w(1:nlongs, 1:nlevs)), inverse = .false., trig=trig)
 ctrl_state_in_hat % b(1:nlevs, 1:nlongs) = &
        nag_fft_1d_real(TRANSPOSE(stateout_hat % b(1:nlongs, 1:nlevs)), inverse = .false., trig=trig)
 ctrl_state_in_hat % r(1:nlevs, 1:nlongs) = &
        nag_fft_1d_real(TRANSPOSE(stateout_hat % r(1:nlongs, 1:nlevs)), inverse = .false., trig=trig)

  ! Swap domains
 !---------------
 temp(1:nlevs, 1:nlongs)                           = (0.0, 0.0)
 temp(1:nlevs, 1:nlongs)                           = ctrl_state_in_hat % u(1:nlevs, 1:nlongs)
 ctrl_state_in_hat % u(1:nlevs, 1:nlongs)            = (0.0, 0.0)
 ctrl_state_in_hat % u(1:nlevs, 1:(nlongs/2))        = temp(1:nlevs, (nlongs/2)+1:nlongs)
 ctrl_state_in_hat % u(1:nlevs, (nlongs/2)+1:nlongs) = temp(1:nlevs, 1:(nlongs/2) )

 temp(1:nlevs, 1:nlongs)                           = (0.0, 0.0)
 temp(1:nlevs, 1:nlongs)                           = ctrl_state_in_hat % v(1:nlevs, 1:nlongs)
 ctrl_state_in_hat % v(1:nlevs, 1:nlongs)            = (0.0, 0.0)
 ctrl_state_in_hat % v(1:nlevs, 1:(nlongs/2))        = temp(1:nlevs, (nlongs/2)+1:nlongs)
 ctrl_state_in_hat % v(1:nlevs, (nlongs/2)+1:nlongs) = temp(1:nlevs, 1:(nlongs/2) )

 temp(1:nlevs, 1:nlongs)                           = (0.0, 0.0)
 temp(1:nlevs, 1:nlongs)                           = ctrl_state_in_hat % w(1:nlevs, 1:nlongs)
 ctrl_state_in_hat % w(1:nlevs, 1:nlongs)            = (0.0, 0.0)
 ctrl_state_in_hat % w(1:nlevs, 1:(nlongs/2))        = temp(1:nlevs, (nlongs/2)+1:nlongs)
 ctrl_state_in_hat % w(1:nlevs, (nlongs/2)+1:nlongs) = temp(1:nlevs, 1:(nlongs/2) )

 temp(1:nlevs, 1:nlongs)                           = (0.0, 0.0)
 temp(1:nlevs, 1:nlongs)                           = ctrl_state_in_hat % r(1:nlevs, 1:nlongs)
 ctrl_state_in_hat % r(1:nlevs, 1:nlongs)            = (0.0, 0.0)
 ctrl_state_in_hat % r(1:nlevs, 1:(nlongs/2))        = temp(1:nlevs, (nlongs/2)+1:nlongs)
 ctrl_state_in_hat % r(1:nlevs, (nlongs/2)+1:nlongs) = temp(1:nlevs, 1:(nlongs/2) )
 
 temp(1:nlevs, 1:nlongs)                           = (0.0, 0.0)
 temp(1:nlevs, 1:nlongs)                           = ctrl_state_in_hat % b(1:nlevs, 1:nlongs)
 ctrl_state_in_hat % b(1:nlevs, 1:nlongs)            = (0.0, 0.0)
 ctrl_state_in_hat % b(1:nlevs, 1:(nlongs/2))        = temp(1:nlevs, (nlongs/2)+1:nlongs)
 ctrl_state_in_hat % b(1:nlevs, (nlongs/2)+1:nlongs) = temp(1:nlevs, 1:(nlongs/2) )


 PRINT*, 'Adjoint Helmholtz transform'
 
 ! M-transform, Adjoint Helmholtz transform
  
 ! Multiply r
 !---------------
 ctrl_state_in_hat % r = ctrl_state_in_hat % r / Cz
 
 ! Convert divergence to u
 !-------------------------
 DO k = 1, nlongs
     ktemp = k - 1 - (nlongs/2)
   phase = imag * piovern * REAL(ktemp)
   IF (ktemp .EQ. 0) THEN
     ctrl_state_in_hat % u(1:nlevs,k) =  negimag * ctrl_state_in_hat % u(1:nlevs,k) 
  ELSE
     ctrl_state_in_hat % u(1:nlevs,k) = exp(phase) * negimag * 2.0 * (REAL(ktemp)) * pi * &
                                         ctrl_state_in_hat % u(1:nlevs,k) / domain  
   END IF
 END DO

 ! Convert streamfunction to v
 !-------------------------------
 DO k = 1, nlongs
   ktemp = k - 1 - (nlongs/2)
   phase = imag * piovern * REAL(ktemp)
 IF (ktemp .EQ. 0) THEN
     ctrl_state_in_hat % v(1:nlevs,k) =  negimag * ctrl_state_in_hat % v(1:nlevs,k) 
   ELSE
     ctrl_state_in_hat % v(1:nlevs,k) = exp(phase) * negimag * 2.0 *(REAL(ktemp))* pi * &
                                      ctrl_state_in_hat % v(1:nlevs,k) / ( domain ) 
   END IF
 END DO

 END SUBROUTINE Hoz_for_Adj

!===================================================================================================
!***************************************************************************************************
!===================================================================================================

SUBROUTINE Vert_Inv(ctrl_state_in, ctrl_state_out, Dims)

 !******************************
 !* INVERSE VERTICAL TRANSFORM *
 !*     MODEL TO CONTROL       *
 !******************************

USE DefConsTypes
USE nag_fft
USE nag_sym_fft
USE nag_gen_lin_sys
USE nag_sym_lin_sys
USE nag_sym_eig, ONLY : nag_sym_eig_all


IMPLICIT NONE

 ! Declare Top Level Variables
 !-----------------------------
 TYPE(transform_type),      INTENT(INOUT)     :: ctrl_state_in
 TYPE(Dimensions_type),     INTENT(IN)        :: Dims
 TYPE(transform_type),      INTENT(INOUT)     :: ctrl_state_out

 ! Declare Local Variables
 !-----------------------------

 REAL(wp)                                     :: trig(2*nlongs), phase, piovern
 COMPLEX(wp)                                  :: temp(1:nlevs, 1:nlongs), imag, negimag
 INTEGER                                      :: k, ktemp,i,m,z,mm
 REAL(wp)                                     :: ztop, ztop1, ztop_wb
 REAL(wp)                                     :: uv_sin_fact, wb_sin_fact, r_cos_fact
 
 ! Define useful parameters
 !--------------------------
 negimag = (0.0,-1.0)
 piovern = pi / REAL(nlongs)
 imag = (0.0, 1.0) 
 ztop = 1.0/ Dims % full_levs(nlevs) 
 
 ! V^{-1}-tranform : Inverse vertical transform
 !----------------------------------------------

 PRINT*, 'Inverse vertical transform'
 
 ! Initialise output to zero 
 CALL Initialise_transform_vars(ctrl_state_out)
 
 DO i = 1, nlongs                    
 ! For each horizontal wave number, k
  
   DO m = 1, nlevs                 
     mm = m - 1
     ! For each verical wave number, mm
          
     IF (mm .EQ. 0) THEN
       ztop1   = ztop 
       ztop_wb = 0.0
       ELSE
       ztop1   = ztop * 2.0
       ztop_wb = ztop * 2.0
     END IF
           
     DO z = 1, nlevs             
     ! Integrate over levs
     
     ! Set factors
       uv_sin_fact   = SIN( ( (mm + 0.5) *  pi * Dims % half_levs(z) * ztop ) ) 
       wb_sin_fact   = SIN( (    mm      *  pi * Dims % full_levs(z) * ztop ) ) 
       r_cos_fact    = COS( (    mm      *  pi * Dims % half_levs(z) * ztop ) ) 
       
	     ! Summation
       ctrl_state_out % u(m,i) = ctrl_state_out % u(m,i) + 2.0 * ztop *                      &
                  (                                                                          &
                    (  ctrl_state_in % u(z,i)  )   *                                         &
                    uv_sin_fact * ( Dims % full_levs(z) - Dims % full_levs(z-1))             & 
                  )          
       ctrl_state_out % v(m,i) = ctrl_state_out % v(m,i) +  2.0 * ztop  *                    &
                  (                                                                          &
                    (  ctrl_state_in % v(z,i)  )   *                                         &
                    uv_sin_fact * ( Dims % full_levs(z) - Dims % full_levs(z-1))             & 
                  )          

       IF (z.EQ.1) THEN        
	       ctrl_state_out % w(m,i) = ctrl_state_out % w(m,i) + ztop_wb *                       &
                  (                                                                          &
                    ( ctrl_state_in % w(z,i)  )  *                                           &
                    wb_sin_fact * ( Dims % half_levs(z) )                                    & 
                  )          
           
	       ctrl_state_out % b(m,i) = ctrl_state_out % b(m,i) + ztop_wb *                       &
                  (                                                                          &
                    ( ctrl_state_in % b(z,i)  ) *                                            &
                    wb_sin_fact * ( Dims % half_levs(z))                                     & 
                  )          
       ELSE
         ctrl_state_out % w(m,i) = ctrl_state_out % w(m,i) + ztop_wb *                       &
                  (                                                                          &
                    (  ctrl_state_in % w(z,i) ) *                                            &
                    wb_sin_fact * ( Dims % half_levs(z) - Dims % half_levs(z-1))             & 
                  )          
         ctrl_state_out % b(m,i) = ctrl_state_out % b(m,i) + ztop_wb *                       &
                  (                                                                          &
                    (  ctrl_state_in % b(z,i)  ) *                                           &
                    wb_sin_fact * ( Dims % half_levs(z) - Dims % half_levs(z-1))             & 
                  )          
       END IF
	  
  	   ctrl_state_out % r(m,i) = ctrl_state_out % r(m,i) + ztop1 *                           &
                  (                                                                          &
                    (  ctrl_state_in % r(z,i)  ) *                                           &
                    r_cos_fact * ( Dims % full_levs(z) - Dims % full_levs(z-1))              & 
                  )          
     END DO
   END DO
 END DO
 

END SUBROUTINE Vert_Inv

!===================================================================================================
!***************************************************************************************************
!===================================================================================================

 SUBROUTINE Vert_For(ctrl_state_in, ctrl_state_out, Dims)

 !******************************
 !* FORWARD VERTICAL TRANSFORM *
 !*     CONTROL TO MODEL       *
 !******************************

 USE DefConsTypes
 USE nag_fft
 USE nag_sym_fft
 USE nag_gen_lin_sys
 USE nag_sym_lin_sys
 USE nag_sym_eig, ONLY : nag_sym_eig_all


 IMPLICIT NONE

 ! Declare Top Level Variables
 !-----------------------------
 TYPE(transform_type),      INTENT(INOUT)     :: ctrl_state_in
 TYPE(transform_type),      INTENT(INOUT)     :: ctrl_state_out
 TYPE(Dimensions_type),     INTENT(IN)        :: Dims
 
 ! Declare Local Variables
 !-----------------------------
 REAL(wp)                                     :: trig(2*nlongs), phase, piovern
 COMPLEX(wp)                                  :: temp(1:nlevs, 1:nlongs), imag, negimag
 INTEGER                                      :: k, ktemp,i,m,z,mm
 REAL(wp)                                     :: ztop, ztop1
 REAL(wp)                                     :: uv_sin_fact, wb_sin_fact, r_cos_fact
 COMPLEX(wp)                                  :: tmp_u, tmp_v, tmp_w, tmp_b, tmp_r

 ! Define useful parameters
 !--------------------------
 negimag = (0.0,-1.0)
 piovern = pi / REAL(nlongs)
 imag = (0.0, 1.0) 
 ztop = 1.0/ Dims % full_levs(nlevs) 
 
 ! V^{-1}-tranform : Forward vertical transform  
 !----------------------------------------------
 
 PRINT*, 'Forward vertical transform'

 ! Initialise output to zero
 CALL Initialise_transform_vars(ctrl_state_out)
 
 DO k = 1, nlongs  
 ! For each horizontal wave number, k 
   DO z = 1, nlevs    
      ! For each vertical level z
   
      ! Set tmp values to zero 
      tmp_u = (0.0,0.0)
      tmp_v = (0.0,0.0)
      tmp_w = (0.0,0.0) 
      tmp_b = (0.0,0.0) 
      tmp_r = (0.0,0.0) 
      
      DO m = 1, nlevs         
        mm = m - 1     ! sum over all wave numbers, mm
	      ! Set factors
	      uv_sin_fact   = SIN(  ( (mm + 0.5) *  pi * Dims % half_levs(z) * ztop )) 
	      wb_sin_fact   = SIN(  (     mm     *  pi * Dims % full_levs(z) * ztop )) 
	      r_cos_fact    = COS(  (     mm     *  pi * Dims % half_levs(z) * ztop )) 
        ! Calculate summation
        tmp_u = tmp_u + ( ctrl_state_in % u(m,k) * uv_sin_fact   ) 
        tmp_v = tmp_v + ( ctrl_state_in % v(m,k) * uv_sin_fact   ) 
        tmp_w = tmp_w + ( ctrl_state_in % w(m,k) * wb_sin_fact   )      
        tmp_r = tmp_r + ( ctrl_state_in % r(m,k) * r_cos_fact    )      
        tmp_b = tmp_b + ( ctrl_state_in % b(m,k) * wb_sin_fact   )      
      ENDDO
    
      ! Reassign variables
      ctrl_state_out % u(z,k) = tmp_u
      ctrl_state_out % v(z,k) = tmp_v
      ctrl_state_out % w(z,k) = tmp_w 
      ctrl_state_out % b(z,k) = tmp_b
      ctrl_state_out % r(z,k) = tmp_r
   ENDDO
 ENDDO

END SUBROUTINE Vert_For

!===================================================================================================
!***************************************************************************************************
!===================================================================================================

 SUBROUTINE Vert_For_Adj(ctrl_state_out_hat, ctrl_state_in_hat, Dims)

 !******************************
 !* ADJOINT VERTICAL TRANSFORM *
 !*     CONTROL TO MODEL       *
 !******************************

 USE DefConsTypes
 USE nag_fft
 USE nag_sym_fft
 USE nag_gen_lin_sys
 USE nag_sym_lin_sys
 USE nag_sym_eig, ONLY : nag_sym_eig_all


 IMPLICIT NONE

 ! Declare Top Level Variables
 !-----------------------------
 TYPE(transform_type),      INTENT(INOUT)     :: ctrl_state_in_hat
 TYPE(transform_type),      INTENT(INOUT)     :: ctrl_state_out_hat
 TYPE(Dimensions_type),     INTENT(IN)        :: Dims
 
 ! Declare Local Variables
 !-----------------------------
 REAL(wp)                                     :: trig(2*nlongs), phase, piovern
 COMPLEX(wp)                                  :: temp(1:nlevs, 1:nlongs), imag, negimag
 INTEGER                                      :: k, ktemp,i,m,z,mm
 REAL(wp)                                     :: ztop, ztop1
 REAL(wp)                                     :: uv_sin_fact, wb_sin_fact, r_cos_fact
 COMPLEX(wp)                                  :: tmp_u, tmp_v, tmp_w, tmp_b, tmp_r

 negimag = (0.0,-1.0)
 piovern = pi / REAL(nlongs)
 imag = (0.0, 1.0) 
 ztop = 1.0/ Dims % full_levs(nlevs) 
 
 ! V^{T}-tranform : Adjoint vertical transform  
 !----------------------------------------------
 
 PRINT*, 'Adjoint of forward vertical transform'

 ! Initialise adjoint variable to zero
 CALL Initialise_transform_vars(ctrl_state_in_hat)

 DO k = 1, nlongs  
 ! For each horizontal wave number, k 
   DO m = 1, nlevs    
      mm = m - 1
      ! For each vertical level z
   
      ! Set tmp values to zero 
      tmp_u = (0.0,0.0)
      tmp_v = (0.0,0.0)
      tmp_w = (0.0,0.0) 
      tmp_b = (0.0,0.0) 
      tmp_r = (0.0,0.0) 
      
      DO z = 1, nlevs         
     !   mm = m - 1
	      ! sum over all wave numbers, mm
	      
	      ! Set factors
	      uv_sin_fact   = SIN(  ( (mm + 0.5) *  pi * Dims % half_levs(z) * ztop )) 
        wb_sin_fact   = SIN(  (     mm     *  pi * Dims % full_levs(z) * ztop )) 
	      r_cos_fact    = COS(  (     mm     *  pi * Dims % half_levs(z) * ztop )) 

        ! Calculate summation
        tmp_u = tmp_u + ( ctrl_state_out_hat % u(z,k) * uv_sin_fact ) 
        tmp_v = tmp_v + ( ctrl_state_out_hat % v(z,k) * uv_sin_fact ) 
        tmp_w = tmp_w + ( ctrl_state_out_hat % w(z,k) * wb_sin_fact ) 
        tmp_b = tmp_b + ( ctrl_state_out_hat % b(z,k) * wb_sin_fact ) 
        tmp_r = tmp_r + ( ctrl_state_out_hat % r(z,k) * r_cos_fact  ) 
     
      ENDDO
      ! Reassign variables
      ctrl_state_in_hat % u(m,k) = tmp_u
      ctrl_state_in_hat % v(m,k) = tmp_v
      ctrl_state_in_hat % w(m,k) = tmp_w 
      ctrl_state_in_hat % b(m,k) = tmp_b
      ctrl_state_in_hat % r(m,k) = tmp_r
   ENDDO
 ENDDO

 ! Truncate high wavenumbers
 !---------------------------
 !DO z = 10, nlevs
 !  ctrl_state_in_hat % u(z,:) = (0.0,0.0)
 !  ctrl_state_in_hat % v(z,:) = (0.0,0.0)
 !  ctrl_state_in_hat % w(z,:) = (0.0,0.0)
 !  ctrl_state_in_hat % b(z,:) = (0.0,0.0)
 !  ctrl_state_in_hat % r(z,:) = (0.0,0.0)
 !END DO


END SUBROUTINE Vert_For_Adj

!===================================================================================================
!***************************************************************************************************
!===================================================================================================

SUBROUTINE Eig_inv(ctrl_state_in, ctrl_vect_out, EigVecs, gen_scale, std_eigvecs)

 USE DefConsTypes
 USE nag_fft
 USE nag_sym_fft
 USE nag_gen_lin_sys
 USE nag_sym_lin_sys
 USE nag_sym_eig, ONLY : nag_sym_eig_all

 IMPLICIT NONE

 ! Declare Top Level Variables
 !-----------------------------
 TYPE(transform_type),  INTENT(INOUT)     :: ctrl_state_in
 REAL(wp),              INTENT(IN)        :: EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs)
 COMPLEX(wp),           INTENT(INOUT)     :: ctrl_vect_out(1:nvars*nlevs, 1:nlongs )
 REAL(wp),              INTENT(IN)        :: std_eigvecs(1:nvars*nlevs, 1:nlongs) 
 INTEGER,               INTENT(IN)        :: gen_scale

 ! Declare Local Variables
 !-----------------------------
 COMPLEX(wp)                              :: imag, negimag
 INTEGER                                  :: k, ktemp,i,m,z,mm,j, herm
 REAL(wp)                                 :: rho0, sqrtb, eps  
 !eps is short for epsilon and is a small number
 COMPLEX(wp)                              :: xvect(1:nvars*nlevs, 1:nlongs )
 REAL(wp)                                 :: ev_tmp_arr(1:nvars*nlevs, 1:nvars*nlevs) 
 COMPLEX(wp)                              :: x_tmp_arr(1:nvars*nlevs), ctrl_vect_tmp(1:nvars*nlevs)

 
 ! Initialise and define local variables
 !----------------------------------------
 
 ! Define useful variables
 !------------------------
 negimag = (0.0,-1.0)
 imag    = (0.0, 1.0) 
 rho0    = 1.0
 sqrtb   = sqrt(B * Cz * rho0)  
 eps     = 2E-18
 xvect(1:nvars*nlevs,1:nvars*nlevs)       = (0.0, 0.0)
 ev_tmp_arr(1:nvars*nlevs, 1:nvars*nlevs) = 0.0
 x_tmp_arr(1:nvars*nlevs)                 = (0.0, 0.0)
 ctrl_vect_tmp(1:nvars*nlevs)             = (0.0, 0.0)
 ctrl_vect_out(1:nvars*nlevs, 1:nlongs)   = 0.0 
 

 !********************************************
 !*****  STEP 4: EIGENVECTOR PROJECTION  *****
 !********************************************
 
 ! *** NOTE ***
 ! For this projection must have the variables in a specific order
 ! i.e. the variable "xvect" contains
 ! chi, psi, w, Rp and b in that order to maintain consistency with 
 ! the analytical linear analysis and therefore construction of the matrix of eigenvectors

 PRINT*, 'Inverse eigenvector Projection'

 DO k = 1,360  ! For each horizontal wavenumber

   ! Inverse symmetric scaling transform
   !----------------------------------------
   IF (k .EQ. 1) THEN
     PRINT*, 'Inverse symmetric scaling'
   END IF

   ktemp = k - 1 - (nlongs/2)
   IF (ktemp .EQ. 0) THEN
     ctrl_state_in % u(1:nlevs,k) = ctrl_state_in % u(1:nlevs,k)  * negimag 
     ctrl_state_in % w(1:nlevs,k) = ctrl_state_in % w(1:nlevs,k)  * negimag 
     ctrl_state_in % r(1:nlevs,k) = ctrl_state_in % r(1:nlevs,k) / sqrtb
     ctrl_state_in % b(1:nlevs,k) = ctrl_state_in % b(1:nlevs,k) / sqrt(Nsq)
   ELSE
     ctrl_state_in % u(1:nlevs,k) = ctrl_state_in % u(1:nlevs,k) * negimag 
     ctrl_state_in % w(1:nlevs,k) = ctrl_state_in % w(1:nlevs,k) &
                                        * negimag * domain /( 2 * REAL(ktemp) * pi)
     ctrl_state_in % r(1:nlevs,k) = ctrl_state_in % r(1:nlevs,k) &
                                        * domain / (2 *REAL(ktemp) * pi * sqrtb )
     ctrl_state_in % b(1:nlevs,k) = ctrl_state_in % b(1:nlevs,k) &
                                        * domain / (2 * REAL(ktemp) * pi * sqrt(Nsq))
   ENDIF

   ev_tmp_arr(1:nvars*nlevs, 1:nvars*nlevs) = EigVecs(k,1:nvars*nlevs,1:nvars*nlevs)   

   ! Use x_tmp_arr for MATMUL function
   DO  m = 1, nlevs
     x_tmp_arr(m)           = ctrl_state_in % u(m,k)
     x_tmp_arr(m + nlevs)   = ctrl_state_in % v(m,k)
     x_tmp_arr(m + 2*nlevs) = ctrl_state_in % w(m,k)
     x_tmp_arr(m + 3*nlevs) = ctrl_state_in % r(m,k)
     x_tmp_arr(m + 4*nlevs) = ctrl_state_in % b(m,k) 
   END DO

   ! Inverse Eigenvector projection
   !-----------------------------------
   IF (k .EQ. 1) THEN
     PRINT*, 'Inverse eigenvector projection'
   END IF

   ctrl_vect_tmp = MATMUL(TRANSPOSE(ev_tmp_arr),x_tmp_arr )
  
   IF (gen_scale .EQ. 1) THEN
 !   PRINT*, 'Generating scaling',gen_scale
     ctrl_vect_out(1:nvars*nlevs,k) = ctrl_vect_tmp(1:nvars*nlevs)
   ELSE 
  
     ! Inverse variance scaling
     !-------------------------------
     IF (k .EQ. 1) THEN
        PRINT*, 'Inverse variance scaling'
     END IF
      
     DO j = 1, nvars*nlevs
  !     PRINT*, k,'',j,'',std_eigvecs(j,k)
       !SCALING
       IF (std_eigvecs(j,k) .LT. eps) THEN
         ctrl_vect_out(j,k) = 0.0
        ELSE
         ctrl_vect_out(j,k) = ctrl_vect_tmp(j)/std_eigvecs(j, k)   
       END IF
       ! NO SCALING
!         ctrl_vect_out(j,k) = ctrl_vect_tmp(j)!/std_eigvecs(j, k)
     END DO
   END IF
   
 END DO      

 
 END SUBROUTINE Eig_inv

!===================================================================================================
!***************************************************************************************************
!===================================================================================================

 SUBROUTINE Eig_for(ctrl_vect_in, ctrl_state_out, EigVecs, std_eigvecs)

 USE DefConsTypes
 USE nag_fft
 USE nag_sym_fft
 USE nag_gen_lin_sys
 USE nag_sym_lin_sys
 USE nag_sym_eig, ONLY : nag_sym_eig_all

 IMPLICIT NONE

 ! Declare Top Level Variables
 !-----------------------------
 
 TYPE(transform_type),      INTENT(INOUT)     :: ctrl_state_out
 REAL(wp),                  INTENT(IN)        :: EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs)
 COMPLEX(wp),               INTENT(INOUT)     :: ctrl_vect_in(1:nvars*nlevs, 1:nlongs )
 REAL(wp),                  INTENT(INOUT)     :: std_eigvecs(1:nvars*nlevs, 1:nlongs) 
 ! Declare Local Variables
 !-----------------------------
 COMPLEX(wp)                                  :: imag, negimag
 REAL(wp)                                     :: rho0, sqrtb, recipdom
 INTEGER                                      :: k, ktemp,i,m,z,mm, kk, herm
 REAL(wp)                                     :: ev_tmp_arr(1:nvars*nlevs, 1:nvars*nlevs) 
 COMPLEX(wp)                                  :: x_tmp_arr(1:nvars*nlevs), ctrl_vect_tmp(1:nvars*nlevs)

 ! Initialise local variables
 !-----------------------------
 
 ! Define useful parameters
 !--------------------------
 negimag  = (0.0,-1.0)
 imag     = (0.0, 1.0) 
 rho0     = 1.0
 sqrtb    = sqrt(B * Cz * rho0)  
 recipdom = 1.0 / domain
 
 ev_tmp_arr(1:nvars*nlevs, 1:nvars*nlevs) = 0.0
 x_tmp_arr(1:nvars*nlevs)                 = (0.0, 0.0)
 ctrl_vect_tmp(1:nvars*nlevs)             = (0.0, 0.0)

 !==================================================================================================
 DO k = 1,nlongs
    ev_tmp_arr(1:nvars*nlevs, 1:nvars*nlevs) = EigVecs(k,1:nvars*nlevs,1:nvars*nlevs)
  
    !===============================================================================================
    !  Forward variance scaling
    !-----------------------------
       IF (k .EQ. 1) THEN
        PRINT*, 'Forward variance scaling'
      END IF
    
      DO z = 1,nvars*nlevs
      ! PRINT*, 'z ', z, 'eigscal: ', std_eigvecs(z,i)  
        ! SCALING
         ctrl_vect_tmp(z) = ctrl_vect_in(z,k)*std_eigvecs(z,k)     
        ! NO SCALING
!         ctrl_vect_tmp(z) = ctrl_vect_in(z,k)!*std_eigvecs(z,k)
      END DO
      
    !===============================================================================================

    !===============================================================================================
    ! Forward Eigenvector projection
    !------------------------------------
    IF (k .EQ. 1) THEN
      PRINT*, 'Forward eigenvector projection'
    END IF
    x_tmp_arr = MATMUL((ev_tmp_arr), ctrl_vect_tmp)
!    x_tmp_arr = ctrl_vect_tmp
  
    DO  m = 1, nlevs
      ctrl_state_out % u(m,k) = x_tmp_arr(m)              
      ctrl_state_out % v(m,k) = x_tmp_arr(m + nlevs)   
      ctrl_state_out % w(m,k) = x_tmp_arr(m + 2*nlevs) 
      ctrl_state_out % r(m,k) = x_tmp_arr(m + 3*nlevs) 
      ctrl_state_out % b(m,k) = x_tmp_arr(m + 4*nlevs)
    ENDDO
    !===============================================================================================

   ENDDO      
 !==================================================================================================

 
 !==================================================================================================
 herm = 1
 
 IF (herm .EQ. 1) THEN
   
   ! ENSURE EXACT HERMITIAN SEQUENCE
   !----------------------------------------- 

   DO m = 1, nlevs
    ctrl_state_out % u(m,1)   = REAL(ctrl_state_out % u(m,1))
    ctrl_state_out % u(m,181) = REAL(ctrl_state_out % u(m,181))
    ctrl_state_out % v(m,1)   = imag * (AIMAG(ctrl_state_out % v(m,1)))
    ctrl_state_out % v(m,181) = imag * (AIMAG(ctrl_state_out % v(m,181)))
    ctrl_state_out % w(m,1)   = imag * (AIMAG(ctrl_state_out % w(m,1)))
    ctrl_state_out % w(m,181) = imag * (AIMAG(ctrl_state_out % w(m,181)))
    ctrl_state_out % r(m,1)   = REAL(ctrl_state_out % r(m,1))
    ctrl_state_out % r(m,181) = REAL(ctrl_state_out % r(m,181))
    ctrl_state_out % b(m,1)   = REAL(ctrl_state_out % b(m,1))
    ctrl_state_out % b(m,181) = REAL(ctrl_state_out % b(m,181))
   ENDDO     


   DO m = 1, nlevs
   kk = 360
     DO k = 2,nlongs/2
      ctrl_state_out % u(m,kk) = -1.0 * CONJG(ctrl_state_out % u(m,k))
      ctrl_state_out % v(m,kk) =        CONJG(ctrl_state_out % v(m,k))
      ctrl_state_out % w(m,kk) =        CONJG(ctrl_state_out % w(m,k))
      ctrl_state_out % r(m,kk) = -1.0 * CONJG(ctrl_state_out % r(m,k))
      ctrl_state_out % b(m,kk) = -1.0 * CONJG(ctrl_state_out % b(m,k))
      kk = kk-1
     ENDDO
   ENDDO
  
 END IF
 !==================================================================================================


 !==================================================================================================
 ! Forward symmetric scaling transform
 !--------------------------------------------------------
 PRINT*, 'Forward symmetric scaling'
 DO k = 1, nlongs
     ktemp = k - 1 - (nlongs/2)
    IF (ktemp .EQ. 0) THEN
       ctrl_state_out % u(1:nlevs,k) = ctrl_state_out % u(1:nlevs,k) * imag
       ctrl_state_out % w(1:nlevs,k) = ctrl_state_out % w(1:nlevs,k) * imag
       ctrl_state_out % r(1:nlevs,k) = ctrl_state_out % r(1:nlevs,k) * sqrtb 
       ctrl_state_out % b(1:nlevs,k) = ctrl_state_out % b(1:nlevs,k) * sqrt(Nsq)
    ELSE
       ctrl_state_out % u(1:nlevs,k) = ctrl_state_out % u(1:nlevs,k) * imag
       ctrl_state_out % w(1:nlevs,k) = ctrl_state_out % w(1:nlevs,k)  *                  &
                                    2.0 * imag * REAL(ktemp) * pi * recipdom  
       ctrl_state_out % r(1:nlevs,k) = ctrl_state_out % r(1:nlevs,k) *                   &
                                   2.0 * pi * REAL(ktemp) * sqrtb * recipdom
       ctrl_state_out % b(1:nlevs,k) = ctrl_state_out % b(1:nlevs,k) *                   &
                                    2.0 * pi * REAL(ktemp) * sqrt(Nsq) * recipdom
   ENDIF
  ENDDO
 !==================================================================================================

 
 END SUBROUTINE Eig_for

!===================================================================================================
!***************************************************************************************************
!===================================================================================================

 SUBROUTINE Eig_for_Adj(ctrl_state_out_hat, ctrl_vect_in_hat, EigVecs, std_eigvecs)

 USE DefConsTypes
 USE nag_fft
 USE nag_sym_fft
 USE nag_gen_lin_sys
 USE nag_sym_lin_sys
 USE nag_sym_eig, ONLY : nag_sym_eig_all

 IMPLICIT NONE

 ! Declare Top Level Variables
 !-----------------------------
 
 TYPE(transform_type),      INTENT(INOUT)     :: ctrl_state_out_hat
 REAL(wp),                  INTENT(IN)        :: EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs)
 COMPLEX(wp),               INTENT(INOUT)     :: ctrl_vect_in_hat(1:nvars*nlevs, 1:nlongs )
 REAL(wp),                  INTENT(IN)        :: std_eigvecs(1:nvars*nlevs, 1:nlongs) 

 ! Declare Local Variables
 !-----------------------------
 COMPLEX(wp)                                  :: imag, negimag
 REAL(wp)                                     :: rho0, sqrtb, recipdom
 INTEGER                                      :: k, ktemp,i,m,z,mm, kk, herm, j
 REAL(wp)                                     :: ev_tmp_arr(1:nvars*nlevs, 1:nvars*nlevs) 
 COMPLEX(wp)                                  :: x_tmp_arr(1:nvars*nlevs), ctrl_vect_tmp(1:nvars*nlevs)

 ! Initialise local variables
 !-----------------------------
 
 ! Define useful parameters
 !--------------------------
 negimag  = (0.0,-1.0)
 imag     = (0.0, 1.0) 
 rho0     = 1.0
 sqrtb    = sqrt(B * Cz * rho0)  
 recipdom = 1.0 /domain
 
 ev_tmp_arr(1:nvars*nlevs, 1:nvars*nlevs) = 0.0
 x_tmp_arr(1:nvars*nlevs)                 = (0.0, 0.0)
 ctrl_vect_tmp(1:nvars*nlevs)             = (0.0, 0.0)
 
 ! Initialise Adjoint variables to zero
 !--------------------------------------
 ctrl_vect_in_hat(1:nvars*nlevs,1:nlongs) = (0.0,0.0)
 
 
 ! S-Transform : Forward symmetric scaling transform
 !--------------------------------------------------------

 DO k = 1,nlongs

   !=================================================================================================
   ! Symmetric Scaling
   !-----------------------
    IF (k .EQ. 1) THEN
      PRINT*, 'Adjoint Symmetric Scaling'
    END IF
    
    ktemp = k - 1 - (nlongs/2)
    IF (ktemp .EQ. 0) THEN
       ctrl_state_out_hat % u(1:nlevs,k) = ctrl_state_out_hat % u(1:nlevs,k) * negimag
       ctrl_state_out_hat % w(1:nlevs,k) = ctrl_state_out_hat % w(1:nlevs,k) * negimag
       ctrl_state_out_hat % r(1:nlevs,k) = ctrl_state_out_hat % r(1:nlevs,k) * sqrtb 
       ctrl_state_out_hat % b(1:nlevs,k) = ctrl_state_out_hat % b(1:nlevs,k) * sqrt(Nsq)
    ELSE
       ctrl_state_out_hat % u(1:nlevs,k) = ctrl_state_out_hat % u(1:nlevs,k) * negimag
!
       ctrl_state_out_hat % w(1:nlevs,k) = ctrl_state_out_hat % w(1:nlevs,k) *                  &
                                       2.0 * negimag * REAL(ktemp) * pi * recipdom
       ctrl_state_out_hat % r(1:nlevs,k) = ctrl_state_out_hat % r(1:nlevs,k) *                  &
                                        2.0 * pi * REAL(ktemp) * sqrtb * recipdom
       ctrl_state_out_hat % b(1:nlevs,k) = ctrl_state_out_hat % b(1:nlevs,k) *                  &
                                        2.0 * pi * REAL(ktemp) * sqrt(Nsq) * recipdom
    ENDIF
  
    ev_tmp_arr(1:nvars*nlevs, 1:nvars*nlevs) = EigVecs(k,1:nvars*nlevs,1:nvars*nlevs)  
     
    DO  m = 1, nlevs
      x_tmp_arr(m)           = ctrl_state_out_hat % u(m,k) 
      x_tmp_arr(m + nlevs)   = ctrl_state_out_hat % v(m,k)    
      x_tmp_arr(m + 2*nlevs) = ctrl_state_out_hat % w(m,k) 
      x_tmp_arr(m + 3*nlevs) = ctrl_state_out_hat % r(m,k) 
      x_tmp_arr(m + 4*nlevs) = ctrl_state_out_hat % b(m,k)
    ENDDO
  !===============================================================================================
     
  !===============================================================================================
  ! Adjoint Eigenvector projection
  !-------------------------------------------------
    IF (k .EQ. 1) THEN
      PRINT*, 'Adjoint eigenvector projection'
    END IF
        ctrl_vect_tmp = MATMUL(TRANSPOSE(ev_tmp_arr), x_tmp_arr)
 !   ctrl_vect_tmp =  x_tmp_arr
  !=================================================================================================
     
  !=================================================================================================
  ! Adjoint variance scaling
  !-------------------------------------------------
     IF (k .EQ. 1) THEN
        PRINT*, 'Adjoint variance scaling'
     END IF
 
      DO j = 1, nvars*nlevs
        ctrl_vect_in_hat(j,k) = ctrl_vect_tmp(j)*std_eigvecs(j,k)
!        ctrl_vect_in_hat(j,k) = ctrl_vect_tmp(j)
      END DO 
    
  !=================================================================================================
   
   ENDDO    ! End loop over horizontal wave numbers   
 
  
 END SUBROUTINE Eig_for_Adj

!===================================================================================================
!***************************************************************************************************
!===================================================================================================

