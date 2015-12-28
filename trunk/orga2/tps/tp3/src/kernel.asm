BITS 16

%include "macrosmodoreal.mac"

global start
extern idt;
extern _isr32;
extern _isr33;
extern IDT_DESC
extern idtFill
extern tsss;

;Aca arranca todo, en el primer byte.
start:
		cli		;se deshabilitan las interrupciones.
		jmp 	bienvenida

;aca ponemos todos los mensajes		
iniciando: db 'Iniciando el kernel mas geek del mundo'
iniciando_len equ $ - iniciando		

bienvenida:
	IMPRIMIR_MODO_REAL iniciando, iniciando_len, 0x07, 0, 0
	; Ejercicios AQUI

	; se deshabilitan las interrupciones
	cli
		
	; Ejercicio 1
		
		;; sacar el punterito pero por el bios
		mov ah, 2
		mov bh,0
		mov dl,1
		mov dh,1
		int $10
		
		
		; Habilitar Gate 20
		call enable_A20
		
		; Cargar el registro GDTR
		lgdt [gdt_descriptor]	; cargamos la gdt

			
		; Pasar a modo protegido
		mov eax, cr0
		or eax, 1
		mov cr0, eax
		jmp 0x08:modoprotegido
		
		BITS 32
		modoprotegido:
		; actualizar la informacion de los registros DS ES GS FS SS
			mov ax, 0x18
			mov ds, ax
			mov es, ax			;se pone 18 para escribir por el segmento de video
			mov fs, ax
			mov gs, ax
			mov ss, ax
		
		;escribo la pantalla tal cual solicitaba el ej por medio del segmento de video
		xor edi, edi		
		mov 	esi,mensaje
		mov 	ecx, 80
		
		mov ax,0x0A2A
		
		.cicloazul:
			mov [edi],ax
			add edi,2
		loop .cicloazul
		
		mov edx,23
		
	mitad:
		mov [edi],ax
		add edi,2
		mov ax,0x0000
		mov ecx, 78
		
		.cicloNegro:
			mov [edi],ax
			add edi,2
		loop .cicloNegro
			
			
		mov ax,0x0A2A	
		mov [edi],ax
		add edi,2
		sub edx,1
		cmp edx,0
		jg mitad
		
		mov ecx, 80

		.ultima:
			mov [edi],ax
			add edi,2
		loop .ultima
		

	mov ax, 0x10		;volvemos al segmento de datos
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax	

			
	; Ejercicio 2
	
	fillPintorPage_dir:				;inicializo la primer entrada del directorio con la direccion de la tabla
		mov 	eax, pintorTable
		or 	eax, 0x3				;supervisor, read/write, present
		mov 	[pintorPage_dir], eax
		
	fillTyKPage_dir:				;inicializo la primer entrada del directorio con la direccion de la tabla
		mov 	eax, traductorYKernelTable
		or 	eax, 0x3				;supervisor, read/write, present
		mov 	[traductorYKernelPage_dir], eax
		
		
;------------------------------------PAGINACION PINTOR-------------------------------------------------------
fillPintorTablePages:			;inicializo la primer entrada del directorio con la direccion de la tabla
	mov 	esi,pintorTable		;llenamos desde la primer tabla
	mov 	eax, 0
	mov ecx,9 					; 1024 = 4m
	llenarTablas:
		or 	eax, 0x3			;supervisor, read/write, present
		mov 	[esi], eax
		lea esi,[esi + 4]		;porque cada descriptor de tabla(eax) tiene 4 bytes
		lea eax,[eax + 4096]	;porque cada tabla ocupa 4k.
	loop llenarTablas 			;aca completamos hasta la 0x8fff
	
	;lleno las dir e000
	mov 	esi,pintorTable			;llenamos desde la primer tabla
	mov 	eax, 0
	lea esi,[esi + 4 * 14]	
	lea eax,[eax + 4096 * 14]		;salteamos los que no estan en identity mapping
	or 	eax, 0x3					;supervisor, read/write, present
	mov 	[esi], eax
	lea esi,[esi + 4]				;cada descriptor de tabla(eax) tiene 4 bytes
	lea eax,[eax + 4096]			;cada tabla ocupa 4k.
	or 	eax, 0x3					;supervisor, read/write, present
	mov 	[esi], eax
	lea esi,[esi + 4]				;cada descriptor de tabla(eax) tiene 4 bytes
	lea eax,[eax + 4096]			;cada tabla ocupa 4k.
	
	;seteamos la dir 13000
	mov 	esi,pintorTable			;llenamos desde la primer tabla
	mov 	eax, 0xB8000
	lea esi,[esi + 4 * 19]		
	or 	eax, 0x3					;supervisor, read/write, present
	mov 	[esi], eax
		
	;seteamos la dir 15000
	mov 	esi,pintorTable			;llenamos desde la primer tabla
	mov 	eax, 0
	lea esi,[esi + 4 * 21]	
	lea eax,[eax + 4096 * 21]		;salteamos los que no estan en identity mapping
	or 	eax, 0x3					;supervisor, read/write, present
	mov 	[esi], eax
	
	;seteamos la b800
	mov esi,pintorTable				;llenamos desde la primer tabla
	mov eax, 0
	lea esi,[esi + 4 * 184]			;salteamos hasta b8000	
	mov eax,0x10000	
	or 	eax, 0x3					;supervisor, read/write, present
	mov [esi], eax
	
