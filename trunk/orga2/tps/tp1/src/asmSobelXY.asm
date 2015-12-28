; extern void asmSobel(const char* src, char* dst, int ancho, int alto, int xorder, int yorder);

global asmSobel
global multiplicar
extern sobelX
extern sobelY

%define height	[ebp + 20]	
%define widht	[ebp + 16]
%define x	[ebp + 24]
%define y	[ebp + 28]


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
	
	;hago los calculos con la matriz				
	mov eax, [sobelX + 0]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [sobelX + 8]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi+2]
	lea esi,[esi + ebx]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [sobelX + 12]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [sobelX + 20]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi+ 2]
	lea esi,[esi + ebx]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [sobelX + 24]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [sobelX + 32]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi+2]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz
	

	;saturo el resultado	
	cmp edi,0
	jl %%ponerCero			;si es menor a 0 saturo con 0
	cmp edi,255			
	jnl %%poner255			;si es mayor que 255 saturo con 255
	mov eax,edi
	jmp %%fin
%%ponerCero:
	mov eax,0
	jmp %%fin
%%poner255:
	mov eax,255
	
%%fin:
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
	
;hago los calculos con la matriz
	mov eax, [sobelY + 0]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [sobelY + 4]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi+1]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [sobelY + 8]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi+2]
	lea esi,[esi + ebx*2]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [sobelY + 24]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [sobelY + 28]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi+1]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz

	xor eax,eax			
	mov eax, [sobelY + 32]
	xor edx,edx			;para que nos quede extendido a 32
	mov dl,[esi+2]
	mul edx
	add edi,eax			;en edi voy guardando el valor para poner en la nueva matriz
	

	;saturo el resultado	
	cmp edi,0
	jl %%ponerCeroY			;si es menor a 0 saturo con 0
	cmp edi,255			
	jnl %%poner255Y			;si es mayor que 255 saturo con 255
	mov eax,edi
	jmp %%finY
%%ponerCeroY:
	mov eax,0
	jmp %%finY
%%poner255Y:
	mov eax,255
	
%%finY:
	
	pop edx
	pop edi	
	pop ebx
	pop ecx
	pop esi
%endmacro

asmSobel:
	push ebp
	mov ebp, esp
	sub esp, 4
	push ebx
	push edi
	push esi

	cmp dword x,1
	jne operarSoloY
	cmp dword y,1
	jne operarSoloX
	
	;operoConXY	
	
	;opero primero con x	
	mov esi, [ebp+8] 		;tengo el puntero a la matriz de entrada
	mov edi, [ebp+12]	        ;tengo el puntero a la matriz resultado
	xor ebx,ebx
	
cicloFilasXYenX:
	xor ecx, ecx
	add edi,[ebp+16]			;posiciono la matriz donde voy a guardar el resultado		
	lea edi,[edi+2]

aplicarFiltroXYenX:

	multiplicarX

	;escribo en la matriz resultado
	mov byte [edi+ecx+1],al
	inc ecx
	cmp ecx, widht		;veo si termine de computar la fila
	jne aplicarFiltroXYenX
	inc ebx
	lea ecx,[ecx+2]
	add esi, widht
	lea esi, [esi+2]		;me muevo a la proxima fila
	cmp ebx, height		;me fijo si termine la matriz
	jne cicloFilasXYenX


	;termine de calcular los bordes en x
	;ahora calculo los bordes en y los saturo, los sumo a la matrix, los saturo y dejo el resultado!
	
	

	mov esi, [ebp+8] 		;posiciono de nuevo al principio
	mov edi, [ebp+12]	   
	xor ebx,ebx
	
cicloFilasXYenY:
	xor ecx, ecx
	add edi,[ebp+16]			;posiciono la matriz donde voy a guardar el resultado		
	lea edi,[edi+2]
aplicarFiltroXYenY:
		
	multiplicarY

	add byte [edi+ecx+1],al
	jo poner255Final			;si hay overflow pongo 255 porque saturo
	jmp finFinal				;sino lo dejo como estaba
poner255Final:
	mov byte [edi+ecx+1],255


finFinal:
	inc ecx
	cmp ecx, widht		;veo si termine de computar la fila
	jne aplicarFiltroXYenY
	inc ebx
	lea ecx,[ecx+2]
	add esi, widht
	lea esi, [esi+2]		;me muevo a la proxima fila
	cmp ebx, height		;me fijo si termine la matriz
	jne cicloFilasXYenY


	pop esi
	pop edi
	pop ebx
	add esp, 4 			;devolvemos la memoria de la variable
	pop ebp

	ret

;-------------------------------------------------------------------------------------------------------------------------------

operarSoloX:
	
	mov esi, [ebp+8] 		;tengo el puntero a la matriz de entrada
	mov edi, [ebp+12]	        ;tengo el puntero a la matriz resultado
	xor ebx,ebx
	
cicloFilasX:
	xor ecx, ecx
	add edi,[ebp+16]			;posiciono la matriz donde voy a guardar el resultado		
	lea edi,[edi+2]
aplicarFiltroX:
	
	
	multiplicarX

	;escribo el resultado
	mov byte [edi+ecx+1],al
	inc ecx
	cmp ecx, widht		;veo si termine de computar la fila
	jne aplicarFiltroX
	inc ebx
	lea ecx,[ecx+2]
	add esi, widht
	lea esi, [esi+2]		;me muevo a la proxima fila
	cmp ebx, height		;me fijo si termine la matriz
	jne cicloFilasX


	pop esi
	pop edi
	pop ebx
	add esp, 4 			;devolvemos la memoria de la variable
	pop ebp

	ret



operarSoloY:

	mov esi, [ebp+8] 		;tengo el puntero a la matriz de entrada
	mov edi, [ebp+12]	        ;tengo el puntero a la matriz resultado
	xor ebx,ebx
	
cicloFilasY:
	xor ecx, ecx
	add edi,[ebp+16]			;posiciono la matriz donde voy a guardar el resultado		
	lea edi,[edi+2]
aplicarFiltroY:
	
	multiplicarY

	;escribo el resultado
	mov byte [edi+ecx+1],al
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
	
	






