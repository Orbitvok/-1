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
LFB25:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	andl	$-16, %esp
	subl	$32, %esp
	call	___main
	cmpl	$1, 8(%ebp)
	jg	L2
	movl	$LC0, (%esp)
	call	_puts
	movl	$1, %eax
	jmp	L3
L2:
	movl	12(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	_atoi
	movl	%eax, 28(%esp)
	movl	28(%esp), %eax
	subl	$1, %eax
	movl	%eax, (%esp)
	call	_fibonacci
	movl	%eax, 16(%esp)
	movl	%edx, 20(%esp)
	movl	28(%esp), %eax
	leal	-1(%eax), %ecx
	movl	16(%esp), %eax
	movl	20(%esp), %edx
	movl	%eax, 8(%esp)
	movl	%edx, 12(%esp)
	movl	%ecx, 4(%esp)
	movl	$LC1, (%esp)
	call	_printf
	movl	$0, %eax
L3:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE25:
	.ident	"GCC: (MinGW.org GCC-6.3.0-1) 6.3.0"
	.def	_puts;	.scl	2;	.type	32;	.endef
	.def	_atoi;	.scl	2;	.type	32;	.endef
	.def	_fibonacci;	.scl	2;	.type	32;	.endef
	.def	_printf;	.scl	2;	.type	32;	.endef