;------------------------------------FIN PAGINACION PINTOR-------------------------------------------------------
	
	
;------------------------------------ PAGINACION TRADUCTOR Y KERNEL-------------------------------------------------------
fillTyKTablePages:					;inicializo la primer entrada del directorio con la direccion de la tabla
	mov esi,traductorYKernelTable	;llenamos desde la primer tabla
	mov eax, 0
	mov ecx,8 						; 1024 = 4m
	llenarTablastYk:
		or 	eax, 0x3				;supervisor, read/write, present
		mov [esi], eax
		lea esi,[esi + 4]			;cada descriptor de tabla(eax) tiene 4 bytes
		lea eax,[eax + 4096]		;cada tabla ocupa 4k.
	loop llenarTablastYk 			;aca completamos hasta la 0x8fff

;lleno las dir 9000
	mov	esi,traductorYKernelTable	;llenamos desde la primer tabla
	mov	eax, 0
	lea esi, [esi + 4 * 9]	
	lea eax, [eax + 4096 * 9]		;para saber en donde emepezar
	mov ecx, 8 						; 1024 = 4m
	llenarTablastYk2:
		or 	eax, 0x3				;supervisor, read/write, present
		mov [esi], eax
		lea esi, [esi + 4]			;cada descriptor de tabla(eax) tiene 4 bytes
		lea eax, [eax + 4096]		;cada tabla ocupa 4k.
	loop llenarTablastYk2 			;completamos hasta la 0x8fff
	
	;lleno la dir 13000
	mov esi,traductorYKernelTable	;llenamos desde la primer tabla
	mov eax, 0
	lea esi,[esi + 4 * 19]	
	mov eax,0xB8003					;supervisor, read/write, present
	mov	[esi], eax
	
	;lleno la dir 16000
	mov esi,traductorYKernelTable	;llenamos desde la primer tabla
	mov eax, 0
	lea esi,[esi + 4 * 22]	
	lea eax,[eax + 4096 * 22]		;salteamos los que no estan en identity mapping
	or 	eax, 0x3					;supervisor, read/write, present
	mov	[esi], eax
	
	;lleno la dir 18000
	mov	esi,traductorYKernelTable	;llenamos desde la primer tabla
	mov	eax, 0
	lea esi,[esi + 4 * 24]	
	mov eax,0xB8000	
	or 	eax, 0x3					;supervisor, read/write, present
	mov	[esi], eax


	;desde la a0000
	mov	esi,traductorYKernelTable	;llenamos desde la primer tabla
	mov	eax, 0
	lea esi,[esi + 4 * 160]	
	lea eax,[eax + 4096 * 160]		;Para saber en donde emepezar
	mov ecx,32 						; 1024 = 4m
	llenarTablastYk3:
		or 	eax, 0x3				;supervisor, read/write, present
		mov [esi], eax
		lea esi,[esi + 4]			;cada descriptor de tabla(eax) tiene 4 bytes
		lea eax,[eax + 4096]		;cada tabla ocupa 4k.
	loop llenarTablastYk3 			;aca completamos hasta la 0x8fff

;------------------------------------FIN PAGINACION TRADUCTOR Y KERNEL-------------------------------------------------------


	mov eax, traductorYKernelPage_dir	;cargamos la direccion del directorio en cr3
	mov cr3, eax

	mov eax, cr0				
	or  eax, 0x80000000					;habilitamos paginacion
	mov cr0, eax


