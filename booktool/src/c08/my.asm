section data1 align=16 vstart=0
    lba db 0x55, 0xf0

section data2 align=16 vstart=0
    lbb db 0x00, 0x90
    lbc dw 0xf000

section data3 align=16
    lbd dw 0xfff0, 0xfffc


; ----------------------------------------------------------------------------------------
; 使用 C 语言库在控制台输出 "Hola, mundo"。程序运行在 Linux 或者其他在 C 语言库中不使用下划线的操作系统上。
; 如何编译执行:
;
;     nasm -felf64 hola.asm && gcc hola.o && ./a.out
; ----------------------------------------------------------------------------------------

        global  main
        extern  puts

        section .text
main:                                   ; 被 C 语言库的初始化代码所调用 
        mov     rdi, message            ; 在 rdi 中的第一个整数（或者指针）
        call    puts                    ; 输入文本 
        ret                             ; 由 main 函数返回 C 语言库例程 
message:
        db      "Hola, mundo", 0        ; 注意到在 C 语言中字符串必须以 0 结束 