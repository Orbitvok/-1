	.file	"functions.c"
	.text
	.globl	_fibonacci
	.def	_fibonacci;	.scl	2;	.type	32;	.endef
_fibonacci:
LFB0:
    .cfi_startproc
    pushl   %ebp                   ; Сохраняем регистры
    .cfi_def_cfa_offset 8
    .cfi_offset 5, -8
    pushl   %edi                   ; 
    .cfi_def_cfa_offset 12
    .cfi_offset 7, -12
    pushl   %esi                   ; 
    .cfi_def_cfa_offset 16
    .cfi_offset 6, -16
    pushl   %ebx                   ; 
    .cfi_def_cfa_offset 20
    .cfi_offset 3, -20
    subl    $12, %esp              ; Выделяем 12 байт под локальные переменные
    .cfi_def_cfa_offset 32
    movl    32(%esp), %esi         ; Загружаем аргумент n в ESI
    movl    %esi, %eax             ; Копируем n в EAX (для возврата при n ≤ 1)
    cltd                           ; Расширяем EAX в EDX:EAX (64-бит)
    cmpl    $1, %esi               ; Сравниваем n с 1
    jle     L1                     ; Если n ≤ 1, переход к завершению
    ; Инициализация переменных (n > 1)
    movl    $2, %edi               ; Инициализация счетчика i = 2
    movl    $1, %ecx               ; Младшая часть current = 1
    movl    $0, %ebx               ; Старшая часть current = 0 (current = 1)
    movl    $0, (%esp)             ; Младшая часть prev = 0 (в стек)
    movl    $0, 4(%esp)            ; Старшая часть prev = 0 (prev = 0)
    movl    %edi, %ebp             ; Копируем i в EBP
L2:
    ; Вычисление next = prev + current 
    movl    (%esp), %eax           ; Загрузка prev (мл.) в EAX
    movl    4(%esp), %edx          ; Загрузка prev (ст.) в EDX
    addl    %ecx, %eax             ; Сложение мл. частей: EAX += ECX
    adcl    %ebx, %edx             ; Сложение ст. частей: EDX += EBX (с переносом)
    addl    $1, %ebp               ; i += 1
    ; Обновление prev = current
    movl    %ecx, (%esp)           ; Сохраняем current (мл.) в prev (мл.)
    movl    %ebx, 4(%esp)          ; Сохраняем current (ст.) в prev (ст.)
    ; Обновление current = next 
    movl    %eax, %ecx             ; ECX = мл. часть next
    movl    %edx, %ebx             ; EBX = ст. часть next
    cmpl    %ebp, %esi             ; Сравниваем i (EBP) с n (ESI)
    jge     L2                     ; Если i ≤ n, продолжаем цикл
L1:
    addl    $12, %esp              ; Восстанавливаем стек
    .cfi_def_cfa_offset 20
    popl    %ebx                   ; Восстанавливаем регистры
    .cfi_restore 3
    .cfi_def_cfa_offset 16
    popl    %esi                   ; 
    .cfi_restore 6
    .cfi_def_cfa_offset 12
    popl    %edi                   ; 
    .cfi_restore 7
    .cfi_def_cfa_offset 8
    popl    %ebp                   ; 
    .cfi_restore 5
    .cfi_def_cfa_offset 4
    ret                            ; Возврат результата
    .cfi_endproc
LFE0:
	.ident	"GCC: (MinGW.org GCC-6.3.0-1) 6.3.0"
