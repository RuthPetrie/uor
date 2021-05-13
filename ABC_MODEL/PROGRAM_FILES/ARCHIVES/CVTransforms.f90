SUBROUTINE Hoz_Inv(statein, ctrlstateout)

USE DefConsTypes
USE nag_fft
USE nag_sym_fft
USE nag_gen_lin_sys
USE nag_sym_lin_sys
USE nag_sym_eig, ONLY : nag_sym_eig_all


IMPLICIT NONE

 ! Declare Top lev Variables
 !-----------------------------
 TYPE(model_vars_type),           INTENT(IN)        :: statein
 TYPE(transform_type),      INTENT(INOUT)     :: ctrlstateout

 ! Declare Local Variables
 !-----------------------------
 REAL(wp)      :: trig(2*nlongs), phase, piovern
 COMPLEX(wp)   :: temp(1:nlevs, 1:nlongs) , negimag, imag
 INTEGER       :: k, ktemp,i,m,z

 negimag = (0.0,-1.0)
 piovern = pi / REAL(nlongs) 
 imag = (0.0, 1.0) 
  

 ! Set trig for nag fft
 !----------------------
 CALL nag_fft_trig(trig)

 PRINT*, 'Performing inverse horizontal transform; x to k'

 ! H^{-1}-transform : Horizontal transform from model to control space 
 ctrlstateout % u    = nag_fft_1d_real(TRANSPOSE(statein % u(1:nlongs, 1:nlevs))   , inverse = .false., trig=trig)
 ctrlstateout % v    = nag_fft_1d_real(TRANSPOSE(statein % v(1:nlongs, 1:nlevs))   , inverse = .false., trig=trig)
 ctrlstateout % w    = nag_fft_1d_real(TRANSPOSE(statein % w(1:nlongs, 1:nlevs))   , inverse = .false., trig=trig)
 ctrlstateout % b   = nag_fft_1d_real(TRANSPOSE(statein % b(1:nlongs, 1:nlevs))  , inverse = .false., trig=trig)
 ctrlstateout % r = nag_fft_1d_real(TRANSPOSE(statein % r(1:nlongs, 1:nlevs)), inverse = .false., trig=trig)

 temp(:,:) = 0.0
 temp = ctrlstateout % u
 ctrlstateout % u(:,:) = 0.0
 ctrlstateout % u(:, 1:(nlongs/2)) = temp(:, (nlongs/2)+1:nlongs)
 ctrlstateout % u(:, (nlongs/2)+1:nlongs) = temp(:, 1:(nlongs/2) )

 temp(:,:) = 0.0
 temp = ctrlstateout % v
 ctrlstateout % v(:,:) = 0.0
 ctrlstateout % v(:, 1:(nlongs/2)) = temp(:, (nlongs/2)+1:nlongs)
 ctrlstateout % v(:, (nlongs/2)+1:nlongs) = temp(:, 1:(nlongs/2) )

 temp(:,:) = 0.0
 temp = ctrlstateout % w
 ctrlstateout % w(:,:) = 0.0
 ctrlstateout % w(:, 1:(nlongs/2)) = temp(:, (nlongs/2)+1:nlongs)
 ctrlstateout % w(:, (nlongs/2)+1:nlongs) = temp(:, 1:(nlongs/2) )

 temp(:,:) = 0.0
 temp = ctrlstateout % r
 ctrlstateout % r(:,:) = 0.0
 ctrlstateout % r(:, 1:(nlongs/2)) = temp(:, (nlongs/2)+1:nlongs)
 ctrlstateout % r(:, (nlongs/2)+1:nlongs) = temp(:, 1:(nlongs/2) )
 
 temp(:,:) = 0.0
 temp = ctrlstateout % b
 ctrlstateout % b(:,:) = 0.0
 ctrlstateout % b(:, 1:(nlongs/2)) = temp(:, (nlongs/2)+1:nlongs)
 ctrlstateout % b(:, (nlongs/2)+1:nlongs) = temp(:, 1:(nlongs/2) )


 !****************************************
 !***** CONVERT TO R, STREAMFUNCTION *****
 !*****       AND DIVERGENCE         *****
 !****************************************
 
 PRINT*, 'Inverse Helmholtz (variable transform)'

 ! M^{-1} transform: Inverse Helmholtz transform
 
 ! Multiply r
 !---------------
 ctrlstateout % r = Cz * ctrlstateout % r
 
 ! Convert u to divergence
 !-------------------------
 DO k = 1, nlongs
    ktemp = k - 1 - (nlongs/2)
    IF (ktemp .EQ. 0) THEN
       ctrlstateout % u(:,k) =  ctrlstateout % u(:,k)
     ELSE
       ctrlstateout % u(:,k) = (ctrlstateout % u(:,k) * domain ) / (2.0*REAL(ktemp)*pi)
    ENDIF
 ENDDO

 ! Convert v to streamfunction
 !-----------------------------
 ! Include phase change to account for grid staggering

 DO k = 1, nlongs
    ktemp = k - 1 - (nlongs/2)
    phase = negimag * piovern * REAL(ktemp)
    IF (ktemp .EQ. 0) THEN
       ctrlstateout % v(:,k) = negimag *  ctrlstateout % v(:,k)
 !      ctrlstateout % v(:,k) =  ctrlstateout % v(:,k)
    ELSE
!       ctrlstateout % v(:,k) = (negimag * ctrlstateout % v (:,k)* domain ) / (2.0*(REAL(ktemp))*pi) 
       ctrlstateout % v(:,k) = exp(phase) * (negimag * ctrlstateout % v (:,k)* domain ) / (2.0*(REAL(ktemp))*pi) 
    ENDIF
 ENDDO

END SUBROUTINE Hoz_Inv

!================================================================================================

!================================================================================================
SUBROUTINE Hoz_for(ctrlstatein, stateout)

USE DefConsTypes
USE nag_fft
USE nag_sym_fft
USE nag_gen_lin_sys
USE nag_sym_lin_sys
USE nag_sym_eig, ONLY : nag_sym_eig_all


