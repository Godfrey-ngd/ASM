        .MODEL  SMALL
        .STACK  100H

;====================================================================
; 数据段
;====================================================================
.DATA
BUF     DB  4           ; 最多 3 位 + 回车
        DB  0           ; 实际读取的字符数（DOS 填充）
        DB  4 DUP(?)    ; 输入缓冲区
RESULT  DB  'Sum = $'   ; 结果前缀
OUTBUF  DB  6 DUP(?)    ; 结果缓冲区（最多 5 位 + $）
CRLF    DB  0DH,0AH,'$' ; 回车换行 + 结束符

;====================================================================
; 代码段
;====================================================================
.CODE
MAIN    PROC
        MOV     AX,@DATA
        MOV     DS,AX

        ;--- 1) 读取一行（最多 3 字符） --------------------
        LEA     DX,BUF
        MOV     AH,0AH          ; DOS 缓冲输入
        INT     21H

        ;--- 2) 把 ASCII 串转为数值 n -----------------------
        LEA     SI,BUF+2        ; SI -> 第一个字符
        XOR     AX,AX           ; n = 0
        MOV     CL,[BUF+1]      ; 实际字符数
        OR      CL,CL
        JZ      EXIT            ; 直接回车则 n=0

CONV_LOOP:
        MOV     BL,[SI]         ; 取字符
        SUB     BL,'0'          ; 转为数值 0~9
        MOV     BH,10
        MUL     BH              ; AX = AX*10
        ADD     AL,BL
        ADC     AH,0            ; 处理进位
        INC     SI
        DEC     CL
        JNZ     CONV_LOOP
        ; 此时 AX = n (0~100)

        ;--- 3) 计算 1+2+…+n --------------------
        MOV     BX,AX
        INC     BX
        MUL     BX              ; DX:AX = n*(n+1)
        SHR     AX,1            ; 除以 2
        ADC     AX,0

        ;--- 4) 结果 AX → 十进制 ASCII --------------------
        LEA     DI,OUTBUF+5
        MOV     BYTE PTR [DI],'$'   ; 结束符
        MOV     BX,10
        OR      AX,AX
        JNZ     DIG_LOOP
        DEC     DI
        MOV     BYTE PTR [DI],'0'   ; n=0 特殊处理
        JMP     PRINT

DIG_LOOP:
        XOR     DX,DX
        DIV     BX              ; 
        ADD     DL,'0'
        DEC     DI
        MOV     [DI],DL
        OR      AX,AX
        JNZ     DIG_LOOP

        ;--- 5) 输出结果 ------------------------------------
PRINT:
        LEA     DX,RESULT
        MOV     AH,09H
        INT     21H

        MOV     DX,DI           ; DI 指向第一个数字
        MOV     AH,09H
        INT     21H

        LEA     DX,CRLF
        MOV     AH,09H
        INT     21H

EXIT:
        MOV     AX,4C00H
        INT     21H
MAIN    ENDP
        END     MAIN