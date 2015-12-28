; extern void asmRoberts(const char* src, char* dst, int ancho, int alto);

global asmRoberts

%define srcMat	[ebp + 8]
%define dstMat	[ebp + 12]	
%define width	[ebp + 16]
%define height	[ebp + 20]	

%define widthMenos1	[ebp - 4]
%define widthMenos16	[ebp - 8]

section .text

asmRoberts:
	enter 8, 0 

operarXY:	
	mov esi, srcMat 			; puntero a la matriz de entrada
	mov edi, dstMat	      ; puntero a la matriz resultado
	xor ebx, ebx
		
	; Cargamos valores auxiliares
	mov edx, width
	lea edx, [edx - 1]
	mov widthMenos1, edx
	lea edx, [edx - 15]
	mov widthMenos16, edx
	lea edx, [edx + 16]
	
	mov eax, height
	lea eax, [eax - 2]
	
cicloFilasXY:
	xor ecx, ecx
	add edi, width			; Posicionamos la matriz donde vamos a guardar el resultado

aplicarFiltroXY:
	push esi
	pxor xmm0, xmm0

	;; Vamos a hacer 2 accesos a memoria y traer los datos corridos solo por 1 pixel,
	;; de esta manera podemos procesar una mayor cantidad de pixeles.

	lea esi, [esi + ecx]				; puntero a la primer posicion a leer
	movdqu  xmm1, [esi]				; xmm1 primer linea
	movdqu  xmm4, [esi + edx + 1]	; xmm4 segunda linea desplazado en 1
	psubusb xmm1, xmm4				; xmm1 = xmm1 - xmm4
		
	movdqu xmm0, xmm1					; guardo el resultado en xmm0
	
	pop esi
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	; xmm0 resultado final de X
		
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	push esi

	lea esi, [esi + ecx]				; puntero a la primer posicion a leer
	movdqu  xmm1, [esi + 1]			; xmm1 primer linea desplazado en 1
	movdqu  xmm4, [esi + edx]		; xmm4 segunda linea
	psubusb xmm1, xmm4				; xmm1 = fila1 - fila4
		
	paddusb xmm0, xmm1				; sumamos el resultado en xmm0

	pop esi	

	movdqu [edi+ecx+1], xmm0	; salteamos el primer elemento, porque no podemos calcularlo

	add ecx, 15						; avanzamos de a 15 porque es la cantidad de pixeles que procesamos
	cmp ecx, widthMenos16 		; procesamos de a 15 hasta que llegamos a los ultimos 16 pixeles
	jg compararConFinXY			; si pasamos los ultimos 16, podemos haber terminado
	jmp aplicarFiltroXY			; sino, seguimos calculando de a 15
	
compararConFinXY:
	cmp ecx, widthMenos1			; llegamos al final de la fila
	je proximaFilaXY
	mov ecx, widthMenos16		; preparamos para procesar los ultimos
	jmp aplicarFiltroXY			

proximaFilaXY:
	inc ebx
	add esi, width		; avanzamos a la proxima columna
	cmp ebx, eax		
	jne cicloFilasXY	; si no termino la matriz, repite el ciclo

finXY:
	leave
	ret	

