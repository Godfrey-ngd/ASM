.LC0:
        .string "%dx%d=%2d"
.LC1:
        .string "  "
main:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     DWORD PTR [rbp-4], 9
        jmp     .L2
.L6:
        mov     eax, 10
        sub     eax, DWORD PTR [rbp-4]
        mov     DWORD PTR [rbp-8], eax
        jmp     .L3
.L5:
        mov     eax, DWORD PTR [rbp-4]
        imul    eax, DWORD PTR [rbp-8]
        mov     ecx, eax
        mov     edx, DWORD PTR [rbp-8]
        mov     eax, DWORD PTR [rbp-4]
        mov     esi, eax
        mov     edi, OFFSET FLAT:.LC0
        mov     eax, 0
        call    printf
        cmp     DWORD PTR [rbp-8], 8
        jg      .L4
        mov     edi, OFFSET FLAT:.LC1
        mov     eax, 0
        call    printf
.L4:
        add     DWORD PTR [rbp-8], 1
.L3:
        cmp     DWORD PTR [rbp-8], 9
        jle     .L5
        mov     edi, 10
        call    putchar
        sub     DWORD PTR [rbp-4], 1
.L2:
        cmp     DWORD PTR [rbp-4], 0
        jg      .L6
        mov     eax, 0
        leave
        ret