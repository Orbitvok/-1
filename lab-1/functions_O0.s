    .file	"functions.c"
    .text
    .globl	_fibonacci
    .def	_fibonacci;	.scl	2;	.type	32;	.endef
_fibonacci:
LFB0:
    .cfi_startproc
    pushl   %ebp                   ; Сохраняем предыдущий базовый указатель
    .cfi_def_cfa_offset 8
    .cfi_offset 5, -8
    movl    %esp, %ebp             ; Устанавливаем текущий стек как базовый
    .cfi_def_cfa_register 5
    pushl   %ebx                   ; Сохраняем регистр EBX
    subl    $36, %esp              ; Выделяем 36 байт под локальные переменные
    .cfi_offset 3, -12
    cmpl    $1, 8(%ebp)            ; Сравниваем аргумент n с 1
    jg      L2                     ; Если n > 1, переход к L2 (цикл)
    movl    8(%ebp), %eax          ; Загрузка n в EAX (возврат n для n ≤ 1)
    cltd                           ; Расширение EAX в EDX:EAX (для 64-бит)
    jmp     L3                     ; Переход к эпилогу
L2:
    movl    $0, -16(%ebp)          ; Инициализация младшей части prev = 0
    movl    $0, -12(%ebp)          ; Старшая часть prev = 0 (prev = 0)
    movl    $1, -24(%ebp)          ; Младшая часть current = 1
    movl    $0, -20(%ebp)          ; Старшая часть current = 0 (current = 1)
    movl    $2, -28(%ebp)          ; Инициализация счетчика i = 2
jmp L4
L5:
    ; Сложение prev и current (64-бит):
    movl    -16(%ebp), %ecx        ; ECX = младшая часть prev
    movl    -12(%ebp), %ebx        ; EBX = старшая часть prev
    movl    -24(%ebp), %eax        ; EAX = младшая часть current
    movl    -20(%ebp), %edx        ; EDX = старшая часть current
    addl    %ecx, %eax             ; Складываем младшие части (EAX = ECX + EAX)
    adcl    %ebx, %edx             ; Складываем старшие части с учетом переноса
    movl    %eax, -40(%ebp)        ; Сохраняем сумму (младшая часть)
    movl    %edx, -36(%ebp)        ; Сохраняем сумму (старшая часть)
    ; Обновление prev = current:
    movl    -24(%ebp), %eax        ; EAX = младшая часть current
    movl    -20(%ebp), %edx        ; EDX = старшая часть current
    movl    %eax, -16(%ebp)        ; prev (мл.) = current (мл.)
    movl    %edx, -12(%ebp)        ; prev (ст.) = current (ст.)
    ; Обновление current = сумма:
    movl    -40(%ebp), %eax        ; EAX = сумма (мл.)
    movl    -36(%ebp), %edx        ; EDX = сумма (ст.)
    movl    %eax, -24(%ebp)        ; current (мл.) = сумма (мл.)
    movl    %edx, -20(%ebp)        ; current (ст.) = сумма (ст.)
    addl    $1, -28(%ebp)          ; i += 1
L4:
    movl    -28(%ebp), %eax        ; EAX = i
    cmpl    8(%ebp), %eax          ; Сравниваем i и n
    jle     L5                     ; Если i ≤ n, продолжаем цикл
    ; Возврат current (64-бит):
    movl    -24(%ebp), %eax        ; EAX = младшая часть current
    movl    -20(%ebp), %edx        ; EDX = старшая часть current
L3:
    addl    $36, %esp              ; Восстанавливаем стек
    popl    %ebx                   ; Восстанавливаем EBX
    .cfi_restore 3
    popl    %ebp                   ; Восстанавливаем EBP
    .cfi_def_cfa 4, 4
    ret                            ; Возврат из функции
    .cfi_endproc
LFE0:
    .ident	"GCC: (MinGW.org GCC-6.3.0-1) 6.3.0"
