CC=gcc
CFLAGS= -Wall -g
OBJ= mt_client.o mt_server.o
SOURCES= mt_client.c mt_server.c
HEADERS= mt.h

.PHONY	: all clean

all	: clean $(OBJ)

clean :
	rm -rf $(OBJ)
	
%.o: %.c
	$(CC) $(CFLAGS) $< -o $@
	
entrega: clean $(SOURCES) $(HEADERS) Makefile
	tar zcvf entrega.tar.gz $(SOURCES) $(HEADERS) Makefile
