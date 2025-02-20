all: carregador

carregador: carregador.o carregador.asm
    nasm -f elf32 carregador.asm -o carregador_asm.o
    gcc -m32 -o carregador carregador.o carregador_asm.o

carregador.o: carregador.c
    gcc -m32 -c carregador.c -o carregador.o

clean:
    rm -f *.o carregador