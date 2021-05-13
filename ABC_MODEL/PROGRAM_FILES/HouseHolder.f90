PROGRAM Householder

IMPLICIT NONE
INTEGER, PARAMETER       :: ZREAL8=SELECTED_REAL_KIND(15,307)
INTEGER, PARAMETER       :: NumberElements = 50
INTEGER, PARAMETER       :: NumberMembers = 5

REAL (ZREAL8)            :: Members(1:NumberElements, 1:NumberMembers)
REAL (ZREAL8)            :: Members_copy(1:NumberElements, 1:NumberMembers)
REAL (ZREAL8)            :: InputState(1:NumberElements)
REAL (ZREAL8)            :: OutputState(1:NumberElements)
REAL (ZREAL8)            :: LinearCombination(1:NumberMembers)
REAL (ZREAL8)            :: Keep(1:NumberElements)

REAL (ZREAL8)            :: rand, lhs, rhs
INTEGER                  :: i, j, unitno
CHARACTER*7              :: filename


  ! Set-up the members array
  DO j = 1, NumberMembers
    DO i = 1, NumberElements
      CALL RANDOM_NUMBER(rand)
      Members(i,j)      = rand - 0.5
      Members_copy(i,j) = Members(i,j)
    END DO
  END DO

  ! Output original members
  OPEN (unitno, file='OrigMembers')
  DO i = 1, NumberElements
    WRITE (unitno, '(I5,200F16.10)') i, (Members(i,j), j=1,NumberMembers)
  END DO
  CLOSE (unitno)

  ! Set-up Householder transform
  CALL Householder_create ( NumberElements,  &
                            NumberMembers,   &
                            Members(1:NumberElements, 1:NumberMembers) )

  ! Output transform
  OPEN (unitno, file='Transform')
  DO i = 1, NumberElements
    WRITE (unitno, '(I5,200F16.10)') i, (Members(i,j), j=1,NumberMembers)
  END DO
  CLOSE (unitno)


  ! TEST 1 - Put each member through the Householder transform
  ! ==========================================================
  DO j = 1, NumberMembers
    InputState(1:NumberElements) = Members_copy(1:NumberElements, j)
    CALL Householder_act ( NumberElements,                             &
                           NumberMembers,                              &
                           Members(1:NumberElements, 1:NumberMembers), &
                           InputState(1:NumberElements),               &
                           OutputState(1:NumberElements),              &
                           1 )

    WRITE (filename, '(A6,I1)') 'Result', j
    PRINT*, 'Writing to file ', filename
    OPEN (unitno, file=filename)
    DO i = 1, NumberElements
      WRITE (unitno, '(I5,F16.10)') i, OutputState(i)
    END DO
    CLOSE (unitno)

  END DO


  ! TEST 2 - Put new random numbers into the input state
  ! ====================================================
  DO i = 1, NumberElements
    CALL RANDOM_NUMBER(rand)
    InputState(i) = rand - 0.5
  END DO
  CALL Householder_act ( NumberElements,                             &
                         NumberMembers,                              &
                         Members(1:NumberElements, 1:NumberMembers), &
                         InputState(1:NumberElements),               &
                         OutputState(1:NumberElements),              &
                         1 )
  OPEN (unitno, file='RandomVector')
  DO i = 1, NumberElements
    WRITE (unitno, '(I5,F16.10)') i, OutputState(i)
  END DO
  CLOSE (unitno)


  ! TEST 3 - Linear combination of the original ensemble members
  ! ============================================================
  DO j = 1, NumberMembers
    CALL RANDOM_NUMBER(rand)
    LinearCombination(j) = rand - 0.5
  END DO

  InputState(1:NumberElements) = 0.0
  DO j = 1, NumberMembers
    InputState(1:NumberElements) = InputState(1:NumberElements) +    &
      LinearCombination(j) * Members_copy(1:NumberElements, j)
  END DO
  CALL Householder_act ( NumberElements,                             &
                         NumberMembers,                              &
                         Members(1:NumberElements, 1:NumberMembers), &
                         InputState(1:NumberElements),               &
                         OutputState(1:NumberElements),              &
                         1 )
  OPEN (unitno, file='LinearCombination')
  DO i = 1, NumberElements
    WRITE (unitno, '(I5,F16.10)') i, OutputState(i)
  END DO
  CLOSE (unitno)



  ! TEST 4 - Two applications of the Householder transform
  ! ======================================================
  DO i = 1, NumberElements
    CALL RANDOM_NUMBER(rand)
    InputState(i) = rand - 0.5
    Keep(i)       = InputState(i)
  END DO
  CALL Householder_act ( NumberElements,                             &
                         NumberMembers,                              &
                         Members(1:NumberElements, 1:NumberMembers), &
                         InputState(1:NumberElements),               &
                         OutputState(1:NumberElements),              &
                         1 )
  CALL Householder_act ( NumberElements,                             &
                         NumberMembers,                              &
                         Members(1:NumberElements, 1:NumberMembers), &
                         OutputState(1:NumberElements),              &
                         InputState(1:NumberElements),               &
                         -1 )

  OPEN (unitno, file='InverseTest')
  DO i = 1, NumberElements
    WRITE (unitno, '(I5,3F16.10)') i, Keep(i), InputState(i), InputState(i)-Keep(i)
  END DO
  CLOSE (unitno)


  ! TEST 5 - ADJOINT TEST
  ! =====================
  DO i = 1, NumberElements
    CALL RANDOM_NUMBER(rand)
    InputState(i) = rand - 0.5
    Keep(i)       = InputState(i)
  END DO

  ! Act with the Householder transform
  CALL Householder_act ( NumberElements,                             &
                         NumberMembers,                              &
                         Members(1:NumberElements, 1:NumberMembers), &
                         InputState(1:NumberElements),               &
                         OutputState(1:NumberElements),              &
                         1 )

  ! Calculate the LHS <(Hx)^T(Hx)>
  lhs = SUM(OutputState(1:NumberElements) * OutputState(1:NumberElements))

  ! Act with adjoint
  CALL Householder_act ( NumberElements,                             &
                         NumberMembers,                              &
                         Members(1:NumberElements, 1:NumberMembers), &
                         OutputState(1:NumberElements),              &
                         InputState(1:NumberElements),               &
                         -1 )
  ! Calculate the RHS <x^T H^T Hx)>
  rhs = SUM(InputState(1:NumberElements) * Keep(1:NumberElements))

  PRINT *, 'Adjoint test'
  PRINT *, lhs
  PRINT *, rhs



