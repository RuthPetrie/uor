 SUBROUTINE Boundaries ( state, flag_u, flag_v, flag_w, flag_r, flag_b, flag_rho )
 
 !************************************
 !* Subroutine to apply boundary     *
 !* conditions to model variables    *
 !*                                  *
 !* Input flags to choose which      * 
 !* variables to apply boundary      *
 !* conditions to                    *
 !************************************
 
 USE DefConsTypes 
 IMPLICIT NONE

 TYPE(model_vars_type), INTENT(INOUT) :: state
 INTEGER,               INTENT(IN)    :: flag_u, flag_v, flag_w, flag_r, flag_b, flag_rho

 !Local variables
 !---------------

 !PRINT*, 'boundaries called'

 IF (flag_u .EQ. 1) THEN
    ! Horizontal boundaries
    state % u (0, 0:nlevs+1)        = state % u(nlongs, 0:nlevs+1)
    state % u (nlongs+1, 0:nlevs+1) = state % u(1, 0:nlevs+1)
    ! Vertical boundaries
    state % u (0:nlongs+1,0)        = - 1.0 * state % u(:,1) 
    state % u (0:nlongs+1,nlevs+1)  = state % u(0:nlongs+1, nlevs)
 ENDIF

 IF (flag_v .EQ. 1) THEN
    ! Horizontal boundaries
    state % v (0, 0:nlevs+1)        = state % v(nlongs, 0:nlevs+1)
    state % v (nlongs+1, 0:nlevs+1) = state % v(1, 0:nlevs+1)
    ! Vertical boundaries
    state % v (0:nlongs+1,0)          = - 1.0 * state % v(:,1)
    state % v (0:nlongs+1,nlevs+1)  = state % v(0:nlongs+1, nlevs) 
 ENDIF

 IF (flag_w .EQ. 1) THEN
    ! Horizontal boundaries
    state % w (0, 0:nlevs+1)        = state % w(nlongs, 0:nlevs+1)
    state % w (nlongs+1, 0:nlevs+1) = state % w(1, 0:nlevs+1)
    ! Vertical boundaries
    state % w (0:nlongs+1,0)        = 0.0
    state % w (0:nlongs+1,nlevs)    = 0.0
    state % w (0:nlongs+1,nlevs+1)  = 0.0
 ENDIF
 
 IF (flag_r .EQ. 1) THEN
    ! Horizontal boundaries
    state % r (0, 0:nlevs+1)        = state % r(nlongs, 0:nlevs+1)
    state % r (nlongs+1, 0:nlevs+1) = state % r(1, 0:nlevs+1)
    ! Vertical boundaries
    state % r (0:nlongs+1,0)          = state % r(:,1)
    state % r (0:nlongs+1,nlevs+1)  = state % r(0:nlongs+1,nlevs) 
 ENDIF

 IF (flag_b .EQ. 1) THEN
    ! Horizontal boundaries
    state % b (0, 0:nlevs+1)        = state % b(nlongs, 0:nlevs+1)
    state % b (nlongs+1, 0:nlevs+1) = state % b(1, 0:nlevs+1)
    ! Vertical boundaries
    state % b (0:nlongs+1,0)          = 0.0
    state % b (0:nlongs+1,nlevs)    = 0.0
    state % b (0:nlongs+1,nlevs+1)  = 0.0
 ENDIF

 IF (flag_rho .EQ. 1) THEN
    ! Horizontal boundaries
    state % rho (0, 0:nlevs+1)        = state % rho(nlongs, 0:nlevs+1)
    state % rho (nlongs+1, 0:nlevs+1) = state % rho(1, 0:nlevs+1)
    ! Vertical boundaries
    state % rho (0:nlongs+1,0)        = state % rho(:,1)
    state % rho (0:nlongs+1,nlevs+1)  = state % rho(0:nlongs+1,nlevs) 
 ENDIF


 END SUBROUTINE Boundaries
