; extern void asmSobel(const char* src, char* dst, int ancho, int alto, int xorder, int yorder);

global asmSobel_tp1

%define height	[ebp + 20]	
%define widht	[ebp + 16]
%define x		[ebp + 24]
%define y		[ebp + 28]

section .text

%macro saturar 1  		; escribe en EAX el resultado de la saturacion

	cmp %1, 255			
	jnl %%poner255			; si es mayor que 255 saturo con 255
	
	cmp %1, 0
	jl %%ponerCero			; si es menor a 0 saturo con 0
	
	mov eax, %1
	jmp %%fin
	
%%ponerCero:
	mov eax, 0
	jmp %%fin

%%poner255:
	mov eax, 255

%%fin:	

%endmacro

%macro multiplicarX 0 
	push esi	
	push ecx
	push ebx
	push edi
	push edx
	
	mov ebx, widht		;width con -2
	lea ebx, [ebx + 2]

	lea esi, [esi+ecx] 		;tengo el puntero a la matriz de datos
	xor ecx, ecx
	xor edi, edi
	
; Comienzan los calculos con la matriz
; Elemento 1: X multiplica por -1
	xor edx, edx
	mov  dl, [esi]
	sub edi, edx				; EDI acumula el nuevo valor

; Elemento 2: X multiplica por 0

; Elemento 3: X multiplica por 1
	xor edx, edx				; para que nos quede extendido a 32
	mov  dl, [esi+2]
	add edi, edx				; EDI acumula el nuevo valor

	lea esi, [esi + ebx]	; saltar linea

; Elemento 4: X multiplica por -2
	xor edx, edx				; para que nos quede extendido a 32
	mov  dl, [esi]
	sal edx, 1
	sub edi, edx				; EDI acumula el nuevo valor

; Elemento 5: X multiplica por 0

; Elemento 6: X multiplica por -2
	xor edx, edx				; para que nos quede extendido a 32
	mov  dl, [esi + 2]
	sal edx, 1					; multiplica por 2
	add edi, edx				; EDI acumula el nuevo valor

	lea esi, [esi + ebx]	; saltar linea

; Elemento 7: X multiplica por -1
	xor edx, edx				; para que nos quede extendido a 32
	mov  dl, [esi]
	sub edi, edx				; EDI acumula el nuevo valor

; Elemento 8: X multiplica por 0

; Elemento 9: X multiplica por 1
	xor edx, edx				; para que nos quede extendido a 32
	mov  dl, [esi + 2]
	add edi, edx				; EDI acumula el nuevo valor
	
	; saturo el resultado	
	saturar edi 

	pop edx
	pop edi	
	pop ebx
	pop ecx
	pop esi
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%macro multiplicarY 0 
	push esi	
	push ecx
	push ebx
	push edi
	push edx
	
	mov ebx, [ebp+16]		;width con -2
	lea ebx, [ebx+2]

	lea esi, [esi+ecx] 		;tengo el puntero a la matriz de datos
	xor ecx, ecx
	xor edi, edi
	
; Comienzan los calculos con la matriz
; Elemento 1: Y multiplica por -1
	xor edx, edx				; para que nos quede extendido a 32
	mov  dl, [esi]
	sub edi, edx				; EDI acumula el nuevo valor

; Elemento 2: Y multiplica por -2
	xor edx, edx				; para que nos quede extendido a 32
	mov  dl, [esi+1]
	sal edx, 1
	sub edi, edx				; EDI acumula el nuevo valor

; Elemento 3: Y multiplica por -1
	xor edx, edx				; para que nos quede extendido a 32
	mov  dl, [esi+2]
	sub edi, edx				; EDI acumula el nuevo valor

	lea esi, [esi + ebx*2]; saltear una fila que esta llena de ceros

; Elemento 4: Y multiplica por 0

; Elemento 5: Y multiplica por 0

; Elemento 6: Y multiplica por 0

; Elemento 7: Y multiplica por 1
	xor edx, edx				; para que nos quede extendido a 32
	mov  dl, [esi]
	add edi, edx				; EDI acumula el nuevo valor

; Elemento 8: Y multiplica por 2
	xor edx, edx				; para que nos quede extendido a 32
	mov  dl, [esi + 1]
	sal edx, 1
	add edi, edx				; EDI acumula el nuevo valor

; Elemento 9: Y multiplica por 1
	xor edx, edx				; para que nos quede extendido a 32
	mov  dl, [esi + 2]
	add edi, edx				; EDI acumula el nuevo valor
	
	; saturo el resultado	
	saturar edi
	
	pop edx
	pop edi	
	pop ebx
	pop ecx
	pop esi
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%macro multiplicarXY 0 
	push esi	
	push ecx
	push ebx
	push edi
	push edx
	
	mov ebx, [ebp+16]		; width con -2
	lea ebx, [ebx+2]

	lea esi, [esi+ecx] 	; tengo el puntero a la matriz de datos
	xor edi, edi
	xor ecx, ecx
	
; Comienzan los calculos con la matriz
;; en ECX vamos a acumular el nuevo valor respecto la derivada X
;; en EDI vamos a acumular el nuevo valor respecto la derivada Y
;; EAX y EDX lo utilizamos como auxiliar
;

; Elemento 1: X multiplica por -1, Y por -1
	xor eax, eax				
	mov  al, [esi]
	sub ecx, eax			; ECX acumula el nuevo valor derivada X
	sub edi, eax			; EDI acumula el nuevo valor derivada Y

