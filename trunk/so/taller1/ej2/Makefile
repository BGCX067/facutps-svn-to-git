CC=gcc
CFLAGS= -Wall -g
OBJ= launch.o 
SOURCES= launch.c

.PHONY	: all clean

all	: clean $(OBJ)

clean :
	rm -rf $(OBJ)
	
%.o: %.c
	$(CC) $(CFLAGS) $< -o $@
	
entrega: clean $(SOURCES) Makefile
	tar zcvf entrega.tar.gz $(SOURCES) Makefile
