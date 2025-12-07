	.file	"ascii.c"                  # 源文件名
	.text                             # 代码段
	.section	.text.startup,"x"       # startup 段，可执行
	.p2align 4                        # 对齐到16字节
	.globl	main                        # main为全局符号
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main                   # SEH(结构化异常处理)过程开始
main:
	pushq	%rsi                       # 保存调用者rsi寄存器
	.seh_pushreg	%rsi
	pushq	%rbx                       # 保存调用者rbx寄存器
	.seh_pushreg	%rbx
	subq	$40, %rsp                  # 在栈上分配40字节空间作为局部变量
	.seh_stackalloc	40
	.seh_endprologue                  # 栈帧建立完成

	movl	$109, %esi                 # a = 109 (初始值)
	call	__main                      # CRT初始化函数（MinGW运行时）

.L2:                                 # 外层循环入口
	leal	-13(%rsi), %ebx           # 内层循环初始值 j = a-13
	.p2align 4,,10
	.p2align 3

.L3:                                 # 内层循环开始
	addl	$1, %ebx                  # j++ 或 a++
	movsbl	%bl, %ecx                 # 将低8位字符扩展到ecx，用作putchar参数
	call	putchar                    # 输出字符 a
	cmpl	%esi, %ebx                # 比较 j 是否达到上限 (内层循环终止条件)
	jne	.L3                        # 若未达到，继续内层循环

	movl	$10, %ecx                 # ASCII 10 = 换行符
	call	putchar                    # 输出换行

	cmpl	$109, %esi                # 检查外层循环条件 (i是否满足)
	jne	.L4                        # 若不满足，跳出循环
	movl	$122, %esi                 # 外层循环更新 a 的值 (这里模拟C逻辑)
	jmp	.L2                        # 回到外层循环入口

	.p2align 4,,10
	.p2align 3

.L4:                                 # 外层循环结束
	xorl	%eax, %eax                # 返回值 0
	addq	$40, %rsp                  # 释放栈空间
	popq	%rbx                       # 恢复rbx
	popq	%rsi                       # 恢复rsi
	ret                               # 函数返回

	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (x86_64-posix-seh-rev0, Built by MinGW-Builds project) 15.2.0"
	.def	putchar;	.scl	2;	.type	32;	.endef
