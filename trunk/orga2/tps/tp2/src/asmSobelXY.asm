; extern void asmSobel(const char* src, char* dst, int ancho, int alto, int xorder, int yorder);

global asmSobel

%define srcMat	[ebp + 8]
%define dstMat	[ebp + 12]	
%define width	[ebp + 16]
%define height	[ebp + 20]	
%define x		[ebp + 24]
%define y		[ebp + 28]

%define widthMenos2		[ebp - 4]
%define widthMenos16	[ebp - 8]

section .text

;; xmm0: Mascara de 0 // xmm1: primer fila // xmm2: segunda fila // xmm3: tercer fila
;; xmm4: Suma total	 // xmm5: auxiliar	 // xmm6: auxiliar

asmSobel:
	enter 8, 0 

	cmp dword x, 1
	jne operarSoloY
	cmp dword y, 1
	jne operarSoloX
	
operarXY:	
	; procesamos primero con x	
	mov esi, srcMat 		; puntero a la matriz de entrada
	mov edi, dstMat	        ; puntero a la matriz resultado
	xor ebx, ebx
		
	mov edx, width
	lea edx, [edx - 2]
	mov widthMenos2, edx
	lea edx, [edx - 14]
	mov widthMenos16, edx
	lea edx, [edx + 16]
	
	mov eax, height
	lea eax, [eax - 2]
	
cicloFilasXY:
	xor ecx, ecx
	add edi, width			; posiciono la matriz donde voy a guardar el resultado

aplicarFiltroXY:
;; -------------------------------------------------------------------------------------------------------------

aplicarFiltroXYY:
	push esi
	pxor xmm0, xmm0

	lea esi, [esi + ecx]				; puntero a la primer posicion a leer
	movdqu xmm1, [esi]
	movdqu xmm4, xmm1
	punpcklbw xmm4, xmm0			; extendemos a 16 bits los 8 numeros de la parte baja.

	lea esi, [esi + edx]          	
	movdqu xmm2, [esi]				; leemos la segunda fila
	movdqu xmm5, xmm2
	punpcklbw xmm5, xmm0			; extendemos a 16 bits los 8 numeros de la parte baja.

	paddw xmm4, xmm5				; xmm4 = fila1 + fila2
	paddw xmm4, xmm5				; xmm4 = fila1 + fila2 + fila2

	lea esi, [esi + edx]          
	movdqu xmm3, [esi]				; leemos la tercer fila
	movdqu xmm5, xmm3
	punpcklbw xmm5, xmm0			; extendemos a 16 bits los 8 numeros de la parte baja.

	paddw xmm4, xmm5				; xmm4 = (fila1 + fila2) + fila3
	movdqu xmm6, xmm4     			; xmm6 = xmm4 (necesitamos la sumatoria de las filas 7 y 8)

	movdqu xmm5, xmm4					
	pslldq xmm5, 4					; shift 4bytes para acomodar los elementos para restar
	psubw xmm4, xmm5				; xmm4 = @$! | @$! | S2 | S3 | S4 | S5 | S6 | S7 |

;;segunda partee!!!

	; Usamos los mismos registros porque no necesitamos conservar mas los datos
	punpckhbw xmm1, xmm0
	punpckhbw xmm2, xmm0
	punpckhbw xmm3, xmm0

; xmm1 = fila1 + fila2 + fila2 + fila3
	paddw xmm1, xmm2
	paddw xmm1, xmm2
	paddw xmm1, xmm3	

; necesitamos sum7 y sum8 adelante de todo..
	psrldq xmm6, 12				; xmm6 = S7 | S8 | 00 | 00 | 00 | 00 | 00 | 00 | 00 |

	movdqu xmm5, xmm1	
	pslldq xmm5, 4				; shift 4bytes para acomodar los elementos para restar
	
	por xmm6, xmm5				; xmm6 = S7 | S8 | S9 | S10 | S11 | S12 | S13 | S14 | S15 |
	psubw xmm1, xmm6 			; xmm1 = xmm1 - xmm6 (resultado final segunda parte)

	; ahora unimos los 2 resultados

	packuswb xmm4, xmm1			; xmm1 = 0 | 0 | R2 | R3 | ...... | R14 | R15
	
	psrldq 	xmm4, 2				; sacamos 2 numeros basura

	;; en xmm5 guardamos el resultado de X, ya que para calcular Y no lo usamos
	movdqu xmm5, xmm4
	pop esi
	; volvemos a empezar pero con Y
	
	push esi
	pxor xmm0, xmm0

	lea esi, [esi + ecx]		; puntero a la primer posicion a leer
	movdqu xmm1, [esi]			; 16 numeros, dato original
	movdqu xmm6, xmm1			; xmm6 auxiliar donde se guarda la primer parte
	punpcklbw xmm6, xmm0		
	
	movdqu	xmm2, xmm6			; tenemos que guardar el S7 y S8
	psrldq  xmm2, 12
	
	movdqu xmm0, xmm6
	pslldq xmm0, 2				; shift 2 bytes para mover un numero

	paddw xmm6, xmm0
	paddw xmm6, xmm0

	pslldq xmm0, 2				; shift para terminar la suma horizontal
	paddw xmm6, xmm0			; xmm6 = Col1 + Col2 + Col2 + Col3

