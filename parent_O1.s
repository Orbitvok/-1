	.file	"parent.c"
	.def	___main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
	.align 4
LC0:
	.ascii "Enter Fibonacci number to calculate: \0"
LC1:
	.ascii "%d\0"
LC2:
	.ascii "child.exe %d\0"
	.align 4
LC3:
	.ascii "Failed to create child process\0"
	.align 4
LC4:
	.ascii "[PARENT] Fibonacci(%d) = %llu\12\0"
LC5:
	.ascii "%.*s\0"
	.text
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
LFB38:
	.cfi_startproc
	leal	4(%esp), %ecx
	.cfi_def_cfa 1, 0
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	.cfi_escape 0x10,0x5,0x2,0x75,0
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	pushl	%ecx
	.cfi_escape 0xf,0x3,0x75,0x70,0x6
	.cfi_escape 0x10,0x7,0x2,0x75,0x7c
	.cfi_escape 0x10,0x6,0x2,0x75,0x78
	.cfi_escape 0x10,0x3,0x2,0x75,0x74
	subl	$536, %esp
	call	___main
	movl	$LC0, (%esp)
	call	_printf
	leal	-28(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$LC1, (%esp)
	call	_scanf
	movl	$12, -48(%ebp)
	movl	$0, -44(%ebp)
	movl	$1, -40(%ebp)
	movl	$0, 12(%esp)
	leal	-48(%ebp), %eax
	movl	%eax, 8(%esp)
	leal	-36(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_CreatePipe@16
	subl	$16, %esp
	leal	-116(%ebp), %edi
	movl	$17, %ecx
	movl	$0, %eax
	rep stosl
	movl	-28(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$LC2, 4(%esp)
	leal	-388(%ebp), %ebx
	movl	%ebx, (%esp)
	call	_sprintf
	movl	$68, -116(%ebp)
	movl	-36(%ebp), %eax
	movl	%eax, -56(%ebp)
	movl	$256, -72(%ebp)
	leal	-132(%ebp), %eax
	movl	%eax, 36(%esp)
	leal	-116(%ebp), %eax
	movl	%eax, 32(%esp)
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	movl	$1, 16(%esp)
	movl	$0, 12(%esp)
	movl	$0, 8(%esp)
	movl	%ebx, 4(%esp)
	movl	$0, (%esp)
	call	_CreateProcessA@40
	subl	$40, %esp
	testl	%eax, %eax
	je	L8
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	_fibonacci
	movl	%eax, 8(%esp)
	movl	%edx, 12(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$LC4, (%esp)
	call	_printf
	movl	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	_CloseHandle@4
	subl	$4, %esp
	leal	-492(%ebp), %esi
	leal	-488(%ebp), %ebx
	jmp	L4
L8:
	movl	$LC3, (%esp)
	call	_puts
	movl	$1, %eax
	jmp	L1
L6:
	movl	%ebx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$LC5, (%esp)
	call	_printf
L4:
	movl	$0, 16(%esp)
	movl	%esi, 12(%esp)
	movl	$100, 8(%esp)
	movl	%ebx, 4(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_ReadFile@20
	subl	$20, %esp
	testl	%eax, %eax
	je	L5
	movl	-492(%ebp), %eax
	testl	%eax, %eax
	jne	L6
L5:
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_CloseHandle@4
	subl	$4, %esp
	movl	-132(%ebp), %eax
	movl	%eax, (%esp)
	call	_CloseHandle@4
	subl	$4, %esp
	movl	-128(%ebp), %eax
	movl	%eax, (%esp)
	call	_CloseHandle@4
	subl	$4, %esp
	movl	$0, %eax
L1:
	leal	-16(%ebp), %esp
	popl	%ecx
	.cfi_restore 1
	.cfi_def_cfa 1, 0
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	leal	-4(%ecx), %esp
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE38:
	.ident	"GCC: (MinGW.org GCC-6.3.0-1) 6.3.0"
	.def	_printf;	.scl	2;	.type	32;	.endef
	.def	_scanf;	.scl	2;	.type	32;	.endef
	.def	_CreatePipe@16;	.scl	2;	.type	32;	.endef
	.def	_sprintf;	.scl	2;	.type	32;	.endef
	.def	_CreateProcessA@40;	.scl	2;	.type	32;	.endef
	.def	_fibonacci;	.scl	2;	.type	32;	.endef
	.def	_CloseHandle@4;	.scl	2;	.type	32;	.endef
	.def	_puts;	.scl	2;	.type	32;	.endef
	.def	_ReadFile@20;	.scl	2;	.type	32;	.endef
