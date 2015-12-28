;void suma(unsigned int* v1, unsigned int* v2, unsigned short n);



section .text 
global sumaYResta

extern malloc

%define pA [ebp + 8]
%define pB [ebp + 12]
%define cant [ebp + 16]


sumaYResta:
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	push eax


		
	mov esi, pA	; esi = pA
	mov edi, pB	; edi = pB
	

	mov byte eax,16	;quiero 8 bytes
	push eax
	call malloc
	add esp, 4  

	cmp eax, 0
	jnz continuar		; si no tengo memoria, fue
	jmp fin

continuar:
	xor ecx, ecx
	
	;preguntar que pasa con esto porque las mascaras estan al reves!!!!!!!!!!!!!!!!!!!!!
	mov dword [eax],11111111111111110000000000000000b
	mov dword [eax+4],11111111111111110000000000000000b

	mov dword [eax+8],00000000000000001111111111111111b
	mov dword [eax+12],00000000000000001111111111111111b

	movq mm5,[eax]			;tengo una de las mascaras:1111000011110000
	movq mm6,[eax+8]		;tengo la otra mascara;0000111100001111

	mov eax,esi				;pongo el puntero al resultadoo!
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

