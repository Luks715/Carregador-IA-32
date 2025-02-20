#include <stdio.h>
#include <stdlib.h>

// Declaração das funções em Assembly
extern void calcular_blocos(int tamanho_arquivo, int* vetor, int tamanho_vetor);

int main(int argc, char* argv[]) {
    // Verifica o número mínimo de argumentos
    if (argc < 4) {
        printf("Argumentos insuficientes para carregar o programa na memória");
        return 1;
    } else if (argc > 10) {
        printf("Mais argumentos do que o necessário");
        return 1;
    } else if ((argc - 2) % 2 != 0) {
        printf("Argumentos faltando para carregar o programa na memória");
        return 1;
    }

    // Tamanho do programa (primeiro argumento)
    int tamanho_arquivo = atoi(argv[1]);    // Ex, ./carregador 125 500 100 700 50. tamanho_arquivo = 125

    // Número de blocos de memória (endereço e tamanho)
    int tamanho_vetor = (argc - 2) / 2;    // Ex, ./carregador 125 500 100 700 50. tamanho_vetor = 2

    // Aloca memória para armazenar os blocos (endereço e tamanho)
    int* vetor = malloc(tamanho_vetor * 2 * sizeof(int));
    if (!vetor) {
        printf("Erro ao alocar memória.\n");
        return 1;
    }

    // Preenche o array de blocos com os valores da linha de comando
    for (int i = 0; i < tamanho_vetor; i++) {
        vetor[i * 2] = atoi(argv[2 + i * 2]);       // Endereço do bloco
        vetor[i * 2 + 1] = atoi(argv[2 + i * 2 + 1]); // Tamanho do bloco
    }

    // Chama a função em Assembly para calcular os blocos
    calcular_blocos(tamanho_arquivo, vetor, tamanho_vetor);

    // Libera a memória alocada
    free(vetor);
    return 0;
}