IMPLICIT NONE

 ! Declare Top lev Variables
 !-----------------------------
 TYPE(transform_type),      INTENT(INOUT)     :: ctrlstatein
 TYPE(model_vars_type),           INTENT(INOUT)     :: stateout
 
 ! Declare Local Variables
 !-----------------------------
 REAL(wp)      :: trig(2*nlongs), phase, piovern
 COMPLEX(wp)   :: temp(1:nlevs, 1:nlongs), imag, negimag, temp2(1:nlongs, 1:nlevs)
 INTEGER       :: k, ktemp,i,m,z
 
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
 ctrlstatein % r = ctrlstatein % r / Cz
 
 ! Convert divergence to u
 !-------------------------
 DO k = 1, nlongs
     ktemp = k - 1 - (nlongs/2)
   IF (ktemp .EQ. 0) THEN
     ctrlstatein % u(:,k) =  ctrlstatein % u(:,k) 
  ELSE
     ctrlstatein % u(:,k) = 2.0 * (REAL(ktemp)) * pi * ctrlstatein % u(:,k) / domain  
   ENDIF
 ENDDO

 ! Convert streamfunction to v
 !-------------------------------
 DO k = 1, nlongs
   ktemp = k - 1 - (nlongs/2)
   phase = imag * piovern * REAL(ktemp)
 IF (ktemp .EQ. 0) THEN
     ctrlstatein % v(:,k) =  imag * ctrlstatein % v(:,k) 
   ELSE
     ctrlstatein % v(:,k) = exp(phase) * imag * 2.0 *(REAL(ktemp))* pi * ctrlstatein % v(:,k) / ( domain ) 
   ENDIF
 ENDDO

 !************************************************
 !***** STEP 8: FORWARD HORIZONTAL TRANSFORM *****
 !*****           CONTROL TO MODEL SPACE     *****
 !************************************************
 temp(:,:) = (0.0,0.0)
 temp = ctrlstatein % u
 ctrlstatein % u(:,:) = (0.0,0.0)
 ctrlstatein % u(:, 1:(nlongs/2)) = temp(:, (nlongs/2)+1:nlongs)
 ctrlstatein % u(:, (nlongs/2)+1:nlongs) = temp(:, 1:(nlongs/2) )
 
 temp(:,:) = (0.0,0.0)
 temp = ctrlstatein % v
 ctrlstatein % v(:,:) = (0.0,0.0)
 ctrlstatein % v(:, 1:(nlongs/2)) = temp(:, (nlongs/2)+1:nlongs)
 ctrlstatein % v(:, (nlongs/2)+1:nlongs) = temp(:, 1:(nlongs/2) )

 temp(:,:) = (0.0,0.0)
 temp = ctrlstatein % w
 ctrlstatein % w(:,:) = (0.0,0.0)
 ctrlstatein % w(:, 1:(nlongs/2)) = temp(:, (nlongs/2)+1:nlongs)
 ctrlstatein % w(:, (nlongs/2)+1:nlongs) = temp(:, 1:(nlongs/2) )
 
 temp(:,:) = (0.0,0.0)
 temp = ctrlstatein % r
 ctrlstatein % r(:,:) = (0.0,0.0)
 ctrlstatein % r(:, 1:(nlongs/2)) = temp(:, (nlongs/2)+1:nlongs)
 ctrlstatein % r(:, (nlongs/2)+1:nlongs) = temp(:, 1:(nlongs/2) )
 
 temp(:,:) = (0.0,0.0)
 temp = ctrlstatein % b
 ctrlstatein % b(:,:) = (0.0,0.0)
 ctrlstatein % b(:, 1:(nlongs/2)) = temp(:, (nlongs/2)+1:nlongs)
 ctrlstatein % b(:, (nlongs/2)+1:nlongs) = temp(:, 1:(nlongs/2) )

 CALL nag_fft_trig(trig)
 
 PRINT*, 'Forward horizontal transform; k to x'
 ! H- transform: Forward horizontal transform.
 stateout % u(1:nlongs, 1:nlevs)    = &
         TRANSPOSE( nag_fft_1d_real((ctrlstatein % u),    inverse = .true., trig = trig))
 stateout % v(1:nlongs, 1:nlevs)    = &
         TRANSPOSE( nag_fft_1d_real((ctrlstatein % v),    inverse = .true., trig = trig))
 stateout % w(1:nlongs, 1:nlevs)    = &
         TRANSPOSE( nag_fft_1d_real((ctrlstatein % w),    inverse = .true., trig = trig))
 stateout % b(1:nlongs, 1:nlevs)   = &
         TRANSPOSE( nag_fft_1d_real((ctrlstatein % b),   inverse = .true., trig = trig))
 stateout % r(1:nlongs, 1:nlevs) = &
         TRANSPOSE( nag_fft_1d_real((ctrlstatein % r), inverse = .true., trig = trig))

END SUBROUTINE Hoz_for

!================================================================================================

!================================================================================================
SUBROUTINE Hoz_for_Adj(stateout_hat, ctrlstatein_hat)

USE DefConsTypes
USE nag_fft
USE nag_sym_fft
USE nag_gen_lin_sys
USE nag_sym_lin_sys
USE nag_sym_eig, ONLY : nag_sym_eig_all


