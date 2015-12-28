;void suma(unsigned int* v1, unsigned int* v2, unsigned short n);



section .text 
global suma

%define pA [ebp + 8]
%define pB [ebp + 12]
%define cant [ebp + 16]


suma:
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	
	
	mov esi, pA	; esi = pA
	mov edi, pB	; edi = pB
	xor ecx, ecx



seguir:

	movq mm1,[esi]
	movq mm2,[edi]
	paddd mm1,mm2
	movq [esi],mm1

	lea esi,[esi+8]
	lea edi,[edi+8]

	inc ecx
	inc ecx
	cmp ecx,cant
	jne seguir

	pop edi
	pop esi
	pop ebx
	pop ebp
	ret

ret

