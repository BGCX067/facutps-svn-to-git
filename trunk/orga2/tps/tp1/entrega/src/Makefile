CC=gcc
CFLAGS= -Wall -ggdb `pkg-config --cflags --libs opencv`
NASM=nasm
NASMFLAGS=-felf -g
OBJ=main.o auxiliares.o asmSobelXY.o asmRoberts.o asmPrewitt.o

.PHONY	: all clean

all	: clean main

main :  $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o tp

main.o : main.c
	$(CC) $(CFLAGS) -c main.c -o main.o 

auxiliares.o : auxiliares.asm
	$(NASM) $(NASMFLAGS) $<

%.o : %.asm auxiliares.o
	$(NASM) $(NASMFLAGS) $<

clean :
	rm -rf $(OBJ) tp
