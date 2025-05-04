	.file	"functions.c"
	.text
	.globl	_fibonacci
	.def	_fibonacci;	.scl	2;	.type	32;	.endef
_fibonacci:
LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$36, %esp
	.cfi_offset 3, -12
	cmpl	$1, 8(%ebp)
	jg	L2
	movl	8(%ebp), %eax
	cltd
	jmp	L3
L2:
	movl	$0, -16(%ebp)
	movl	$0, -12(%ebp)
	movl	$1, -24(%ebp)
	movl	$0, -20(%ebp)
	movl	$2, -28(%ebp)
	jmp	L4
L5:
	movl	-16(%ebp), %ecx
	movl	-12(%ebp), %ebx
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	addl	%ecx, %eax
	adcl	%ebx, %edx
	movl	%eax, -40(%ebp)
	movl	%edx, -36(%ebp)
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	movl	%eax, -16(%ebp)
	movl	%edx, -12(%ebp)
	movl	-40(%ebp), %eax
	movl	-36(%ebp), %edx
	movl	%eax, -24(%ebp)
	movl	%edx, -20(%ebp)
	addl	$1, -28(%ebp)
L4:
	movl	-28(%ebp), %eax
	cmpl	8(%ebp), %eax
	jle	L5
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
L3:
	addl	$36, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE0:
	.ident	"GCC: (MinGW.org GCC-6.3.0-1) 6.3.0"
