#include <stdio.h>
#include <windows.h>
#include "functions.h"

int main() {
    int n;
    printf("Enter Fibonacci number to calculate: ");
    scanf("%d", &n);

    // Создаем pipe
    HANDLE hReadPipe, hWritePipe;
    SECURITY_ATTRIBUTES sa = { sizeof(SECURITY_ATTRIBUTES), NULL, TRUE };
    CreatePipe(&hReadPipe, &hWritePipe, &sa, 0);

    // Настраиваем дочерний процесс
    STARTUPINFO si = { 0 };
    PROCESS_INFORMATION pi;
    char cmdline[256];
    sprintf(cmdline, "child.exe %d", n);
    
    si.cb = sizeof(STARTUPINFO);
    si.hStdOutput = hWritePipe;
    si.dwFlags = STARTF_USESTDHANDLES;

    // Запускаем дочерний процесс
    if (!CreateProcess(NULL, cmdline, NULL, NULL, TRUE, 0, NULL, NULL, &si, &pi)) {
        printf("Failed to create child process\n");
        return 1;
    }

    // Родитель тоже вычисляет число Фибоначчи
    unsigned long long parent_result = fibonacci(n);
    printf("[PARENT] Fibonacci(%d) = %llu\n", n, parent_result);

    CloseHandle(hWritePipe);

    // Читаем вывод дочернего процесса
    char buffer[100];
    DWORD bytesRead;
    while (ReadFile(hReadPipe, buffer, sizeof(buffer), &bytesRead, NULL) && bytesRead != 0) {
        printf("%.*s", (int)bytesRead, buffer);
    }

    CloseHandle(hReadPipe);
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
    
    return 0;
}