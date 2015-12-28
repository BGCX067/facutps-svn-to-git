section .text
global main

main:
	mov edx, 0x8000ffff 	; preparo datos 
	mov ebx, 0x80000000 	; limpio el registro
	mov bh, dh		; muevo lo de dh a bh
	and bh, 00011111b	; seteo los 3 bits en 0
	ret

