 SUBROUTINE ModelDriver(StateIn, StateOut, Dims, ntimestot, ntimes, filename, &
                       convection_switch, rescale, alpha, Control) 

 !***********************************************************************************
 !*                                                                                 *
 !*  Driver Routine for Non linear forward model                                    *
 !*                                                                                 *
 !*  StateIn                   - input state of model_vars_type                     *
 !*  StateOut                  - output state of model_vars_type                    *
 !*  Dims                      - dimension data                                     *
 !*  ntimestot                 - total number of timesteps for model integration    *
 !*  ntimes                    - number of output times                             *
 !*  filename                  - output filename                                    *
 !*  convection_switch         - convective forcing                                 *
 !*  rescale                   - switch to rescale if running error breeding        *
 !*  alpha                     - rescale values                                     *
 !*  control state             - only required for breeding                         *
 !*   R. Petrie                                                                     *
 !*   Version 2                                                                     *
 !*   10 / 6 / 2011                                                                 *
 !*                                                                                 *
 !*                                                                                 *
 !***********************************************************************************

 USE DefConsTypes
 IMPLICIT NONE
 !Include netcdf
 !---------------
 INCLUDE '/opt/local/include/netcdf.inc'

 ! Top lev variables
 !---------------------
 TYPE(model_vars_type), INTENT(INOUT)         :: StateIn
 TYPE(model_vars_type), INTENT(INOUT)         :: StateOut 
 TYPE(Dimensions_type), INTENT(INOUT)         :: Dims
 TYPE(model_vars_type), INTENT(INOUT)         :: Control(0:nbreedcyc)
 INTEGER, INTENT(IN)                          :: ntimestot, ntimes, rescale, convection_switch
 REAL(ZREAL8), INTENT(IN)                     :: alpha(1:5)
 CHARACTER(*)                                 :: filename
  
 ! Local Variables
 !-----------------
 TYPE(model_vars_type)                        :: dy, temp_state
 REAL(ZREAL8)                                 :: beta(1:5), gama(1:5)
 INTEGER                                   		:: wts
 REAL(ZREAL8)                                 :: uav(1:nlevs), vav(1:nlevs), wav(1:nlevs)
 REAL(ZREAL8)                                 :: rav(1:nlevs), bav(1:nlevs)

 ! Loop counters
 !---------------
 INTEGER                                   		:: t,x,z,k

 ! Functions
 REAL(ZREAL8)                                  :: RMS

 
 CALL Initialise_model_vars(dy)

  ! degbug
  PRINT*, 'Model driver called'

 ! CONSISTENCY CHECKS
 !--------------------

 wts = ntimestot / ntimes  
 
  
 IF ( (dt /deltat .NE. 2.0 )) THEN
   PRINT*, '******************************'
   PRINT*, '********** Error *************'
   PRINT*, '  dt /deltat .NE. 2'
   STOP
 ENDIF  
 
 ! Write Initial Conditions
 !--------------------------- 
 CALL Calc_hydro(StateIn, Dims )
 CALL Calc_geost(StateIn, Dims ) 
 CALL Energy(StateIn)
 CALL Write_state_2d (filename, StateIn, Dims, ntimes+1, 0, wts)


 PRINT*,'----------------------------'
 PRINT*,'    Running prognostic model'
 PRINT*,'----------------------------'

 ! Inititalise Tracer 
 !---------------------------
 StateIn % tracer(0:nlongs+1,30) = 1.0

 ! Apply boundary conditions
 !---------------------------
 CALL Boundaries ( StateIn, 1,1,1,1,1,1 )
 
 PRINT*, ntimes
 
 DO t = 1,ntimestot
  PRINT*,'   ',t
 
!---------------------------------------------------------------------------------------------------
   IF ( convection_switch .EQ. 1 ) THEN 
     IF (t .LE. 1350) THEN
       CALL Convection(StateIn, 180, 1, 50, 5 )   
       PRINT*, maxval(statein % u(:,:)) 
       PRINT*, maxval(statein % v(:,:)) 
       PRINT*, maxval(statein % w(:,:)) 
       PRINT*, maxval(statein % b(:,:)) 
       PRINT*, maxval(statein % r(:,:)) 
     ENDIF
   END IF
