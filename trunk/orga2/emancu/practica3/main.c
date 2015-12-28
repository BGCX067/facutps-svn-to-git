#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern void suma(unsigned int *, unsigned int*, unsigned short ); 			// ejercicio 1a
extern short int * sumaYresta(short int *, short int*, unsigned short ); 	// ejercicio 1b
extern int prodInterno(short int *, char*, unsigned short);						// ejercicio 1c
extern int promYDevEst(short int *, int*, int*);									// ejercicio 1d

extern float* productoEscalar(float*, float, unsigned short);


void mostrar(short int* vec, unsigned short size);
void ejercicio1a(void);
void ejercicio1b(void);
void ejercicio1c(void);
void ejercicio1d(void);
void ejercicio5a(void);

int main( int argc, char* argv[] ) {

//	ejercicio1a();	
//	ejercicio1b();
//	ejercicio1c();
//	ejercicio1d();

	ejercicio5a();

   return 0;
}


void mostrar(short int* vec, unsigned short size){
	int i;
	printf("[");
	for(i=0; i < size; i++)
		printf("%d, ", vec[i]);
		
	printf("] \n");
}


void ejercicio1a(){
	unsigned short n=8;
	unsigned int vecA[8]={1,1,1,1,1,1,1,1};
	unsigned int vecB[8]={2,3,4,5,6,7,8,9};

//	mostrar(&vecA[0], n);
//	mostrar(&vecB[0], n);
	puts("--------------------");
	
	suma(&vecA[0], &vecB[0],n);
	
//	mostrar(&vecA[0], n);

}

void ejercicio1b(){
	unsigned short n=8;
	short int vecA[8]={4,4,4,4,6,6,6,6};
	short int vecB[8]={2,3,4,1,9,8,7,6};

	mostrar(&vecA[0], n);
	mostrar(&vecB[0], n);
	puts("--------------------");

//	long int tscl;

//	__asm__ __volatile__ ("rdtsc;mov %%eax,%0" : : "g" (tscl));
	short int* res = sumaYresta(&vecA[0], &vecB[0],n);
//	__asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (tscl));
//	printf("Mi tiempo : %ld \n",tscl);
			
	mostrar(res, n);

}

void ejercicio1c(){
	unsigned short n=8;
	short int vecA[8]={4,3,2,0,0,0,0,6};
	char vecB[8]={10,2,1,0,9,8,7,0};

//	mostrar(&vecA[0], n);
//	mostrar(&vecB[0], n);
	puts("--------------------");

	int res = prodInterno(&vecA[0], &vecB[0],n);
			
	printf("Resultado: %d", res);

}

void ejercicio1d(){
	short int vecA[8]={4,3,2,0,0,0,0,6};
	int prom=0, v=0;

//	mostrar(&vecA[0], 8);
	puts("--------------------");

	promYDevEst(&vecA[0], &prom, &v);
			
	printf("Promedio: %d, varianza = %d \n", prom, v);

}


void ejercicio5a(){
	float vecA[4]={1.5,2.1,3.2,4.3};
	unsigned short size = 4;
	float escalar = 1.0;
	
	float *res = productoEscalar(&vecA[0], escalar, size);

	int i;
	printf("[");
	for(i=0; i < size; i++)
		printf("%f, ", res[i]);
		
	printf("] \n");


}