IMPLICIT NONE

 ! Declare Top lev Variables
 !-----------------------------
 TYPE(transform_type),      INTENT(INOUT)     :: ctrlstatein_hat
 TYPE(model_vars_type),           INTENT(INOUT)     :: stateout_hat
 
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
 ctrlstatein_hat % u(1:nlevs, 1:nlongs)    = 0.0
 ctrlstatein_hat % v(1:nlevs, 1:nlongs)    = 0.0
 ctrlstatein_hat % w(1:nlevs, 1:nlongs)    = 0.0
 ctrlstatein_hat % b(1:nlevs, 1:nlongs)   = 0.0
 ctrlstatein_hat % r(1:nlevs, 1:nlongs) = 0.0

 
 
 PRINT*, 'ADJOINT HORIZONTAL TRANSFORM'
 
  CALL nag_fft_trig(trig)
 
 ! H^{T}- transform: Adjoint horizontal transform.
 !---------------------------------------------
 ctrlstatein_hat % u(1:nlevs, 1:nlongs)    = &
        nag_fft_1d_real(TRANSPOSE(stateout_hat % u(1:nlongs, 1:nlevs))   , inverse = .false., trig=trig)
 ctrlstatein_hat % v(1:nlevs, 1:nlongs)    = &
        nag_fft_1d_real(TRANSPOSE(stateout_hat % v(1:nlongs, 1:nlevs))   , inverse = .false., trig=trig)
 ctrlstatein_hat % w(1:nlevs, 1:nlongs)    = &
        nag_fft_1d_real(TRANSPOSE(stateout_hat % w(1:nlongs, 1:nlevs))   , inverse = .false., trig=trig)
 ctrlstatein_hat % b(1:nlevs, 1:nlongs)   = &
        nag_fft_1d_real(TRANSPOSE(stateout_hat % b(1:nlongs, 1:nlevs))  , inverse = .false., trig=trig)
 ctrlstatein_hat % r(1:nlevs, 1:nlongs) = &
        nag_fft_1d_real(TRANSPOSE(stateout_hat % r(1:nlongs, 1:nlevs)), inverse = .false., trig=trig)


 temp(:,:) = 0.0
 temp = ctrlstatein_hat % u
 ctrlstatein_hat % u(:,:) = 0.0
 ctrlstatein_hat % u(:, 1:(nlongs/2)) = temp(:, (nlongs/2)+1:nlongs)
 ctrlstatein_hat % u(:, (nlongs/2)+1:nlongs) = temp(:, 1:(nlongs/2) )
 
 temp(:,:) = 0.0
 temp = ctrlstatein_hat % v
 ctrlstatein_hat % v(:,:) = 0.0
 ctrlstatein_hat % v(:, 1:(nlongs/2)) = temp(:, (nlongs/2)+1:nlongs)
 ctrlstatein_hat % v(:, (nlongs/2)+1:nlongs) = temp(:, 1:(nlongs/2) )

 temp(:,:) = 0.0
 temp = ctrlstatein_hat % w
 ctrlstatein_hat % w(:,:) = 0.0
 ctrlstatein_hat % w(:, 1:(nlongs/2)) = temp(:, (nlongs/2)+1:nlongs)
 ctrlstatein_hat % w(:, (nlongs/2)+1:nlongs) = temp(:, 1:(nlongs/2) )
 
 temp(:,:) = 0.0
 temp = ctrlstatein_hat % r
 ctrlstatein_hat % r(:,:) = 0.0
 ctrlstatein_hat % r(:, 1:(nlongs/2)) = temp(:, (nlongs/2)+1:nlongs)
 ctrlstatein_hat % r(:, (nlongs/2)+1:nlongs) = temp(:, 1:(nlongs/2) )
 
! temp(:,:) = 0.0
! temp = ctrlstatein_hat % b
! ctrlstatein_hat % b(:,:) = 0.0
! ctrlstatein_hat % b(:, 1:(nlongs/2)) = temp(:, (nlongs/2)+1:nlongs)
! ctrlstatein_hat % b(:, (nlongs/2)+1:nlongs) = temp(:, 1:(nlongs/2) )

 PRINT*, 'Adjoint Helmholtz transform'
 
 ! M-transform, Adjoint Helmholtz transform
  
 ! Multiply r
 !---------------
 ctrlstatein_hat % r = ctrlstatein_hat % r / Cz
 
 ! Convert divergence to u
 !-------------------------
 DO k = 1, nlongs
     ktemp = k - 1 - (nlongs/2)
   IF (ktemp .EQ. 0) THEN
     ctrlstatein_hat % u(:,k) =  ctrlstatein_hat % u(:,k) 
  ELSE
     ctrlstatein_hat % u(:,k) = 2.0 * (REAL(ktemp)) * pi * ctrlstatein_hat % u(:,k) / domain  
   ENDIF
 ENDDO

 ! Convert streamfunction to v
 !-------------------------------
 DO k = 1, nlongs
   ktemp = k - 1 - (nlongs/2)
   phase = imag * piovern * REAL(ktemp)
 IF (ktemp .EQ. 0) THEN
     ctrlstatein_hat % v(:,k) =  negimag * ctrlstatein_hat % v(:,k) 
   ELSE
     ctrlstatein_hat % v(:,k) = exp(phase) * negimag * 2.0 *(REAL(ktemp))* pi * ctrlstatein_hat % v(:,k) / ( domain ) 
   ENDIF
 ENDDO

 END SUBROUTINE Hoz_for_Adj

!================================================================================================