CONTAINS

RECURSIVE SUBROUTINE Householder_create (   &
      Nels,                                 & !IN     Number of elements (this recurse)
      Nmems,                                & !IN     Number of members (this recurse)
      Ens )                                   !INOUT


! Description
! -----------
! Routine to set-up the first column of a Householder transformation.
! Recursive routine allows all columns to be set-up.
! There are Nels elements of a Nmems ensemble state.
! Ross Bannister, NCEO, November 2010

! Nels       Number of elements in state
! Nmems      Number of ensemble members
! Ens        On entry: ensemble members
!            On exit : u-vectors that define the Householder transform

IMPLICIT NONE
INTEGER, PARAMETER           :: ZREAL8=SELECTED_REAL_KIND(15,307)

! Subroutine arguments
! --------------------
INTEGER,       INTENT(IN)    :: Nels
INTEGER,       INTENT(IN)    :: Nmems
REAL(ZREAL8),  INTENT(INOUT) :: Ens(1:Nels,1:Nmems)

! Local variables
! ---------------
REAL(ZREAL8)                 :: u(1:Nels)
REAL(ZREAL8)                 :: length_x, length_u_2, overlap, factor
INTEGER                      :: i

! Local constants
! ---------------
REAL(ZREAL8), PARAMETER      :: two = 2.0


  ! Calculate the u vector
  ! ----------------------
  u(1:Nels) = Ens(1:Nels,1)
  length_x  = SQRT(SUM(u(1:Nels) * u(1:Nels)))
  u(1)      = u(1) - length_x

  ! Act with the Householder transform defined by the above u on ensemble
  ! ---------------------------------------------------------------------
  length_u_2 = SUM(u(1:Nels) * u(1:Nels))
  ! First member is easy - as below - but don't actually need to do this
