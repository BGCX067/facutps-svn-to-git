#include <cv.h>
#include <highgui.h>
#include <stdio.h>
#include <stdlib.h>

extern void asmSobel(const char* src, char* dst, int ancho, int alto, int xorder, int yorder);
extern void asmPrewitt(const char* src, char* dst, int ancho, int alto);
extern void asmRoberts(const char* src, char* dst, int ancho, int alto);
void mostrar(short int array[], int size);

int sobelX[9] = {-1,0,1,-2,0,2,-1,0,1};
int sobelY[9] = {-1,-2,-1,0,0,0,1,2,1};
int prewittX[9] = {-1,0,1,-1,0,1,-1,0,1};
int prewittY[9] = {-1,-1,-1,0,0,0,1,1,1};
int robertX[4]={1,0,0,-1};
int reobertY[4]={0,1,-1,0};
//char mascara[9] = {1,0,-1,0,0,0,0,0,0};

//int mascara[9] = {1,0,-1,0,0,0,0,0,0};

int rmd2 = 0;

int main( int argc, char* argv[] ) {
	IplImage *src = 0;
	IplImage *dst = 0;
	IplImage *dst_ini = 0;

	//printf("argc = %d char**= %s ", argc, *(argv+1));


	char* filename = argc == 2 ? argv[1] : (char*)"images/lena.bmp";

   // Cargo la imagen
   if( (src = cvLoadImage(filename, CV_LOAD_IMAGE_GRAYSCALE)) == 0 )
		return -1;

   // Creo una IplImage para cada salida esperada
   if( (dst = cvCreateImage(cvGetSize (src), IPL_DEPTH_8U, 1) ) == 0 )
		return -1;

  
// Creo una IplImage para la de la libreria
	if( (dst_ini = cvCreateImage(cvGetSize (src), IPL_DEPTH_8U, 1) ) == 0 )
		return -1;

	int tscl;
// Tomar estado del TSC antes de iniciar el procesamiento de bordes.
 __asm__ __volatile__ ("rdtsc;mov %%eax,%0" : : "g" (tscl));


	asmSobel(src->imageData, dst->imageData , src->widthStep - 2 , src->height -2  , 1, 1);

	cvSaveImage("images/NuestroSobel.bmp", dst);



// Tomo la medici ́n de tiempo con el TSC y calculo la diferencia. Resultado:
// Cantidad de clocks insumidos por el algoritmo.
 __asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (tscl));


	printf("lo que tardo la nuestra es : %d \n",tscl);

// Ahora la de ellos
 __asm__ __volatile__ ("rdtsc;mov %%eax,%0" : : "g" (tscl));


	cvSobel(src, dst_ini ,1,1,3);

	cvSaveImage("images/SobelCV.bmp", dst);

// Tomo la medici ́n de tiempo con el TSC y calculo la diferencia. Resultado:
// Cantidad de clocks insumidos por el algoritmo.
 __asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (tscl));


	printf("lo que tardo LIBRERIA es : %d \n",tscl);

		
	
	

		
   // Aplico el filtro (Sobel con derivada x en este caso) y salvo imagen 
   //cvSobel(src, dst_ini , 1,1,3);
   //cvSaveImage("images/sobelLibXY.bmp", dst_ini);
 	// Esta parte es la que tienen que programar los alumnos en ASM	y comparar

/*
	asmSobel(src->imageData, dst->imageData , src->widthStep - 2 , src->height -2  , 0, 1);

	cvSaveImage("images/nuestroSobelY.bmp", dst);

	
	
   // Aplico el filtro (Sobel con derivada x en este caso) y salvo imagen 
   cvSobel(src, dst_ini ,0,1,3);
   cvSaveImage("images/sobelLibY.bmp", dst_ini);

   // Aplico el filtro (Sobel con derivada y en esta caso) y salvo imagen 
   //cvSobel(src, dst, 0,1,3);    // Esta parte es la que tienen que programar los alumnos en ASM	y comparar
   //cvSaveImage("derivada y.BMP", dst);
*/
	
   return 0;

}

void mostrar(short int array[], int size) {
	int i;
	for(i=0; i < size; i++){
		printf("%hd , ", array[i]);
	}
	printf("\n");

}