!================================================================================================
SUBROUTINE Vert_Inv(ctrlstatein, ctrlstateout, Dims)

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

 ! Declare Top lev Variables
 !-----------------------------
 TYPE(transform_type),      INTENT(INOUT)     :: ctrlstatein
 TYPE(Dimensions_type),     INTENT(IN)        :: Dims
 TYPE(transform_type),      INTENT(INOUT)     :: ctrlstateout
 ! Declare Local Variables
 !-----------------------------

 REAL(wp)                                     :: trig(2*nlongs), phase, piovern
 COMPLEX(wp)                                  :: temp(1:nlevs, 1:nlongs), imag, negimag
 INTEGER                                      :: k, ktemp,i,m,z,mm
 REAL(wp)                                     :: ztop, ztop1, ztop_wb
 REAL(wp)                                     :: uv_sin_fact, wb_sin_fact, r_cos_fact
 negimag = (0.0,-1.0)
 piovern = pi / REAL(nlongs)
 imag = (0.0, 1.0) 
 ztop = 1.0/ Dims % full_levs(nlevs) 
 
 ! V^{-1}-tranform : Inverse vertical transform
 !----------------------------------------------

 PRINT*, 'Performing inverse vertical transform; z to m'
 
 ! Initialise output to zero 
 ctrlstateout % u(1:nlevs, 1:nlongs)    = (0.0,0.0)  
 ctrlstateout % v(1:nlevs, 1:nlongs)    = (0.0,0.0) 
 ctrlstateout % w(1:nlevs, 1:nlongs)    = (0.0,0.0) 
 ctrlstateout % b(1:nlevs, 1:nlongs)   = (0.0,0.0)  
 ctrlstateout % r(1:nlevs, 1:nlongs) = (0.0,0.0)  
 
 DO i = 1, nlongs                    
 ! For each horizontal wave number, k
  
   DO m = 1, nlevs                 
     mm = m - 1
     ! For each verical wave number, mm
          
     IF (mm .EQ. 0) THEN
       ztop1 = ztop 
       ztop_wb = 0.0
       ELSE
       ztop1 = ztop * 2.0
       ztop_wb = ztop * 2.0
     ENDIF
           
     DO z = 1, nlevs             
     ! Integrate over levs
     
     ! Set factors
       uv_sin_fact   = SIN( ( (mm + 0.5) *  pi * Dims % half_levs(z) * ztop ) ) 
       wb_sin_fact   = SIN( (    mm      *  pi * Dims % full_levs(z) * ztop ) ) 
       r_cos_fact = COS( (    mm      *  pi * Dims % half_levs(z) * ztop ) ) 
       
	     ! Summation
       ctrlstateout % u(m,i) = ctrlstateout % u(m,i) + 2.0 * ztop *                          &
                  (                                                                          &
                    (  ctrlstatein % u(z,i)  )   *                                           &
                    uv_sin_fact * ( Dims % full_levs(z) - Dims % full_levs(z-1))         & 
                  )          
       ctrlstateout % v(m,i) = ctrlstateout % v(m,i) +  2.0 * ztop  *                        &
                  (                                                                          &
                    (  ctrlstatein % v(z,i)  )   *                                           &
                    uv_sin_fact * ( Dims % full_levs(z) - Dims % full_levs(z-1))         & 
                  )          

       IF (z.EQ.1) THEN        
	       ctrlstateout % w(m,i) = ctrlstateout % w(m,i) + ztop_wb *                           &
                  (                                                                          &
                    ( ctrlstatein % w(z,i)  )  *                                             &
                    wb_sin_fact * ( Dims % half_levs(z) )                                  & 
                  )          
           
	       ctrlstateout % b(m,i) = ctrlstateout % b(m,i) + ztop_wb *                         &
                  (                                                                          &
                    ( ctrlstatein % b(z,i)  ) *                                             &
                    wb_sin_fact * ( Dims % half_levs(z))                                   & 
                  )          
       ELSE
         ctrlstateout % w(m,i) = ctrlstateout % w(m,i) + ztop_wb *                           &
                  (                                                                          &
                    (  ctrlstatein % w(z,i) ) *                                              &
                    wb_sin_fact * ( Dims % half_levs(z) - Dims % half_levs(z-1))         & 
                  )          
         ctrlstateout % b(m,i) = ctrlstateout % b(m,i) + ztop_wb *                         &
                  (                                                                          &
                    (  ctrlstatein % b(z,i)  ) *                                            &
                    wb_sin_fact * ( Dims % half_levs(z) - Dims % half_levs(z-1))         & 
                  )          
       ENDIF
	  
  	   ctrlstateout % r(m,i) = ctrlstateout % r(m,i) + ztop1 *                         &
                  (                                                                          &
                    (  ctrlstatein % r(z,i)  ) *                                          &
                    r_cos_fact * ( Dims % full_levs(z) - Dims % full_levs(z-1))       & 
                  )          
     ENDDO
   ENDDO
 ENDDO
 

END SUBROUTINE Vert_Inv


!================================================================================================
 SUBROUTINE Vert_For(ctrlstatein, ctrlstateout, Dims)

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

 ! Declare Top lev Variables
 !-----------------------------
 TYPE(transform_type),      INTENT(INOUT)     :: ctrlstatein
 TYPE(transform_type),      INTENT(INOUT)     :: ctrlstateout
 TYPE(Dimensions_type),     INTENT(IN)        :: Dims
 
 ! Declare Local Variables
 !-----------------------------
 REAL(wp)                                     :: trig(2*nlongs), phase, piovern
 COMPLEX(wp)                                  :: temp(1:nlevs, 1:nlongs), imag, negimag
 INTEGER                                      :: k, ktemp,i,m,z,mm
 REAL(wp)                                     :: ztop, ztop1
 REAL(wp)                                     :: uv_sin_fact, wb_sin_fact, r_cos_fact
 COMPLEX(wp)                                  :: tmp_u, tmp_v, tmp_w, tmp_b, tmp_rp

 negimag = (0.0,-1.0)
 piovern = pi / REAL(nlongs)
 imag = (0.0, 1.0) 
 ztop = 1.0/ Dims % full_levs(nlevs) 
 
 ! V^{-1}-tranform : Forward vertical transform  
 !----------------------------------------------
 
 PRINT*, 'Performing Forward vertical transform; z to m'

 ! Initialise output to zero
 ctrlstateout % u(1:nlevs, 1:nlongs)    = (0.0,0.0)
 ctrlstateout % v(1:nlevs, 1:nlongs)    = (0.0,0.0)
 ctrlstateout % w(1:nlevs, 1:nlongs)    = (0.0,0.0) 
 ctrlstateout % b(1:nlevs, 1:nlongs)   = (0.0,0.0) 
 ctrlstateout % r(1:nlevs, 1:nlongs) = (0.0,0.0) 

 DO k = 1, nlongs  
 ! For each horizontal wave number, k 
   DO z = 1, nlevs    
      ! For each vertical lev z
   
      ! Set tmp values to zero 
      tmp_u  = (0.0,0.0)
      tmp_v  = (0.0,0.0)
      tmp_w  = (0.0,0.0) 
      tmp_b = (0.0,0.0) 
      tmp_rp = (0.0,0.0) 
      
      DO m = 1, nlevs         
        mm = m - 1
	      ! sum over all wave numbers, mm
	      
	      ! Set factors
	      uv_sin_fact   = SIN(  ( (mm + 0.5) *  pi * Dims % half_levs(z) * ztop )) 
        wb_sin_fact   = SIN(  (     mm     *  pi * Dims % full_levs(z) * ztop )) 
	      r_cos_fact = COS(  (     mm     *  pi * Dims % half_levs(z) * ztop )) 

        ! Calculate summation
        tmp_u  = tmp_u  + ( ctrlstatein % u(m,k)     * uv_sin_fact   ) 
        tmp_v  = tmp_v  + ( ctrlstatein % v(m,k)     * uv_sin_fact   ) 
        tmp_w  = tmp_w  + ( ctrlstatein % w(m,k)     * wb_sin_fact   ) 
        tmp_b = tmp_b + ( ctrlstatein % b(m,k)    * wb_sin_fact   ) 
        tmp_rp = tmp_rp + ( ctrlstatein % r(m,k)  * r_cos_fact ) 
     
      ENDDO
      ! Reassign variables
      ctrlstateout % u(z,k)    = tmp_u
      ctrlstateout % v(z,k)    = tmp_v
      ctrlstateout % w(z,k)    = tmp_w 
      ctrlstateout % b(z,k)   = tmp_b
      ctrlstateout % r(z,k) = tmp_rp
   ENDDO
 ENDDO

