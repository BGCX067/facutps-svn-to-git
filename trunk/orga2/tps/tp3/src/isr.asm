BITS 32
%include "macrosmodoprotegido.mac"
extern pic1_intr_end


; ----------------------------------------------------------------
; Interrupt Service Routines
; TODO: Definir el resto de las ISR
; ----------------------------------------------------------------

global _isr0
msgisr0: db 'EXCEPCION: Division por cero'
msgisr0_len equ $-msgisr0
_isr0:
  mov edx, msgisr0
  mov esi, msgisr0_len
  call IMPRIMIR_ERROR
  jmp $

global _isr1
msgisr1: db 'EXCEPCION: 1'
msgisr1_len equ $-msgisr1
_isr1:
  mov edx, msgisr0
  mov esi, msgisr1_len
  call IMPRIMIR_ERROR
  jmp $

global _isr2
msgisr2: db 'EXCEPCION: 2'
msgisr2_len equ $-msgisr2
_isr2:
  mov edx, msgisr0
  mov esi, msgisr2_len
  call IMPRIMIR_ERROR
  jmp $

global _isr3
msgisr3: db 'EXCEPCION: 3'
msgisr3_len equ $-msgisr3
_isr3:
  mov edx, msgisr0
  mov esi, msgisr3_len
  call IMPRIMIR_ERROR
  jmp $

global _isr4
msgisr4: db 'EXCEPCION: 4'
msgisr4_len equ $-msgisr4
_isr4:
  mov edx, msgisr0
  mov esi, msgisr4_len
  call IMPRIMIR_ERROR
  jmp $

global _isr5
msgisr5: db 'EXCEPCION: 5'
msgisr5_len equ $-msgisr5
_isr5:
  mov edx, msgisr0
  mov esi, msgisr5_len
  call IMPRIMIR_ERROR
  jmp $

global _isr6
msgisr6: db 'EXCEPCION: 6'
msgisr6_len equ $-msgisr6
_isr6:
  mov edx, msgisr0
  mov esi, msgisr6_len
  call IMPRIMIR_ERROR
  jmp $

global _isr7
msgisr7: db 'EXCEPCION: 7'
msgisr7_len equ $-msgisr7
_isr7:
  mov edx, msgisr0
  mov esi, msgisr7_len
  call IMPRIMIR_ERROR
  jmp $

global _isr8
msgisr8: db 'EXCEPCION: 8'
msgisr8_len equ $-msgisr8
_isr8:
  mov edx, msgisr0
  mov esi, msgisr8_len
  call IMPRIMIR_ERROR
  jmp $

global _isr9
msgisr9: db 'EXCEPCION: 9'
msgisr9_len equ $-msgisr9
_isr9:
  mov edx, msgisr0
  mov esi, msgisr9_len
  call IMPRIMIR_ERROR
  jmp $


global _isr0a
msgisr0a: db 'EXCEPCION: 0a'
msgisr0a_len equ $-msgisr0a
_isr0a:
  mov edx, msgisr0
  mov esi, msgisr0a_len
  call IMPRIMIR_ERROR
  jmp $

global _isr0b
msgisr0b: db 'EXCEPCION: 0b'
msgisr0b_len equ $-msgisr0b
_isr0b:
  mov edx, msgisr0
  mov esi, msgisr0b_len
  call IMPRIMIR_ERROR
  jmp $

global _isr0c
msgisr0c: db 'EXCEPCION: 0c'
msgisr0c_len equ $-msgisr0c
_isr0c:
  mov edx, msgisr0
  mov esi, msgisr0c_len
  call IMPRIMIR_ERROR
  jmp $

global _isr0d
msgisr0d: db 'EXCEPCION: 0d'
msgisr0d_len equ $-msgisr0d
_isr0d:
  mov edx, msgisr0
  mov esi, msgisr0d_len
  call IMPRIMIR_ERROR
  jmp $

global _isr0e
msgisr0e: db 'EXCEPCION: 0e'
msgisr0e_len equ $-msgisr0e
_isr0e:
  mov edx, msgisr0
  mov esi, msgisr0e_len
  call IMPRIMIR_ERROR
  jmp $

global _isr0f
msgisr0f: db 'EXCEPCION: 0f'
msgisr0f_len equ $-msgisr0f
_isr0f:
  mov edx, msgisr0
  mov esi, msgisr0f_len
  call IMPRIMIR_ERROR
  jmp $

global _isr10
msgisr10: db 'EXCEPCION: 10'
msgisr10_len equ $-msgisr10
_isr10:
  mov edx, msgisr0
  mov esi, msgisr10_len
  call IMPRIMIR_ERROR
  jmp $

global _isr11
msgisr11: db 'EXCEPCION:11'
msgisr11_len equ $-msgisr11
_isr11:
  mov edx, msgisr0
  mov esi, msgisr11_len
  call IMPRIMIR_ERROR
  jmp $

global _isr12
msgisr12: db 'EXCEPCION: 12'
msgisr12_len equ $-msgisr12
_isr12:
  mov edx, msgisr0
  mov esi, msgisr12_len
  call IMPRIMIR_ERROR
  jmp $

global _isr13
msgisr13: db 'EXCEPCION: 13'
msgisr13_len equ $-msgisr13
_isr13:
  mov edx, msgisr0
  mov esi, msgisr13_len
  call IMPRIMIR_ERROR
  jmp $

global _isr14
msgisr14: db 'EXCEPCION: 14'
msgisr14_len equ $-msgisr0
_isr14:
  mov edx, msgisr0
  mov esi, msgisr14_len
  call IMPRIMIR_ERROR
  jmp $

