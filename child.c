#include <stdio.h>
#include <windows.h>
#include "functions.h"

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Usage: child.exe <number>\n");
        return 1;
    }

    int n = atoi(argv[1]);
    unsigned long long result = fibonacci(n - 1);
    
    printf("[CHILD] Fibonacci(%d) = %llu\n", n - 1, result);
    
    return 0;
}