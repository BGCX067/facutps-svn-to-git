global saturar
section .text

%macro saturar 1  		; escribe en EAX el resultado de la saturacion

	cmp %1, 255			
	jnl %%poner255			; si es mayor que 255 saturo con 255
	
	cmp %1, 0
	jl %%ponerCero			; si es menor a 0 saturo con 0
	
	mov eax, %1
	jmp %%fin
	
%%ponerCero:
	mov eax, 0
	jmp %%fin

%%poner255:
	mov eax, 255

%%fin:	

%endmacro