END SUBROUTINE Vert_For
!================================================================================================


!================================================================================================
 SUBROUTINE Vert_For_Adj(ctrlstateout_hat, ctrlstatein_hat, Dims)

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

 ! Declare Top lev Variables
 !-----------------------------
 TYPE(transform_type),      INTENT(INOUT)     :: ctrlstatein_hat
 TYPE(transform_type),      INTENT(INOUT)     :: ctrlstateout_hat
 TYPE(Dimensions_type),     INTENT(IN)        :: Dims
 
 ! Declare Local Variables
 !-----------------------------
 REAL(wp)                                     :: trig(2*nlongs), phase, piovern
 COMPLEX(wp)                                  :: temp(1:nlevs, 1:nlongs), imag, negimag
 INTEGER                                      :: k, ktemp,i,m,z,mm
 REAL(wp)                                     :: ztop, ztop1
 REAL(wp)                                     :: uv_sin_fact, wb_sin_fact, r_cos_fact
 COMPLEX(wp)                                  :: tmp_u, tmp_v, tmp_w, tmp_b, tmp_rp

 negimag = (0.0,-1.0)
 piovern = pi / REAL(nlongs)
 imag = (0.0, 1.0) 
 ztop = 1.0/ Dims % full_levs(nlevs) 
 
 ! V^{T}-tranform : Adjoint vertical transform  
 !----------------------------------------------
 
 PRINT*, 'Performing adjoint of forward vertical transform; z to m'

 ! Initialise adjoint variable to zero
 ctrlstatein_hat % u(1:nlevs, 1:nlongs)    = (0.0,0.0)
 ctrlstatein_hat % v(1:nlevs, 1:nlongs)    = (0.0,0.0)
 ctrlstatein_hat % w(1:nlevs, 1:nlongs)    = (0.0,0.0) 
 ctrlstatein_hat % b(1:nlevs, 1:nlongs)   = (0.0,0.0) 
 ctrlstatein_hat % r(1:nlevs, 1:nlongs) = (0.0,0.0) 

 DO k = 1, nlongs  
 ! For each horizontal wave number, k 
   DO m = 1, nlevs    
      mm = m - 1
      ! For each vertical lev z
   
      ! Set tmp values to zero 
      tmp_u  = (0.0,0.0)
      tmp_v  = (0.0,0.0)
      tmp_w  = (0.0,0.0) 
      tmp_b = (0.0,0.0) 
      tmp_rp = (0.0,0.0) 
      
      DO z = 1, nlevs         
     !   mm = m - 1
	      ! sum over all wave numbers, mm
	      
	      ! Set factors
	      uv_sin_fact   = SIN(  ( (mm + 0.5) *  pi * Dims % half_levs(z) * ztop )) 
        wb_sin_fact   = SIN(  (     mm     *  pi * Dims % full_levs(z) * ztop )) 
	      r_cos_fact = COS(  (     mm     *  pi * Dims % half_levs(z) * ztop )) 

        ! Calculate summation
        tmp_u  = tmp_u  + ( ctrlstateout_hat % u(z,k)     * uv_sin_fact   ) 
        tmp_v  = tmp_v  + ( ctrlstateout_hat % v(z,k)     * uv_sin_fact   ) 
        tmp_w  = tmp_w  + ( ctrlstateout_hat % w(z,k)     * wb_sin_fact   ) 
        tmp_b = tmp_b + ( ctrlstateout_hat % b(z,k)    * wb_sin_fact   ) 
        tmp_rp = tmp_rp + ( ctrlstateout_hat % r(z,k)  * r_cos_fact ) 
     
      ENDDO
      ! Reassign variables
      ctrlstatein_hat % u(m,k)    = tmp_u
      ctrlstatein_hat % v(m,k)    = tmp_v
      ctrlstatein_hat % w(m,k)    = tmp_w 
      ctrlstatein_hat % b(m,k)   = tmp_b
      ctrlstatein_hat % r(m,k) = tmp_rp
   ENDDO
 ENDDO

 ! Truncate high wavenumbers
 !---------------------------
 !DO z = 10, nlevs
 !  ctrlstatein_hat % u(z,:)    = (0.0,0.0)
 !  ctrlstatein_hat % v(z,:)    = (0.0,0.0)
 !  ctrlstatein_hat % w(z,:)    = (0.0,0.0)
 !  ctrlstatein_hat % b(z,:)   = (0.0,0.0)
 !  ctrlstatein_hat % r(z,:) = (0.0,0.0)
 !END DO


END SUBROUTINE Vert_For_Adj
!================================================================================================

