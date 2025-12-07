table:
        .base64 "BwIDBAUGBwgJ"
        .base64 "AgQHCAoMDhAS"
        .base64 "AwYJDA8SFRgb"
        .base64 "BAgMEAcYHCAk"
        .base64 "BQoPFBkeIygt"
        .base64 "BgwSGB4HKjA2"
        .base64 "Bw4VHCMqMTg/"
        .base64 "CBAYICgwOAdI"
        .base64 "CRIbJC02P0hR"
.LC0:
        .string "%d %d\n"
main:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     DWORD PTR [rbp-4], 1
        jmp     .L2
.L6:
        mov     DWORD PTR [rbp-8], 1
        jmp     .L3
.L5:
        mov     eax, DWORD PTR [rbp-4]
        imul    eax, DWORD PTR [rbp-8]
        mov     DWORD PTR [rbp-12], eax
        mov     eax, DWORD PTR [rbp-4]
        lea     edx, [rax-1]
        mov     eax, DWORD PTR [rbp-8]
        sub     eax, 1
        movsx   rcx, eax
        movsx   rdx, edx
        mov     rax, rdx
        sal     rax, 3
        add     rax, rdx
        add     rax, rcx
        add     rax, OFFSET FLAT:table
        movzx   eax, BYTE PTR [rax]
        movzx   eax, al
        mov     DWORD PTR [rbp-16], eax
        mov     eax, DWORD PTR [rbp-12]
        cmp     eax, DWORD PTR [rbp-16]
        je      .L4
        mov     edx, DWORD PTR [rbp-8]
        mov     eax, DWORD PTR [rbp-4]
        mov     esi, eax
        mov     edi, OFFSET FLAT:.LC0
        mov     eax, 0
        call    printf
.L4:
        add     DWORD PTR [rbp-8], 1
.L3:
        cmp     DWORD PTR [rbp-8], 9
        jle     .L5
        add     DWORD PTR [rbp-4], 1
.L2:
        cmp     DWORD PTR [rbp-4], 9
        jle     .L6
        mov     eax, 0
        leave
        ret