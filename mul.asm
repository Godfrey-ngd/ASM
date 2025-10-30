stack segment stack
    db 100h dup(?)      ; 
stack ends

code segment
    assume cs:code, ss:stack
start:
    mov ax, stack
    mov ss, ax
    mov sp, 100h      
    mov cx,9
    
  s:mov bx,cx
s0:mov dx,bx
    add dx,30h
    mov ah, 02h       
    int 21h 

    mov dx,2ah
    mov ah, 02h       
    int 21h

    mov dx,bx
    sub dx,cx
    inc dx
    add dx,30h
    mov ah, 02h       
    int 21h
    
    mov dl,3dh
    mov ah,02h
    int 21h
    
    mov ax,bx
    sub ax,cx
    inc ax
    mul bx
    call print
    mov dl,20h
    mov ah, 02h       
    int 21h 
    loop s0

    mov ah, 02h
    mov dl,0dh       
    int 21h
    mov dl,0ah
    int 21h
    mov cx,bx    
    loop s

    ; 退出程序
    mov ax, 4c00h
    int 21h

print proc
    push bx
    push cx
    push dx

    mov cx, 0
    mov bx, 10
div_loop:
    xor dx, dx         
    div bx              
    add dl, '0'         
    push dx
    inc cx
    test ax, ax
    jnz div_loop

output_loop:
    pop dx
    mov ah, 02h       
    int 21h
    loop output_loop

    pop dx
    pop cx
    pop bx
    ret
print endp

code ends
end start