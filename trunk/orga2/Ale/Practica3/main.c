#include <stdio.h>

extern void suma(unsigned int* v1, unsigned int* v2, unsigned short n);
extern short int * sumaYResta(short int * v, short int * w, unsigned short n);
extern int prodInterno(short int *v1, char *v2, unsigned short n);
extern void promYDevEst(short int* vector, int* prom, int* V);
extern float* productoEscalar(float* v, float k, unsigned short n);


void ejercicio1a();
void ejercicio1b();
void ejercicio1c();
void ejercicio1d();
void ejercicio5a();

int main()
{

	//ejercicio1();
	//ejercicio2();
	long int ale;

		__asm__ __volatile__ ("rdtsc;mov %%eax,%0" : : "g" (ale));
		ejercicio5a();
		__asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (ale));

		//printf("Yo tardee : %ld \n",ale);
	





	//free(res);
	//free(A);
	return 0;
}
void ejercicio5a(){


float A[8] = {1,2,3,4,5,6,7,8}; //de 16 bits

	float c = 2;

	float *res;

	res =	productoEscalar(A,c, (unsigned short) 8);



}




void ejercicio1d(){


short int A[8] = {1,2,3,4,5,6,7,8}; //de 16 bits

	int promedio;
	
	int v;



	promYDevEst(&A[0],&promedio,&v);
	
	printf(" %d ", promedio);
	/*for(i=0; i < 8; i++){
			printf(" %d ,",res[i]);
	}
			printf(" \n ");*/


}


void ejercicio1c(){
	short int A[8] = {1,2,3,4,5,6,7,8}; //de 16 bits
	char  B[8] = {2,2,2,2,2,2,2,2}; // de 8 bits

	int res;

	res = prodInterno(&A[0],&B[0],(unsigned short) 8);
	

}


void ejercicio1b(){
	short int A[8] = {1,2,3,4,5,6,7,8};
	short int B[8] = {2,100,2,2,2,2,2,2};

	short int* res;

	res = sumaYResta(&A[0],&B[0],(unsigned short) 8);
	
	
	int i =0;
	
	for(i=0; i < 8; i++){
			printf(" %d ,",res[i]);
	}
			printf(" \n ");

}



void ejercicio1a(){
unsigned int A[8] = {1,2,3,4,5,6,7,8};
unsigned int B[8] = {8,0,2,2,2,2,2,2};


	suma(&A[0],&B[0],(unsigned short) 8);
	
	int i =0;
	
	for(i=0; i < 8; i++){
			printf(" %d ,",A[i]);
	}
			printf(" \n ");

}

