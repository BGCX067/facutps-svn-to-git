CC=gcc
CFLAGS= -Wall -ggdb `pkg-config --cflags --libs opencv`
NASM=nasm
NASMFLAGS=-felf -ggdb
OBJ= asmPrewitt.o emi_asmSobelXY.o asmSobelXY_tp1.o main.o asmRoberts.o asmFrei_Chen.o

.PHONY	: all clean

all	: clean main

main :  $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o tp

main.o : mainEMILIANO.c
	$(CC) $(CFLAGS) -c mainEMILIANO.c -o main.o 

%.o : %.asm 
	$(NASM) $(NASMFLAGS) $<

clean :
	rm -rf $(OBJ) tp
