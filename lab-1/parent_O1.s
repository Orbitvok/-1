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
    leal    4(%esp), %ecx         ; Корректировка указателя стека для выравнивания
    .cfi_def_cfa 1, 0
    andl    $-16, %esp            ; Выравнивание стека по 16 байт
    pushl   -4(%ecx)              ; 
    pushl   %ebp                  ; Сохранение EBP
    .cfi_escape 0x10,0x5,0x2,0x75,0
    movl    %esp, %ebp            ; Установка EBP как текущего стекового фрейма
    pushl   %edi                  ; Сохранение регистров EDI, ESI, EBX, ECX
    pushl   %esi
    pushl   %ebx
    pushl   %ecx
    .cfi_escape 0xf,0x3,0x75,0x70,0x6
    .cfi_escape 0x10,0x7,0x2,0x75,0x7c
    .cfi_escape 0x10,0x6,0x2,0x75,0x78
    .cfi_escape 0x10,0x3,0x2,0x75,0x74
    subl    $536, %esp            ; Выделение 536 байт под локальные переменные
    call    ___main               ; Инициализация среды выполнения MinGW

    ; Запрос ввода числа n
    movl    $LC0, (%esp)          ; "Enter Fibonacci number to calculate: "
    call    _printf
    leal    -28(%ebp), %eax       ; Адрес переменной n (на стеке)
    movl    %eax, 4(%esp)         ; Второй аргумент scanf (адрес n)
    movl    $LC1, (%esp)          ; Формат "%d"
    call    _scanf                ; Считывание числа n

    ; Создание анонимного канала (pipe)
    movl    $12, -48(%ebp)        ; SECURITY_ATTRIBUTES.nLength = 12
    movl    $0, -44(%ebp)         ; SECURITY_ATTRIBUTES.lpSecurityDescriptor = NULL
    movl    $1, -40(%ebp)         ; SECURITY_ATTRIBUTES.bInheritHandle = TRUE
    movl    $0, 12(%esp)          ; lpSecurityAttributes = NULL
    leal    -48(%ebp), %eax       ; Указатель на SECURITY_ATTRIBUTES
    movl    %eax, 8(%esp)         ; 
    leal    -36(%ebp), %eax       ; Указатель на хендл чтения (hReadPipe)
    movl    %eax, 4(%esp)         ; 
    leal    -32(%ebp), %eax       ; Указатель на хендл записи (hWritePipe)
    movl    %eax, (%esp)          ; 
    call    _CreatePipe@16        ; Создание канала
    subl    $16, %esp             ; Очистка стека после вызова

    ; Инициализация структуры STARTUPINFO
    leal    -116(%ebp), %edi      ; Адрес STARTUPINFO
    movl    $17, %ecx             ; Количество повторений (68 байт / 4 = 17)
    movl    $0, %eax              ; Значение для заполнения (0)
    rep stosl                     ; Заполнение структуры нулями

    ; Формирование командной строки "child.exe <n>"
    movl    -28(%ebp), %eax       ; Загрузка n
    movl    %eax, 8(%esp)         ; Аргумент для sprintf
    movl    $LC2, 4(%esp)         ; Формат "child.exe %d"
    leal    -388(%ebp), %ebx      ; Буфер для командной строки
    movl    %ebx, (%esp)          ; 
    call    _sprintf              ; Генерация строки

    ; Настройка STARTUPINFO
    movl    $68, -116(%ebp)       ; STARTUPINFO.cb = sizeof(STARTUPINFO)
    movl    -36(%ebp), %eax       ; Хендл канала чтения
    movl    %eax, -56(%ebp)       ; STARTUPINFO.hStdOutput = hReadPipe
    movl    $256, -72(%ebp)       ; STARTUPINFO.dwFlags = STARTF_USESTDHANDLES

    ; Создание дочернего процесса
    leal    -132(%ebp), %eax      ; Указатель на PROCESS_INFORMATION
    movl    %eax, 36(%esp)        ; 
    leal    -116(%ebp), %eax      ; Указатель на STARTUPINFO
    movl    %eax, 32(%esp)        ; 
    movl    $0, 28(%esp)          ; lpCurrentDirectory = NULL
    movl    $0, 24(%esp)          ; lpEnvironment = NULL
    movl    $0, 20(%esp)          ; dwCreationFlags = 0
    movl    $1, 16(%esp)          ; bInheritHandles = TRUE
    movl    $0, 12(%esp)          ; lpThreadAttributes = NULL
    movl    $0, 8(%esp)           ; lpProcessAttributes = NULL
    movl    %ebx, 4(%esp)         ; Командная строка "child.exe <n>"
    movl    $0, (%esp)            ; lpApplicationName = NULL
    call    _CreateProcessA@40    ; Запуск процесса
    subl    $40, %esp             ; Очистка стека
    testl   %eax, %eax            ; Проверка успешности
    je      L8                     ; Если ошибка, переход к обработке

    ; Вычисление Fibonacci(n) в родительском процессе
    movl    -28(%ebp), %eax       ; Загрузка n
    movl    %eax, (%esp)          ; Аргумент для fibonacci
    call    _fibonacci            ; Вызов функции
    movl    %eax, 8(%esp)         ; Младшая часть результата
    movl    %edx, 12(%esp)        ; Старшая часть результата
    movl    -28(%ebp), %eax       ; n
    movl    %eax, 4(%esp)         ; 
    movl    $LC4, (%esp)          ; "[PARENT] Fibonacci(%d) = %llu\n"
    call    _printf               ; Вывод результата

    ; Закрытие хендла записи в канал
    movl    -36(%ebp), %eax       ; hWritePipe
    movl    %eax, (%esp)          ; 
    call    _CloseHandle@4        ; Закрытие хендла
    subl    $4, %esp              ; 

    ; Подготовка к чтению из канала
    leal    -492(%ebp), %esi      ; Указатель на переменную с количеством байт
    leal    -488(%ebp), %ebx      ; Буфер для данных
    jmp     L4                    ; Переход к циклу чтения