;; segunda fila 
	;; es 0

;; tercer fila
	pxor xmm0, xmm0
	lea esi, [esi + 2*edx]		; puntero a la 3 fila a leer
	movdqu xmm3, [esi]			; 16 numeros, dato original
	movdqu xmm7, xmm3			; xmm7 auxiliar donde se guarda la primera parte
	punpcklbw xmm7, xmm0		
	
	movdqu  xmm4, xmm7			; tenemos que guardar el S39 y S40
	psrldq  xmm4, 12
	
	movdqu xmm0, xmm7
	pslldq xmm0, 2				; shift 2 bytes para mover un numero

	paddw xmm7, xmm0
	paddw xmm7, xmm0

	pslldq xmm0, 2				; shift para terminar la suma horizontal
	paddw xmm7, xmm0			; xmm7 = Col1 + Col2 + Col2 + Col3
	psubw xmm7, xmm6			; xmm7 resultado, xmm6 libre

;;segunda partee!!!
	; Usamos los mismos registros porque no necesitamos conservar mas los datos
	pxor xmm0, xmm0
	punpckhbw xmm1, xmm0
	punpckhbw xmm3, xmm0
	
	movdqu xmm0, xmm1
	pslldq xmm0, 4				; shift 4 bytes para mover 2 numeros
	por xmm0, xmm2
	pcmpeqb xmm2,xmm2			; creamos la mascara
	pslldq xmm2,14
	psrldq xmm2,2
	pand   xmm2, xmm1
	pslldq  xmm2, 2
	paddw   xmm1, xmm0			; sumo !
	psrldq xmm0, 2
	por xmm0, xmm2
	paddw   xmm1, xmm0			; sumo !
	paddw   xmm1, xmm0			; xmm1 = Col1 + Col2 + Col2 + Col3
	
	;fila 3
	
	movdqu 	xmm0, xmm3
	pslldq 	xmm0, 4				; shift 4 bytes para mover 2 numeros
	por 	xmm0, xmm4
	pcmpeqb xmm4, xmm4			; creamos la mascara
	pslldq 	xmm4, 14			; creamos la mascara
	psrldq  xmm4, 2
	pand   	xmm4, xmm3
	pslldq  xmm4, 2
	paddw   xmm3, xmm0			; sumo !
	psrldq 	xmm0, 2
	por 	xmm0, xmm4
	paddw   xmm3, xmm0			; sumo !
	paddw   xmm3, xmm0			; xmm3 = Col1 + Col2 + Col2 + Col3

	psubw	xmm3, xmm1
	; ahora unimos los 2 resultados

	packuswb	xmm7, xmm3		; en xmm3 vamos a tener 0 | 0 | R2 | R3 | ...... | R14 | R15
	psrldq 	xmm7, 2

	pop esi	
	
	paddusb xmm5, xmm7
	
	; asdasdasd	

	movdqu [edi+ecx+1], xmm5	; salteamos el primer elemento, porque no podemos calcularlo

	add ecx, 14					; avanzamos de a 14 porque es la cantidad de pixeles que procesamos
	cmp ecx, widthMenos16 		; procesamos de a 14 hasta que llegamos a los ultimos 16 pixeles
	jg compararConFinXY			; si pasamos los ultimos 16, podemos haber terminado
	jmp aplicarFiltroXY			; sino, seguimos calculando de a 14
	
compararConFinXY:
	cmp ecx, widthMenos2		; llegamos al final de la fila
	je proximaFilaXY
	mov ecx, widthMenos16		; preparamos para procesar los ultimos
	jmp aplicarFiltroXY			

proximaFilaXY:
	inc ebx
	add esi, width		; avanzamos a la proxima columna ?!?!?!?!?!?! @@@@@@@@@@@@@@@@@@@@@@@@@
	cmp ebx, eax		; me fijo si termine la matriz
	jne cicloFilasXY

finXY:
	leave
	ret	

;-------------------------------------------------------------------------------------------------------------------------------

