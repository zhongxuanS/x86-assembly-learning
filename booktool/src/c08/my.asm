    ; 用户程序起始扇号100，也可以声明成
    ; app_lba_start db 100，这样的话会占用内存和磁盘空间
    app_lba_start equ 100


; 引导程序的作用：
; 1. 从100扇号读取用户程序到0x10000内存处，使用0x10000是因为8086只能管理1MB内存，
;    0x0 0000~0xf ffff
;    0x0000~0x7c00~0xffff被MBR/BIOS占用，高位还有被IO映射占用，只有中间一截是可以被利用的，
;    0x10000肯定是空闲，可以被占用
section mbr align=16 vstart=0x7c00
    ; 用户程序内存映射基地址
    phy_base dd 0x10000

    ; 计算用户程序内存的段地址，0x1000，保存到ds和es寄存器中
    ; 这是因read_hard_disk_0函数映射磁盘数据到内存中的时候，
    ; 使用ds:bx来操作内存。所以要映射到ds中
    mov ax, [cs:phy_base]
    mov dx, [cs:phy_base+0x02]
    mov bx, 16
    div bx
    ; 商在ax中
    mov ds, ax
    mov es, ax 


    ; 读取扇号为100的磁盘
    xor di, di
    mov si, app_lba_start
    xor bx, bx
    call read_hard_disk_0



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

.readw:
    in ax, dx
    mov [bx], ax
    add bx, 2
    loop .readw

    pop ax
    pop bx
    pop cx
    pop dx

    ret




