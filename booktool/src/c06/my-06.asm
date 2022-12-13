    jmp near start

mytext db 'L',0x07,'a',0x07,'b',0x07,'e',0x07,'l',0x07,' ',0x07,'o',0x07,\
        'f',0x07,'f',0x07,'s',0x07,'e',0x07,'t',0x07,':',0x07
number db 0,0,0,0,0

start:
    ; BIOS会把MBR加载到0x7c0，所以数据段的基地址可以设置为0x7c0,
    ; 这样的话，我们的代码就在一个数据段中了
    mov ax, 0x7c0
    mov ds, ax                      ;设置源数据段

    ; 因为显存的地址在0xb800，我们想显示Label这样的字符
    mov ax, 0xb800
    mov es, ax                     ;设置目的段

    ; 要把mytext中的字符串常量拷贝到显存的位置，使用movsw指令
    ; movsw指令的源数据在ds:si, 目的数据在es:di，计数器在cx
    mov cx, (number - mytext) / 2   ;计算要拷贝多少次
    xor di, di                      ;设置目的偏移量
    mov si, mytext                  ;设置源偏移量

    cld                             ;设置拷贝方向为正向拷贝（di寄存器）
    rep movsw

    ; 设置死循环
    jmp near $

    ; padding 补齐512字节
    times 510-($-$$) db 0
                     db 0x55,0xaa
