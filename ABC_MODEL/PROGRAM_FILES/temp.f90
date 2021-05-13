!===================================================================================================
!***************************************************************************************************
!===================================================================================================
 SUBROUTINE GenPhaseStd(ensemble,dims,ensnum,eigenvects_file )
 
 !**************************************************** 
 !* Subroutine to calculate the phase space          *
 !* standard deviation at each grid point            *
 !* use to find implied correlation not implied      *
 !* covariance                                       *
 !****************************************************
 
 USE DefConsTypes
 IMPLICIT NONE

 ! Declare global variables
 !--------------------------
 TYPE(model_vars_type), INTENT(INOUT)    :: ensemble(0:nems)
 TYPE(dimensions_type), INTENT(INOUT)    :: dims
 CHARACTER(LEN=*),      INTENT(IN)       :: ensnum
 CHARACTER(LEN=*),     INTENT(IN)        :: eigenvects_file

 ! Declare local variables
 !-------------------------
 TYPE(model_vars_type)                   :: en_av , en_pert(1:nems), en_std
 REAL(wp)                                :: EigVecs(1:nlongs,1:nvars*nlevs,1:nvars*nlevs)
 COMPLEX(wp)                             :: Ctrl_vect(1:nvars*nlevs, 1:nlongs )
 COMPLEX(wp)                             :: en_ctrl_vect(1:nems,1:nvars*nlevs, 1:nlongs )
 REAL(wp)                                :: ctrl_std(1:nvars*nlevs, 1:nlongs)
 COMPLEX(wp)                             :: ctrl_av(1:nvars*nlevs, 1:nlongs)
 INTEGER                                 :: en
 CHARACTER                               :: ens_av_file*69
 CHARACTER                               :: ens_stds_file*62
 CHARACTER                               :: ens_pert_file*68
 CHARACTER                               :: filenumber*2

 ! Counters
 INTEGER                                  :: k, i, j, en,n

!===================================================================================================
 ! Initialisations
 !-----------------
 CALL Initialise_model_vars(en_av)
 CALL Initialise_model_vars(en_std)
 DO en = 1, nems  ! changed from 0:nems-1
   CALL Initialise_model_vars(en_pert(en))
 END DO
!===================================================================================================
 
 PRINT*, '--------------------------------------------------------------------------'
 PRINT*, 'Calculating phase space standard deviations '
 PRINT*, '--------------------------------------------------------------------------'
 
 
 ! Calculate ensemble perturbations
 !==================================
   
 ! Calculate ensemble average 
 !-----------------------------
! PRINT*,' Calculate ensemble average'
 DO k = 1, nlevs
   DO i = 1, nlongs
     DO en = 1, nems
       en_av % u(i,k) = en_av % u(i,k) + ensemble(en) % u(i,k)
       en_av % v(i,k) = en_av % v(i,k) + ensemble(en) % v(i,k)
       en_av % w(i,k) = en_av % w(i,k) + ensemble(en) % w(i,k)
       en_av % r(i,k) = en_av % r(i,k) + ensemble(en) % r(i,k)
       en_av % b(i,k) = en_av % b(i,k) + ensemble(en) % b(i,k)       
     END DO
     en_av % u(i,k) = en_av % u(i,k) / nems
     en_av % v(i,k) = en_av % v(i,k) / nems
     en_av % w(i,k) = en_av % w(i,k) / nems
     en_av % r(i,k) = en_av % r(i,k) / nems
     en_av % b(i,k) = en_av % b(i,k) / nems
   END DO
 END DO
   
 ! Write ensemble average
 !------------------------------
 ens_av_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/COVARIANCES/En_'//ensnum//'_Av.nc'
 CALL Write_state_2d (ens_av_file,en_av, Dims, 1, 0, 1)

 ! Calculate perturbations
 !--------------------------   
 DO en = 1, nems
   DO k = 1, nlevs
     DO i = 1, nlongs
       en_pert(en) % u(i,k) = ensemble(en) % u(i,k) - en_av % u(i,k) 
       en_pert(en) % v(i,k) = ensemble(en) % v(i,k) - en_av % v(i,k) 
       en_pert(en) % w(i,k) = ensemble(en) % w(i,k) - en_av % w(i,k) 
       en_pert(en) % r(i,k) = ensemble(en) % r(i,k) - en_av % r(i,k) 
       en_pert(en) % b(i,k) = ensemble(en) % b(i,k) - en_av % b(i,k) 
     END DO
   END DO
 END DO
     
 ! Write ensemble perturbations
 !------------------------------
 DO en = 1, nems  !!! changed from 0,nems-1
   WRITE(filenumber,'(i2.2)')en
   ens_pert_file = '/export/carrot/raid2/wx019276/DATA/ENSEMBLE/PERTS/En_'//ensnum//&
                   '_pert_'//filenumber//'.nc'
   CALL Write_state_2d (ens_pert_file,en_pert(en), Dims, 1, 0, 1)
 END DO
      
 ! Calculate phase space standard deviation
 
 en_std % u(1:nlongs, 1:nlevs) = 0.0
 en_std % v(1:nlongs, 1:nlevs) = 0.0
 en_std % w(1:nlongs, 1:nlevs) = 0.0
 en_std % r(1:nlongs, 1:nlevs) = 0.0
 en_std % b(1:nlongs, 1:nlevs) = 0.0
 
 DO k = 1, nlevs
   DO i = 1, nlongs
     DO en = 1, nems
       en_std % u(i,k) = en_std % u(i,k) + en_pert(en) % u(i,k) * en_pert(en) % u(i,k)
       en_std % v(i,k) = en_std % v(i,k) + en_pert(en) % v(i,k) * en_pert(en) % v(i,k) 
       en_std % w(i,k) = en_std % w(i,k) + en_pert(en) % w(i,k) * en_pert(en) % w(i,k)
       en_std % r(i,k) = en_std % r(i,k) + en_pert(en) % r(i,k) * en_pert(en) % r(i,k)
       en_std % b(i,k) = en_std % b(i,k) + en_pert(en) % b(i,k) * en_pert(en) % b(i,k) 
     END DO
       en_std % u(i,k) = sqrt ( en_std % u(i,k) / nems )
       en_std % v(i,k) = sqrt ( en_std % v(i,k) / nems ) 
       en_std % w(i,k) = sqrt ( en_std % w(i,k) / nems )
       en_std % r(i,k) = sqrt ( en_std % r(i,k) / nems )
       en_std % b(i,k) = sqrt ( en_std % b(i,k) / nems ) 
   END DO
 END DO

 ! Write phase space standard deviations
 !------------------------------
 ens_stds_file = '/export/carrot/raid2/wx019276/DATA/CVT/phase_space_stds'//ensnum//'.nc'
 CALL Write_state_2d (ens_stds_file, en_std, Dims, 1, 0, 1)


 END SUBROUTINE GenPhaseStd
!===================================================================================================
!***************************************************************************************************
!===================================================================================================
