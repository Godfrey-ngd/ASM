table:
        .base64 "BwIDBAUGBwgJ"    ; 第1行: 1,2,3,4,5,6,7,8,9     (Base64 编码的字节)
        .base64 "AgQHCAoMDhAS"    ; 第2行: 2,4,7,8,10,12,14,16,18
        .base64 "AwYJDA8SFRgb"    ; 第3行: 3,6,9,12,15,18,21,24,27
        .base64 "BAgMEAcYHCAk"    ; 第4行: 4,8,12,16,7,24,28,32,36
        .base64 "BQoPFBkeIyAt"    ; 第5行: 5,10,15,20,25,30,35,40,45
        .base64 "BgwSGB4HKjA2"    ; 第6行: 6,12,18,24,30,7,42,48,54
        .base64 "Bw4VHCMqMTg/"    ; 第7行: 7,14,21,28,35,42,49,56,63
        .base64 "CBAYICgwOAdI"    ; 第8行: 8,16,24,32,40,48,56,7,72
        .base64 "CRIbJC02P0hR"    ; 第9行: 9,18,27,36,45,54,63,72,81

.LC0:
        .string "%d %d\n"         ; 格式化字符串：打印 "i j\n"

; main 函数入口
main:
        push    rbp                     ; 保存调用者栈基址
        mov     rbp, rsp                ; 设置当前栈帧
        sub     rsp, 16                 ; 分配 16 字节局部变量空间
                                        ; [rbp-4]  = i (行号，1~9)
                                        ; [rbp-8]  = j (列号，1~9)
                                        ; [rbp-12] = expected = i * j
                                        ; [rbp-16] = actual   = table[i-1][j-1]

        mov     DWORD PTR [rbp-4], 1    ; i = 1
        jmp     .L2                     ; 跳转到外层循环条件判断

; 外层循环开始 (.L6)
.L6:
        mov     DWORD PTR [rbp-8], 1    ; j = 1
        jmp     .L3                     ; 进入内层循环

; 内层循环 (.L5)
.L5:
        ; 计算预期值：expected = i * j
        mov     eax, DWORD PTR [rbp-4]      ; eax = i
        imul    eax, DWORD PTR [rbp-8]      ; eax = i * j
        mov     DWORD PTR [rbp-12], eax     ; expected = eax

        ; 计算 table[i-1][j-1] 的地址
        mov     eax, DWORD PTR [rbp-4]      ; eax = i
        lea     edx, [rax-1]                ; edx = i - 1 (行索引 0~8)
        mov     eax, DWORD PTR [rbp-8]      ; eax = j
        sub     eax, 1                      ; eax = j - 1 (列索引 0~8)

        ; 转换为 64 位索引
        movsx   rcx, eax                    ; rcx = j - 1 (64位)
        movsx   rdx, edx                    ; rdx = i - 1 (64位)

        ; 计算偏移：offset = (i-1)*9 + (j-1)
        mov     rax, rdx                    ; rax = i - 1
        sal     rax, 3                      ; rax = (i-1) * 8
        add     rax, rdx                    ; rax = (i-1) * 9
        add     rax, rcx                    ; rax = (i-1)*9 + (j-1)
        add     rax, OFFSET FLAT:table      ; rax = &table[i-1][j-1]

        ; 读取字节并扩展
        movzx   eax, BYTE PTR [rax]         ; eax = table[i-1][j-1] (零扩展)
        movzx   eax, al                     ; eax = al (低8位)
        mov     DWORD PTR [rbp-16], eax     ; actual = eax

        ; 比较：expected == actual ?
        mov     eax, DWORD PTR [rbp-12]     ; eax = expected
        cmp     eax, DWORD PTR [rbp-16]     ; 比较
        je      .L4                         ; 相等 → 跳过打印

        ; === 不相等：打印 "i j\n" ===
        mov     edx, DWORD PTR [rbp-8]      ; edx = j
        mov     eax, DWORD PTR [rbp-4]      ; eax = i
        mov     esi, eax                    ; esi = i (printf 第2个参数)
        mov     edi, OFFSET FLAT:.LC0        ; edi = "%d %d\n"
        mov     eax, 0                      ; 清零 eax (无浮点参数)
        call    printf                      ; printf("%d %d\n", i, j)

.L4:
        add     DWORD PTR [rbp-8], 1         ; j++

; 内层循环条件
.L3:
        cmp     DWORD PTR [rbp-8], 9         ; j <= 9 ?
        jle     .L5                         ; 是 → 继续内层

        add     DWORD PTR [rbp-4], 1         ; i++

; 外层循环条件
.L2:
        cmp     DWORD PTR [rbp-4], 9         ; i <= 9 ?
        jle     .L6                         ; 是 → 继续外层

        mov     eax, 0                      ; return 0
        leave                               ; 恢复栈帧
        ret                                 ; 返回