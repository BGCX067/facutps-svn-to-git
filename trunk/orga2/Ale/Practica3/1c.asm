;int prodInterno(short int *v1, char *v2, unsigned short n);

section .text 
global prodInterno

extern malloc

%define pA [ebp + 8]
%define pB [ebp + 12]
%define cant [ebp + 16]


prodInterno:
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	push eax


		
	mov esi, pA	; esi = pA
	mov edi, pB	; edi = pB
	

continuar:
	xor ecx, ecx
	
seguir:
	movq mm1,[esi]
	movq mm4,mm1			;copio para hacer la resta
	movq mm2,[edi]
	paddw mm1,mm2
	psubw mm4,mm2
	pand mm1,mm6			;aca me quedo con las sumas
	pand mm4,mm5			;aca me quedo con las restas
	por mm1,mm4				;junto los 2 resultados
		
	movq [esi],mm1

	lea esi,[esi+8]
	lea edi,[edi+8]

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