;-------------------------EJERCICIO 2b-----------------------------------------------------------------------------------

	;escribimos Orga2 RET  a traves de la pos de memoria 13000 que esta mapeada a la b8000
	mov ecx, mensajeEj_len		
	mov ah, 0x0c
	mov esi, mensajeEj
	xor edi, edi
	; accedemos a la memoria de video a traves de la paginacion en la pantalla donde quiero escribir
	add edi, (160) + 2 + 0x13000	

	.ciclo2:
		lodsb 			; lee desde ds:esi e incrementa esi en 1
		stosw 			; escribe en es:edi e incrementa edi en 2
	loop .ciclo2

	; Ejercicio 3

		; Inicializacion PIC1

		mov al, 0x11 ;ICW1: IRQs activas por flanco, Modo cascada, ICW4 Si.
		out 20h, al
		mov al, 0x20    ;ICW2: INT base para el PIC1 Tipo 8.
		out 21h, al
		mov al, 04h ;ICW3: PIC1 Master, tiene un Slave conectado a IRQ2
		out 21h ,al
		mov al, 01h ;ICW4: Modo No Buffered, Fin de Interrupcion Normal

		out 21h, al ;       Deshabilitamos las Interrupciones del PIC1
		mov al, 0x00 ;OCW1: Set o Clear el IMR
		out 21h, al
		 ;Inicializacion PIC2

		mov al, 11h ;ICW1: IRQs activas por flanco, Modo cascada, ICW4 Si.
		out 0xA0, al
		mov al, 28h ;ICW2: INT base para el PIC1 Tipo 070h.
		out 0xA1, al
		mov al, 02h ;ICW3: PIC2 Slave, IRQ2 es la linea que envia al Master

		out 0xA1, al
		mov al, 01h ;ICW4: Modo No Buffered, Fin de Interrupcion Normal										  
		out 0xA1, al		

	pic_enable:
		mov al, 0x00
		out 0x21, al
		mov al, 0x00
		out 0xA1, al

		call idtFill
		lidt [IDT_DESC]		; load idt 

	; Ejercicio 4

	; Inicializar las TSS

		; Inicializar TSS para el traductor
		mov edi, tsss			; usamos la tss[1] porque la cero es para volver. 
		add edi, 104			; tamano de la TSS

		add edi, 4 ; avanzamos a esp0
		mov [esi], esp
		add edi, 4 ; avanzamos a grabar ess
		mov [esi], ss

		add edi, 20  ; avanzamos al CR3
		mov eax, cr3
		mov dword [edi], eax

		add edi, 4  ; avanzamos al EIP
		mov dword [edi], 0x9000 ; tarea de traductor

		add edi, 4 ; avanzamos a los eflags
		mov dword [edi], 0x202 ; si hay interrupciones, poner 202

		add edi, 20 ; avanzamos a ESP
		mov dword [edi], 0x17000

		add edi, 4	; ebp
		mov dword[edi], 0x17000

		add edi, 12 	; ES
		mov word [edi], 0x10	;descriptor de datos del kernel

		add edi, 4	; CS
		mov word [edi], 0x8

		mov cl, 4
		.ciclo:
			add edi, 4	; el resto de los registros de segmentos SS DS FS GS
			mov word [edi], 0x10
		loop .ciclo

		;; inicializacion finalizada...

		; Inicializar TSS para el pintor
		mov edi, tsss			; usamos la tss[2] porque la cero es para volver. 
		add edi, 208			; tamano de la TSS

		add edi, 4 ; avanzamos a esp0
		mov [esi], esp
		add edi, 4 ; avanzamos a grabar ess
		mov [esi], ss

		add edi, 20  ; avanzamos al CR3
		mov eax, pintorPage_dir		
		mov dword [edi], eax

		add edi, 4  ; avanzamos al EIP
		mov dword [edi], 0x8000 ; tarea de traductor

		add edi, 4 ; avanzamos a los eflags
		mov dword [edi], 0x202 ; si hay interrupciones, poner 202

		add edi, 20 ; avanzamos a ESP
		mov dword [edi], 0x16000

		add edi, 4	; ebp
		mov dword[edi], 0x16000

		add edi, 12 	; ES
		mov word [edi], 0x10	;descriptor de datos del kernel

		add edi, 4	; CS
		mov word [edi], 0x8

		mov cl, 4
		.ciclo2:
			add edi, 4	; el resto de los registros de segmentos SS DS FS GS
			mov word [edi], 0x10
		loop .ciclo2

		;; inicializacion finalizada...

	; Inicializar correctamente los descriptores de TSS en la GDT

		;; ahora agregamos en la gdt un descriptor para el tss nuevo (0x20)
		mov edi, gdt

		; Descriptor para la tarea Basura
		add edi, 0x20
		mov eax, tsss
		mov word [edi + 2 ], ax	
		shr eax, 16
		mov byte [edi + 4], al
		mov byte [ edi + 7], ah

		; Descriptor para la tarea Traductor
		mov edi, gdt
		add edi,0x28

		mov eax, tsss
		add eax, 104

		mov word [edi + 2 ], ax
		shr eax, 16
		mov byte [edi + 4], al
		mov byte [ edi + 7], ah

		; Descriptor para la tarea Pintor
		mov edi, gdt
		add edi,0x30

		mov eax, tsss
		add eax, 208 

		mov word [edi + 2 ], ax
		shr eax, 16
		mov byte [edi + 4], al
		mov byte [ edi + 7], ah

	; Cargar el registro TR con el descriptor de la GDT de la TSS actual

		mov ax, 0x20
		ltr ax

	; Saltar a la primer tarea

		jmp 0x30:0
		jmp $ ; aca no deberia llegar nunca
			
