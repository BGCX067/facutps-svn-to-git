;float* productoEscalar(float* v, float k, unsigned short n);

section .text 
global productoEscalar

extern malloc

%define pA [ebp + 8]
%define escalarFloat [ebp + 12]
%define tamaño [ebp + 16]


productoEscalar:
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	push eax
	
	
	mov esi, pA	; esi = pA

	
continuar:
	xor ecx, ecx

seguir:
	movups xmm0,[esi]			; mm1 = |a1 |a2 |a3 |a4 |
	movss xmm1, escalarFloat
	pshufd xmm1, xmm1, 00000000
	;lea esi,[esi+8]

	;add ecx,4
	;cmp ecx,cant
	;jne seguir

	

fin:
	pop eax
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret

ret

