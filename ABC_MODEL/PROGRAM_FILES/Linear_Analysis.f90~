 SUBROUTINE Linear_Analysis(Asqd_test, B_test, C_test, fileset)

 USE DefConsTypes
 USE nag_sym_lin_sys
 USE nag_sym_eig, ONLY : nag_sym_eig_all

 IMPLICIT NONE

!*****************************************************
!*   Program to calculate the eigenvalues and        *  
!*   speeds fo the waves in the model and to         * 
!*   detect the sensitivity of these to model        *
!*   parameters                                      *  
!*                                                   *  
!*   R. Petrie                                       *  
!*   Version 2                                       * 
!*   16-06-11                                        *
!*****************************************************



 ! DEFINE PARAMETERS
 !--------------------

 REAL(wp),     INTENT(IN)  :: Asqd_test, B_test, C_test
 CHARACTER(*), INTENT(IN)  :: fileset
 REAL(wp)                  :: nxdx, kfact, mfact
 REAL(wp)                  :: fa, fH, A_test, Aoverf
 REAL(wp)                  :: rho0, P, sqrtbp
 REAL(wp)                  :: mall(0:nlevs-1), kall(0:nlongs-1)
 REAL(wp)                  :: L(1:nvars, 1:nvars)
 REAL(wp)                  :: lambda(1:nvars)
 REAL(wp)                  :: EigVals(1:nvars)
 REAL(wp)                  :: gravity_freq(0:nlevs-1, 0:nlongs-1)
 REAL(wp)                  :: acoustic_freq(0:nlevs-1, 0:nlongs-1)
 REAL(wp)                  :: hoz_grav_speed(0:nlevs-1,1:nlongs-1)
 REAL(wp)                  :: hoz_ac_speed(0:nlevs-1,1:nlongs-1)
 REAL(wp)                  :: vert_grav_speed(0:nlongs-1,1:nlevs-1)
 REAL(wp)                  :: vert_ac_speed(0:nlongs-1,1:nlevs-1) 
 CHARACTER                 :: fileloc*50
 CHARACTER (1)             :: uplo
 INTEGER                   :: k,m
 
 nxdx = REAL(nlongs) * REAL(dx)
 kfact = (2.0 * pi) / nxdx
 mfact = pi / H
 uplo = 'u'
 fa = f0 * nxdx   ! a = nxdx 
 fH = f0 * H 
 rho0 = 1.0
 P = C_test*rho0
 sqrtbp = sqrt(B_test*P)
 A_test = sqrt(Asqd_test)
 Aoverf = A_test / f0
fileloc = '/export/carrot/raid2/wx019276/DATA/MODEL/WAVESENS/'

 ! Allocate horizontal and vertical wavenumbers
 !-----------------------------------------------
 DO m = 0, nlevs-1
   mall(m) = (REAL(m) * pi )
 END DO
 
 DO k = 0, nlongs-1
   kall(k) = ( 2.0 * pi * REAL(k) )
 END DO

 DO m = 0, nlevs-1
   DO k = 0, nlongs-1			

     ! Set system matrix 
     !-------------------    
     L(:,:) = 0.0
     L(1,2) = 1.0
     L(2,1) = 1.0
     L(3,5) = Aoverf
     L(5,3) = Aoverf
     L(1,4) = -1.0 * ( kall(k) * sqrtbp ) / fa
     L(4,1) = L(1,4)
     L(3,4) = ( mall(m) * sqrtbp)/ fH
     L(4,3) = L(3,4)

     CALL nag_sym_eig_all(uplo, L, lambda)
     EigVals = lambda
     gravity_freq(m,k)  = f0 * EigVals(4)  ! as nag routine lists frequencies in order - - 0 + + 
     acoustic_freq(m,k) = f0 * EigVals(5)
   
  
   END DO
 END DO

 
 ! Calculate wave speeds
 !------------------------
 
 DO m = 0, nlevs-1
   DO k = 1, nlongs-1
      hoz_grav_speed(m,k) = (gravity_freq(m,k)  - gravity_freq(m,k-1))  / kfact
      hoz_ac_speed(m,k)   = (acoustic_freq(m,k) - acoustic_freq(m,k-1)) / kfact
   ENDDO
 ENDDO

 DO k = 0, nlongs-1
   DO m = 1, nlevs-1
      vert_grav_speed(k,m) = (gravity_freq(m,k)  - gravity_freq(m-1,k))  / mfact
      vert_ac_speed(k,m)   = (acoustic_freq(m,k) - acoustic_freq(m-1,k)) / mfact
   ENDDO
 ENDDO

 ! Dump data
 !------------
  
 PRINT*, fileloc//'hoz_grav_speed_'//fileset//'.dat'
 
 OPEN(51, file = fileloc//'hoz_grav_speed_'//fileset//'.dat')
 OPEN(52, file = fileloc//'hoz_ac_speed_'//fileset//'.dat')
 OPEN(53, file = fileloc//'vert_grav_speed_'//fileset//'.dat')
 OPEN(54, file = fileloc//'vert_ac_speed_'//fileset//'.dat')
 OPEN(55, file = fileloc//'acoustic_freq_'//fileset//'.dat')
 OPEN(56, file = fileloc//'gravity_freq_'//fileset//'.dat')
 
 DO m = 0, nlevs-1
   WRITE (51, *) hoz_grav_speed(m,:)
   WRITE (52, *) hoz_ac_speed(m,:)
 ENDDO

 DO k = 0, nlongs-1
   WRITE (53, *) vert_grav_speed(k,:)
   WRITE (54, *) vert_ac_speed(k,:)
   WRITE (55, *) acoustic_freq(:,k)
   WRITE (56, *) gravity_freq(:,k)
 ENDDO


 CLOSE(51) 
 CLOSE(52) 
 CLOSE(53) 
 CLOSE(54) 
 CLOSE(55) 
 CLOSE(56) 
  
 END SUBROUTINE Linear_Analysis
