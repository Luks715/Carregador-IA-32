# Compilador e flags
CC = gcc
ASM = nasm
CFLAGS = -m32
ASMFLAGS = -f elf32

# Nomes dos arquivos objeto
OBJS = carregador_c.o calcular_blocos_asm.o

# Nome do executável final
TARGET = carregador

# Regra padrão
all: $(TARGET)

# Regra para compilar o arquivo C
carregador_c.o: carregador.c
	$(CC) $(CFLAGS) -c carregador.c -o carregador_c.o

# Regra para montar o arquivo ASM
calcular_blocos_asm.o: calcular_blocos.asm
	$(ASM) $(ASMFLAGS) -o calcular_blocos_asm.o calcular_blocos.asm

# Regra para linkar os arquivos objeto e gerar o executável
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

# Regra para limpar os arquivos gerados
clean:
	rm -f $(OBJS) $(TARGET)

# Regra para rodar o programa
run: $(TARGET)
	./$(TARGET) 200 500 100 700 100