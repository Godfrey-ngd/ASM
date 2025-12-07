.LC0:
        .string "%d"                   # 格式字符串，用于 scanf 和 printf

main:
        push    rbp                     # 保存旧的栈基址
        mov     rbp, rsp                # 设置新的栈基址
        sub     rsp, 16                 # 为局部变量分配16字节栈空间

        mov     DWORD PTR [rbp-4], 0   # sum = 0，将栈上偏移 -4 的位置初始化为 0

        lea     rax, [rbp-12]           # 取 n 的地址
        mov     rsi, rax                # scanf 第二个参数，地址传给 rsi
        mov     edi, OFFSET FLAT:.LC0   # scanf 第一个参数，格式字符串 "%d"
        mov     eax, 0
        call    __isoc99_scanf           # 调用 scanf("%d", &n)

        mov     DWORD PTR [rbp-8], 1    # i = 1，循环计数器初始化
        jmp     .L2                      # 跳转到循环判断

.L3:
        mov     eax, DWORD PTR [rbp-8]  # eax = i
        add     DWORD PTR [rbp-4], eax  # sum += i
        add     DWORD PTR [rbp-8], 1    # i++

.L2:
        mov     eax, DWORD PTR [rbp-12] # eax = n
        cmp     DWORD PTR [rbp-8], eax  # 比较 i 和 n
        jle     .L3                      # i <= n 则继续循环

        mov     eax, DWORD PTR [rbp-4]  # eax = sum
        mov     esi, eax                # printf 参数 sum
        mov     edi, OFFSET FLAT:.LC0  # printf 格式字符串 "%d"
        mov     eax, 0
        call     printf                 # printf("%d", sum)

        mov     eax, 0                  # 函数返回值 0
        leave                           # 恢复栈基址（等于 mov rsp, rbp / pop rbp）
        ret                             # 返回
