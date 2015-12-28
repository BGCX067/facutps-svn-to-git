#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern void monocromatizar(char*, int, int); 			// ejercicio 1

void ejercicio1(void);

int main( int argc, char* argv[] ) {

	ejercicio1();

   return 0;
}

void ejercicio3b(){

	int *res = usandoSSE();

	printf("Resultado= %d , %d , %d , %d\n", *res, *(res+1), *(res+2), *(res+3));
}

