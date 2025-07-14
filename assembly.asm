section .data
    string db 'Hello', 0
    msg db 'Número de caracteres: ', 0
    newline db 10

    num_str db '000', 0  ; Buffer de 3 caracteres ASCII para o número

section .text
    global _start

_start:
    ; RSI -> ponteiro da string
    mov rsi, string
    xor rcx, rcx             ; RCX = contador

contar_loop:
    mov al, [rsi]            ;primeiro valor da string copiar o endereço de um pro outro
    cmp al, 0                ;comparar os valores de duas variaveis
    je fim_contagem          ;só acontece quando der verdadeiro
    inc rcx                  ;o contador de quantos caracteres tem
    inc rsi 
    jmp contar_loop          ;vai voltando até chegar o fim do array

fim_contagem:
    ; Contagem está em RCX
    mov rax, rcx
    mov rdi, num_str + 2     ; Posição do último dígito
    mov rcx, 3               ; Máximo de 3 dígitos
    mov rbx, 10

convert_loop:
    xor rdx, rdx 
    div rbx                  ; RAX /= 10, RDX = resto
    add dl, '0'
    mov [rdi], dl
    dec rdi
    loop convert_loop

    ; Imprimir mensagem
    mov rax, 1               ; syscall write
    mov rdi, 1               ; stdout
    mov rsi, msg
    mov rdx, 22              ; Tamanho da mensagem
    syscall

    ; Imprimir número
    mov rax, 1
    mov rdi, 1
    mov rsi, num_str
    mov rdx, 3
    syscall

    ; Imprimir nova linha
    mov rax, 1
    mov rdi, 1
    mov rsi, newline         ;quebra de linha
    mov rdx, 1
    syscall

    ; Sair do programa
    mov rax, 60              ; syscall exit
    xor rdi, rdi             ; código de saída 0
    syscall