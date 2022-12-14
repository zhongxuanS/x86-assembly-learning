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

; 计算number标号对应汇编地址，并将其分解成个十百千万
    ; 保存number标号地址到ax寄存器中，因为div指令的被除数需要放在dx:ax中
    mov ax, number
    ; 后面要保存商到number中，这里要记一下number的地址
    mov bx, ax
    ; 保存除数
    mov si, 10
    ; 设置循环次数cx寄存器，因为loop每次会把cx寄存器值减1
    ; 我们正好是个十百千万
    mov cx, 5
digit:
    ; 每次都要把dx清零，因为是32位除16位
    xor dx, dx
    div si
    ; 保存余数到number中
    ; 余数保存在dx寄存器中，因为肯定是小于10，所以取低8位就够了
    mov [bx], dl
    ; bx加1
    inc bx
    ; 循环计算
    loop digit

; 到此为止，number中已经按照个十百千万保存了number处的地址
; 下面需要做的是把number中的值搬运到显存中
; 因为number中保存的是数字，所以要将其转成ASCII码，每个数字加0x30
    mov bx, number
    mov si, 0x4
show:
    ; 拷贝number中的值到al寄存器中，因为我们要用ax寄存器临时保存
    ; 放到显存中的值
    mov al, [bx + si]
    ; 将数字转成ASCII码
    add al, 0x30
    ; 设置显示属性为0x04
    mov ah, 0x04
    ; 搬运ax寄存器中值到显存中，es中保存显存的基地址,es:di正好在":"后面
    mov [es:di], ax
    ; 显存index + 2，因为高位是显示属性，低位是ASCII码
    add di, 2
    ; si减一，继续拷贝后面的值
    dec si
    ; 当si减到-1时，sf标志位被设置，继续执行jns show下面的指令
    jns show
    ; 设置最后的"D"字符
    mov word [es:di],0x0744

    ; 死循环
    jmp near $

    ; padding 补齐512字节
    times 510-($-$$) db 0
                     db 0x55,0xaa