L8:
    ; Обработка ошибки создания процесса
    movl    $LC3, (%esp)          ; "Failed to create child process"
    call    _puts                 ; Вывод сообщения
    movl    $1, %eax              ; Код возврата 1 (ошибка)
    jmp     L1                    ; Переход к завершению

L6:
    ; Вывод данных из канала
    movl    %ebx, 8(%esp)         ; Буфер данных
    movl    %eax, 4(%esp)         ; Количество байт
    movl    $LC5, (%esp)          ; Формат "%.*s"
    call    _printf               ; Вывод прочитанных данных

L4:
    ; Чтение данных из канала
    movl    $0, 16(%esp)          ; lpOverlapped = NULL
    movl    %esi, 12(%esp)        ; Указатель на количество прочитанных байт
    movl    $100, 8(%esp)         ; Максимальное количество байт (100)
    movl    %ebx, 4(%esp)         ; Буфер данных
    movl    -32(%ebp), %eax       ; Хендл чтения (hReadPipe)
    movl    %eax, (%esp)          ; 
    call    _ReadFile@20          ; Чтение из канала
    subl    $20, %esp             ; 
    testl   %eax, %eax            ; Проверка успеха
    je      L5                    ; Если ошибка, завершить цикл
    movl    -492(%ebp), %eax      ; Количество прочитанных байт
    testl   %eax, %eax            ; Если байт > 0
    jne     L6                    ; Повторить вывод

L5:
    ; Закрытие хендлов
    movl    -32(%ebp), %eax       ; Хендл чтения
    movl    %eax, (%esp)          ; 
    call    _CloseHandle@4        ; 
    subl    $4, %esp              ; 
    movl    -132(%ebp), %eax      ; Хендл процесса
    movl    %eax, (%esp)          ; 
    call    _CloseHandle@4        ; 
    subl    $4, %esp              ; 
    movl    -128(%ebp), %eax      ; Хендл потока
    movl    %eax, (%esp)          ; 
    call    _CloseHandle@4        ; 
    subl    $4, %esp              ; 
    movl    $0, %eax              ; Код возврата 0 (успех)

L1:
    ; Эпилог
    leal    -16(%ebp), %esp       ; Восстановление стека
    popl    %ecx                  ; 
    .cfi_restore 1
    .cfi_def_cfa 1, 0
    popl    %ebx                  ; Восстановление регистров
    .cfi_restore 3
    popl    %esi                  ; 
    .cfi_restore 6
    popl    %edi                  ; 
    .cfi_restore 7
    popl    %ebp                  ; 
    .cfi_restore 5
    leal    -4(%ecx), %esp        ; 
    .cfi_def_cfa 4, 4
    ret                           ; Завершение программы
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
