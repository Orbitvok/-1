	.file	"child.c"               ; Исходный файл
	.def	___main; .scl	2; .type	32; .endef  ; Объявление ___main
	.section .rdata,"dr"           ; Секция read-only данных
LC0:
	.ascii "Usage: child.exe <number>\0"  ; Строка для сообщения об ошибке
LC1:
	.ascii "[CHILD] Fibonacci(%d) = %llu\12\0"  ; Строка формата вывода
	.text
	.globl	_main
	.def	_main; .scl	2; .type	32; .endef
_main:
LFB25:
	.cfi_startproc
	pushl	%ebp               ; Сохраняем предыдущий базовый указатель
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp         ; Устанавливаем новый базовый указатель
	.cfi_def_cfa_register 5
	andl	$-16, %esp         ; Выравнивание стека (16 байт)
	subl	$32, %esp          ; Выделяем 32 байта на стеке
	call	___main            ; Инициализация GCC
	cmpl	$1, 8(%ebp)        ; Сравниваем argc с 1
	jg	L2                  ; Если argc > 1, переходим к L2
	movl	$LC0, (%esp)        ; Иначе загружаем строку ошибки
	call	_puts              ; Выводим сообщение об ошибке
	movl	$1, %eax           ; Возвращаем код ошибки 1
	jmp	L3                  ; Переход к завершению
L2:
	movl	12(%ebp), %eax      ; Загружаем argv
	addl	$4, %eax            ; Получаем argv[1]
	movl	(%eax), %eax        ; Загружаем значение argv[1]
	movl	%eax, (%esp)        ; Подготавливаем аргумент для atoi
	call	_atoi              ; Преобразуем строку в число
	movl	%eax, 28(%esp)      ; Сохраняем n в стеке
	movl	28(%esp), %eax      ; Загружаем n
	subl	$1, %eax            ; Вычисляем n-1
	movl	%eax, (%esp)        ; Подготавливаем аргумент для fibonacci
	call	_fibonacci         ; Вызываем функцию
	movl	%eax, 16(%esp)      ; Сохраняем младшие 32 бита результата
	movl	%edx, 20(%esp)      ; Сохраняем старшие 32 бита результата (для 64-bit)
	movl	28(%esp), %eax      ; Загружаем n
	leal	-1(%eax), %ecx      ; Вычисляем n-1 для вывода
	movl	16(%esp), %eax      ; Загружаем младшие биты результата
	movl	20(%esp), %edx      ; Загружаем старшие биты результата
	movl	%eax, 8(%esp)       ; Устанавливаем 3-й аргумент printf (младшие биты)
	movl	%edx, 12(%esp)      ; Устанавливаем 4-й аргумент printf (старшие биты)
	movl	%ecx, 4(%esp)       ; Устанавливаем 2-й аргумент printf (n-1)
	movl	$LC1, (%esp)        ; Устанавливаем 1-й аргумент printf (строка формата)
	call	_printf            ; Выводим результат
	movl	$0, %eax           ; Возвращаем 0 (успешное завершение)
L3:
	leave                    ; Восстанавливаем стек
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret                      ; Возврат из функции
	.cfi_endproc
LFE25:
	.ident	"GCC: (MinGW.org GCC-6.3.0-1) 6.3.0"
	.def	_puts;	.scl	2;	.type	32;	.endef
	.def	_atoi;	.scl	2;	.type	32;	.endef
	.def	_fibonacci;	.scl	2;	.type	32;	.endef
	.def	_printf;	.scl	2;	.type	32;	.endef
