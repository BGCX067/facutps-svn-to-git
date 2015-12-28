section .text
global suma

suma:
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov esi, [ebp+8]
	mov edi, [ebp+12]
	xor ecx, ecx
	mov cx, [ebp+16]		; cargo el n, que es el size del array
	sar cx, 1				; lo divido por 2, porque proceso de a 2 numeros
	
for:	
	movq mm0, [esi] 	; tomo los 2 enteros vecA 64 bits
	movq mm1, [edi] 	; tomo los 2 enteros vecB 64 bits
	paddd mm0, mm1		; sumo de a double (32 bits) cada entero

	movq [esi], mm0	; devuelvo los 2 enteros en vecA 64 bits

	lea esi, [esi+8]
	lea edi, [edi+8]
	 
loop for	



	pop edi
	pop esi
	pop ebx
	pop ebp

ret