!=================================================================================================== 
 SUBROUTINE Boundary_Discontinuity_Modification (state)
 
 ! Subroutine to modify the boundary such that they are appropriate for periodic conditions
 USE DefConsTypes
 IMPLICIT NONE

 !Declare Top Level Variables
 !---------------------
 TYPE(model_vars_type), INTENT(INOUT) :: state
 TYPE(model_vars_type)                :: discont
 TYPE(model_vars_type)                :: typical_diff
 
 REAL(ZREAL8) :: sgn_u(1:nlevs), u_temp(1:nlongs, 1:nlevs)
 REAL(ZREAL8) :: sgn_v(1:nlevs), v_temp(1:nlongs, 1:nlevs)
 REAL(ZREAL8) :: sgn_w(1:nlevs), w_temp(1:nlongs, 1:nlevs)
 REAL(ZREAL8) :: sgn_b(1:nlevs), b_temp(1:nlongs, 1:nlevs)
 REAL(ZREAL8) :: sgn_r(1:nlevs), r_temp(1:nlongs, 1:nlevs)
 REAL(ZREAL8) :: temp, sgn

 INTEGER      :: x,z
 


 ! Calculate average difference between points for each variable at each level
 !------------------------------------------------------------------------------
 DO z = 1, nlevs
   typical_diff % u(1,z) = 0.0
   typical_diff % v(1,z) = 0.0
   typical_diff % w(1,z) = 0.0
   typical_diff % b(1,z) = 0.0
   typical_diff % r(1,z) = 0.0
   sgn_u(z) = SIGN(1, state % u(2,z) - state % u(1,z))
   sgn_v(z) = SIGN(1, state % v(2,z) - state % v(1,z))
   sgn_w(z) = SIGN(1, state % w(2,z) - state % w(1,z))
   sgn_b(z) = SIGN(1, state % b(2,z) - state % b(1,z)) 
   sgn_r(z) = SIGN(1, state % r(2,z) - state % r(1,z))
   DO x = 1, nlongs-1
     typical_diff % u(1,z) = typical_diff % u(1,z) + sqrt(( state % u(x,z) - state % u(x+1,z))**2)
     typical_diff % v(1,z) = typical_diff % v(1,z) + sqrt(( state % v(x,z) - state % v(x+1,z))**2)
     typical_diff % w(1,z) = typical_diff % w(1,z) + sqrt(( state % w(x,z) - state % w(x+1,z))**2)
     typical_diff % b(1,z) = typical_diff % b(1,z) + sqrt(( state % b(x,z) - state % b(x+1,z))**2)
     typical_diff % r(1,z) = typical_diff % r(1,z) + sqrt(( state % r(x,z) - state % r(x+1,z))**2)
   END DO
   typical_diff % u(1,z) = sgn_u(z) * typical_diff % u(1,z)/(nlongs-1)
   typical_diff % v(1,z) = sgn_v(z) * typical_diff % v(1,z)/(nlongs-1)
   typical_diff % w(1,z) = sgn_w(z) * typical_diff % w(1,z)/(nlongs-1)
   typical_diff % b(1,z) = sgn_b(z) * typical_diff % b(1,z)/(nlongs-1)
   typical_diff % r(1,z) = sgn_r(z) * typical_diff % r(1,z)/(nlongs-1)
 END DO


 !Write typical values to file
 !--------------------
 !OPEN(50, file = '/home/wx019276/Modelling/Matlab/Data/u_typ_discont.dat')
 !OPEN(51, file = '/home/wx019276/Modelling/Matlab/Data/v_typ_discont.dat')
 !OPEN(52, file = '/home/wx019276/Modelling/Matlab/Data/w_typ_discont.dat')
 !OPEN(53, file = '/home/wx019276/Modelling/Matlab/Data/bp_typ_discont.dat')
 !OPEN(54, file = '/home/wx019276/Modelling/Matlab/Data/rhop_typ_discont.dat')
 !WRITE(50, *) typical_diff % u(:)
 !WRITE(51, *) typical_diff % v(:)
 !WRITE(52, *) typical_diff % w(:)
 !WRITE(53, *) typical_diff % b(:)
 !WRITE(54, *) typical_diff % r(:)
 !CLOSE(50)
 !CLOSE(51)
 !CLOSE(52)
 !CLOSE(53)
 !CLOSE(54)

 !Calculate the discontinuity at the boundary
 !-------------------------------------------
 DO z = 1, nlevs
   discont % u(1,z) = state % u(1,z) - state % u(nlongs,z)
   discont % v(1,z) = state % v(1,z) - state % v(nlongs,z)
   discont % w(1,z) = state % w(1,z) - state % w(nlongs,z)
   discont % b(1,z) = state % b(1,z) - state % b(nlongs,z)
   discont % r(1,z) = state % r(1,z) - state % r(nlongs,z)
 ENDDO

 !z = 20
 !PRINT*, discont % u(1,z) 
 !PRINT*, discont % v(1,z)
 !PRINT*, discont % w(1,z)
 !PRINT*, discont % b(1,z) 
 !PRINT*, discont % r(1,z)

 !Write to file
 !OPEN(50, file = '/home/wx019276/Modelling/Matlab/discont % u 2_bef.dat')
 !OPEN(51, file = '/home/wx019276/Modelling/Matlab/Data/discont % v 2_bef.dat')
 !OPEN(52, file = '/home/wx019276/Modelling/Matlab/Data/discont % w2_bef.dat')
 !OPEN(53, file = '/home/wx019276/Modelling/Matlab/Data/discont % bp2_bef.dat')
 !OPEN(54, file = '/home/wx019276/Modelling/Matlab/Data/discont % rhop2_bef.dat')
 !WRITE(50, *) discont % u(1,:)	
 !WRITE(51, *) discont % v(1,:)
 !WRITE(52, *) discont % w(1,:)
 !WRITE(53, *) discont % b(1,:)
 !WRITE(54, *) discont % r(1,:)
 !CLOSE(50) 
 !CLOSE(51)
 !CLOSE(52)
 !CLOSE(53)	
 !CLOSE(54)

 !Modify fields to be periodic
 !---------------------
 
 !Modify bp
 !-----------

 !OPEN(51, file = '/home/wx019276/Modelling/Matlab/Data/bp_level1.dat')
 !OPEN(52, file = '/home/wx019276/Modelling/Matlab/Data/bp_level17.dat')
 !OPEN(53, file = '/home/wx019276/Modelling/Matlab/Data/bp_orig.dat')
 !WRITE(51,*) state % b(:,1)
 !WRITE(52,*) state % b(:,17)
 ! DO k = 1, nlevs
 !   WRITE (53, *) state % b(:,z)
 ! ENDDO
 !CLOSE(51)
 !CLOSE(52)
 !CLOSE(53)

 DO z = 1, nlevs
   DO x = 1, (nlongs)
     IF (x < (nlongs/2)) THEN
       temp = -((x*x)/500.0)
       sgn = 1.0
     ELSE
       temp = -(nlongs-x)*(nlongs-x)/500.0
       sgn = -1.0
     END IF
       b_temp(x,z) = state % b(x,z) - 0.5*sgn*exp(temp)*(discont % b(1,z)- typical_diff % b(1,z))
   END DO
 END DO

 state % b(1:nlongs,1:nlevs) = b_temp(1:nlongs, 1:nlevs)

 !OPEN(51, file = '/home/wx019276/Modelling/Matlab/Data/bp_level1_mod.dat')
 !OPEN(52, file = '/home/wx019276/Modelling/Matlab/Data/bp_level17_mod.dat')
 !OPEN(53, file = '/home/wx019276/Modelling/Matlab/Data/bp_mod.dat')
 !WRITE(51,*) state % bp(:,1)
 !WRITE(52,*) state % bp(:,17)
 ! DO k = 1, nlevs
 !   WRITE (53, *) state % bp(:,z)
 !ENDDO
 !CLOSE(51)
 !CLOSE(52)
 !CLOSE(53)


 !Modify u
 !-----------

 !OPEN(51, file = '/home/wx019276/Modelling/Matlab/Data/u_level1.dat')
 !OPEN(52, file = '/home/wx019276/Modelling/Matlab/Data/u_level17.dat')
 !!OPEN(53, file = '/home/wx019276/Modelling/Matlab/Data/u_orig.dat')
 !WRITE(51,*) state % u(:,1)
 !WRITE(52,*) state % u(:,17)
 ! DO k = 1, nlevs
 !    WRITE (53, *) state % u(:,z)
 ! ENDDO
 !CLOSE(51)
 !CLOSE(52)
 !CLOSE(53)

 DO z = 1, nlevs
   DO x = 1, nlongs
     IF (x < (nlongs/2)) THEN
       temp = -((x*x)/500.0)
       sgn = 1.0
     ELSE
       temp = -(nlongs-x)*(nlongs-x)/500.0
       sgn = -1.0
     END IF
     u_temp(x,z) = state %  u(x,z) - 0.5*sgn*exp(temp)*(discont % u(1,z)- typical_diff % u(1,z))
   ENDDO
 ENDDO
 state % u(1:nlongs,1:nlevs) = u_temp(1:nlongs, 1:nlevs)



 !OPEN(51, file = '/home/wx019276/Modelling/Matlab/Data/u_level1_mod.dat')
 !OPEN(52, file = '/home/wx019276/Modelling/Matlab/Data/u_level17_mod.dat')
 !OPEN(53, file = '/home/wx019276/Modelling/Matlab/Data/u_mod.dat')
 !WRITE(51,*) state % u(:,1)
 !WRITE(52,*) state % u(:,17)
 !!DO k = 1, nlevs
 !  WRITE (53, *) state % u(:,z)
 !ENDDO
 !CLOSE(51)
 !CLOSE(52)
 !CLOSE(53)


 !Modify v
 !-----------
 !OPEN(51, file = '/home/wx019276/Modelling/Matlab/Data/v_level1.dat')
 !OPEN(52, file = '/home/wx019276/Modelling/Matlab/Data/v_level17.dat')
 !OPEN(53, file = '/home/wx019276/Modelling/Matlab/Data/v_orig.dat')
 !WRITE(51,*) state % v(:,1)
 !WRITE(52,*) state % v(:,17)
 !DO k = 1, nlevs
 !  WRITE (53, *) state % v(:,z)
 !ENDDO
 !CLOSE(51)
 !CLOSE(52)
 !CLOSE(53)

 DO z = 1, nlevs
   DO x = 1, nlongs
     IF (x < (nlongs/2)) THEN
       temp = -((x*x)/500.0)
       sgn = 1.0
     ELSE
       temp = -(nlongs-x)*(nlongs-x)/500.0
       sgn = -1.0
     END IF
     v_temp(x,z) = state % v(x,z) - 0.5*sgn*exp(temp)*(discont % v(1,z)- typical_diff % v(1,z))
   END DO
 END DO
 state % v(1:nlongs,1:nlevs) = v_temp(1:nlongs, 1:nlevs)

 !OPEN(51, file = '/home/wx019276/Modelling/Matlab/Data/v_level1_mod.dat')
 !OPEN(52, file = '/home/wx019276/Modelling/Matlab/Data/v_level17_mod.dat')
 !OPEN(53, file = '/home/wx019276/Modelling/Matlab/Data/v_mod.dat')
 !WRITE(51,*) state % v(:,1)
 !WRITE(52,*) state % v(:,17)
 !DO k = 1, nlevs
 !  WRITE (53, *) state % v(:,z)
 !ENDDO
 !CLOSE(51)
 !CLOSE(52)
 !CLOSE(53)

 !Modify w
 !-----------
 !OPEN(51, file = '/home/wx019276/Modelling/Matlab/Data/w_level1.dat')
 !OPEN(52, file = '/home/wx019276/Modelling/Matlab/Data/w_level17.dat')
 !OPEN(56, file = '/home/wx019276/Modelling/Matlab/Data/w_orig2.dat')
 !WRITE(51,*) state % w(:,1)
 !WRITE(52,*) state % w(:,17)
 !DO k = 1, nlevs
 !	WRITE (56, *) state % w(:,z)
 !ENDDO
 !CLOSE(51)
 !CLOSE(52)
 !CLOSE(56)

 DO z = 1, nlevs
   DO x = 1, nlongs
     IF (x < (nlongs/2)) THEN
       temp = -((x*x)/500.0)
       sgn = 1.0
     ELSE
       temp = -(nlongs-x)*(nlongs-x)/500.0
       sgn = -1.0
     END IF
     w_temp(x,z) = state % w(x,z) - 0.5*sgn*exp(temp)*(discont % w(1,z)- typical_diff % w(1,z))
   END DO
 END DO
 state % w(1:nlongs,1:nlevs) = w_temp(1:nlongs, 1:nlevs)
 !DO k = 1, nlevs
 !  DO i = 1, (nlongs)
 !    IF (i < (nlongs/2)) THEN
 !      temp = -((i*i)/500.0)
 !      sgn = 1.0
 !    ELSE
 !      temp = -(nlongs-i)*(nlongs-i)/500.0
 !      sgn = -1.0
 !    END IF
 !      w_temp(x,z) = state % w(x,z) - 0.5*sgn*exp(temp)*(discont % w(k)- typical_diff % w(k))
 !    ENDDO
 !ENDDO
 
 !state % w(1:nlongs,1:nlevs) = w_temp(:,:)

 !OPEN(51, file = '/home/wx019276/Modelling/Matlab/Data/w_level1_mod.dat')
 !OPEN(52, file = '/home/wx019276/Modelling/Matlab/Data/w_level17_mod.dat')
 !!OPEN(56, file = '/home/wx019276/Modelling/Matlab/Data/w_mod2.dat')
 !WRITE(51,*) state % w(:,1)
 !WRITE(52,*) state % w(:,17)
 !DO k = 1, nlevs!
 !	WRITE (56, *) state % w(:,z)
 !ENDDO
 !CLOSE(51)
 !CLOSE(52)
 !CLOSE(56)


 !Modify rhop
 !-----------

 !OPEN(51, file = '/home/wx019276/Modelling/Matlab/Data/rhop_level1.dat')
 !OPEN(52, file = '/home/wx019276/Modelling/Matlab/Data/rhop_level17.dat')
 !OPEN(53, file = '/home/wx019276/Modelling/Matlab/Data/rhop_orig.dat')
 !WRITE(51,*) state % rhop(:,1)
 !WRITE(52,*) state % rhop(:,17)
 !DO k = 1, nlevs
 !  WRITE (53, *) state % rhop(:,z)
 !ENDDO
 !CLOSE(51)
 !CLOSE(52)
 !CLOSE(53)
 DO z = 1, nlevs
   DO x = 1, nlongs
     IF (x < (nlongs/2)) THEN
       temp = -((x*x)/500.0)
       sgn = 1.0
     ELSE
       temp = -(nlongs-x)*(nlongs-x)/500.0
       sgn = -1.0
     END IF
     r_temp(x,z) = state % r(x,z) - 0.5*sgn*exp(temp)*(discont % r(1,z)- typical_diff % r(1,z))
   END DO
 END DO
 state % r(1:nlongs,1:nlevs) = r_temp(1:nlongs, 1:nlevs)
 
 !OPEN(51, file = '/home/wx019276/Modelling/Matlab/Data/rhop_level1_mod.dat')
 !OPEN(52, file = '/home/wx019276/Modelling/Matlab/Data/rhop_level17_mod.dat')
 !OPEN(53, file = '/home/wx019276/Modelling/Matlab/Data/rhop_mod.dat')
 !WRITE(51,*) state % rhop(:,1)
 !WRITE(52,*) state % rhop(:,17)
 !DO k = 1, nlevs
 !  WRITE (53, *) state % rhop(:,z)
 !ENDDO
 !CLOSE(51)
 !CLOSE(52)
 !CLOSE(53)

 !Calculate the discontinuity at the boundary
 !-------------------------------------------
 DO z = 1, nlevs
   discont % u (2,z) = state % u(1,z) - state % u(nlongs,z)
   discont % v (2,z) = state % v(1,z) - state % v(nlongs,z)
   discont % w (2,z) = state % w(1,z) - state % w(nlongs,z)
   discont % b (2,z) = state % b(1,z) - state % b(nlongs,z)
   discont % r (2,z) = state % r(1,z) - state % r(nlongs,z)
 ENDDO
 !z = 20
 !PRINT*, discont % u(2,z) 
 !PRINT*, discont % v(2,z)
 !PRINT*, discont % w(2,z)
 !PRINT*, discont % b(2,z) 
 !PRINT*, discont % r(2,z)
!Write to file
!--------
!OPEN(50, file = '/home/wx019276/Modelling/Matlab/Data/discont % u 2.dat')
!OPEN(51, file = '/home/wx019276/Modelling/Matlab/Data/discont % v 2.dat')
!OPEN(52, file = '/home/wx019276/Modelling/Matlab/Data/discont % w2.dat')
!OPEN(53, file = '/home/wx019276/Modelling/Matlab/Data/discont % bp2.dat')
!OPEN(54, file = '/home/wx019276/Modelling/Matlab/Data/discont % rhop2.dat')
!WRITE(50, *) discont % u (:)	
!WRITE(51, *) discont % v (:)
!WRITE(52, *) discont % w(:)
!WRITE(53, *) discont % bp(:)
!WRITE(54, *) discont % rhop(:)
!CLOSE(50)
!CLOSE(51)
!CLOSE(52)
!CLOSE(53)	
!CLOSE(54)
 DO z = 1, nlevs
   DO x = 1, nlongs
     state % rho(x,z) = state % r(x,z) + state % rho0(z)
   END DO
 END DO
 
 CALL Boundaries(state, 1,1,1,1,1,1)

END SUBROUTINE Boundary_Discontinuity_Modification

   
        
