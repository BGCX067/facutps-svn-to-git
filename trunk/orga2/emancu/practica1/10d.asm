section .text
global main

main:
	jc esUno
	bt bx, 8	; es bh, 1 solo q no se puede
	cmc
	ret

esUno:
	bt bx,8