!---------------------------------------------------------------------------------------------------
!   PRINT*, maxval(statein % u(:,:)) 
!   PRINT*, maxval(statein % v(:,:)) 
!   PRINT*, maxval(statein % w(:,:)) 
!   PRINT*, maxval(statein % b(:,:)) 
!   PRINT*, maxval(statein % r(:,:)) 
!   DO z = 1,nlevs
!    uav(z) = 0.0
!    vav(z) = 0.0
!    wav(z) = 0.0
!    rav(z) = 0.0
!    bav(z) = 0.0
!     DO x = 1,nlongs
!       uav(z) = uav(z) + StateIn % u(x,z)
!       vav(z) = vav(z) + StateIn % v(x,z)
!       wav(z) = wav(z) + StateIn % w(x,z)
!       rav(z) = rav(z) + StateIn % r(x,z)
!       bav(z) = bav(z) + StateIn % b(x,z)
!     END DO
!     uav(z) = uav(z) / nlongs
!     vav(z) = vav(z) / nlongs
!     wav(z) = wav(z) / nlongs
!     rav(z) = rav(z) / nlongs
!     bav(z) = bav(z) / nlongs
!   PRINT*,  vav(z), wav(z), bav(z) 
!   END DO

   CALL Forward_model(StateIn, StateOut, Dims)   
   
   StateIn = StateOut
  
   ! At output times
   !-----------------
   IF ((t/wts)*wts == t) THEN
      
     ! Used in breeding 
     IF (rescale .EQ. 1) THEN
     
       !*** CALCULATE beta ***
       !-----------------------
       k = 1  ! k ensures correct time in control vector
 
 
       dy % u(1:nlongs, 1:nlevs) = StateIn % u(1:nlongs, 1:nlevs) - Control(k) % u(1:nlongs, 1:nlevs)
       dy % v(1:nlongs, 1:nlevs) = StateIn % v(1:nlongs, 1:nlevs) - Control(k) % v(1:nlongs, 1:nlevs)
       dy % w(1:nlongs, 1:nlevs) = StateIn % w(1:nlongs, 1:nlevs) - Control(k) % w(1:nlongs, 1:nlevs)
       dy % r(1:nlongs, 1:nlevs) = StateIn % r(1:nlongs, 1:nlevs) - Control(k) % r(1:nlongs, 1:nlevs)
       dy % b(1:nlongs, 1:nlevs) = StateIn % b(1:nlongs, 1:nlevs) - Control(k) % b(1:nlongs, 1:nlevs)
       beta (1) = RMS( dy % u(1:nlongs, 1:nlevs) )
       beta (2) = RMS( dy % v(1:nlongs, 1:nlevs) )
       beta (3) = RMS( dy % w(1:nlongs, 1:nlevs) )
       beta (4) = RMS( dy % r(1:nlongs, 1:nlevs) )
       beta (5) = RMS( dy % b(1:nlongs, 1:nlevs) )   
 
       PRINT*, 'beta - u', beta(1)
       PRINT*, 'beta - v', beta(2)
       PRINT*, 'beta - w', beta(3)
       PRINT*, 'beta - r', beta(4)
       PRINT*, 'beta - b', beta(5)
       
       !*** CALCULATE gama ***
       !-----------------------
       gama(1) = alpha(1)/beta(1)
       gama(2) = alpha(2)/beta(2)
       gama(3) = alpha(3)/beta(3)
       gama(4) = alpha(4)/beta(4)
       gama(5) = alpha(5)/beta(5)

       PRINT*, 'gama - u', gama(1)
       PRINT*, 'gama - v', gama(2)
       PRINT*, 'gama - w', gama(3)
       PRINT*, 'gama - r', gama(4)
       PRINT*, 'gama - b', gama(5)
 
 
      
       DO z = 1, nlevs
         DO x = 1, nlongs
           StateIn % u(x,z)    = ( dy % u(x,z) * gama(1) ) + Control(k) % u(x,z)
           StateIn % v(x,z)    = ( dy % v(x,z) * gama(2) ) + Control(k) % v(x,z)
           StateIn % w(x,z)    = ( dy % w(x,z) * gama(3) ) + Control(k) % w(x,z)
           StateIn % r(x,z)    = ( dy % r(x,z) * gama(4) ) + Control(k) % r(x,z)
           StateIn % b(x,z)    = ( dy % b(x,z) * gama(5) ) + Control(k) % b(x,z)
         END DO
       ENDDO
     
       PRINT*,'maxval control u: ', maxval(Control(k) % u(:,:)) 
       PRINT*,'maxval control v: ', maxval(Control(k) % v(:,:)) 
       PRINT*,'maxval control w: ', maxval(Control(k) % w(:,:)) 
       PRINT*,'maxval control r: ', maxval(Control(k) % b(:,:)) 
       PRINT*,'maxval control b: ', maxval(Control(k) % r(:,:)) 

       ! Calculate RMS of Statein
       PRINT*,' rescaled rms should equal alpha approximately'
       PRINT*, 'rms rescaled u', RMS(StateIn % u(1:nlongs, 1:nlevs))
       PRINT*, 'rms rescaled v', RMS(StateIn % v(1:nlongs, 1:nlevs))
       PRINT*, 'rms rescaled w', RMS(StateIn % w(1:nlongs, 1:nlevs))
       PRINT*, 'rms rescaled r', RMS(StateIn % r(1:nlongs, 1:nlevs))
       PRINT*, 'rms rescaled b', RMS(StateIn % b(1:nlongs, 1:nlevs))
 
       k = k + 1
 
       PRINT*, 'Main Perturb state rescaled'
    
       DO z = 1, nlevs
         DO x = 1, nlongs
           StateIn % rho(x,z)  = StateIn % r(x,z) + StateIn % rho0(z)
         ENDDO
       ENDDO
       CALL Boundaries (StateIn, 1, 1, 1, 1, 1, 1 )
        
     ENDIF
    
     ! Calculate diagnostics
     !------------------------  
     CALL Calc_hydro(StateIn, Dims )
     CALL Calc_geost(StateIn, Dims ) 
     CALL Energy(StateIn)
     CALL Write_state_2d (filename, StateIn, Dims,ntimes+1,(t/wts), wts)

   ENDIF
 ENDDO


 PRINT*,'-----------------------------------------'
 PRINT*,'   Output file'
 PRINT*,'    xconv ', filename, '&'
 PRINT*,'-----------------------------------------'

 END SUBROUTINE ModelDriver
