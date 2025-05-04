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
LFB25:
    .cfi_startproc
    leal    4(%esp), %ecx         ; Корректировка указателя стека для выравнивания
    .cfi_def_cfa 1, 0
    andl    $-16, %esp           ; Выравнивание стека по 16 байт
    pushl   -4(%ecx)             ; 
    pushl   %ebp                 ; Сохраняем EBP
    .cfi_escape 0x10,0x5,0x2,0x75,0
    movl    %esp, %ebp           ; Устанавливаем EBP как текущий стековый фрейм
    pushl   %edi                 ; Сохраняем регистры EDI, ECX
    pushl   %ecx
    .cfi_escape 0xf,0x3,0x75,0x78,0x6
    .cfi_escape 0x10,0x7,0x2,0x75,0x7c
    subl    $528, %esp           ; Выделяем 528 байт под локальные переменные
    call    ___main              ; Инициализация среды выполнения

    ; Вывод приглашения для ввода
    movl    $LC0, (%esp)         ; "Enter Fibonacci number to calculate: "
    call    _printf

    ; Считывание числа через scanf
    leal    -20(%ebp), %eax      ; Адрес переменной для ввода (n)
    movl    %eax, 4(%esp)        ; Второй аргумент scanf (адрес n)
    movl    $LC1, (%esp)         ; Первый аргумент scanf ("%d")
    call    _scanf

    ; Создание анонимного канала (pipe)
    movl    $12, -40(%ebp)       ; Размер структуры SECURITY_ATTRIBUTES = 12
    movl    $0, -36(%ebp)        ; inheritHandle = FALSE
    movl    $1, -32(%ebp)        ; bInheritHandle = TRUE
    movl    $0, 12(%esp)         ; lpSecurityAttributes = NULL
    leal    -40(%ebp), %eax      ; Указатель на структуру SECURITY_ATTRIBUTES
    movl    %eax, 8(%esp)        ; 
    leal    -28(%ebp), %eax      ; Указатель на хендл чтения
    movl    %eax, 4(%esp)        ; 
    leal    -24(%ebp), %eax      ; Указатель на хендл записи
    movl    %eax, (%esp)         ; 
    call    _CreatePipe@16       ; Создание канала
    subl    $16, %esp            ; Очистка стека после вызова

    ; Подготовка структуры STARTUPINFO
    leal    -108(%ebp), %edx     ; Адрес структуры STARTUPINFO
    movl    $0, %eax             ; Обнуление
    movl    $17, %ecx            ; Размер структуры (68 байт / 4 = 17)
    movl    %edx, %edi           ; Назначение (EDI)
    rep stosl                    ; Заполнение нулями

    ; Формирование командной строки для дочернего процесса
    movl    -20(%ebp), %eax      ; Загружаем n
    movl    %eax, 8(%esp)        ; Аргумент для sprintf
    movl    $LC2, 4(%esp)        ; Форматная строка "child.exe %d"
    leal    -380(%ebp), %eax     ; Буфер для командной строки
    movl    %eax, (%esp)         ; 
    call    _sprintf             ; Формируем строку "child.exe <n>"

    ; Настройка структуры STARTUPINFO
    movl    $68, -108(%ebp)      ; cb = sizeof(STARTUPINFO)
    movl    -28(%ebp), %eax      ; Хендл канала для чтения
    movl    %eax, -48(%ebp)      ; STARTUPINFO.hStdOutput = канал
    movl    $256, -64(%ebp)      ; dwFlags = STARTF_USESTDHANDLES

    ; Создание дочернего процесса
    leal    -124(%ebp), %eax     ; Указатель на PROCESS_INFORMATION
    movl    %eax, 36(%esp)       ; 
    leal    -108(%ebp), %eax     ; Указатель на STARTUPINFO
    movl    %eax, 32(%esp)       ; 
    movl    $0, 28(%esp)         ; lpCurrentDirectory = NULL
    movl    $0, 24(%esp)         ; lpEnvironment = NULL
    movl    $0, 20(%esp)         ; dwCreationFlags = 0
    movl    $1, 16(%esp)         ; bInheritHandles = TRUE
    movl    $0, 12(%esp)         ; lpThreadAttributes = NULL
    movl    $0, 8(%esp)          ; lpProcessAttributes = NULL
    leal    -380(%ebp), %eax     ; Командная строка
    movl    %eax, 4(%esp)        ; 
    movl    $0, (%esp)           ; lpApplicationName = NULL
    call    _CreateProcessA@40   ; Создание процесса
    subl    $40, %esp            ; Очистка стека
    testl   %eax, %eax           ; Проверка успешности
    jne     L2                   ; Если успешно, переход к L2

    ; Обработка ошибки создания процесса
    movl    $LC3, (%esp)         ; "Failed to create child process"
    call    _puts
    movl    $1, %eax             ; Возвращаем код ошибки
    jmp     L7                   ; Переход к завершению

