; extern void asmPrewitt(const char* src, char* dst, int ancho, int alto);

global asmPrewitt

%define srcMat	[ebp + 8]
%define dstMat	[ebp + 12]	
%define width	[ebp + 16]
%define height	[ebp + 20]	

%define widthMenos2	[ebp - 4]
%define widthMenos16	[ebp - 8]

section .text

asmPrewitt:
	enter 8, 0 

operarXY:	
	mov esi, srcMat 			; puntero a la matriz de entrada
	mov edi, dstMat	      ; puntero a la matriz resultado
	xor ebx, ebx
		
	; Cargamos valores auxiliares
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
	add edi, width			; Posicionamos la matriz donde vamos a guardar el resultado

aplicarFiltroXY:
	push esi
	pxor xmm0, xmm0

	;; Vamos a hacer 2 accesos a memoria y traer los datos corridos solo por dos
	;; pixeles, de esta manera podemos procesar una mayor cantidad de pixeles.

	; Primer linea

	lea esi, [esi + ecx]				; puntero a la primer posicion a leer
	movdqu  xmm4, [esi]				; xmm4 auxiliar, (1..16)
	movdqu  xmm1, [esi + 2]			; xmm1 = numeros (3..18)
	psubusb xmm1, xmm4				; xmm1 = 3-1 | 4-2 | 5-3 | 6-4 | ... | 
	
	; Segunda linea
	
	lea esi, [esi + edx]				; avanzamos a la 2 linea
	movdqu  xmm4, [esi]				; xmm4 auxiliar, (17..32)
	movdqu  xmm2, [esi + 2]			; xmm2 = numeros (19..35)
	psubusb xmm2, xmm4				; xmm2 = 19-17 | 20-18 | 21-19 | 22-20 | ... |

	paddusb xmm1, xmm2				; xmm1 = linea1 + linea2

	; Tercer linea

	lea esi, [esi + edx]				; avanzamos a la 3 linea      	
	movdqu  xmm4, [esi]				; xmm4 auxiliar, (33..48)
	movdqu  xmm2, [esi + 2]			; xmm2 = numeros (35..48 @ @)
	psubusb xmm2, xmm4				; xmm2 = 35-33 | 36-34 | 37-35 | 38-36 | ... |

	paddusb xmm1, xmm2				; xmm1 = linea1 + linea2 + linea3
	
	movdqu xmm0, xmm1					; guardo el resultado en xmm0
	
	pop esi
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	; xmm0 resultado final de X
		
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	push esi

	; Primer columna

	lea esi, [esi + ecx]				; puntero a la primer posicion a leer
	movdqu  xmm4, [esi]				; xmm4 auxiliar, fila 1
	movdqu  xmm1, [esi + 2*edx]	; xmm1 		   , fila 3
	psubusb xmm1, xmm4				; xmm1 = fila3 - fila1
		
	; Segunda columna
	lea esi, [esi + 1]				; puntero a la primer posicion a leer
	movdqu  xmm4, [esi]				; xmm4 auxiliar, fila 1
	movdqu  xmm2, [esi + 2*edx]	; xmm2 		   , fila 3
	psubusb xmm2, xmm4				; xmm2 = fila3 - fila1

	; Tercer columna
	lea esi, [esi + 1]				; puntero a la primer posicion a leer
	movdqu  xmm4, [esi]				; xmm4 auxiliar, fila 1
	movdqu  xmm3, [esi + 2*edx]	; xmm3 		   , fila 3
	psubusb xmm3, xmm4				; xmm3 = fila3 - fila1
	
	paddusb xmm1, xmm2
	paddusb xmm1, xmm3				; xmm1 = resultado de Y
	
	paddusb xmm0, xmm1				; sumamos el resultado en xmm0

	pop esi	

	movdqu [edi+ecx+1], xmm0	; salteamos el primer elemento, porque no podemos calcularlo

	add ecx, 14						; avanzamos de a 14 porque es la cantidad de pixeles que procesamos
	cmp ecx, widthMenos16 		; procesamos de a 14 hasta que llegamos a los ultimos 16 pixeles
	jg compararConFinXY			; si pasamos los ultimos 16, podemos haber terminado
	jmp aplicarFiltroXY			; sino, seguimos calculando de a 14
	
compararConFinXY:
	cmp ecx, widthMenos2			; llegamos al final de la fila
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