mensaje: db 	0x2b 
mensajeEj db "Orga 2   RET",0
mensajeEj_len equ $-mensajeEj			
%include "a20.asm"


%define TASK1INIT 0x8000
%define TASK2INIT 0x9000
%define KORG 0x1200

; 8000 - iniciodelkernel- gilada..
TIMES TASK1INIT - KORG - ($ - $$) db 0x00 ; rellena de 0 hasta la direccion.
incbin "pintor.tsk" ; ocupa 4k
incbin "traductor.tsk" ; este no ocupa 4k!! hay q rellenar con 0 hasta llegar a la dir q nos dicen y empezar la tabla de pagina


TIMES 0xA000 - KORG - ($ - $$) db 0x00 ;rellena de 0 hasta la direccion

;empiezo a llenar el lugar para los directorios y las tablas de paginas	
pintorPage_dir:	
%rep	0x400
	dd	0x00000002		;supervisor, read/write, not present
%endrep

traductorYKernelPage_dir:	
%rep	0x400
	dd	0x00000002		;supervisor, read/write, not present
%endrep

pintorTable:	
%rep	0x400
	dd	0x00000002		;supervisor, read/write, not present
%endrep

traductorYKernelTable:	
%rep	0x400
	dd	0x00000002		;supervisor, read/write, not present
%endrep

; Definicion de la GDT
ALIGN 0x10
gdt:
;descriptor nulo
	dd 0x00	
	dd 0x00
	
; 0x8 (1) descriptor segmento de codigo
	dw 0xffff		; segment limit
	dw 0x00			; base 15
	db 0x00			; base
	db 10011010b	;
	db 11001111b 	; 3 byte
	db 0x00			; base 31:24 
; 0x10(2) descriptor segmento de datos
	dw 0xffff		; segment limit
	dw 0x00			; base 15
	db 0x00			; base
	db 10010010b	;
	db 11001111b 	; 3 byte
	db 0x00			; base 31:24 
	
; 0x18(3) descriptor segmento de video
	dw 0xffff		; segment limit
	dw 0x8000		; base 15
	db 0x0B			; base
	db 10010010b	;
	db 11001111b 	; 3 byte
	db 0x00			; base 31:24 


; 0x20(3) descriptor de TSS para la tarea nula
	dw 0x67			; segment limit
	dw 0x00			; base 15
	db 0x00			; base
	db 10001001b	;
	db 0x00 		; 3 bit
	db 0x00			; base 31:24 

; 0x28(3) descriptor de TSS para la tarea Traductor
	dw 0x67			; segment limit
	dw 0x00			; base 15
	db 0x00			; base
	db 10001001b	;
	db 0x00 		; 3 bit
	db 0x00			; base 31:24 

; 0x30(3) descriptor de TSS para la tarea Pintor
	dw 0x67			; segment limit
	dw 0x00			; base 15
	db 0x00			; base
	db 10001001b	;
	db 0x00 		; 3 bit
	db 0x00			; base 31:24 

gdt_descriptor:
	dw gdt_descriptor - gdt
	dd gdt

; Fin definicion GDT