L2:
    ; Вычисление числа Фибоначчи в родительском процессе
    movl    -20(%ebp), %eax      ; Загрузка n
    movl    %eax, (%esp)         ; Аргумент для fibonacci
    call    _fibonacci           ; Вызов функции
    movl    %eax, -16(%ebp)      ; Сохранение младшей части результата
    movl    %edx, -12(%ebp)      ; Сохранение старшей части

    ; Вывод результата
    movl    -20(%ebp), %ecx      ; n
    movl    -16(%ebp), %eax      ; fibonacci(n) (мл.)
    movl    -12(%ebp), %edx      ; fibonacci(n) (ст.)
    movl    %eax, 8(%esp)        ; 
    movl    %edx, 12(%esp)       ; 
    movl    %ecx, 4(%esp)        ; 
    movl    $LC4, (%esp)         ; "[PARENT] Fibonacci(%d) = %llu\n"
    call    _printf

    ; Закрытие ненужного хендла записи
    movl    -28(%ebp), %eax      ; Хендл канала записи
    movl    %eax, (%esp)         ; 
    call    _CloseHandle@4       ; Закрытие
    subl    $4, %esp             ; 

L4:
    ; Чтение данных из канала
    movl    -24(%ebp), %eax      ; Хендл канала чтения
    movl    $0, 16(%esp)         ; lpOverlapped = NULL
    leal    -484(%ebp), %edx     ; Указатель на количество прочитанных байт
    movl    %edx, 12(%esp)       ; 
    movl    $100, 8(%esp)        ; Максимальное количество байт (100)
    leal    -480(%ebp), %edx     ; Буфер для данных
    movl    %edx, 4(%esp)        ; 
    movl    %eax, (%esp)         ; 
    call    _ReadFile@20         ; Чтение
    subl    $20, %esp            ; 
    testl   %eax, %eax           ; Проверка успеха
    je      L5                   ; Если ошибка, переход к L5

    ; Вывод прочитанных данных
    movl    -484(%ebp), %eax     ; Количество прочитанных байт
    testl   %eax, %eax           ; Если байт > 0
    jne     L6                   ; Повтор чтения

L5:
    ; Закрытие хендлов
    movl    -24(%ebp), %eax      ; Хендл канала чтения
    movl    %eax, (%esp)         ; 
    call    _CloseHandle@4       ; 
    subl    $4, %esp             ; 
    movl    -124(%ebp), %eax     ; Хендл процесса
    movl    %eax, (%esp)         ; 
    call    _CloseHandle@4       ; 
    subl    $4, %esp             ; 
    movl    -120(%ebp), %eax     ; Хендл потока
    movl    %eax, (%esp)         ; 
    call    _CloseHandle@4       ; 
    subl    $4, %esp             ; 
    movl    $0, %eax             ; Возвращаем 0 (успех)

L7:
    ; Эпилог
    leal    -8(%ebp), %esp       ; Восстановление стека
    popl    %ecx                 ; 
    .cfi_restore 1
    .cfi_def_cfa 1, 0
    popl    %edi                 ; 
    .cfi_restore 7
    popl    %ebp                 ; 
    .cfi_restore 5
    leal    -4(%ecx), %esp       ; 
    .cfi_def_cfa 4, 4
    ret                          ; Возврат из программы
    .cfi_endproc
LFE25:
    .ident	"GCC: (MinGW.org GCC-6.3.0-1) 6.3.0"
    .def	_printf;	.scl	2;	.type	32;	.endef
    .def	_scanf;	.scl	2;	.type	32;	.endef
    .def	_CreatePipe@16;	.scl	2;	.type	32;	.endef
    .def	_sprintf;	.scl	2;	.type	32;	.endef
    .def	_CreateProcessA@40;	.scl	2;	.type	32;	.endef
    .def	_puts;	.scl	2;	.type	32;	.endef
    .def	_fibonacci;	.scl	2;	.type	32;	.endef
    .def	_CloseHandle@4;	.scl	2;	.type	32;	.endef
    .def	_ReadFile@20;	.scl	2;	.type	32;	.endef
