; extern void asmSobel(const char* src, char* dst, int ancho, int alto, int xorder, int yorder);

global asmSobel

%define srcMat	[ebp + 8]
%define dstMat	[ebp + 12]	
%define width	[ebp + 16]
%define height	[ebp + 20]	
%define x      [ebp + 24]
%define y      [ebp + 28]


%define widthMenos2		[ebp - 4]
%define widthMenos16		[ebp - 8]

%include "sobel.mac"

section .text

asmSobel:
	enter 8, 0 
	
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

	;; verificamos que filtro tenemos que realizar
	cmp dword x,1
	jne operarSoloY
	cmp dword y,1
	jne operarSoloX
	
	; sino operamos con XY	

operarXY:

cicloXY:
	xor ecx, ecx
	add edi, width					; Posicionamos la matriz donde vamos a guardar el resultado

aplicarFiltroXY:
	filtroX

	filtroY

grabarResultado:
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
	add esi, edx					; avanzamos a la proxima columna
	cmp ebx, eax					; ¿ termino la matriz ?
	jne cicloXY

finXY:
	leave
	ret	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; OPERAR SOLO CON X ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

operarSoloX:

cicloX:
	xor ecx, ecx
	add edi, width						;posiciono la matriz donde voy a guardar el resultado		

	aplicarFiltroX:
		filtroX

	grabarResultadoX:
		movdqu [edi+ecx+1], xmm0	; salteamos el primer elemento, porque no podemos calcularlo

		add ecx, 14						; avanzamos de a 14 porque es la cantidad de pixeles que procesamos
		cmp ecx, widthMenos16 		; procesamos de a 14 hasta que llegamos a los ultimos 16 pixeles
		jg compararConFinX			; si pasamos los ultimos 16, podemos haber terminado
		jmp aplicarFiltroX			; sino, seguimos calculando de a 14
	
	compararConFinX:
		cmp ecx, widthMenos2			; llegamos al final de la fila
		je proximaFilaX
		mov ecx, widthMenos16		; preparamos para procesar los ultimos
		jmp aplicarFiltroX

	proximaFilaX:
		inc ebx
		add esi, edx					; avanzamos a la proxima columna
		cmp ebx, eax					; ¿ termino la matriz ?
		jne cicloX

finX:
	leave
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; OPERAR SOLO CON X ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

operarSoloY:

cicloY:
	xor ecx, ecx
	add edi, width						;posiciono la matriz donde voy a guardar el resultado		

	aplicarFiltroY:
		pxor xmm0, xmm0				; limpiamos el registro como pide la especificacion del macro filtroY
		filtroY

	grabarResultadoY:
		movdqu [edi+ecx+1], xmm0	; salteamos el primer elemento, porque no podemos calcularlo

		add ecx, 14						; avanzamos de a 14 porque es la cantidad de pixeles que procesamos
		cmp ecx, widthMenos16 		; procesamos de a 14 hasta que llegamos a los ultimos 16 pixeles
		jg compararConFinY			; si pasamos los ultimos 16, podemos haber terminado
		jmp aplicarFiltroY			; sino, seguimos calculando de a 14
	
	compararConFinY:
		cmp ecx, widthMenos2			; llegamos al final de la fila
		je proximaFilaY
		mov ecx, widthMenos16		; preparamos para procesar los ultimos
		jmp aplicarFiltroY

	proximaFilaY:
		inc ebx
		add esi, edx					; avanzamos a la proxima columna
		cmp ebx, eax					; ¿ termino la matriz ?
		jne cicloY

finY:
	leave
	ret
