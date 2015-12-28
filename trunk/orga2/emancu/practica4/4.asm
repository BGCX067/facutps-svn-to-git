section .data
	quinto: 			dd 0.2
	tresMedios: 	dd 1.5
	sieteCuartos: 	dd 1.75

section .text
global func4

%define X [ebp+ 8]
%define Y [ebp+12]

func4:
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	finit					; inicializo 

	FLD dword X			; ST0= X
	FMUL st0, st0		; ST0= X*X
	FLD1					; ST0= 1 // ST1= X*X
	FADD st0, st0
	FMUL st1, st0		; ST0= 2 // ST1= 2*X*X
	
	FLDPI
	FMUL st0, st0
	FMULP					; ST0= 2*PI^2 // ST1= 2*X^2

	FADDP					; ST0= 2*PI^2 + 2*X^2

	FMUL dword [sieteCuartos] ;
	
	FCOS					; ST0= cos( (7/4) * (2*PI^2 + 2*X^2))

	FMUL dword [tresMedios] ;
	
	;; cargo e*e en la pila
	
	FLDL2E				; ST0= log2 (e) // ST1= cos(...) *(3/2)
	F2XM1					; ST0= 2^(log2 (e)) - 1 // ST1= cos(...) *(3/2)
	FLD1					;
	FADDP st1			; ST0= e		//	ST1= cos(...)*(3/2)
	FMUL st0				; ST0= e^2  // ST1= cos(...)*(3/2)
	FMULP st1			; ST0= (e^2) * cos(...)*(3/2)

	;; ya tengo lista la segunda parte, ahora cargo la primera
	
	FLD dword X			; ST0= X			// ST1= segunda parte
	FSIN					; ST0= sin(X)	// ST1= segunda parte
	FLD dword Y 				; ST0= Y			// ST1= sin(X)				// ST2= segunda parte
	FCOS 					; ST0= cos(Y)	// ST1= sin(X)				// ST2= segunda parte
	
	FMULP 				; ST0= cos(Y)*sin(X)	// ST1= segunda parte
	FMUL dword [quinto]			; ST0= cos(Y)*sin(X)/5	// ST1= segunda parte
	
	FXCH					; Alterna ST0 con ST1, pues FSUBP hace ST0= ST1 - ST0	
	FSUBP 				; ST0= cos(Y)*sin(X)/5 - (3/2)*cos(...)*e^2


fin:
	pop edi
	pop esi
	pop ebx
	pop ebp

ret
