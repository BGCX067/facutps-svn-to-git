CC=gcc
CFLAGS= -ggdb  -Wall
NASM=nasm
NASMFLAGS=-felf -g
OBJ=3.o main.o 
#OBJ=5a.o main.o 

.PHONY	: all clean

all	: clean main

main :  $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o tp

main.o : main.c
	$(CC) $(CFLAGS) -c main.c -o main.o 

%.o : %.asm 
	$(NASM) $(NASMFLAGS) $<

clean :
	rm -rf $(OBJ) tp
