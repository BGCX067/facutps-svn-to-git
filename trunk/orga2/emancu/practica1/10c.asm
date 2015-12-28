section .text
global main

main:
	mov bx, ax		; 
	and bx, 0x1FFF		; pongo en 0 los 3 bits mas signif
	or  bx, 0x000F		; 1 los 4 menos significativos
	btc bx, 7		; invierte el bit 7
	btc bx, 8		; invierte el bit 8
	btc bx, 9		; invierte el bit 9
	ret

