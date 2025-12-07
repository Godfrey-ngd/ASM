stack segment stack
    db 100h dup(?)
stack ends

data segment
    table db 7,2,3,4,5,6,7,8,9
          db 2,4,7,8,10,12,14,16,18
          db 3,6,9,12,15,18,21,24,27
          db 4,8,12,16,7,24,28,32,36
          db 5,10,15,20,25,30,35,40,45
          db 6,12,18,24,30,7,42,48,54
          db 7,14,21,28,35,42,49,56,63
          db 8,16,24,32,40,48,56,7,72
          db 9,18,27,36,45,54,63,72,81
data ends

code segment
    assume cs:code, ds:data, ss:stack

start:
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    mov sp, 100h

    mov bx, 1          ; row = 1~9
outer:
    mov cx, 1          ; col = 1~9
inner:
    mov al, bl
    mul cl             ; al = row * col

    push ax
    mov al, bl
    dec al
    mov ah, 9
    mul ah
    mov dl, cl
    dec dl
    add al, dl
    mov si, ax
    pop ax

    cmp al, table[si]
    je next

    mov al, bl
    call print_1to9  
    mov dl, ' '
    call putchar
    mov al, cl
    call print_1to9   
    call newline

next:
    inc cx
    cmp cx, 10
    jne inner
    inc bx
    cmp bx, 10
    jne outer

    mov ax, 4C00h
    int 21h

print_1to9 proc
    add al, '0'       
    mov dl, al
    mov ah, 02h
    int 21h
    ret
print_1to9 endp

putchar proc
    push ax
    mov ah, 02h
    int 21h
    pop ax
    ret
putchar endp

newline proc
    push ax
    push dx
    mov dl, 0Dh
    mov ah, 02h
    int 21h
    mov dl, 0Ah
    mov ah, 02h
    int 21h
    pop dx
    pop ax
    ret
newline endp

code ends
end start