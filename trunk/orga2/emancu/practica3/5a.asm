section .text
global productoEscalar

%define n, 4


productoEscalar:
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov esi, [ebp+8]		; array
	
	; creo la mascara del escalar
	movss xmm7, [ebp+12]	; cargo el escalar
	pshufd	xmm7, xmm7, 00000000	; 
	
	xor ecx, ecx
	mov cx, [ebp+16]		; cargo el n, que es el size del array
	sar cx, 2				; lo divido por 4, porque proceso de a 4 numeros
	
	
for:	
	movups xmm0, [esi]
; falta hacer el ejercicio 
	movq mm5, [esi]			; mm5= {e0,e1,e2,e3}
	pmaddwd mm5, mm5			; mm5= {e0*e0 + e1*e1 , e2*e2 + e3*e3}

	
	paddd	mm4, mm5				; mm4+= {p1	|	p2}

	lea esi, [esi+8]
	 
loop for	

	; preparo el mm0 : promedio
	movq mm1, mm0			; mm1 auxiliar para sumar horizontalmente
	psrlq mm1, 32			; acomodo para sumar los 2 bajos de mm0 con los 2 altos
	paddd mm0, mm1
	psrlq mm1, 16
	paddd mm0, mm1			; suma total en mm0[0]
	
	; como mierda dividoooooooooooooooooo ?!?!?!?!


	; preparo el mm4 : varianza
	movq mm5, mm4
	psrlq	mm5, 32
	paddd	mm4, mm5	; mm4=  sumatoria al cuadrado

	; escribo los datos en las variables.	
	mov esi, [ebp+12]
	movd	[esi], mm0	
	mov esi, [ebp+16]	
	movd	[esi], mm4

	pop edi
	pop esi
	pop ebx
	pop ebp

ret