!  Ens(1:Nels,1) = 0.0
!  Ens(1,1)      = length_x

  ! Instead put this u vector in the place of the first ensemble member for later use
  Ens(1:Nels,1) = u(1:Nels)

  ! Do remainder of ensemble members
  IF (Nmems > 1) THEN
    DO i = 2, Nmems
      overlap = SUM(u(1:Nels)*Ens(1:Nels,i))
      factor  = two * overlap / length_u_2
      Ens(1:Nels,i) = Ens(1:Nels,i) - factor * u(1:Nels)
    END DO

    ! Call this routine on sub set
    CALL Householder_create (    &
           Nels-1,               &
           Nmems-1,              &
           Ens(2:Nels,2:Nmems) )
  END IF

END SUBROUTINE Householder_create




SUBROUTINE Householder_act (     &
     Nels,                       & !IN     Number of elements
     Nmems,                      & !IN     Number of members
     uMat,                       & !IN
     InputState,                 & !IN
     OutputState,                & !INOUT
     ForAdj )                      !IN     1 = forward, -1 = adjoint/inverse

! Description
! -----------
! Routine to act with the Householder transformation.
! The matrix of u-vectors (uMat) must be prepared beforehand using Householder_create
! There are Nels elements of a Nmems ensemble state.
! Ross Bannister, NCEO, November 2010

IMPLICIT NONE
INTEGER, PARAMETER       :: ZREAL8=SELECTED_REAL_KIND(15,307)

! Subroutine arguments
! --------------------
INTEGER,       INTENT(IN)      :: Nels
INTEGER,       INTENT(IN)      :: Nmems
REAL(ZREAL8),  INTENT(INOUT)   :: umat(1:Nels,1:Nmems)
REAL(ZREAL8),  INTENT(IN)      :: InputState(1:Nels)
REAL(ZREAL8),  INTENT(INOUT)   :: OutputState(1:Nels)
INTEGER,       INTENT(IN)      :: ForAdj

! Local variables
! ---------------
REAL(ZREAL8)                   :: inputoutput(1:Nels,1:2)
REAL(ZREAL8)                   :: u(1:Nels)
REAL(ZREAL8)                   :: length_u_2, overlap, factor
INTEGER                        :: i, j, instate_index, outstate_index, start, finish

! Local constants
! ---------------
REAL(ZREAL8), PARAMETER        :: two = 2.0

  ! Sort out forward or adjoint/inverse
  IF (ForAdj == 1) THEN
    start  = 1
    finish = Nmems
  ELSE
    start  = Nmems
    finish = 1
  END IF

  ! The two vectors in this array will alternate input/output within the routine
  InputOutput(1:Nels,1) = InputState(1:Nels)
  InputOutput(1:Nels,2) = 0.0

  ! Loop over each Householder transform
  DO i = start, finish, ForAdj
    instate_index  = MOD(i+1,2)+1
    outstate_index = MOD(i,2)+1
    IF (i > 1) THEN
      ! The identity part of this transform
      DO j = 1, i-1
        InputOutput(j,outstate_index) = InputOutput(j,instate_index)
      END DO
    END IF
    ! The I-2uu^T/u^Tu part
    ! The u-vector this transform comprises elements i to Nels of column i of umat
    length_u_2  = SUM(umat(i:Nels,i) * umat(i:Nels,i))
    overlap = SUM(umat(i:Nels,i) * InputOutput(i:Nels,instate_index))
    factor  = two * overlap / length_u_2
    DO j = i, Nels
      InputOutput(j,outstate_index) = InputOutput(j,instate_index) - factor *  &
                                      umat(j,i)
    END DO
  END DO

  ! Transfer final result into output state
  OutputState(1:Nels) = InputOutput(1:Nels,outstate_index)

END SUBROUTINE Householder_act

END PROGRAM Householder