!=================================================================================================== 

!=================================================================================================== 
 SUBROUTINE Forward_model(input, stateout, Dims)
 
 ! Forward model integrated over dt
 ! adjust is the input state
  
 USE DefConsTypes
 IMPLICIT NONE

 ! Declare global parameters
 !---------------------------
 TYPE(model_vars_type), INTENT(IN)       :: input
 TYPE(model_vars_type), INTENT(INOUT)    :: stateout
 TYPE(Dimensions_type), INTENT(IN)       :: Dims

 ! Declare local parameters
 !---------------------------
 TYPE(model_vars_type)                   :: adjust, adjust_p1
 TYPE(Averages_type)                     :: aves
 REAL(ZREAL8)                            :: u_at_b(1:nlongs,1:nlevs), w_at_u(1:nlongs,1:nlevs)
 REAL(ZREAL8)                            :: u_at_v(1:nlongs,1:nlevs), w_at_v(1:nlongs,1:nlevs)
 REAL(ZREAL8)                            :: upstr_u, upstr_w, rhodivu

 ! Declare functions
 !-------------------
 REAL(ZREAL8)    :: INT_FH, INT_HF
 
 ! Declare Flags
 !----------------------
 LOGICAL                                 :: flag_u, flag_w, flag_u_at_b 
 LOGICAL                                 :: flag_w_at_u, flag_u_at_v, flag_w_at_v 
 
 ! Declare Loop counters
 !----------------------
 INTEGER                                 :: i,k, tsmall
 
 ! Initialise
 CALL Initialise_Averages(aves)
 
 ! copy input state into adjust array
 adjust = input
 

 !****************************
 !***** ADJUSTMENT STAGE *****
 !****************************

 !Begin temporal loop, with small timestep
 DO tsmall = 1, 2		 

 !*** Forward-backward scheme ***
 
   DO k = 1, nlevs
     DO i = 1, nlongs
        
       adjust_p1 % u(i,k) = bdiva_f * adjust % u(i,k) - deltat * recip_alpha_f *             &
             (                                                                               &
                Cz * ( adjust % r(i+1,k) - adjust % r(i,k) ) * recipdx -                     &
                f0 *  0.5 * (adjust % v(i,k) + adjust % v(i+1,k) )                           &
             )
	     
	     adjust_p1 % v(i,k) = bdiva_f * adjust % v(i,k) - deltat * recip_alpha_f *  f0 *       &
             (                                                                               &
                 0.5 * ( adjust % u(i-1,k) + adjust % u(i,k) )  -                            &
                deltat * Cz * 0.5 *                                                          &
		            ( adjust % r(i+1,k) - adjust % r(i-1,k)) * recip2dx                          &   
	           )
         
       adjust_p1 % w(i,k) = bdiva_N * adjust % w(i,k) - deltat * recip_alpha_N *             &
           (                                                                                 &
	             - 1.0 * adjust % b(i,k)  +                                                    &
               Cz * ( adjust % r(i,k+1) - adjust % r(i,k) ) /                                &
                    ( Dims % half_levs(k+1) - Dims % half_levs(k) )                          &
	            )
       adjust_p1 % b(i,k) = bdiva_N * adjust % b(i,k) - deltat * recip_alpha_N * Nsq *       &
	           (                                                                               &
	             adjust % w(i,k) -                                                             &
                deltat * 0.5 * Cz *( adjust % r(i,k+1) - adjust % r(i,k)  ) /                &
                   ( Dims % half_levs(k+1) - Dims % half_levs(k) )                           & 
              )
     END DO
   END DO
 
   ! Reassign variables
   !--------------------
   DO k = 1, nlevs
     DO i = 1, nlongs
       adjust % u(i,k) = adjust_p1 % u(i,k)
       adjust % v(i,k) = adjust_p1 % v(i,k)
       adjust % w(i,k) = adjust_p1 % w(i,k)
       adjust % b(i,k) = adjust_p1 % b(i,k)
     END DO
   END DO 
   DO i = 1, nlongs
     adjust % w(i,0) = adjust_p1 % w(i,0)
   END DO
 
   CALL Boundaries( adjust, 1, 1, 1, 0, 0, 1 )
 
   !Store all adjustment variables 
   !-------------------------------             
   IF (tsmall == 1) THEN
     DO k = 0, nlevs+1
       DO i = 0, nlongs+1
         aves % u_1(i,k) = adjust % u(i,k)
         aves % w_1(i,k) = adjust % w(i,k)
       END DO
     END DO
   ELSE IF (tsmall == 2 ) THEN
     DO k = 0, nlevs+1
       DO i = 0, nlongs+1
         aves % u_2(i,k) = adjust % u(i,k)
         aves % w_2(i,k) = adjust % w(i,k)
       END DO
     END DO
   END IF

   !Compute continuity equation, i.e. r
   
   !Calculate rho = r + rho_0
   DO k = 1, nlevs
     DO i = 1, nlongs
       adjust % rho(i,k) = adjust % r(i,k) + adjust % rho0(k) !1.0 !input % rho0(k)
     END DO
   END DO
   
   !Apply boundary conditions to full rho
   CALL Boundaries( adjust, 0, 0, 0, 1, 0, 0 )
   
   !Calculate rnext using a forward upstream
   !--------------------------------------------

   !Calculate advecting interpolations  
   DO k = 1, nlevs
     DO i = 1, nlongs
       u_at_v(i,k) = 0.5 * ( adjust % u(i-1, k) + adjust % u(i,k) )
       w_at_v(i,k) = INT_FH( adjust % w(i,k-1), adjust % w(i,k), k , Dims ) 
     END DO
   END DO

   DO k = 1, nlevs
     DO i = 1,nlongs

       !Calculate flags     
       flag_u_at_v = ( u_at_v(i,k) .LE. 0.0 )
       flag_w_at_v = ( w_at_v(i,k) .LE. 0.0 )
  
       !Calculate upstream terms 
       IF (flag_u_at_v) THEN
         upstr_u = u_at_v(i,k) * ( adjust % rho(i+1,k) - adjust % rho(i,k) ) * recipdx
       ELSE
         upstr_u = u_at_v(i,k) * ( adjust % rho(i,k) - adjust % rho(i-1,k) ) * recipdx
       END IF
          
       IF (flag_w_at_v) THEN
         upstr_w = w_at_v(i,k) * ( adjust % rho(i,k+1) - adjust % rho(i,k) ) /            &
                                 ( Dims % half_levs(k+1) - Dims % half_levs(k) )
       ELSE
         upstr_w = w_at_v(i,k) * ( adjust % rho(i,k) - adjust % rho(i,k-1) ) /            &
                                 ( Dims % half_levs(k) - Dims % half_levs(k-1) )
       END IF

       rhodivu  =  adjust % rho(i,k) *                                                    &
         (                                                                                &
	          ( adjust % u(i,k) - adjust % u(i-1,k) ) * recipdx +                           &
            ( adjust % w(i,k) - adjust % w(i,k-1) ) /                                     &
            ( Dims % full_levs(k) - Dims % full_levs(k-1) )                               &
          )                                                                             
	   
       adjust_p1 % r(i,k) = adjust % r(i,k) - deltat *  B *                               &
                          (                                                               &
                          ! rho div u 
                            rhodivu +                                                     &
                          ! u dot grad rho 
                            upstr_w + upstr_u                                             &      
		                      )                                                
       
     END DO
   END DO

   ! Update fields
   adjust % r(1:nlongs,1:nlevs) = adjust_p1 % r(1:nlongs,1:nlevs)
   
   ! Apply boundary conditions
   CALL Boundaries( adjust, 0, 0, 0, 0, 1, 0 )
 
   !End of temporal loop for tsmall  
 END DO 
 
 !*************************************
 !***** Calculate advecting means *****
 !*************************************
  
 DO k = 1, nlevs
   DO i = 1, nlongs
     aves % u_m(i,k) = 0.5 * ( aves % u_1(i,k) + aves % u_2(i,k) )
     aves % w_m(i,k) = 0.5 * ( aves % w_1(i,k) + aves % w_2(i,k) )
   END DO
 END DO     
  
 ! Apply Boundary Conditions to advecting means 
 !----------------------------------------------
 aves % u_m(0,0:nlevs+1) = aves % u_m(nlongs, 0:nlevs+1)
 aves % w_m(0,0:nlevs+1) = aves % w_m(nlongs, 0:nlevs+1)
 aves % u_m(nlongs+1,0:nlevs+1) = aves % u_m(1, 0:nlevs+1)
 aves % w_m(nlongs+1,0:nlevs+1) = aves % w_m(1, 0:nlevs+1)
 aves % u_m( 0:nlongs+1,nlevs+1) = aves % u_m( 0:nlongs+1, nlevs)
 aves % u_m( 0:nlongs+1,0) = -1.0 * aves % u_m( 0:nlongs+1,1)         
 aves % w_m(0:nlongs+1,0) = 0.0
 aves % w_m(0:nlongs+1,nlevs) = 0.0
 aves % w_m(0:nlongs+1,nlevs+1) = 0.0

 !Reassign r 
 stateout % r(1:nlongs,1:nlevs) = adjust % r(1:nlongs,1:nlevs)
  
 !***************************
 !***** ADVECTION STAGE *****
 !***************************

 !Calculate advecting interpolations  
 DO k = 1, nlevs
   DO i = 1, nlongs
     u_at_b(i,k) = 0.5 * ( INT_HF(aves % u_m(i-1,k), aves % u_m(i-1,k+1), k, Dims)  +      &
                           INT_HF(aves % u_m(i-1,k), aves % u_m(i-1,k+1), k, Dims) )
     u_at_v(i,k) = 0.5 * ( aves % u_m(i-1, k) + aves % u_m(i,k) )
     w_at_u(i,k) = 0.5 * ( INT_FH( aves % w_m(i,k-1), aves % w_m(i, k), k , Dims)   +      &
                           INT_FH( aves % w_m(i+1,k-1), aves % w_m(i+1, k), k , Dims))
     w_at_v(i,k) = INT_FH( aves % w_m(i,k-1), aves % w_m(i, k), k , Dims)
   END DO
 END DO

 DO k = 1, nlevs
   DO i = 1,nlongs

     !Calculate flags     
     !---------------    
     flag_u      = (aves % u_m(i,k) .LE. 0.0)
     flag_w      = (aves % w_m(i,k) .LE. 0.0)
     flag_u_at_b = ( u_at_b(i,k) .LE. 0.0 )
     flag_w_at_u = ( w_at_u(i,k) .LE. 0.0 )
     flag_u_at_v = ( u_at_v(i,k) .LE. 0.0 )
     flag_w_at_v = ( w_at_v(i,k) .LE. 0.0 )

     ! u- component 
     !---------------
     IF (flag_u) THEN
       upstr_u = aves % u_m(i,k) * ( input % u(i+1,k) - input % u(i,k) ) * recipdx
     ELSE
       upstr_u = aves % u_m(i,k) * ( input % u(i,k) - input % u(i-1,k) ) * recipdx
     END IF
     IF (flag_w_at_u) THEN
       upstr_w = w_at_u(i,k) * (input % u(i,k+1) -input % u(i,k) ) /                   &
                                ( Dims % half_levs(k+1) - Dims % half_levs(k) )
     ELSE
       upstr_w = w_at_u(i,k) * (input % u(i,k) - input % u(i,k-1) ) /                  &
                                ( Dims % half_levs(k) - Dims % half_levs(k-1) )
     END IF
     stateout % u(i,k) = adjust % u(i,k) - dt *                                            &
                 (                                                                         &
                   ! vec(u) . grad u
                   B * ( upstr_u + upstr_w )                                               &

                 )
                 
     ! v- component
     !-------------    
     IF (flag_u_at_v) THEN
       upstr_u = u_at_v(i,k) * ( input % v(i+1,k) - input % v(i,k) ) * recipdx
     ELSE
       upstr_u = u_at_v(i,k) * ( input % v(i,k) - input % v(i-1,k) ) * recipdx
     END IF
     IF (flag_w_at_v) THEN
       upstr_w = w_at_v(i,k) * ( input % v(i,k+1) - input % v(i,k) ) /                 &
                               ( Dims %  half_levs(k+1) - Dims % half_levs(k) )
     ELSE
       upstr_w = w_at_v(i,k) * ( input % v(i,k) - input % v(i,k-1) ) /                 &
                               ( Dims % half_levs(k) - Dims % half_levs(k-1) )
     END IF
                   
     stateout % v(i,k) = adjust % v(i,k) - dt *                                            &
                   (                                                                       &
                     ! vec(u) . grad v
                     B * ( upstr_u + upstr_w )                                             &
                   ) 
	    
     ! w- component 
     !-------------    
     IF (flag_u_at_b) THEN
       upstr_u = u_at_b(i,k) * ( input % w(i+1,k) -input % w(i,k) ) * recipdx
     ELSE
       upstr_u = u_at_b(i,k) * ( input % w(i,k) - input % w(i-1,k) ) * recipdx
     END IF
     IF (flag_w) THEN
       upstr_w = aves % w_m(i,k) *                                                         &
                 ( input % w(i,k+1) - input % w(i,k) ) /                               &
                 ( Dims % full_levs(k+1) - Dims % full_levs(k) )
     ELSE
       upstr_w = aves % w_m(i,k) *                                                         &
                 ( input % w(i,k) - input % w(i,k-1) ) /                               &
                 ( Dims % full_levs(k) - Dims % full_levs(k-1) )
     END IF

     stateout % w(i,k) = adjust % w(i,k) - dt *                                            &
                  (                                                                        &
                    ! vec(u) . grad w
                    B * ( upstr_u + upstr_w )                                              &
                  )
   
     ! b' component
     !-------------    
     IF (flag_u_at_b) THEN
       upstr_u = u_at_b(i,k) * ( input % b(i+1,k) - input % b(i,k) ) * recipdx
     ELSE
       upstr_u = u_at_b(i,k) * ( input % b(i,k) -  input % b(i-1,k) ) * recipdx
     END IF
     IF (flag_w) THEN
       upstr_w = aves % w_m(i,k) *                                                         &
                  ( input % b(i,k+1) - input % b(i,k) ) /                              &
                  ( Dims % full_levs(k+1) - Dims % full_levs(k) )
     ELSE
       upstr_w = aves % w_m(i,k) *                                                         &
                  ( input % b(i,k) - input % b(i,k-1) ) /                              &
                  ( Dims % full_levs(k) - Dims % full_levs(k-1) )
     END IF

     stateout % b(i,k) = adjust % b(i,k) - dt *                                            &
                    ( B *                                                                  &
                      ! u . grad b
                      ( upstr_u + upstr_w )                                                &
                    )          
   END DO
 END DO

 ! Apply boundary conditions, u, v, w, b'
 CALL Boundaries( stateout, 1, 1, 1, 0, 1, 0 )

 !************************* 
 !***** Advect Tracer *****
 !*************************

 DO k = 1, nlevs
   DO i = 1,nlongs

     !Calculate flags     
     !---------------    
     flag_u_at_v = ( u_at_v(i,k) .LE. 0.0 )
     flag_w_at_v = ( w_at_v(i,k) .LE. 0.0 )

     IF (flag_u_at_v) THEN
         upstr_u = u_at_v(i,k) * ( input % tracer(i+1,k) - input % tracer(i,k) ) * recipdx
     ELSE
         upstr_u = u_at_v(i,k) * ( input % tracer(i,k) - input % tracer(i-1,k) ) * recipdx
     END IF
     IF (flag_w_at_v) THEN
         upstr_w = w_at_v(i,k) * ( input % tracer(i,k+1) - input % tracer(i,k) ) /         &
                   ( Dims % half_levs(k+1) - Dims % half_levs(k) )
     ELSE
         upstr_w = w_at_v(i,k) * ( input % tracer(i,k) - input % tracer(i,k-1) ) /         &
                   ( Dims % half_levs(k) - Dims % half_levs(k-1) )
     END IF
                  
     stateout % tracer (i,k) =  input % tracer(i,k) - dt *                                 &
                  (                                                                        &
                    ! vec(u) . grad tracer
                    ( upstr_u + upstr_w )                                                  &
                  )
   END DO 
 END DO  
     
 !Apply Boundary conditions to tracer
 !------------------------------------
 stateout %tracer(0,:) = stateout %tracer(nlongs,:)
 stateout %tracer(nlongs+1,:) = stateout %tracer(1,:)
 stateout %tracer(:,0) = -1.0 * stateout %tracer(:,1)
 stateout %tracer(:,nlevs) = -1.0 * stateout %tracer(:,nlevs+1)

 ! Update rho and ensure rho0
 stateout % rho0(1:nlevs) = 1.0
 DO k = 1, nlevs
   DO i = 1, nlongs
     stateout % rho(i,k) = stateout % r(i,k) + stateout % rho0(k)
   END DO
 END DO

END SUBROUTINE Forward_model
!===================================================================================================
 
