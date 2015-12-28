ORG 0x8000
BITS 32


%include "macrosmodoprotegido.mac"
jmp main

num: dd 0x00000000
test: dd 0x00000000
message: db '|','/','-','\',0x00
message2: db 'Este es el numero en hexa de la tarea 1: 0x'
message3: db '00000000'
mes_len equ $ - message2


main:
	mov eax, (0xB8000 + ((80 * 24) << 1))
	mov ebx, [num]
	inc ebx
	;xchg bx,bx
	inc DWORD [test]
	cmp ebx, 0x4
	jl .ok
		mov ebx, 0
	.ok:
		mov byte cl, [message + ebx]
		mov ch, 0x0C
		mov word [eax], cx 


	mov [num], ebx
	mov eax, [test]
	
	DWORD_TO_HEX eax, message3
	IMPRIMIR_TEXTO message2, mes_len, 0x1A, 0x07, 0x00
	
	jmp main 

TIMES 0x1000 - ($ - $$) db 0x0
