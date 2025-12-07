DATA SEGMENT
    PROMPT1 DB 'Please input a Hex number:', 0DH, 0AH, '$'
    PROMPT2 DB 0DH, 0AH, 'The Dec number:', 0DH, 0AH, '$'
    PROMPT3 DB 0DH, 0AH, 'Please input a Dec number:', 0DH, 0AH, '$'
    PROMPT4 DB 0DH, 0AH, 'The Hex number:', 0DH, 0AH, '$'
    MENU    DB 0DH, 0AH, '1. Hex to Dec', 0DH, 0AH
            DB '2. Dec to Hex', 0DH, 0AH
            DB '0. Exit', 0DH, 0AH
            DB 'Choose: $'
    BUFFER  DB 10 DUP(0)
    HEXNUM  DW 0
    DECNUM  DW 0
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA

START:
    MOV AX, DATA
    MOV DS, AX
    
MAIN_LOOP:
    ; 显示菜单
    LEA DX, MENU
    MOV AH, 09H
    INT 21H
    
    ; 获取用户选择
    MOV AH, 01H
    INT 21H
    
    CMP AL, '0'
    JE EXIT_PROG
    CMP AL, '1'
    JE HEX_TO_DEC
    CMP AL, '2'
    JE DEC_TO_HEX
    JMP MAIN_LOOP

HEX_TO_DEC:
    ; 显示提示信息
    LEA DX, PROMPT1
    MOV AH, 09H
    INT 21H
    
    ; 输入16进制数
    CALL INPUT_HEX
    
    ; 显示结果提示
    LEA DX, PROMPT2
    MOV AH, 09H
    INT 21H
    
    ; 输出10进制数
    MOV AX, HEXNUM
    CALL OUTPUT_DEC
    
    JMP MAIN_LOOP

DEC_TO_HEX:
    ; 显示提示信息
    LEA DX, PROMPT3
    MOV AH, 09H
    INT 21H
    
    ; 输入10进制数
    CALL INPUT_DEC
    
    ; 显示结果提示
    LEA DX, PROMPT4
    MOV AH, 09H
    INT 21H
    
    ; 输出16进制数
    MOV AX, DECNUM
    CALL OUTPUT_HEX
    
    JMP MAIN_LOOP

EXIT_PROG:
    MOV AH, 4CH
    INT 21H

; 输入16进制数子程序
INPUT_HEX PROC
    MOV HEXNUM, 0
    MOV BX, 0
    
INPUT_HEX_LOOP:
    MOV AH, 01H
    INT 21H
    
    CMP AL, 0DH         ; 回车结束
    JE INPUT_HEX_END
    
    ; 判断是否是数字0-9
    CMP AL, '0'
    JL INPUT_HEX_LOOP
    CMP AL, '9'
    JLE IS_DIGIT
    
    ; 判断是否是A-F
    CMP AL, 'A'
    JL CHECK_LOWER
    CMP AL, 'F'
    JLE IS_UPPER
    
CHECK_LOWER:
    ; 判断是否是a-f
    CMP AL, 'a'
    JL INPUT_HEX_LOOP
    CMP AL, 'f'
    JG INPUT_HEX_LOOP
    SUB AL, 20H         ; 转换为大写
    
IS_UPPER:
    SUB AL, 'A'
    ADD AL, 10
    JMP CONVERT_HEX
    
IS_DIGIT:
    SUB AL, '0'
    
CONVERT_HEX:
    MOV CL, AL
    MOV CH, 0
    MOV AX, HEXNUM
    MOV DX, 16
    MUL DX
    ADD AX, CX
    MOV HEXNUM, AX
    JMP INPUT_HEX_LOOP
    
INPUT_HEX_END:
    RET
INPUT_HEX ENDP

; 输出10进制数子程序
OUTPUT_DEC PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV CX, 0
    MOV BX, 10
    
DIVIDE_LOOP:
    MOV DX, 0
    DIV BX
    PUSH DX             ; 保存余数
    INC CX
    CMP AX, 0
    JNE DIVIDE_LOOP
    
PRINT_LOOP:
    POP DX
    ADD DL, '0'
    MOV AH, 02H
    INT 21H
    LOOP PRINT_LOOP
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET
OUTPUT_DEC ENDP

; 输入10进制数子程序
INPUT_DEC PROC
    MOV DECNUM, 0
    
INPUT_DEC_LOOP:
    MOV AH, 01H
    INT 21H
    
    CMP AL, 0DH         ; 回车结束
    JE INPUT_DEC_END
    
    ; 判断是否是数字0-9
    CMP AL, '0'
    JL INPUT_DEC_LOOP
    CMP AL, '9'
    JG INPUT_DEC_LOOP
    
    SUB AL, '0'
    MOV CL, AL
    MOV CH, 0
    MOV AX, DECNUM
    MOV BX, 10
    MUL BX
    ADD AX, CX
    MOV DECNUM, AX
    JMP INPUT_DEC_LOOP
    
INPUT_DEC_END:
    RET
INPUT_DEC ENDP

; 输出16进制数子程序
OUTPUT_HEX PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV CX, 0
    MOV BX, 16
    
DIVIDE_HEX_LOOP:
    MOV DX, 0
    DIV BX
    PUSH DX             ; 保存余数
    INC CX
    CMP AX, 0
    JNE DIVIDE_HEX_LOOP
    
PRINT_HEX_LOOP:
    POP DX
    CMP DL, 9
    JG IS_LETTER
    ADD DL, '0'
    JMP PRINT_CHAR
    
IS_LETTER:
    SUB DL, 10
    ADD DL, 'A'
    
PRINT_CHAR:
    MOV AH, 02H
    INT 21H
    LOOP PRINT_HEX_LOOP
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET
OUTPUT_HEX ENDP

CODE ENDS
    END START
