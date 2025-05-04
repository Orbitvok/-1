    .file "child.c"               ; Указывает исходный файл
    .def ___main; .scl 2; .type 32; .endef  ; Объявляет символ ___main
    .section .rdata,"dr"          ; Начинает секцию read-only данных
LC0:
    .ascii "Usage: child.exe <number>\0"  ; Строка ошибки
LC1:
    .ascii "[CHILD] Fibonacci(%d) = %llu\12\0"  ; Строка формата вывода
    .text                        ; Начинает секцию кода
    .globl _main                 ; Делает _main видимой извне
    .def _main; .scl 2; .type 32; .endef
_main:
LFB38:
    .cfi_startproc           ; Начало процедуры
    pushl %ebp               ; Сохраняем предыдущий указатель базы
    .cfi_def_cfa_offset 8
    .cfi_offset 5, -8
    movl %esp, %ebp          ; Устанавливаем новый указатель базы
    .cfi_def_cfa_register 5
    pushl %ebx               ; Сохраняем регистр EBX
    andl $-16, %esp          ; Выравниваем стек по 16 байт
    subl $16, %esp           ; Выделяем 16 байт на стеке
    .cfi_offset 3, -12       ; Информация для отладки
    call ___main             ; Вызов инициализации GCC
    cmpl $1, 8(%ebp)         ; Сравниваем argc с 1
    jle L5                   ; Если argc <= 1, переходим к L5 (ошибка)
    movl 12(%ebp), %eax      ; Загружаем argv
    movl 4(%eax), %eax       ; Получаем argv[1]
    movl %eax, (%esp)        ; Подготавливаем аргумент для atoi
    call _atoi              ; Преобразуем строку в число
    leal -1(%eax), %ebx     ; Вычисляем n-1 и сохраняем в EBX
    movl %ebx, (%esp)       ; Подготавливаем аргумент для fibonacci
    call _fibonacci        ; Вызываем функцию
    movl %eax, 8(%esp)      ; Младшие 32 бита результата
    movl %edx, 12(%esp)     ; Старшие 32 бита результата (64-битное число)
    movl %ebx, 4(%esp)      ; Значение n-1 для вывода
    movl $LC1, (%esp)       ; Строка формата
    call _printf           ; Выводим результат
    movl $0, %eax          ; Возвращаем 0 (успех)
L1:
    movl -4(%ebp), %ebx    ; Восстанавливаем EBX
    leave                  ; Восстанавливаем ESP/EBP
    .cfi_remember_state
    .cfi_restore 5
    .cfi_restore 3
    .cfi_def_cfa 4, 4
    ret                    ; Возврат из функции
L5:
    movl $LC0, (%esp)       ; Загружаем строку ошибки
    call _puts             ; Выводим сообщение
    movl $1, %eax          ; Возвращаем 1 (ошибка)
    movl	$1, %eax
    jmp	L1
    .cfi_endproc
LFE38:
    .ident	"GCC: (MinGW.org GCC-6.3.0-1) 6.3.0"
    .def	_atoi;	.scl	2;	.type	32;	.endef
    .def	_fibonacci;	.scl	2;	.type	32;	.endef
    .def	_printf;	.scl	2;	.type	32;	.endef
    .def	_puts;	.scl	2;	.type	32;	.endef
