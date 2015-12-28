; extern void asmRoberts(const char* src, char* dst, int ancho, int alto);

global asmRoberts

%define height	[ebp + 20]	
%define width	[ebp + 16]

section .text

%macro saturar 1  		; escribe en EAX el resultado de la saturacion

	cmp %1, 255			
	jnl %%poner255			; si es mayor que 255 saturo con 255
	
	cmp %1, 0
	jl %%ponerCero			; si es menor a 0 saturo con 0
	
	mov eax, %1
	jmp %%fin
	
%%ponerCero:
	mov eax,0
	jmp %%fin

%%poner255:
	mov eax,255

%%fin:	

%endmacro

%macro multiplicarXY 0 
	push esi	
	push ecx
	push ebx
	push edi
	push edx
	
	mov ebx, width			; width con -2 o deberia ser -1 ??
	lea ebx, [ebx+1]

	lea esi, [esi+ecx] 	; tengo el puntero a la matriz de datos
	xor edi, edi
	xor ecx, ecx
	
; Comienzan los calculos con la matriz
;; en ECX vamos a acumular el nuevo valor respecto la derivada X
;; en EDI vamos a acumular el nuevo valor respecto la derivada Y
;; EAX y EDX lo utilizamos como auxiliar

; Elemento 1: X multiplica por 1, Y por 0
	xor eax, eax
	mov  al, [esi]
	add ecx, eax			; ECX acumula el nuevo valor derivada X

; Elemento 2: X multiplica por 0, Y por 1
	xor eax, eax				
	mov  al, [esi + 1]
	add edi, eax			; EDI acumula el nuevo valor derivada Y

	lea esi,[esi + ebx]	; ir a la proxima fila
	
; Elemento 3: X multiplica por 0, Y por -1	
	xor eax, eax			; para que nos quede extendido a 32
	mov  al, [esi]
	sub edi, eax			; EDI acumula el nuevo valor derivada Y

; Elemento 4: X multiplica por -1, Y por 0
	xor eax, eax
	mov  al, [esi + 1]
	sub ecx, eax			; ECX acumula el nuevo valor derivada X

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

asmRoberts:
	enter 0, 0
	
	mov esi, [ebp + 8] 			;tengo el puntero a la matriz de entrada
	mov edi, [ebp + 12]	      ;tengo el puntero a la matriz resultado
	xor ebx,ebx
	
cicloFilas:
	xor ecx, ecx
	add edi, width			;posiciono la matriz donde voy a guardar el resultado		
	lea edi, [edi + 1]

aplicarFiltro:		
	multiplicarXY

escribir:
	mov byte [edi + ecx + 1], al
	inc ecx
	cmp ecx, width					; termino de computar la fila?
	jne aplicarFiltro
	
	inc ebx
	add esi, width
	lea esi, [esi + 1]			; avanzamos proxima fila
	cmp ebx, height				; termino la matriz?
	jne cicloFilas

	leave
	ret