!=========================================================================================================
SUBROUTINE Eig_inv(ctrlstatein, pvectout, EigVecs, gen_scale, eigscale)

 USE DefConsTypes
 USE nag_fft
 USE nag_sym_fft
 USE nag_gen_lin_sys
 USE nag_sym_lin_sys
 USE nag_sym_eig, ONLY : nag_sym_eig_all

 IMPLICIT NONE

 ! Declare Top lev Variables
 !-----------------------------
 TYPE(transform_type),  INTENT(INOUT)     :: ctrlstatein
 REAL(wp),              INTENT(IN)        :: EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs)
 COMPLEX(wp),           INTENT(INOUT)     :: pvectout(1:nvars*nlevs, 1:nlongs )
 COMPLEX(wp),           INTENT(IN)        :: eigscale(1:nvars*nlevs, 1:nlongs) 
 INTEGER,               INTENT(IN)        :: gen_scale

 ! Declare Local Variables
 !-----------------------------
 COMPLEX(wp)                              :: imag, negimag
 INTEGER                                  :: k, ktemp,i,m,z,mm,j, herm
 REAL(wp)                                 :: rho0, sqrtb
 COMPLEX(wp)                              :: xvect(1:nvars*nlevs, 1:nlongs )
 REAL(wp)                                 :: evtmparr(1:nvars*nlevs, 1:nvars*nlevs) 
 COMPLEX(wp)                              :: xtmparr(1:nvars*nlevs), ptmparr(1:nvars*nlevs)

 
 ! Initialise and define local variables
 !----------------------------------------
 
 negimag = (0.0,-1.0)
 imag = (0.0, 1.0) 
 rho0 = 1.0
 sqrtb = sqrt(B * Cz * rho0)  
   
 xvect(1:nvars*nlevs,1:nvars*nlevs) = (0.0, 0.0)
 evtmparr(1:nvars*nlevs, 1:nvars*nlevs) = 0.0
 xtmparr(1:nvars*nlevs) = (0.0, 0.0)
 ptmparr(1:nvars*nlevs) = (0.0, 0.0)
 pvectout(1:nvars*nlevs, 1:nlongs) = 0.0 
 

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

    ! S^{-1}-Transform : Inverse symmetric scaling transform
    !--------------------------------------------------------
    !PRINT*, 'INVERSE SYMMETRIC SCALING'
    ktemp = k - 1 - (nlongs/2)
    IF (ktemp .EQ. 0) THEN
        ctrlstatein % w(:,k)    = ctrlstatein % w(:,k)  * negimag 
        ctrlstatein % r(:,k) = ctrlstatein % r(:,k) / sqrtb
        ctrlstatein % b(:,k)   = ctrlstatein % w(:,k) / sqrt(Nsq)
    ELSE
        ctrlstatein % w(:,k)    = ctrlstatein % w(:,k)  * negimag * domain /( 2 * REAL(ktemp) * pi)
        ctrlstatein % r(:,k) = ctrlstatein % r(:,k) * domain/(2 *REAL(ktemp) * pi * sqrtb )
        ctrlstatein % b(:,k)   = ctrlstatein % b(:,k) * domain /(2 * REAL(ktemp) * pi * sqrt(Nsq))
    ENDIF

    evtmparr(1:nvars*nlevs, 1:nvars*nlevs) = EigVecs(k,1:nvars*nlevs,1:nvars*nlevs) 

    ! Use xtmparr for MATMUL function
    DO  m = 1, nlevs
       xtmparr(m)             = ctrlstatein % u(m,k)
       xtmparr(m + nlevs)   = ctrlstatein % v(m,k)
       xtmparr(m + 2*nlevs) = ctrlstatein % w(m,k)
       xtmparr(m + 3*nlevs) = ctrlstatein % r(m,k)
       xtmparr(m + 4*nlevs) = ctrlstatein % b(m,k)
    END DO

    ! E^{-1}-transform: Inverse Eigenvector projection
    !-------------------------------------------------
    !PRINT*, 'INVERSE EIGENVECTOR PROJECTION'
    ptmparr = MATMUL(evtmparr,xtmparr )
    
    IF (gen_scale .EQ. 1) THEN
   !    PRINT*, 'Generating scaling',gen_scale
        pvectout(1:nvars*nlevs,k) = ptmparr(1:nvars*nlevs)
      ELSE 
  
      ! D^{-1}-transform: Inverse variance scaling
      !--------------------------------------------
      IF (k .EQ. 1) THEN
        PRINT*, 'INVERSE VARIANCE SCALING'
      END IF
      
      DO j = 1, nvars*nlevs
    !     PRINT*, eigscale(j,k)
         ! Scale
!         pvectout(j,k) = ptmparr(j)/eigscale(j, k)
         ! No scale
         pvectout(j,k) = ptmparr(j)
      END DO
    END IF
   
  END DO      

 PRINT*, 'COMPLETED INVERSE PROJECTION TO CONTROL VARIABLES'
 PRINT*, '-------------------------------'
 PRINT*, '-------------------------------'
 
 END SUBROUTINE Eig_inv
!=========================================================================================================

