	SUBROUTINE EXT(argc, argv)  
C	Wrapper routine which acts as an interface to the real code
C	in ext1
	INTEGER*4 argc, argv(*)
	j = LOC(argc)
	CALL EXT1(%VAL(argv(1)), %VAL(argv(2)), %VAL(argv(3)))
	RETURN
	END

	SUBROUTINE EXT1(A, B, C)
	REAL*4 A, B, C
	C=A*B
	RETURN
	END
