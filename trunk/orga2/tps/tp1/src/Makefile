CC=gcc
CFLAGS= -Wall -ggdb `pkg-config --cflags --libs opencv`
NASM=nasm
NASMFLAGS=-felf -g
OBJ=main.o auxiliares.o asmSobelXYEmi.o asmRobertsEmi.o asmPrewittEmi.o

.PHONY	: all clean

all	: clean main

main :  $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o tp

main.o : mainEMILIANO.c
	$(CC) $(CFLAGS) -c mainEMILIANO.c -o main.o 

auxiliares.o : auxiliares.asm
	$(NASM) $(NASMFLAGS) $<

%.o : %.asm auxiliares.o
	$(NASM) $(NASMFLAGS) $<

clean :
	rm -rf $(OBJ) tp
