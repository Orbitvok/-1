	.file	"child.c"
	.def	___main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
LC0:
	.ascii "Usage: child.exe <number>\0"
LC1:
	.ascii "[CHILD] Fibonacci(%d) = %llu\12\0"
	.text
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
LFB38:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	andl	$-16, %esp
	subl	$16, %esp
	.cfi_offset 3, -12
	call	___main
	cmpl	$1, 8(%ebp)
	jle	L5
	movl	12(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, (%esp)
	call	_atoi
	leal	-1(%eax), %ebx
	movl	%ebx, (%esp)
	call	_fibonacci
	movl	%eax, 8(%esp)
	movl	%edx, 12(%esp)
	movl	%ebx, 4(%esp)
	movl	$LC1, (%esp)
	call	_printf
	movl	$0, %eax
L1:
	movl	-4(%ebp), %ebx
	leave
	.cfi_remember_state
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
L5:
	.cfi_restore_state
	movl	$LC0, (%esp)
	call	_puts
	movl	$1, %eax
	jmp	L1
	.cfi_endproc
LFE38:
	.ident	"GCC: (MinGW.org GCC-6.3.0-1) 6.3.0"
	.def	_atoi;	.scl	2;	.type	32;	.endef
	.def	_fibonacci;	.scl	2;	.type	32;	.endef
	.def	_printf;	.scl	2;	.type	32;	.endef
	.def	_puts;	.scl	2;	.type	32;	.endef
