.LC0:
        .string "%dx%d=%2d"         ; 格式串：打印 "ixj=结果"，结果占2位右对齐
.LC1:
        .string "  "                ; 两个空格，用于分隔每项

; main 函数入口
main:
        push    rbp                     ; 保存调用者栈基址
        mov     rbp, rsp                ; 建立当前栈帧
        sub     rsp, 16                 ; 分配 16 字节局部变量空间
                                        ; [rbp-4]  = i     (当前行，从9到1)
                                        ; [rbp-8]  = j     (当前列，从 10-i 到9)

        mov     DWORD PTR [rbp-4], 9    ; i = 9
        jmp     .L2                     ; 跳转到外层循环条件判断

; 外层循环：控制行 (.L6)
.L6:
        mov     eax, 10
        sub     eax, DWORD PTR [rbp-4]  ; eax = 10 - i
        mov     DWORD PTR [rbp-8], eax  ; j = 10 - i   ← 每行起始列号
        jmp     .L3                     ; 进入内层循环


; 内层循环：打印一行 (.L5)
.L5:
        ; 计算 i * j
        mov     eax, DWORD PTR [rbp-4]      ; eax = i
        imul    eax, DWORD PTR [rbp-8]      ; eax = i * j
        mov     ecx, eax                    ; ecx = i * j   (第3个参数)

        ; 准备 printf 参数
        mov     edx, DWORD PTR [rbp-8]      ; edx = j       (第2个参数)
        mov     eax, DWORD PTR [rbp-4]      ; eax = i
        mov     esi, eax                    ; esi = i       (第1个参数)
        mov     edi, OFFSET FLAT:.LC0       ; edi = "%dx%d=%2d"
        mov     eax, 0                      ; 清零 eax (无浮点参数)
        call    printf                      ; printf("%dx%d=%2d", i, j, i*j)

        ; 如果 j <= 8，打印两个空格分隔
        cmp     DWORD PTR [rbp-8], 8
        jg      .L4                         ; j > 8 → 跳过空格（最后一项）
        mov     edi, OFFSET FLAT:.LC1       ; edi = "  "
        mov     eax, 0
        call    printf                      ; printf("  ")

.L4:
        add     DWORD PTR [rbp-8], 1         ; j++

; 内层循环条件
.L3:
        cmp     DWORD PTR [rbp-8], 9         ; j <= 9 ?
        jle     .L5                         ; 是 → 继续打印

        ; 一行结束，打印换行
        mov     edi, 10                     ; '\n'
        call    putchar

        sub     DWORD PTR [rbp-4], 1         ; i--

; 外层循环条件
.L2:
        cmp     DWORD PTR [rbp-4], 0         ; i > 0 ?
        jg      .L6                         ; 是 → 继续下一行

        mov     eax, 0                      ; return 0
        leave                               ; 恢复栈帧
        ret                                 ; 返回