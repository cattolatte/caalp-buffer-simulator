#include <stdio.h>
#include <string.h>

void secret_function() {
    printf("\n[+] BOOM! Buffer overflow successful. You hijacked the execution flow!\n");
}

void process_input(char *user_input) {
    int auth_flag = 0;
    char buffer[16]; // Small 16-byte buffer

    // Vulnerability: strcpy doesn't check if user_input is larger than 16 bytes
    strcpy(buffer, user_input); 

    if (auth_flag != 0) {
        printf("\n[!] Memory overwritten! auth_flag changed from 0 to %d\n", auth_flag);
        secret_function();
    } else {
        printf("\n[-] Normal execution. Buffer contains: %s\n", buffer);
    }
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <input_string>\n", argv[0]);
        return 1;
    }
    process_input(argv[1]);
    return 0;
}