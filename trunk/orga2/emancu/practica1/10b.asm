section .text
global main

main:
	mov esi, edi		; 
	or esi, 00011111b	; seteo los 5 bits en 1
	ret

