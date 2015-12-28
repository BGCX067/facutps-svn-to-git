#include <cv.h>
#include <highgui.h>
#include <stdio.h>
#include <stdlib.h>

extern void asmSobel(const char* src, char* dst, int ancho, int alto, int xorder, int yorder);
extern void asmPrewitt(const char* src, char* dst, int ancho, int alto);
extern void asmFrei_Chen(const char* src, char* dst, int ancho, int alto);
extern void asmRoberts(const char* src, char* dst, int ancho, int alto);
void mostrar(short int array[], int size);

int sobelX[9] = {-1,0,1,-2,0,2,-1,0,1};
int sobelY[9] = {-1,-2,-1,0,0,0,1,2,1};
int prewittX[9] = {-1,0,1,-1,0,1,-1,0,1};
int prewittY[9] = {-1,-1,-1,0,0,0,1,1,1};
//char mascara[9] = {1,0,-1,0,0,0,0,0,0};

//int mascara[9] = {1,0,-1,0,0,0,0,0,0};

int rmd2 = 0;

int main( int argc, char* argv[] ) {
	IplImage *src = 0;
	IplImage *dst = 0;
	IplImage *dst_ini = 0;

	//printf("argc = %d char**= %s ", argc, *(argv+1));


	//char* filename = argc == 2 ? argv[1] : (char*)"images/lena.bmp";
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

//	asmSobel(src->imageData, dst->imageData , src->width, src->height,1,1);
//	cvSaveImage("images/Tp2sobel_XY.bmp", dst);
	
	asmFrei_Chen(src->imageData, dst->imageData , src->width, src->height);
	cvSaveImage("images/Tp2Frei.bmp", dst);
	
   return 0;

}

void mostrar(short int array[], int size) {
	int i;
	for(i=0; i < size; i++){
		printf("%hd , ", array[i]);
	}
	printf("\n");

}