operarSoloX:
	
	mov esi, srcMat 		; puntero a la matriz de entrada
	mov edi, dstMat	        ; puntero a la matriz resultado
	xor ebx, ebx			; contador para el alto de la matriz
	
	mov edx, width
	lea edx, [edx - 2]
	mov widthMenos2, edx
	lea edx, [edx - 14]
	mov widthMenos16, edx
	lea edx, [edx + 16]
	
	mov eax, height
	lea eax, [eax - 2]
	
cicloFilasX:
	xor ecx, ecx
	add edi, width			; posiciono la matriz donde voy a guardar el resultado		

aplicarFiltroX:
	push esi
	pxor xmm0, xmm0
	
	lea esi,[esi + ecx]				; puntero a la primer posicion a leer
	movdqu xmm1, [esi]
	movdqu xmm4, xmm1
	punpcklbw xmm4, xmm0			; extendemos a 16 bits los 8 numeros de la parte baja.
	
	lea esi, [esi + edx]          	
	movdqu xmm2, [esi]				; leemos la segunda fila
	movdqu xmm5, xmm2
	punpcklbw xmm5, xmm0			; extendemos a 16 bits los 8 numeros de la parte baja.

	paddw xmm4, xmm5				; xmm4 = fila1 + fila2
	paddw xmm4, xmm5				; xmm4 = fila1 + fila2 + fila2

	lea esi, [esi + edx]          
	movdqu xmm3, [esi]				; leemos la tercer fila
	movdqu xmm5, xmm3
	punpcklbw xmm5, xmm0			; extendemos a 16 bits los 8 numeros de la parte baja.

	paddw xmm4, xmm5				; xmm4 = (fila1 + fila2) + fila3
	movdqu xmm6, xmm4     			; xmm6 = xmm4 (necesitamos la sumatoria de las filas 7 y 8)
	
	movdqu xmm5, xmm4					
	pslldq xmm5, 4					; shift 4bytes para acomodar los elementos para restar
	psubw xmm4, xmm5				; xmm4 = @$! | @$! | S2 | S3 | S4 | S5 | S6 | S7 |


;;segunda partee!!!

	; Usamos los mismos registros porque no necesitamos conservar mas los datos
	punpckhbw xmm1, xmm0
	punpckhbw xmm2, xmm0
	punpckhbw xmm3, xmm0

; xmm1 = fila1 + fila2 + fila2 + fila3
	paddw xmm1, xmm2
	paddw xmm1, xmm2
	paddw xmm1, xmm3	

; necesitamos sum7 y sum8 adelante de todo..
	psrldq xmm6, 12				; xmm6 = S7 | S8 | 00 | 00 | 00 | 00 | 00 | 00 | 00 |

	movdqu xmm5, xmm1	
	pslldq xmm5, 4				; shift 4bytes para acomodar los elementos para restar
	
	por xmm6, xmm5				; xmm6 = S7 | S8 | S9 | S10 | S11 | S12 | S13 | S14 | S15 |
	psubw xmm1, xmm6 			; xmm1 = xmm1 - xmm6 (resultado final segunda parte)

	; ahora unimos los 2 resultados

	packuswb xmm4, xmm1			; xmm1 = 0 | 0 | R2 | R3 | ...... | R14 | R15
	
	psrldq 	xmm4, 2				; sacamos 2 numeros basura
	
	; grabamos a memoria
	pop esi

	movdqu [edi+ecx+1], xmm4	; salteamos el primer elemento, porque no podemos calcularlo

	add ecx, 14					; avanzamos de a 14 porque es la cantidad de pixeles que procesamos
	cmp ecx, widthMenos16 		; procesamos de a 14 hasta que llegamos a los ultimos 16 pixeles
	jg compararConFin			; si pasamos los ultimos 16, podemos haber terminado
	jmp aplicarFiltroX			; sino, seguimos calculando de a 14
	
compararConFin:
	cmp ecx, widthMenos2		; llegamos al final de la fila
	je proximaFila				 
	mov ecx, widthMenos16		; preparamos para procesar los ultimos
	jmp aplicarFiltroX			

proximaFila:
	inc ebx
	add esi, width		; avanzamos a la proxima columna ?!?!?!?!?!?! @@@@@@@@@@@@@@@@@@@@@@@@@
	cmp ebx, eax		; me fijo si termine la matriz
	jne cicloFilasX

fin:
	leave
	ret	