!=========================================================================================================
 SUBROUTINE Eig_for(pvectin, ctrlstateout, EigVecs, eigscale)

 USE DefConsTypes
 USE nag_fft
 USE nag_sym_fft
 USE nag_gen_lin_sys
 USE nag_sym_lin_sys
 USE nag_sym_eig, ONLY : nag_sym_eig_all

 IMPLICIT NONE

 ! Declare Top lev Variables
 !-----------------------------
 
 TYPE(transform_type),      INTENT(INOUT)     :: ctrlstateout
 REAL(wp), INTENT(IN)                         :: EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs)
 COMPLEX(wp), INTENT(INOUT)                   :: pvectin(1:nvars*nlevs, 1:nlongs )
 COMPLEX(wp), INTENT(IN)                      :: eigscale(1:nvars*nlevs, 1:nlongs) 

 ! Declare Local Variables
 !-----------------------------
 COMPLEX(wp)                                  :: imag, negimag
 REAL(wp)                                     :: rho0, sqrtb, recipdom
 INTEGER                                      :: k, ktemp,i,m,z,mm, kk, herm
 COMPLEX(wp)                                  :: xvect2(1:nvars*nlevs, 1:nlongs )
 REAL(wp)                                     :: evtmparr(1:nvars*nlevs, 1:nvars*nlevs) 
 COMPLEX(wp)                                  :: xtmparr(1:nvars*nlevs), ptmparr(1:nvars*nlevs)

 ! Initialise local variables
 !-----------------------------
 
 negimag = (0.0,-1.0)
 imag = (0.0, 1.0) 
 rho0 = 1.0
 sqrtb = sqrt(B * Cz * rho0)  
 recipdom = 1.0 / domain
 
 xvect2(1:nvars*nlevs,1:nvars*nlevs) = (0.0, 0.0)
 evtmparr(1:nvars*nlevs, 1:nvars*nlevs) = 0.0
 xtmparr(1:nvars*nlevs) = (0.0, 0.0)
 ptmparr(1:nvars*nlevs) = (0.0, 0.0)

 PRINT*, 'Forward Eigenvector Projection'
 
 DO k = 1,nlongs
    evtmparr(1:nvars*nlevs, 1:nvars*nlevs) = EigVecs(k,1:nvars*nlevs,1:nvars*nlevs)
        
    ! D-transform: Forward variance scaling
    !--------------------------------------------
    DO z = 1,nvars*nlevs
    !  PRINT*, 'z ', z, 'eigscal: ', eigscale(z,i)
   
    ! Scale
!    ptmparr(z) = pvectin(z,k)*eigscale(z,k)

    ! No scale
    ptmparr(z) = pvectin(z,k)
    END DO
    ! E-transform: Forward Eigenvector projection
    !-------------------------------------------------
     xtmparr = MATMUL(TRANSPOSE(evtmparr), ptmparr)
   ! xtmparr = ptmparr
  
    DO  m = 1, nlevs
      ctrlstateout % u(m,k)    = xtmparr(m)              
      ctrlstateout % v(m,k)    = xtmparr(m + nlevs)   
      ctrlstateout % w(m,k)    = xtmparr(m + 2*nlevs) 
      ctrlstateout % r(m,k) = xtmparr(m + 3*nlevs) 
      ctrlstateout % b(m,k)   = xtmparr(m + 4*nlevs)
    ENDDO

   ENDDO      
 
 herm = 1
 IF (herm .EQ. 1) THEN
   
   ! ENSURE EXACT HERMITIAN SEQUENCE
   !----------------------------------------- 

   DO m = 1, nlevs
    ctrlstateout % u(m,1)     = REAL(ctrlstateout % u(m,1))
    ctrlstateout % u(m,181)   = REAL(ctrlstateout % u(m,181))
    ctrlstateout % v(m,1)     = imag * (AIMAG(ctrlstateout % v(m,1)))
    ctrlstateout % v(m,181)   = imag * (AIMAG(ctrlstateout % v(m,181)))
    ctrlstateout % w(m,1)     = imag * (AIMAG(ctrlstateout % w(m,1)))
    ctrlstateout % w(m,181)   = imag * (AIMAG(ctrlstateout % w(m,181)))
    ctrlstateout % r(m,1)  = REAL(ctrlstateout % r(m,1))
    ctrlstateout % r(m,181)= REAL(ctrlstateout % r(m,181))
    ctrlstateout % b(m,1)    = REAL(ctrlstateout % b(m,1))
    ctrlstateout % b(m,181)  = REAL(ctrlstateout % b(m,181))
   ENDDO

   DO m = 1, nlevs
   kk = 360
     DO k = 2,nlongs/2
      ctrlstateout % u(m,kk)    = -1.0 * CONJG(ctrlstateout % u(m,k))
      ctrlstateout % v(m,kk)    =  CONJG(ctrlstateout % v(m,k))
      ctrlstateout % w(m,kk)    =  CONJG(ctrlstateout % w(m,k))
      ctrlstateout % r(m,kk) = -1.0 * CONJG(ctrlstateout % r(m,k))
      ctrlstateout % b(m,kk)   = -1.0 * CONJG(ctrlstateout % b(m,k))
      kk = kk-1
     ENDDO
   ENDDO
  
 END IF

 ! S-Transform : Forward symmetric scaling transform
 !--------------------------------------------------------

 DO k = 1, nlongs
   ktemp = k - 1 - (nlongs/2)
   
   IF (ktemp .EQ. 0) THEN
     ctrlstateout % w(:,k)    = ctrlstateout % w(:,k)  * imag
     ctrlstateout % r(:,k) = ctrlstateout % r(:,k) * sqrtb 
     ctrlstateout % b(:,k)   = ctrlstateout % b(:,k) * sqrt(Nsq)
   ELSE
     ctrlstateout % w(:,k)    = ctrlstateout % w(:,k)  *                             &
                                2.0 * imag * REAL(ktemp) * pi * recipdom  
     ctrlstateout % r(:,k) = ctrlstateout % r(:,k) *                           &
                                2.0 * pi * REAL(ktemp) * sqrtb * recipdom
     ctrlstateout % b(:,k)   = ctrlstateout % b(:,k) *                             &
                                2.0 * pi * REAL(ktemp) * sqrt(Nsq) * recipdom
   ENDIF
 
 ENDDO


 END SUBROUTINE Eig_for
!=========================================================================================================

