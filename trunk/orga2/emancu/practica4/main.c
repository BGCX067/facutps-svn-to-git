#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern float suma(float, float); 			// ejercicio 1a
extern double sumaD(double, double); 			// ejercicio 1b

extern double func4(float, float); 			// ejercicio 4


void ejercicio1a(void);
void ejercicio1b(void);

void ejercicio4(void);

int main( int argc, char* argv[] ) {

//	ejercicio1a();	
//	ejercicio1b();	

	ejercicio4();

   return 0;
}

void ejercicio1a(){
	float a=1.1111, b=242.352553, res=0.0;
	
	res = suma(a,b);
	
	printf("%f + %f = %f \n",a,b,res);
}

void ejercicio1b(){
	double a=1.1112312312311, b=242.35200000000553, res=0.0;
	
	res = sumaD(a,b);
	
	printf("%e + %e = %e \n",a,b,res);
}

void ejercicio4(){
	float a=1.0, b=2.0;
	double res = 0.0L;
	
	res = func4(a,b);

	printf("Res %e \n en long %lf \n", res, res);

}

