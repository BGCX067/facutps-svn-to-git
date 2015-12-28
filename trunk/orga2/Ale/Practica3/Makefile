CC=gcc
CFLAGS= -Wall -ggdb 
NASM=nasm
NASMFLAGS=-felf -ggdb
OBJ=1a.o 1b.o 1c.o 1d.o 5a.o  main.o

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
