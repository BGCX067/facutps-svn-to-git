section .text
global prodInterno

prodInterno:
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov esi, [ebp+8]
	mov edi, [ebp+12]
	xor ecx, ecx
	mov cx, [ebp+16]		; cargo el n, que es el size del array
	sar cx, 2				; lo divido por 4, porque proceso de a 4 numeros
	
for:	
	movq mm0, [esi] 		; tomo los 4 enteros vecA 64 bits
	movq mm1, [edi] 		; tomo los 4 enteros vecB 64 bits
	
	mov eax, 0x0001FFFF			; creo la mascara 1, -1	
	movd mm2, eax
	pshufw mm2, mm2, 00010001	; ya tengo la mascara ordenada, lista para multiplicar

	pmullw mm1,mm2
	
	paddw mm0, mm1		; sumo de a word (16 bits) cada entero

	movq [esi], mm0	; devuelvo los 4 enteros en vecA 64 bits

	lea esi, [esi+8]
	lea edi, [edi+8]
	 
loop for	


pop eax
	pop edi
	pop esi
	pop ebx
	pop ebp

ret
