section .text
bits 32

global _bar
_bar:
	xor eax, eax
	mov eax, lba
	ret

section data1 align=16 vstart=0
    lba db 0x55, 0xf0

section data2 align=16 vstart=0
    lbb db 0x00, 0x90
    lbc dw 0xf000

section data3 align=16 vstart=0
    lbd dw 0xfff0, 0xfffc

program_end: