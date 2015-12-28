BITS 16

%define TASK1INIT 0x8000
%define KORG 0x1200
%define ESPTASK1 0x10000

global start
extern GDT_DESC
extern tsss;
extern gdt;

%define TSS_SIZE 104

;Aca arranca todo, en el primer byte.
start:
		cli			;no me interrumpan por ahora
		;xchg	bx, bx
		jmp 	bienvenida

%include "macrosmodoreal.mac"
;aca ponemos todos los mensajes		
iniciando: db 'Iniciando el kernel mas inutil del mundo   '
iniciando_len equ $ - iniciando		


bienvenida:

		IMPRIMIR_MODO_REAL iniciando, iniciando_len, 0x07, 0, 0
		call	disable_A20
		;xchg	bx, bx
		call	check_A20
		;xchg	bx, bx
		call 	enable_A20
		;xchg	bx, bx
		call	check_A20
		;xchg 	bx, bx

		;deshabilitamos las interrupciones
		cli
		
		;cargamos la gdt
		lgdt [GDT_DESC]
;		
;		;seteamos el bit PE del registro cr0
		mov 	eax, cr0
		or  	eax, 01h
		mov 	cr0, eax
		
;		;segundo segmento en la GDT, el primero es nulo
		jmp 	0x08:modo_protegido

BITS 32
modo_protegido:

		mov 	ax, 0x10
		mov 	ds, ax		;acomodo el segmento de datos antes de hacer lio
		mov 	es, ax		;acomodo el segmento de datos antes de hacer lio
		mov 	fs, ax		;acomodo el segmento de datos antes de hacer lio
		mov 	gs, ax		;acomodo el segmento de datos antes de hacer lio
		mov		ss, ax		;acomodo el segmento de pila antes de usarla
			
		; Completar codigo aqui
		mov edi, tsss			; usamos la tss[1] porque la cero es para volver. 
		add edi, 104			; tamano de la TSS
		
		add edi, 4 ; avanzamos a esp0
		mov [esi], esp
		add edi, 4 ; avanzamos a grabar ess
		mov [esi], ss
		;; falta poner el CR3 q es para paginacion!!
		
		add edi, 24  ; avanzamos al EIP
		mov dword [edi], 0x8000 
		
		add edi, 4 ; avanzamos a los eflags
		mov dword [edi], 0x02 ;; si hay interrupciones, poner 202
		
		add edi, 20 ; avanzamos a ESP
		mov dword [edi], 0x30000
		
		add edi, 4	; ebp
		mov dword[edi], 0x30000
		
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
		
		;; ahora agregamos en la gdt un descriptor para el tss nuevo (0x20)
		mov edi, gdt
		
		add edi, 0x18	
		mov eax, tsss
		mov word [edi + 2 ], ax	;
		shr eax, 16
		mov byte [edi + 4], al
		mov byte [ edi + 7], ah
		
		; agregamos el tss2 
		
		mov eax, tsss
		add eax, 104 
		add edi, 8
		mov word [edi + 2 ], ax
		shr eax, 16
		mov byte [edi + 4], al
		mov byte [ edi + 7], ah
		
		mov ax, 0x18
		ltr ax
		jmp 0x20:0
		
		jmp $
		
		
		
		
%include "a20.asm"
TIMES TASK1INIT - KORG - ($ - $$) db 0x00
incbin "task1.tsk"


