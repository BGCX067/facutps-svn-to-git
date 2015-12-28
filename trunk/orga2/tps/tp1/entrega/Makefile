.PHONY	: all clean install

all: clean install

clean : 
	rm -f exe/*
	cd src; make clean; cd ..;

install : 
	cd src; make all; cd .. ; cp src/tp exe/tp; ln -s ../src/images/ exe/images; ln -s ../resultados/ exe/out;