;-------------------------------------------------------------------------------------------------------------------------------
operarSoloY:

	mov esi, srcMat 		;tengo el puntero a la matriz de entrada
	mov edi, dstMat	        ;tengo el puntero a la matriz resultado
	xor ebx, ebx
	
	mov edx, width
	lea edx, [edx - 2]
	mov widthMenos2, edx
	lea edx, [edx - 14]
	mov widthMenos16, edx
	lea edx, [edx + 16]
	
	mov eax, height
	lea eax, [eax - 2]
	
cicloFilasY:
	xor ecx, ecx
	add edi, width			;posiciono la matriz donde voy a guardar el resultado		
	
aplicarFiltroY:
	push esi
	pxor xmm0, xmm0

	lea esi, [esi + ecx]		; puntero a la primer posicion a leer
	movdqu xmm1, [esi]			; 16 numeros, dato original
	movdqu xmm6, xmm1			; xmm6 auxiliar donde se guarda la primer parte
	punpcklbw xmm6, xmm0		
	
	movdqu	xmm2, xmm6			; tenemos que guardar el S7 y S8
	psrldq  xmm2, 12
	
	movdqu xmm0, xmm6
	pslldq xmm0, 2				; shift 2 bytes para mover un numero

	paddw xmm6, xmm0
	paddw xmm6, xmm0

	pslldq xmm0, 2				; shift para terminar la suma horizontal
	paddw xmm6, xmm0			; xmm6 = Col1 + Col2 + Col2 + Col3

;; segunda fila 
	;; es 0

;; tercer fila
	pxor xmm0, xmm0
	lea esi, [esi + 2*edx]		; puntero a la 3 fila a leer
	movdqu xmm3, [esi]			; 16 numeros, dato original
	movdqu xmm7, xmm3			; xmm7 auxiliar donde se guarda la primera parte
	punpcklbw xmm7, xmm0		
	
	movdqu  xmm4, xmm7			; tenemos que guardar el S39 y S40
	psrldq  xmm4, 12
	
	movdqu xmm0, xmm7
	pslldq xmm0, 2				; shift 2 bytes para mover un numero

	paddw xmm7, xmm0
	paddw xmm7, xmm0

	pslldq xmm0, 2				; shift para terminar la suma horizontal
	paddw xmm7, xmm0			; xmm7 = Col1 + Col2 + Col2 + Col3
	psubw xmm7, xmm6			; xmm7 resultado, xmm6 libre

;;segunda partee!!!
	; Usamos los mismos registros porque no necesitamos conservar mas los datos
	pxor xmm0, xmm0
	punpckhbw xmm1, xmm0
	punpckhbw xmm3, xmm0
	
	movdqu xmm0, xmm1
	pslldq xmm0, 4				; shift 4 bytes para mover 2 numeros
	por xmm0, xmm2
	pcmpeqb xmm2,xmm2			; creamos la mascara
	pslldq xmm2,14
	psrldq xmm2,2
	pand   xmm2, xmm1
	pslldq  xmm2, 2
	paddw   xmm1, xmm0			; sumo !
	psrldq xmm0, 2
	por xmm0, xmm2
	paddw   xmm1, xmm0			; sumo !
	paddw   xmm1, xmm0			; xmm1 = Col1 + Col2 + Col2 + Col3
	
	;fila 3
	
	movdqu 	xmm0, xmm3
	pslldq 	xmm0, 4				; shift 4 bytes para mover 2 numeros
	por 	xmm0, xmm4
	pcmpeqb xmm4, xmm4			; creamos la mascara
	pslldq 	xmm4, 14			; creamos la mascara
	psrldq  xmm4, 2
	pand   	xmm4, xmm3
	pslldq  xmm4, 2
	paddw   xmm3, xmm0			; sumo !
	psrldq 	xmm0, 2
	por 	xmm0, xmm4
	paddw   xmm3, xmm0			; sumo !
	paddw   xmm3, xmm0			; xmm3 = Col1 + Col2 + Col2 + Col3

	psubw	xmm3, xmm1
	; ahora unimos los 2 resultados

	packuswb	xmm7, xmm3		; en xmm3 vamos a tener 0 | 0 | R2 | R3 | ...... | R14 | R15
	psrldq 	xmm7, 2

	pop esi
	; grabamos en memoria
	movdqu [edi+ecx+1], xmm7
	
	add ecx, 14
	cmp ecx, widthMenos16 	;me fijo se me pase de width - 16
	jg compararConFinY
	jmp aplicarFiltroY
	
compararConFinY:
	cmp ecx, widthMenos2
	je proximaFilaY
	mov ecx, widthMenos16
	jmp aplicarFiltroY

proximaFilaY:
	inc ebx
	add esi, width		;me muevo a la proxima columna
	cmp ebx, eax		;me fijo si termine la matriz
	jne cicloFilasY

finY:
	leave
	ret
