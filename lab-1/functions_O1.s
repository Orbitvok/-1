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
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$12, %esp
	.cfi_def_cfa_offset 32
	movl	32(%esp), %esi
	movl	%esi, %eax
	cltd
	cmpl	$1, %esi
	jle	L1
	movl	$2, %edi
	movl	$1, %ecx
	movl	$0, %ebx
	movl	$0, (%esp)
	movl	$0, 4(%esp)
	movl	%edi, %ebp
L2:
	movl	(%esp), %eax
	movl	4(%esp), %edx
	addl	%ecx, %eax
	adcl	%ebx, %edx
	addl	$1, %ebp
	movl	%ecx, (%esp)
	movl	%ebx, 4(%esp)
	movl	%eax, %ecx
	movl	%edx, %ebx
	cmpl	%ebp, %esi
	jge	L2
L1:
	addl	$12, %esp
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
LFE0:
	.ident	"GCC: (MinGW.org GCC-6.3.0-1) 6.3.0"
