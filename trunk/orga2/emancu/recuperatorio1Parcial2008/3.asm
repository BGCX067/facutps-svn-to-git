section .data
A:	dd 1.5, 0.3, 5.1, 3.0
B:	dd 3.8, 1.0, 2.0, 9.99
C: dd 9.0, 81.4, 3.14, 4.424

A2:	dd -1,  5,  3,  8
B2:	dd 3,  8, 19, 99
C2:   dd 9, 81,  4,  3

section .text
	global usandoSSE
	global usandoFPU

usandoFPU:
	enter 0,0
	
	leave
ret

usandoSSE:
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	movups xmm0, [A2]
	movups xmm1, [B2]
	movups xmm2, [C2] 
	
ojo:
	MOVMSKPS eax, xmm0
	CMP eax, 0
	JE	sonMayores
	MOVUPS	xmm0, xmm2
	JMP continuar
	
sonMayores:
	MOVUPS xmm0, xmm1	
	
continuar:		
	movups [A2], xmm0
	mov eax, A2

	pop edi
	pop esi
	pop ebx
	pop ebp


ret
