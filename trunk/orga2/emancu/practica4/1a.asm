section .text
global suma

%define A [ebp+ 8]
%define B [ebp+12]

suma:
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	finit	

	fld dword A
	fadd dword B				


	pop edi
	pop esi
	pop ebx
	pop ebp

ret