!=========================================================================================================
 SUBROUTINE Eig_for_Adj(ctrlstateout_hat, pvectin_hat, EigVecs, eigscale)

 USE DefConsTypes
 USE nag_fft
 USE nag_sym_fft
 USE nag_gen_lin_sys
 USE nag_sym_lin_sys
 USE nag_sym_eig, ONLY : nag_sym_eig_all

 IMPLICIT NONE

 ! Declare Top lev Variables
 !-----------------------------
 
 TYPE(transform_type),      INTENT(INOUT)     :: ctrlstateout_hat
 REAL(wp), INTENT(IN)                         :: EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs)
 COMPLEX(wp), INTENT(INOUT)                   :: pvectin_hat(1:nvars*nlevs, 1:nlongs )
 COMPLEX(wp), INTENT(IN)                      :: eigscale(1:nvars*nlevs, 1:nlongs) 

 ! Declare Local Variables
 !-----------------------------
 COMPLEX(wp)                                  :: imag, negimag
 REAL(wp)                                     :: rho0, sqrtb, recipdom
 INTEGER                                      :: k, ktemp,i,m,z,mm, kk, herm, j
 COMPLEX(wp)                                  :: xvect2(1:nvars*nlevs, 1:nlongs )
 REAL(wp)                                     :: evtmparr(1:nvars*nlevs, 1:nvars*nlevs) 
 COMPLEX(wp)                                  :: xtmparr(1:nvars*nlevs), ptmparr(1:nvars*nlevs)

 ! Initialise local variables
 !-----------------------------
 
 negimag = (0.0,-1.0)
 imag = (0.0, 1.0) 
 rho0 = 1.0
 sqrtb = sqrt(B * Cz * rho0)  
 recipdom = 1.0 /domain
 xvect2(1:nvars*nlevs,1:nvars*nlevs) = (0.0, 0.0)
 evtmparr(1:nvars*nlevs, 1:nvars*nlevs) = 0.0
 xtmparr(1:nvars*nlevs) = (0.0, 0.0)
 ptmparr(1:nvars*nlevs) = (0.0, 0.0)
 
 ! Initialise Adjoint variables to zero
 !--------------------------------------
 pvectin_hat(1:nvars*nlevs,1:nlongs) = (0.0,0.0)
 PRINT*, 'ADJOINT EIGENVECTOR PROJECTION'
 
 ! S-Transform : Forward symmetric scaling transform
 !--------------------------------------------------------

 DO k = 1,nlongs
   
    ktemp = k - 1 - (nlongs/2)
    IF (ktemp .EQ. 0) THEN
       ctrlstateout_hat % w(:,k)    = ctrlstateout_hat % w(:,k)  * negimag
       ctrlstateout_hat % r(:,k) = ctrlstateout_hat % r(:,k) * sqrtb 
       ctrlstateout_hat % b(:,k)   = ctrlstateout_hat % b(:,k) * sqrt(Nsq)
    ELSE
       ctrlstateout_hat % w(:,k)    = ctrlstateout_hat % w(:,k) *                                &
                                        2.0 * negimag * REAL(ktemp) * pi * recipdom
       ctrlstateout_hat % r(:,k) = ctrlstateout_hat % r(:,k) *                             &
                                        2.0 * pi * REAL(ktemp) * sqrtb * recipdom
       ctrlstateout_hat % b(:,k)   = ctrlstateout_hat % b(:,k) *                               &
                                        2.0 * pi * REAL(ktemp) * sqrt(Nsq) * recipdom
    ENDIF

   
    evtmparr(1:nvars*nlevs, 1:nvars*nlevs) = EigVecs(k,1:nvars*nlevs,1:nvars*nlevs)  
     
    DO  m = 1, nlevs
      xtmparr(m)             = ctrlstateout_hat % u(m,k) 
      xtmparr(m + nlevs)   = ctrlstateout_hat % v(m,k)    
      xtmparr(m + 2*nlevs) = ctrlstateout_hat % w(m,k) 
      xtmparr(m + 3*nlevs) = ctrlstateout_hat % r(m,k) 
      xtmparr(m + 4*nlevs) = ctrlstateout_hat % b(m,k)
    ENDDO
     
    ! E-transform: Forward Eigenvector projection
    !-------------------------------------------------
    ptmparr = MATMUL((evtmparr), xtmparr)
 !   ptmparr =  xtmparr
     
    ! D-transform: Forward variance scaling
    !--------------------------------------------
    DO j = 1, nvars*nlevs
      pvectin_hat(j,k) = ptmparr(j)*CONJG(eigscale(j,k))
    END DO 
   ENDDO      
 
 herm = 0
 IF (herm .EQ. 1) THEN   
  
   ! ENSURE EXACT HERMITIAN SEQUENCE
   !----------------------------------------- 

   DO m = 1, nlevs
     pvectin_hat (m,1)                 = REAL(pvectin_hat (m,1))
     pvectin_hat (m,181)               = REAL(pvectin_hat (m,181))
     pvectin_hat (m + nlevs,1)       = negimag * (AIMAG(pvectin_hat (m + nlevs,1)))
     pvectin_hat (m + nlevs,181)     = negimag * (AIMAG(pvectin_hat (m + nlevs,181)))
     pvectin_hat (m + 2*nlevs,1)     = negimag * (AIMAG(pvectin_hat (m + 2*nlevs,1)))
     pvectin_hat (m + 2*nlevs,181)   = negimag * (AIMAG(pvectin_hat (m + 2*nlevs,181)))
     pvectin_hat (m + 3*nlevs,1)     = REAL(pvectin_hat (m + 3*nlevs,1))
     pvectin_hat (m + 3*nlevs,181)   = REAL(pvectin_hat (m + 3*nlevs,181))
     pvectin_hat (m + 4*nlevs,1)     = REAL(pvectin_hat (m + 4*nlevs,1))
     pvectin_hat (m + 4*nlevs,181)   = REAL(pvectin_hat (m + 4*nlevs,181))
   ENDDO

   DO m = 1, nlevs
   kk = 360
     DO k = 2,nlongs/2
       pvectin_hat (m,kk)             = -1.0 * (pvectin_hat(m,k))
       pvectin_hat (m + nlevs,kk)   =  (pvectin_hat(m + nlevs,k))
       pvectin_hat (m + 2*nlevs,kk) =  (pvectin_hat(m + 2*nlevs,k))
       pvectin_hat (m + 3*nlevs,kk) = -1.0 * (pvectin_hat(m + 3*nlevs,k))
       pvectin_hat (m + 4*nlevs,kk) = -1.0 * CONJG(pvectin_hat(m + 4*nlevs,k))
       kk = kk-1
     ENDDO
   ENDDO
 
 END IF
 
 END SUBROUTINE Eig_for_Adj

!=========================================================================================================