; Elemento 2: X multiplica por 0, Y por -2
	xor eax, eax				
	mov  al, [esi+1]
	sal eax, 1
	sub edi, eax			; EDI acumula el nuevo valor derivada Y
	
; Elemento 3: X multiplica por 1, Y por -1	
	xor eax, eax			; para que nos quede extendido a 32
	mov  al, [esi+2]
	add ecx, eax			; ECX acumula el nuevo valor derivada X
	sub edi, eax			; EDI acumula el nuevo valor derivada Y

	lea esi,[esi + ebx]	; ir a la proxima fila
	
; Elemento 4: X multiplica por -2, Y por 0
	xor eax, eax
	mov  al, [esi]
	sal eax, 1
	sub ecx, eax			; ECX acumula el nuevo valor derivada X

; Elemento 5: X multiplica por 0, Y por 0

; Elemento 6: X multiplica por 2, Y por 0
	xor eax, eax
	mov  al, [esi+2]
	sal eax, 1
	add ecx, eax			; ECX acumula el nuevo valor derivada X

	lea esi, [esi + ebx]	; ir a la proxima fila

; Elemento 7: X multiplica por -1, Y por 1
	xor eax, eax
	mov  al, [esi]
	add edi, eax			; EDI acumula el nuevo valor derivada Y
	sub ecx, eax			; ECX acumula el nuevo valor derivada X
	
; Elemento 8: X multiplica por 0, Y por 2
	xor eax, eax			
	mov  al, [esi+1]
	sal eax, 1
	add edi, eax			; EDI acumula el nuevo valor derivada Y
	
; Elemento 9: X multiplica por 1, Y por 1
	xor eax, eax
	mov  al, [esi+2]
	add ecx, eax			; ECX acumula el nuevo valor derivada X
	add edi, eax			; EDI acumula el nuevo valor derivada Y	
		
	; saturo el resultado	
	saturar ecx		; viene en eax
	mov ecx, eax   ; lo paso a ecx
	saturar edi		; devuelve en eax
	add ecx, eax	; lo sumo para luego saturar
	saturar ecx
	
	pop edx
	pop edi	
	pop ebx
	pop ecx
	pop esi
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asmSobel_tp1:
	push ebp
	mov ebp, esp
	push ebx
	push edi
	push esi

	cmp dword x,1
	jne operarSoloY
	cmp dword y,1
	jne operarSoloX
	
	;operoConXY	
	
	;opero primero con x	
	mov esi, [ebp + 8] 			;tengo el puntero a la matriz de entrada
	mov edi, [ebp + 12]	      ;tengo el puntero a la matriz resultado
	xor ebx, ebx
	
cicloFilasXY:
	xor ecx, ecx
	add edi, [ebp+16]			;posiciono la matriz donde voy a guardar el resultado		
	lea edi, [edi+2]

aplicarFiltroXY:
	multiplicarXY

	;escribo el resultado
	mov byte [edi+ecx+1],al
	inc ecx
	cmp ecx, widht		;veo si termine de computar la fila
	jne aplicarFiltroXY
	inc ebx
	lea ecx, [ecx+2]
	add esi, widht
	lea esi, [esi+2]		;me muevo a la proxima fila
	cmp ebx, height		;me fijo si termine la matriz
	jne cicloFilasXY

	pop esi
	pop edi
	pop ebx
	pop ebp

	ret

;-------------------------------------------------------------------------------------------------------------------------------

operarSoloX:
	
	mov esi, [ebp+8] 		;tengo el puntero a la matriz de entrada
	mov edi, [ebp+12]	        ;tengo el puntero a la matriz resultado
	xor ebx, ebx
	
cicloFilasX:
	xor ecx, ecx
	add edi, [ebp+16]			;posiciono la matriz donde voy a guardar el resultado		
	lea edi, [edi+2]

aplicarFiltroX:
	multiplicarX

	;escribo el resultado
	mov byte [edi+ecx+1],al
	inc ecx
	cmp ecx, widht		;veo si termine de computar la fila
	jne aplicarFiltroX
	inc ebx
	lea ecx, [ecx+2]
	add esi, widht
	lea esi, [esi+2]		;me muevo a la proxima fila
	cmp ebx, height		;me fijo si termine la matriz
	jne cicloFilasX

	pop esi
	pop edi
	pop ebx
	pop ebp

	ret

operarSoloY:

	mov esi, [ebp+8] 		;tengo el puntero a la matriz de entrada
	mov edi, [ebp+12]	        ;tengo el puntero a la matriz resultado
	xor ebx, ebx
	
cicloFilasY:
	xor ecx, ecx
	add edi, [ebp+16]			;posiciono la matriz donde voy a guardar el resultado		
	lea edi, [edi+2]
aplicarFiltroY:
	
	multiplicarY

	;escribo el resultado
	mov byte [edi+ecx+1],al
	inc ecx
	cmp ecx, widht		;veo si termine de computar la fila
	jne aplicarFiltroY
	inc ebx
	lea ecx, [ecx+2]
	add esi, widht
	lea esi, [esi+2]		;me muevo a la proxima fila
	cmp ebx, height		;me fijo si termine la matriz
	jne cicloFilasY


	pop esi
	pop edi
	pop ebx
	pop ebp

	ret
	

