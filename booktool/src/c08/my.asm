section mbr align=16 vstart=0x7c00

; 扇区编号: DI:SI（高16位，低16位）
; 默认只读取1个扇区
; 数据：DS:BX
read_hard_disk_0:
    push ax
    push bx
    push cx
    push dx

    ; 设置读取扇区数量
    ; 寄存器0x1f2
    mov dx, 0x1f2
    mov al, 0x1 ;1个扇区
    out dx, al

    ; 设置要读取扇区的扇号(LBA28)
    ; 寄存器0x1f3,0x1f4,0x1f5,0x1f6(0-7,8-15,16-23,24-28)
    ; 其中0x1f6的低四位是扇号，高4位分别为：1110（必须为1，LBA模式，必须为1，0为主盘，1为从盘）
    inc dx          ; 0x1f3
    mov ax, si
    out dx, al

    inc dx          ; 0x1f4
    mov al, ah
    out dx, al

    inc dx          ; 0x1f5
    mov ax, di
    out dx, al

    inc dx          ; 0x1f6
    mov al, 0xe0    ; 1110 0000 | xxxx xxxx = 111x xxxx
    or al, ah       ; 要注意，111x，中的X不能为1，要不然算出来就不是1110开头了，
                    ; 所以说di寄存器中只能保存0x0xxx xxxx
    out dx, al      ; 到这里设置扇号结束

    ; 开始发送读取命令
    ; 寄存器0x1f7, 发送 0x20
    inc dx          ; 0x1f7
    mov al, 0x20
    out dx, al

    ; 0x1f7在发送读取命令后，其中的数据含义是读取状态
    ; BSY, , , ,DRQ, , ,ERR
    ; 只要取BSY和DRQ（0x88)，判断DRQ的值是否为1即可，为1说明DATA READY
.waits:
    in al, dx
    and al, 0x88
    cmp al, 0x08 ; BSY=0, DRQ=1
    jnz .waits

    mov cx, 256 ; 读取256字
    mov dx, 0x1f0
.readw
    in ax, dx
    mov [bx], ax
    add bx, 2
    loop .readw

    pop ax
    pop bx
    pop cx
    pop dx

    ret




