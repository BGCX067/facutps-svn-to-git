#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern float* usandoFPU(); 			// ejercicio 3a
extern int* usandoSSE(); 			// ejercicio 3b

void ejercicio3a(void);
void ejercicio3b(void);

int main( int argc, char* argv[] ) {

//	ejercicio3a();
	ejercicio3b();

   return 0;
}

void ejercicio3a(){
	
	float *res = usandoFPU();
		
	printf("Resultado= %f , %f , %f , %f\n", *res, *(res+1), *(res+2), *(res+3));
}

void ejercicio3b(){

	int *res = usandoSSE();

	printf("Resultado= %d , %d , %d , %d\n", *res, *(res+1), *(res+2), *(res+3));
}

