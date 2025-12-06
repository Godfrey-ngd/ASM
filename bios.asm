.model small
.stack 100h

.code
start:
    ; DOS程序启动时，ES和DS都指向PSP
    ; 保存PSP段地址到BX寄存器备用
    mov bx, es
    
    mov ax, @code
    mov ds, ax

main_loop:
    ; 直接读取BIOS键盘状态字节 (0040:0017h)
    push ds
    push bx                ; 保护BX（存储PSP段地址）
    mov ax, 40h
    mov ds, ax
    mov bx, 17h
    mov al, [bx]           ; 读取键盘状态字节
    pop bx                 ; 恢复BX
    pop ds
    
    ; Bit 0 = 右Shift按下
    ; Bit 1 = 左Shift按下
    test al, 03h           ; 测试位0和位1
    jnz exit_program       ; 如果Shift键被按下,退出
    
    ; 调用 INT 16h, AH=1 检查是否有按键
    mov ah, 1
    int 16h
    jz main_loop           ; 如果没有按键,继续等待
    
    ; 调用 INT 16h, AH=0 读取键盘按键
    mov ah, 0
    int 16h
    ; AL = ASCII码, AH = 扫描码
    
    ; 显示字符 - 调用 INT 10h, AH=0Eh (写字符)
    mov ah, 0Eh
    mov bh, 0              ; 页号 = 0
    mov bl, 07h            ; 属性 = 白色
    int 10h
    
    ; 继续循环
    jmp main_loop

exit_program:
    mov ax, 4C00h
    int 21h

end start

