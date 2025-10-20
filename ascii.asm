assume cs:code
code segment
	mov cx,2h
	mov dh,61h

      s:mov bx,cx
	mov cx,000dh

    s0:mov dl,dh
	mov ah,02h
	int 21h
	inc dh
	mov dl,20h
	mov ah,02h
	int 21h
	loop s0

	mov dl,0ah
	mov ah,02h
	int 21h
	mov cx,bx
	loop s

	mov ax,4c00h
	int 21h
code ends
end
