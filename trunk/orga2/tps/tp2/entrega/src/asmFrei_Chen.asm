; extern void asmFrei-Chen(const char* src, char* dst, int ancho, int alto);

global asmFrei_Chen

%define srcMat	[ebp + 8]
%define dstMat	[ebp + 12]	
%define width	[ebp + 16]
%define height	[ebp + 20]	

%define widthMenos2		[ebp - 4]
%define widthMenos16	[ebp - 8]

section .text

asmFrei_Chen:
	enter 8, 0 

operarXY:	
	mov esi, srcMat 		; puntero a la matriz de entrada
	mov edi, dstMat	        ; puntero a la matriz resultado
	xor ebx, ebx

	;; Calculamos la raiz de 2
	mov eax, 2
	movd xmm0, eax
	pshufd xmm0, xmm0, 00000000
	cvtdq2ps xmm0, xmm0
	sqrtps xmm0,xmm0
	; xmm0 => sqrt(2) | sqrt(2) | sqrt(2) | sqrt(2) |

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

	;; Vamos a hacer 2 accesos a memoria y traer los datos corridos solo por dos
	;; pixeles, de esta manera podemos procesar una mayor cantidad de pixeles.

	; La primer linea no necesitamos pasarla a 32 bits, calculamos todo junto

	lea esi, [esi + ecx]			; avanzamos a la 1 linea
	movdqu xmm4, [esi]				; xmm4 auxiliar, (1..16)
	movdqu xmm1, [esi + 2]			; xmm1 = numeros (3..18)
	psubusb  xmm1, xmm4				; xmm1 = 3-1 | 4-2 | 5-3 | 6-4 | ... | 

	; La segunda linea calculamos todo junto, y despues la multiplicamos por raiz(2)
	; cuando hagamos el calculo de las 3 lineas al mismo tiempo.

	lea esi, [esi + edx]			; avanzamos a la 2 linea
	movdqu xmm4, [esi]				; xmm4 auxiliar, (17..32)
	movdqu xmm2, [esi + 2]			; xmm2 = numeros (19..35)
	psubusb  xmm2, xmm4				; xmm2 = 19-17 | 20-18 | 21-19 | 22-20 | ... |

	lea esi, [esi + edx]			; avanzamos a la 3 linea      	
	movdqu xmm4, [esi]				; xmm4 auxiliar, (33..48)
	movdqu xmm3, [esi + 2]			; xmm3 = numeros (35..48 @ @)
	psubusb  xmm3, xmm4				; xmm3 = 35-33 | 36-34 | 37-35 | 38-36 | ... |

	; sumamos las lineas 1 y 3 para luego ir desempaquetando y sumando con raix(2) * xmm2									

	paddusb xmm1, xmm3				; xmm1 = xmm1 + xmm3 

	; ¡ xmm1 y xmm2 no se pueden editar !
	; los registros del xmm3 hasta el xmm7 estan libres	
	pack_and_unpackX:
		pxor xmm4, xmm4					; xmm4 = xmm2 * raiz(2)
		pxor xmm5, xmm5					; llenamos de ceros para poder desempaquetar
		pcmpeqd xmm6, xmm6				; creamos una mascara en xmm6 que vamos a utilizar para unir los calculos
		psrldq xmm6, 12					; | 0 | 0 | 0 | FFFFFFFF | 
		
	;; Desempaquetamos solo el xmm2 porque hay que multiplicarlo por la raiz(2),
	;; despues lo volvemos a empaquetar y operamos en bytes!
	
	;; 1° parte: 

		; Extendemos los que estan en xmm2, y los multiplicamos por raiz(2)
		movdqu xmm3, xmm2
		punpcklbw xmm3, xmm5			; extendemos a 16 bits los 8 numeros de la parte baja.
		; ahora extendemos los primeros 4 a 32 bits
		punpcklwd xmm3,xmm5				; son los primeros 4 numeros
		cvtdq2ps xmm3,xmm3				; convertimos a float		
		mulps xmm3,xmm0					; multiplicamos por raiz(2)

		cvtps2dq xmm3, xmm3				; lo volvemos a convertir en enteros de 32

		; xmm3 = primeros 4 resultados
		packssdw xmm3,xmm3				
		packuswb xmm3,xmm3				; los devolvemos a tamaño de byte

		pand xmm3, xmm6					; los primeros 32 bits deja igual
		por xmm4, xmm3					; guarda el resultado en xmm4

	; 2° parte: 
		; movemos la mascara
		pslldq xmm6, 4					; | 0 | 0 | FFFF | 0 |

		; Extendemos los que estan en xmm2, y los multiplicamos por raiz(2)
		movdqu xmm3, xmm2
		punpcklbw xmm3, xmm5			; extendemos a 16 bits los 8 numeros de la parte baja.
		; ahora extendemos los segundos 4 a 32 bits
		punpckhwd xmm3, xmm5			; son los segundos 4 numeros
		cvtdq2ps xmm3, xmm3				; convertimos a float		
		mulps xmm3, xmm0				; multiplicamos por raiz(2)

		cvtps2dq xmm3, xmm3				; lo volvemos a convertir en enteros de 32

		; xmm3 = segundos 4 resultados
		packssdw xmm3,xmm3				
		packuswb xmm3,xmm3				; los devolvemos a tamaño de byte

		pand xmm3, xmm6					; los segundos 32 bits deja igual
		por xmm4, xmm3					; guarda el resultado en xmm4
		
	; 3° parte: 
		; movemos la mascara
		pslldq xmm6, 4					; | 0 | FFFF | 0 | 0 |

		; Extendemos los que estan en xmm2, y los multiplicamos por raiz(2)
		movdqu xmm3, xmm2
		punpckhbw xmm3, xmm5			; extendemos a 16 bits los 8 numeros de la parte alta.
		; ahora extendemos los primeros 4 a 32 bits
		punpcklwd xmm3, xmm5			; son los terceros 4 numeros
		cvtdq2ps xmm3, xmm3				; convertimos a float		
		mulps xmm3, xmm0					; multiplicamos por raiz(2)

		cvtps2dq xmm3, xmm3				; lo volvemos a convertir en enteros de 32

		; xmm3 = segundos 4 resultados
		packssdw xmm3, xmm3				
		packuswb xmm3, xmm3				; los devolvemos a tamaño de byte

		pand xmm3, xmm6					; los terceros 32 bits deja igual
		por xmm4, xmm3					; guarda el resultado en xmm4
		
	; 4° parte: 
		; movemos la mascara
		pslldq xmm6, 4					; | FFFF | 0 | 0 | 0 |

		; Extendemos los que estan en xmm2, y los multiplicamos por raiz(2)
		movdqu xmm3, xmm2
		punpckhbw xmm3, xmm5			; extendemos a 16 bits los 8 numeros de la parte alta.
		; ahora extendemos los cuartos 4 a 32 bits
		punpckhwd xmm3, xmm5			; son los terceros 4 numeros
		cvtdq2ps xmm3, xmm3				; convertimos a float		
		mulps xmm3, xmm0				; multiplicamos por raiz(2)

		cvtps2dq xmm3, xmm3				; lo volvemos a convertir en enteros de 32

		; xmm3 = segundos 4 resultados
		packssdw xmm3, xmm3				
		packuswb xmm3, xmm3				; los devolvemos a tamaño de byte

		pand xmm3, xmm6					; los terceros 32 bits deja igual
		por xmm4, xmm3					; guarda el resultado en xmm7	

		movdqu xmm7, xmm4
		paddusb xmm7, xmm1

	pop esi
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
		
	; xmm7 = resultado final de X

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	push esi
	;; Vamos a hacer 3 accesos a memoria por cada linea y traer los datos corridos solo por 1 y por 2
	;; pixeles, de esta manera podemos procesar una mayor cantidad de pixeles.

	; La primer linea no necesitamos pasarla a 32 bits, calculamos todo junto

	lea esi, [esi + ecx]			; avanzamos a la 1 columna
	movdqu xmm4, [esi]				; xmm4 auxiliar
	movdqu xmm1, [esi + 2*edx]		; xmm1 = 3 linea
	psubusb  xmm1, xmm4				; xmm1 = 33-1 | 34-2 | 35-3 | 36-4 | ... | 

	; La segunda linea calculamos todo junto, y despues la multiplicamos por raiz(2)

	lea esi, [esi + 1]				; avanzamos a la 2 columna
	movdqu xmm4, [esi]				; xmm4 auxiliar, (17..32)
	movdqu xmm2, [esi + 2*edx]		; xmm2 = numeros (19..35)
	psubusb  xmm2, xmm4				; xmm2 = 19-17 | 20-18 | 21-19 | 22-20 | ... |

	; La tercer linea no necesitamos pasarla a 32 bits, calculamos todo junto
	
	lea esi, [esi + 1]				; avanzamos a la 3 columna
	movdqu xmm4, [esi]				; xmm4 auxiliar, (33..48)
	movdqu xmm3, [esi + 2*edx]		; xmm3 = numeros (35..48 @ @)
	psubusb  xmm3, xmm4				; xmm3 = 35-33 | 36-34 | 37-35 | 38-36 | ... |

	; sumamos las lineas 1 y 3 para luego ir desempaquetando y sumando con raix(2) * xmm2									

	paddusb xmm1, xmm3				; xmm1 = xmm1 + xmm3 

	; ¡ xmm1 y xmm2 no se pueden editar !
	; los registros del xmm3 hasta el xmm7 estan libres	
	pack_and_unpackY:
		pxor xmm4, xmm4
		pxor xmm5, xmm5					; llenamos de ceros para poder desempaquetar
		pcmpeqd xmm6, xmm6				; creamos una mascara en xmm6 que vamos a utilizar para unir los calculos
		psrldq xmm6, 12					; | 0 | 0 | 0 | FFFFFFFF | 
		
	;; Extendemos de a pedazos solo los que estan en xmm2, para multiplicarlos por raiz(2) y luego los volvemos
	;; a enteros, y operamos con los otros, sin desempaquetarlos.

	;; 1° parte: 
		; Extendemos los que estan en xmm2, y los multiplicamos por raiz(2)
		movdqu xmm3, xmm2
		punpcklbw xmm3, xmm5			; extendemos a 16 bits los 8 numeros de la parte baja.
		; ahora extendemos los primeros 4 a 32 bits
		punpcklwd xmm3, xmm5				; son los primeros 4 numeros
		cvtdq2ps xmm3, xmm3				; convertimos a float		
		mulps xmm3, xmm0					; multiplicamos por raiz(2)

		cvtps2dq xmm3, xmm3				; lo volvemos a convertir en enteros de 32

		; xmm4 = primeros 4 resultados
		packssdw xmm3, xmm3				
		packuswb xmm3, xmm3				; los devolvemos a tamaño de byte

		pand xmm3, xmm6					; los primeros 32 bits deja igual
		por xmm4, xmm3					; creamos el resultado de multiplicar por raiz(2) en xmm4

	; 2° parte: 
		; movemos la mascara
		pslldq xmm6, 4					; | 0 | 0 | FFFF | 0 |

		; Extendemos los que estan en xmm2, y los multiplicamos por raiz(2)
		movdqu xmm3, xmm2
		punpcklbw xmm3, xmm5			; extendemos a 16 bits los 8 numeros de la parte baja.
		; ahora extendemos los segundos 4 a 32 bits
		punpckhwd xmm3,xmm5				; son los segundos 4 numeros
		cvtdq2ps xmm3,xmm3				; convertimos a float		
		mulps xmm3,xmm0					; multiplicamos por raiz(2)

		cvtps2dq xmm3, xmm3				; lo volvemos a convertir en enteros de 32

		; xmm3 = segundos 4 resultados
		packssdw xmm3,xmm3				
		packuswb xmm3,xmm3				; los devolvemos a tamaño de byte

		pand xmm3, xmm6					; los segundos 32 bits deja igual
		por xmm4, xmm3					; creamos el resultado de multiplicar por raiz(2) en xmm4
		
	; 3° parte: 
		; movemos la mascara
		pslldq xmm6, 4					; | 0 | FFFF | 0 | 0 |

		; Extendemos los que estan en xmm2, y los multiplicamos por raiz(2)
		movdqu xmm3, xmm2
		punpckhbw xmm3, xmm5			; extendemos a 16 bits los 8 numeros de la parte alta.
		; ahora extendemos los primeros 4 a 32 bits
		punpcklwd xmm3,xmm5				; son los terceros 4 numeros
		cvtdq2ps xmm3,xmm3				; convertimos a float		
		mulps xmm3,xmm0					; multiplicamos por raiz(2)

		cvtps2dq xmm3, xmm3				; lo volvemos a convertir en enteros de 32

		; xmm3 = segundos 4 resultados
		packssdw xmm3,xmm3				
		packuswb xmm3,xmm3				; los devolvemos a tamaño de byte

		pand xmm3, xmm6					; los terceros 32 bits deja igual
		por xmm4, xmm3					; creamos el resultado de multiplicar por raiz(2) en xmm4
		
	; 4° parte: 
		; movemos la mascara
		pslldq xmm6, 4					; | FFFF | 0 | 0 | 0 |

		; Extendemos los que estan en xmm2, y los multiplicamos por raiz(2)
		movdqu xmm3, xmm2
		punpckhbw xmm3, xmm5			; extendemos a 16 bits los 8 numeros de la parte alta.
		; ahora extendemos los cuartos 4 a 32 bits
		punpckhwd xmm3, xmm5				; son los terceros 4 numeros
		cvtdq2ps xmm3, xmm3				; convertimos a float		
		mulps xmm3, xmm0					; multiplicamos por raiz(2)

		cvtps2dq xmm3, xmm3				; lo volvemos a convertir en enteros de 32

		; xmm3 = segundos 4 resultados
		packssdw xmm3,xmm3				
		packuswb xmm3,xmm3				; los devolvemos a tamaño de byte

		pand xmm3, xmm6					; los terceros 32 bits deja igual
		por xmm4, xmm3					; creamos el resultado de multiplicar por raiz(2) en xmm4
	
	; xmm4 resultado final de Y

	paddusb xmm7, xmm4
	
	; xmm7 = resultado final XY
		
	pop esi

	movdqu [edi+ecx+1], xmm7	; salteamos el primer elemento, porque no podemos calcularlo

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
	add esi, edx				; avanzamos a la proxima columna
	cmp ebx, eax				; ¿ termino la matriz ?
	jne cicloFilasXY

finXY:
	leave
	ret	
