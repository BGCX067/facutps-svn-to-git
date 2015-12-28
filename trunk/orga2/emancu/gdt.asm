BITS 16
ORG 0x1200

call disabled_A20
call check_A20
call enabled_A20
call check_A20
cli				; desactiva interrupciones
lgdt [gdtr]	; cargamos la gdt

mov eax, cr0
or eax, 1
mov cr0, eax
jmp 0x08:modoprotegido
BITS 32
modoprotegido:
; actualizar la informacion de los registros DS ES GS FS SS
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	
	mov esi, 0xB8000	; apuntamos a la memoria de video, la direccion es distinta, tiene un 0 mas
	mov edi, mensaje	
	
	mov ah,	0x0A	; modo de video (azul brillante)
	mov ecx, mensaje_len
	
ciclo:
	lodsb	; carga en ax
	stosw	; guarda en donde esta apuntado por edi
	loop ciclo
	
	jmp $	; colgamos el programa para que se vea

mensaje: db 'Los pibes haciendo palmas en orga..'
mensaje_len: equ $ - mensaje

%include "A20.asm"

;;;;;;;;;;;;;;;;; esto va en otro archivo? no entiendo nada creo q es en kernel.bin

ALIGN 0x10
gdt:	
	dd 0	
	dd 0
	
; 0x8 (1)

	dw 0xffff		; segment limit
	dw 0			; segment limit
	db 0			; ??
	db 10011010b	;
	db 11001111b 	; 3 byte
	db 0			; base 31:24 
; 0x10(2)
	dw 0xffff
	dw 0
	db 0
	db 10010010b
	db 11001111b
	db 0

gdt_end:
	dw gdt_end - gdt - 1
	dd gdt
gdtr:


; nasm -f bin -o kernel.bin modoprotegido
; mcopy -i diskette.img kernel.bin ::/


;; x /2 0x1548 muestra la memoria en el bochs

;; info gdt !! muy util

;; creg ;; no se bien q hac pero sirve. las cosas en mayusculas estan habilitadas

;; sreg ;; muy copado

