# Compilador e linker
NASM = nasm
GCC = gcc
LD = ld

# Flags
NASM_FLAGS = -f elf32
GCC_FLAGS = -m32 -c
LD_FLAGS = -m elf_i386

# Arquivos
ASM_SRC = carregador.asm
ASM_OBJ = carregador_asm.o
ASM_OUT = carregador_asm

C_SRC = carregador.c
C_OBJ = carregador_c.o

ASM_CALC_SRC = calcular_blocos.asm
ASM_CALC_OBJ = calcular_blocos_asm.o

EXEC = carregador

all: carregador_asm carregador

# Versão Assembly Puro
carregador_asm: $(ASM_SRC)
	$(NASM) $(NASM_FLAGS) -o $(ASM_OBJ) $(ASM_SRC)
	$(LD) $(LD_FLAGS) -o $(ASM_OUT) $(ASM_OBJ)

# Versão C + Assembly
carregador: $(C_SRC) $(ASM_CALC_SRC)
	$(NASM) $(NASM_FLAGS) -o $(ASM_CALC_OBJ) $(ASM_CALC_SRC)
	$(GCC) $(GCC_FLAGS) -o $(C_OBJ) $(C_SRC)
	$(GCC) -m32 -o $(EXEC) $(C_OBJ) $(ASM_CALC_OBJ)

# Limpeza de arquivos gerados
clean:
	rm -f $(ASM_OBJ) $(ASM_OUT) $(C_OBJ) $(ASM_CALC_OBJ) $(EXEC)