global _isr15
msgisr15: db 'EXCEPCION: 15'
msgisr15_len equ $-msgisr15
_isr15:
    mov edx, msgisr0
  mov esi, msgisr15_len
  call IMPRIMIR_ERROR
  jmp $


global _isr16
msgisr16: db 'EXCEPCION: 16'
msgisr16_len equ $-msgisr16
_isr16:
  mov edx, msgisr0
  mov esi, msgisr16_len
  call IMPRIMIR_ERROR
  jmp $

global _isr17
msgisr17: db 'EXCEPCION: 17'
msgisr17_len equ $-msgisr17
_isr17:
  mov edx, msgisr0
  mov esi, msgisr17_len
  call IMPRIMIR_ERROR
  jmp $

global _isr18
msgisr18: db 'EXCEPCION: 18'
msgisr18_len equ $-msgisr18
_isr18:
  mov edx, msgisr0
  mov esi, msgisr18_len
  call IMPRIMIR_ERROR
  jmp $

global _isr19
msgisr19: db 'EXCEPCION: 19'
msgisr19_len equ $-msgisr19
_isr19:
  mov edx, msgisr0
  mov esi, msgisr19_len
  call IMPRIMIR_ERROR
  jmp $

global _isr1a
msgisr1a: db 'EXCEPCION: 1a'
msgisr1a_len equ $-msgisr1a
_isr1a:
  mov edx, msgisr0
  mov esi, msgisr1a_len
  call IMPRIMIR_ERROR
  jmp $


global _isr1b
msgisr1b: db 'EXCEPCION: 19'
msgisr1b_len equ $-msgisr1b
_isr1b:
  mov edx, msgisr0
  mov esi, msgisr1b_len
  call IMPRIMIR_ERROR
  jmp $

global _isr1c
msgisr1c: db 'EXCEPCION: 1c'
msgisr1c_len equ $-msgisr1c
_isr1c:
  mov edx, msgisr0
  mov esi, msgisr1c_len
  call IMPRIMIR_ERROR
  jmp $


global _isr1d
msgisr1d: db 'EXCEPCION: 1d'
msgisr1d_len equ $-msgisr1d
_isr1d:
  mov edx, msgisr0
  mov esi, msgisr1d_len
  call IMPRIMIR_ERROR
  jmp $

global _isr1e
msgisr1e: db 'EXCEPCION: 1e'
msgisr1e_len equ $-msgisr1e
_isr1e:
  mov edx, msgisr0
  mov esi, msgisr1e_len
  call IMPRIMIR_ERROR
  jmp $

global _isr1f
msgisr1f: db 'EXCEPCION: 1f'
msgisr1f_len equ $-msgisr1f
_isr1f:
  mov edx, msgisr0
  mov esi, msgisr1f_len
  call IMPRIMIR_ERROR
  jmp $

; clock
global _isr32
_isr32:
  cli
  pushad
  call next_clock

  mov al, 0x20
  out 0x20, al
  popad

  ;task switching
  push eax
  str ax
  cmp ax, 0x28
  je switchPintor
  pop eax
  jmp 0x28:0
  sti
  iret

  switchPintor:
    pop eax
  jmp 0x30:0
  sti
  iret


global _isr33
_isr33:
  cli
    pushad
    in al, 0x60 ; lee el scan code del teclado

    test al, 0x80
    jnz .saltar

    mov ebx, letra_null    ;empezamos con ''

    inc ebx
    cmp al, [scan_a]
    jz .cont
    inc ebx
    cmp al, [scan_c]
    jz .cont
    inc ebx
    cmp al, [scan_r]
    jz .cont
    inc ebx
    cmp al, [scan_e]
    jz .cont
    inc ebx
    cmp al, [scan_space]
    jz .cont

    inc ebx
    cmp al, [scan_delete]
    jz .borrar

    jmp .saltar      ;si no es ninguno no pongo nada
    mov ebx, letra_null

  .cont:
    mov ecx, [columna]
    IMPRIMIR_TEXTO ebx, 1, 0x0A, 14, ecx, 0x13000
    inc dword [columna]
    jmp .saltar

  .borrar:
    mov ecx, [columna]
    sub ecx,1
    IMPRIMIR_TEXTO ebx, 1, 0x0A, 14, ecx, 0x13000
    dec dword [columna]


  .saltar:
    mov al, 0x20
    out 0x20, al

    popad
    sti
    iret




IMPRIMIR_ERROR:
pushad
  IMPRIMIR_TEXTO edx, esi, 0x0C, 0, 0, 0x13000
popad
ret


next_clock:
  pushad
  inc DWORD [isrnumero]
  mov ebx, [isrnumero]
  cmp ebx, 0x4
  jl .ok
    mov DWORD [isrnumero], 0x0
    mov ebx, 0
  .ok:
    add ebx, isrmessage1
    mov edx, isrmessage
    IMPRIMIR_TEXTO edx, 6, 0x0A, 23, 1, 0x13000
    IMPRIMIR_TEXTO ebx, 1, 0x0A, 23, 8, 0x13000
  popad
  ret


isrmessage: db 'Clock:'
isrnumero: dd 0x00000000
isrmessage1: db '|'
isrmessage2: db '/'
isrmessage3: db '-'
isrmessage4: db '\'

columna: dd 0x0000000A
letra_null: db ' '
letra_a: db 'a'
letra_c: db 'c'
letra_r: db 'r'
letra_e: db 'e'
space:   db ' '
delete: db ' '
scan_a: db 0x1E
scan_c: db 0x2E
scan_r: db 0x13
scan_e: db 0x12
scan_space: db 0x39
scan_delete: db 0x0E

