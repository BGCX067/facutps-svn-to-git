;void promYDevEst(short int* vector, int* prom, int* V);

section .text 
global promYDevEst

extern malloc

%define pA [ebp + 8]
%define promedio [ebp + 12]
%define varianza [ebp + 16]
%define cant 8


promYDevEst:
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	push eax
	
	mov edi,[ebp + 12]
	mov dword [edi],0
	mov esi, pA	; esi = pA

	mov edx, 65537 ; 2^16 + 1		;todo esto para poder sumar en paralelooo
	MOVD mm5 , edx
	PSLLQ mm5, 32
	MOVD mm4 , edx	; tengo que moverlo a mm4 porque si no pisa la parte alta con 0	
						; el MOVD
	por mm5, mm4	; sumo los unos de la parte alta con los de la parte baja
						; en mm3 tengo los famosos 4 unos.
	

continuar:
	xor ecx, ecx
	
seguir:
	movq mm1,[esi]			; mm1 = |a1 |a2 |a3 |a4 |
	movq mm2,mm1
	movq mm3,mm1	
	pmaddwd mm1, mm5		; mm1 = |a1 + a2 | a3 + a4|
	pmullw mm2,mm2			;la parte baja de cada multiplicacion |l (a1*a1)|l (a2*a2) |l (a3*a3)| l (a4*a4)|
	movq mm4,mm2				;muevo para almacenar dps los otros numeros  |l (a1*a1)|l (a2*a2) |l (a3*a3)| l (a4*a4)|
	pmulhw mm3,mm3			;la parte alta |h (a1*a1)|h (a2*a2) |h (a3*a3)|h (a4*a4)|
	punpckhwd mm2,mm3		;junto los 2 primero numeros |h (a1*a1)|l (a1*a1)|h (a2*a2)|l (a2*a2)|
	punpcklwd mm4,mm3  	;junto los otros numeros |h (a3*a3)|l (a3*a3)|h (a4*a4)|l (a4*a4)|
	
	;en mm2 y mm4 tengo los numeros al cuadradoo

	paddd mm2,mm4
	movq mm6,mm2			;para sumar las 2 partes, lo muevo shifteo y lo sumo de nuevo
	psrlq mm6,32	
	paddd mm2,mm6		;en la dword menos significativa tengo el resultado

	movd edx,mm2
	add [edi],edx

	lea esi,[esi+8]

	add ecx,4
	cmp ecx,cant
	jne seguir

	

fin:
	pop eax
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret

ret

