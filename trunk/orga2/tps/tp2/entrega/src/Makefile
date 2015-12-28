CC=gcc
CFLAGS= -Wall -ggdb `pkg-config --cflags --libs opencv`
NASM=nasm
NASMFLAGS=-felf -ggdb
OBJ= asmPrewitt.o asmSobelXY.o main.o asmRoberts.o asmFrei_Chen.o

.PHONY	: all clean install

all	: clean main

main :  $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o tp

main.o : main.c
	$(CC) $(CFLAGS) -c main.c -o main.o 

%.o : %.asm 
	$(NASM) $(NASMFLAGS) $<

clean :
	rm -rf $(OBJ) tp
	
install : clean main
	cp tp ../exe/tp
	
