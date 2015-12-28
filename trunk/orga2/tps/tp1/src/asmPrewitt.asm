; extern void asmPrewitt(const char* src, char* dst, int ancho, int alto);

global asmPrewitt

%define height	[ebp + 20]	
%define widht	[ebp + 16]
extern prewittX
extern prewittY


section .text

%macro multiplicarX 0
	push esi	
	push ecx
	push ebx
	push edi
	push edx
	
	mov ebx,widht		;width con -2
	lea ebx,[ebx+2]

	lea esi, [esi+ecx] 		;tengo el puntero a la matriz de datos
	xor ecx,ecx
	xor edi,edi
	
	mov eax, [prewittX + 0]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [prewittX + 8]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi+2]
	lea esi,[esi + ebx]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [prewittX + 12]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [prewittX + 20]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi+ 2]
	lea esi,[esi + ebx]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [prewittX + 24]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [prewittX + 32]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi+2]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz
		
	cmp edi,0
	jl ponerCero			;si es menor a 0 saturo con 0
	cmp edi,255			
	jnl poner255			;si es mayor que 255 saturo con 255
	mov eax,edi
	jmp fin
ponerCero:
	mov eax,0
	jmp fin
poner255:
	mov eax,255
	
fin:
	pop edx
	pop edi	
	pop ebx
	pop ecx
	pop esi
%endmacro


%macro multiplicarY 0
	push esi	
	push ecx
	push ebx
	push edi
	push edx
	
	mov ebx,[ebp+16]		;width con -2
	lea ebx,[ebx+2]

	lea esi, [esi+ecx] 		;tengo el puntero a la matriz de datos
	xor ecx,ecx
	xor edi,edi
	
	mov eax, [prewittY + 0]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [prewittY + 4]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi+1]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [prewittY + 8]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi+2]
	lea esi,[esi + ebx*2]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [prewittY + 24]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [prewittY + 28]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi+1]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [prewittY + 32]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi+2]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz
		
	cmp edi,0
	jl ponerCeroY			;si es menor a 0 saturo con 0
	cmp edi,255			
	jnl poner255Y			;si es mayor que 255 saturo con 255
	mov eax,edi
	jmp finY
ponerCeroY:
	mov eax,0
	jmp finY
poner255Y:
	mov eax,255
	
finY:
	
	pop edx
	pop edi	
	pop ebx
	pop ecx
	pop esi
%endmacro

asmPrewitt:
	push ebp
	mov ebp, esp
	sub esp, 4
	push ebx
	push edi
	push esi

	mov esi, [ebp+8] 		;tengo el puntero a la matriz de entrada
	mov edi, [ebp+12]	        ;tengo el puntero a la matriz resultado
	xor ebx,ebx
	
cicloFilas:
	xor ecx, ecx
	add edi,[ebp+16]			;posiciono la matriz donde voy a guardar el resultado		
	lea edi,[edi+2]
aplicarFiltro:
		
	multiplicarX

	mov byte [edi+ecx+1],al
	inc ecx
	cmp ecx, widht		;veo si termine de computar la fila
	jne aplicarFiltro
	inc ebx
	lea ecx,[ecx+2]
	add esi, widht
	lea esi, [esi+2]		;me muevo a la proxima fila
	cmp ebx, height		;me fijo si termine la matriz
	jne cicloFilas
	
	

	;termine de calcular los bordes en x
	;ahora calculo los bordes en y los saturo, los sumo a la matrix, los saturo y dejo el resultado!
	;-----------------------------------------------------------------------------------------------

	mov esi, [ebp+8] 		;posiciono de nuevo al principio
	mov edi, [ebp+12]	   
	xor ebx,ebx
	
cicloFilasY:
	xor ecx, ecx
	add edi,[ebp+16]			;posiciono la matriz donde voy a guardar el resultado		
	lea edi,[edi+2]
aplicarFiltroY:
		
	multiplicarY

	
	add byte [edi+ecx+1],al
	jc poner255Final			;si hay overflow pongo 255 porque saturo
	jmp finFinal				;sino lo dejo como estaba
poner255Final:
	mov byte [edi+ecx+1],255
	
finFinal:
	
	inc ecx
	cmp ecx, widht		;veo si termine de computar la fila
	jne aplicarFiltroY
	inc ebx
	lea ecx,[ecx+2]
	add esi, widht
	lea esi, [esi+2]		;me muevo a la proxima fila
	cmp ebx, height		;me fijo si termine la matriz
	jne cicloFilasY
	


	pop esi
	pop edi
	pop ebx
	add esp, 4 			;devolvemos la memoria de la variable
	pop ebp

	ret
	
	





