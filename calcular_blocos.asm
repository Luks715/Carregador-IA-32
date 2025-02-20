section .bss
    tamanho_arquivo resd 1     ; Reserva 4 bytes para o tamanho do arquivo
    vetor resd 1               ; Reserva 4 bytes para o ponteiro do vetor
    tamanho_vetor resd 1       ; Reserva 4 bytes para o tamanho do vetor
    buffer resb 12             ; Reserva 12 bytes para armazenar strings de números

section .data
    msg_inteiro1 db "O programa coube inteiro no endereco inicial: ", 0
    msg_inteiro2 db ", e no endereco final: ", 0

    msg_dividido1 db "O programa foi dividido nos seguintes blocos: ", 0
    msg_dividido2 db "Endereco inicial: ", 0
    msg_dividido3 db ", endereco final: ", 0

    msg_falha db "Não há espaço suficiente para armazenar o arquivo.", 0

    newline db 10              ; Código ASCII para nova linha

    ;vetor dd 500, 100, 700, 100
    ;tamanho_arquivo dd 201
    ;tamanho_vetor dd 2

section .text
    ;global _start
    global calcular_blocos

int_to_string:
    push ebp
    mov ebp, esp

    push ebx
    push ecx
    push edx 
    push edi

    mov ecx, 10            ; Divisor
    lea edi, [buffer + 11] ; Ponteiro para o final do buffer
    mov byte [edi], 0      ; Terminador nulo
    dec edi

convert:
    xor edx, edx        ; Limpa EDX para a divisão
    div ecx             ; Divide EAX por 10
    add dl, '0'         ; Converte o resto para ASCII
    mov [edi], dl       ; Armazena o caractere no buffer
    dec edi             ; Move o ponteiro para a esquerda
    test eax, eax       ; Verifica se ainda há dígitos
    jnz convert

    ; Move a string para o início do buffer
    inc edi
    lea esi, [edi]
    lea edi, [buffer]
    mov ecx, 11
    rep movsb

    pop edi
    pop edx
    pop ecx
    pop ebx

    mov esp, ebp
    pop ebp
    ret

;-------------------------------------------------------------------------------------------------------------------
section .text
    global calcular_blocos

calcular_blocos:
    push ebp
    mov ebp, esp

    ; em [ebp + 8] está o tamanho do arquivo
    mov esi, [ebp + 12]  ; Ponteiro para o vetor de inteiros
    mov ecx, [ebp + 16]  ; Tamanho do vetor
    mov edx, 0

loop_verifica:
    mov eax, [esi]       ; endereço inicial do bloco
    mov ebx, [esi + 4]   ; tamanho de memória disponível no bloco
   
    add edx, ebx         ; Ao final do loop, edx terá o espaço total disponível para o armazenamento

    ; Verifica se o arquivo cabe inteiro no bloco atual
    cmp dword [ebp + 8], ebx
    jbe cabe_inteiro 

    ; Avança para o próximo bloco
    add esi, 8        

    ; Se o loop terminar, o programa não cabe inteiro em nenhum bloco e terá que ser dividido   
    loop loop_verifica 
    
    ; Se o tamanho do arquivo for menor que o espaço total disponível, ele pode ser dividido
    cmp dword [ebp + 8], edx
    jbe dividir_arquivo

    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, msg_falha       ; conteúdo
    mov edx, 53              ; n bytes
    int 0x80

    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, newline         ; conteúdo
    mov edx, 1               ; n bytes
    int 0x80

    ; fim da função
    mov esp, ebp
    pop ebp
    ret

;-------------------------------------------------------------------------------------------------------------------

cabe_inteiro:
    ; Calcula o endereço final do arquivo no bloco
    mov ebx, eax         
    add ebx, [ebp + 8] 
    sub ebx, 1 ; O endereço inicial conta para o armazenamento, então se o bloco tem 10 espaços vagos e começa no endereço 500, o endereço final será 509 e não 510

    push ebx                 ; ebx = fim do bloco
    push eax                 ; eax = inicio do bloco

    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, msg_inteiro1    ; conteúdo
    mov edx, 46              ; n bytes
    int 0x80

    pop eax
    call int_to_string

    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, buffer          ; conteúdo
    mov edx, 12              ; n bytes
    int 0x80

    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, msg_inteiro2    ; conteúdo
    mov edx, 23              ; n bytes
    int 0x80

    pop eax
    call int_to_string

    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, buffer          ; conteúdo
    mov edx, 12              ; n bytes
    int 0x80

    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, newline         ; conteúdo
    mov edx, 1               ; n bytes
    int 0x80

    ; fim da função
    mov esp, ebp
    pop ebp
    ret

;-------------------------------------------------------------------------------------------------------------------

dividir_arquivo:
    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, msg_dividido1   ; conteúdo
    mov edx, 46              ; n bytes
    int 0x80

    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, newline         ; conteúdo
    mov edx, 1               ; n bytes
    int 0x80

    mov edx, [ebp + 8]       ; tamanho do arquivo
    mov esi, [ebp + 12]      ; ponteiro do vetor
    mov ecx, [ebp + 16]      ; tamanho do vetor

loop_divide:
    mov eax, [esi]        ; endereço inicial do bloco
    mov ebx, [esi + 4]    ; tamanho do bloco

    cmp edx, ebx
    jbe bloco_final     

    add ebx, eax          ; calcula o endereço final do bloco
    sub ebx, 1

    push esi              ; esi = ponteiro para o vetor
    push edx              ; edx = tamanho do programa
    push ecx              ; ecx = loop
    push ebx              ; ebx = fim do bloco
    push eax              ; eax = inicio do bloco,

    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, msg_dividido2   ; conteúdo
    mov edx, 18              ; n bytes
    int 0x80

    pop eax
    call int_to_string

    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, buffer          ; conteúdo
    mov edx, 12              ; n bytes
    int 0x80

    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, msg_dividido3   ; conteúdo
    mov edx, 18              ; n bytes
    int 0x80

    pop eax
    call int_to_string

    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, buffer          ; conteúdo
    mov edx, 12              ; n bytes
    int 0x80

    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, newline         ; conteúdo
    mov edx, 1               ; n bytes
    int 0x80

    pop ecx
    pop edx
    pop esi

    sub edx, [esi + 4]
    add esi, 8
    
    dec ecx
    jnz loop_divide

bloco_final:
    mov ebx, eax
    add ebx, edx
    sub ebx, 1
    
    push ebx              ; ebx = fim do bloco
    push eax              ; eax = inicio do bloco,

    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, msg_dividido2   ; conteúdo
    mov edx, 18              ; n bytes
    int 0x80

    pop eax
    call int_to_string

    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, buffer          ; conteúdo
    mov edx, 12              ; n bytes
    int 0x80

    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, msg_dividido3   ; conteúdo
    mov edx, 18              ; n bytes
    int 0x80

    pop eax
    call int_to_string

    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, buffer          ; conteúdo
    mov edx, 12              ; n bytes
    int 0x80

    mov eax, 4               ; write
    mov ebx, 1               ; stdout
    mov ecx, newline         ; conteúdo
    mov edx, 1               ; n bytes
    int 0x80

    ; fim da função
    mov esp, ebp
    pop ebp
    ret

;-------------------------------------------------------------------------------------------------------------------