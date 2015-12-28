section .text
global sumaD

%define A [ebp+ 8]
%define B [ebp+16]

sumaD:
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	finit	

	fld qword A
	fadd qword B				


	pop edi
	pop esi
	pop ebx
	pop ebp

ret
