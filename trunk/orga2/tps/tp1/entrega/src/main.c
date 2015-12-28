#include <cv.h>
#include <highgui.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <unistd.h>
#include <termio.h>

extern void asmSobel(const char* src, char* dst, int ancho, int alto, int xorder, int yorder);
extern void asmPrewitt(const char* src, char* dst, int ancho, int alto);
extern void asmRoberts(const char* src, char* dst, int ancho, int alto);

int sobelX[9] = {-1,0,1,-2,0,2,-1,0,1};
int sobelY[9] = {-1,-2,-1,0,0,0,1,2,1};
int prewittX[9] = {-1,0,1,-1,0,1,-1,0,1};
int prewittY[9] = {-1,-1,-1,0,0,0,1,1,1};
int robertsX[4]={1,0,0,-1};
int robertsY[4]={0,1,-1,0};

void cargarParametros(int *, char **);
void mostrarImagen(char*, IplImage**);
void compararTiempos(IplImage*);
int readch(void);

int main( int argc, char* argv[] ) {
	IplImage *src = 0, *dst = 0;
	int option;
	char input;
	char *filename = malloc(sizeof(char) * 100);
	char *outFilename = malloc(sizeof(char) * 150);

	if (argc != 3){
		system("clear");
		puts("Parametros invalidos, siga las instrucciones..");
		cargarParametros(&option, &filename);
	}else{
		option = atoi((argv[1]+1));
		filename = argv[2];
	}
	
	while(option!=0){
		strcpy(outFilename, "out/");

		// Cargo la imagen
		src = cvLoadImage(filename, CV_LOAD_IMAGE_GRAYSCALE);
		if( src == NULL )
			printf("\n No se pudo cargar la imagen \"%s\" \n", filename);
		else {
			// Creo una IplImage para cada salida esperada
			dst = cvCreateImage(cvGetSize (src), IPL_DEPTH_8U, 1);
			if( dst == NULL )
				puts("\n No se pudo crear la imagen.");
		}
		
		if(src != NULL && dst != NULL){
			// Do action selected
			switch( option ) {
				case 1: {
					asmRoberts(src->imageData, dst->imageData , src->width -1, src->height-1);
					strcat(outFilename, "roberts_");
					break;
				}case 2:{
					asmPrewitt(src->imageData, dst->imageData , src->width - 2 , src->height -2);
					strcat(outFilename, "prewitt_");
					break;
				}case 3: {
					asmSobel(src->imageData, dst->imageData , src->width - 2 , src->height -2 , 1, 0);
					strcat(outFilename, "sobelX_");
					break;
				}case 4: {
					asmSobel(src->imageData, dst->imageData , src->width - 2 , src->height -2  , 0, 1);
					strcat(outFilename, "sobelY_");
					break;
				}case 5: {
					asmSobel(src->imageData, dst->imageData , src->width - 2 , src->height -2  , 1, 1);
					strcat(outFilename, "sobelXY_");
					break;
				}case 6: {
					cvSobel(src, dst , 1,0,3);
					strcat(outFilename, "cvSobelX_");
					break;
				}case 7: {
					cvSobel(src, dst , 0,1,3);
					strcat(outFilename, "cvSobelY_");
					break;
				}case 8: {
					cvSobel(src, dst , 1,1,3);
					strcat(outFilename, "cvSobelXY_");
					break;
				}case 9: { 
					compararTiempos(src);
					break;
				}
			}
			
			strcat(outFilename, (filename+7));
			printf("Imagen \"%s\" procesada. \n \n", outFilename);
			if(option != 9){
				cvSaveImage(outFilename, dst);
				do{
					puts("Presione una tecla. (V)er imagen creada, (P)rocesar otra imagen, (S)alir.");
					input = readch();
				}while((input != 'v' && input != 'V')&&(input != 'p' && input != 'P')&&(input != 's' && input != 'S'));
			}else{
				do{
					puts("Presione una tecla. (P)rocesar otra imagen, (S)alir.");
					input = readch();
				}while((input != 'p' && input != 'P')&&(input != 's' && input != 'S'));
			
			}	
		}
				
		if(input == 'v' || input == 'V'){
			mostrarImagen(filename, &dst);
			option = 0;
		}else {
			if(input == 's' || input == 'S'){
				option = 0;
			}else{
				if(input == 'p' || input == 'P')
					system("clear");
					
				cargarParametros(&option, &filename);
			}
		}
	
	}

   return 0;
}

void mostrarImagen(char *filename, IplImage **img) {
	cvNamedWindow( filename, 1); 		// creamos la ventana de nombre Juego
	cvShowImage( filename, *img ); 	// representamos la imagen en la ventana
	cvWaitKey(000); 						// se pulsa tecla para terminar
	cvDestroyWindow(filename); 		// destruimos todas las ventanas
	cvReleaseImage(img);
}

void cargarParametros(int *option, char **str) {
	int opcionValida = 1;

	do{
	
		if(opcionValida == 0)
			system("clear");

		puts("Operaciones disponibles: ");
		puts("1. Realzar los bordes con el operador de Roberts ");
		puts("2. Realzar los bordes con el operador de Prewitt ");
		puts("3. Realzar los bordes con el operador de Sobel, derivacion solo en X ");
		puts("4. Realzar los bordes con el operador de Sobel, derivacion solo en Y ");
		puts("5. Realzar los bordes con el operador de Sobel, derivacion en X y en Y ");
		puts("6. Realzar los bordes con el OPENCV Sobel, derivacion solo en X ");
		puts("7. Realzar los bordes con el OPENCV Sobel, derivacion solo en Y ");
		puts("8. Realzar los bordes con el OPENCV Sobel, derivacion en X y en Y ");
		puts("9. Comparar tiempos con la libreria OpenCV.");
		puts("0. Salir del programa \n ");

		printf("\n Ingrese el numero de operacion que quiere realizar: ");
		scanf("%d", option);
		
		opcionValida = ((*option >= 0) && (*option <= 9))? 1 : 0;
		
	}while(opcionValida == 0);
	
	if (*option == 0)
		return;
	
	system("ls -1 images/ | sort");
	
	char *input = malloc(sizeof(char) * 80);
	
	printf("Escriba el nombre de la imagen a procesar: ");
	scanf("%s", input);
	strcpy(*str, "images/");
	strcat(*str, input);	
	readch();	
}

int readch( void ){
	char ch;
	int fd = fileno(stdin);
	struct termio old_tty, new_tty;

	ioctl(fd, TCGETA, &old_tty);
	new_tty = old_tty;
	new_tty.c_lflag &= ~(ICANON | ECHO | ISIG);
	ioctl(fd, TCSETA, &new_tty);
	fread(&ch, 1, sizeof(ch), stdin);
	ioctl(fd, TCSETA, &old_tty);

	return ch;
}

void compararTiempos(IplImage* src){
	long int tscl_NX, tscl_EX, tscl_NY, tscl_EY, tscl_NXY, tscl_EXY;
	IplImage *dst = 0, *dst_lib = 0;
	dst = cvCreateImage(cvGetSize(src), IPL_DEPTH_8U, 1);
	dst_lib = cvCreateImage(cvGetSize(src), IPL_DEPTH_8U, 1);

	if(dst == NULL || dst_lib == NULL){
		puts("No se pudo crear las imagenes de destino.");
		return;
	}

	system("echo 'Nuesto X, openCV X, Nuestro Y, OpenCV Y, Nuestro XY, OpenCV XY' > tabla.xls");

	int i=0;
	for (i=0; i<20;i++){
		printf("%d \n", i);	
		/*
		 *		Bordes X
		 */

		__asm__ __volatile__ ("rdtsc;mov %%eax,%0" : : "g" (tscl_NX));
		asmSobel(src->imageData, dst->imageData , src->width - 2 , src->height -2  , 1, 0);
		__asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (tscl_NX));

		printf("Sobel en X de grupo RET : %ld \n",tscl_NX);

		//Ahora Sobel X de OpenCV

		__asm__ __volatile__ ("rdtsc;mov %%eax,%0" : : "g" (tscl_EX));
		cvSobel(src, dst_lib , 1,0,3);
		__asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (tscl_EX));

		printf("Sobel en X de OpenCV : %ld \n",tscl_EX);

		/*
		 *		Bordes Y
		 */

		dst = cvCreateImage(cvGetSize(src), IPL_DEPTH_8U, 1);
		dst_lib = cvCreateImage(cvGetSize(src), IPL_DEPTH_8U, 1);

		if(dst == NULL || dst_lib == NULL){
			puts("No se pudo crear las imagenes de destino.");
			return;
		}

		__asm__ __volatile__ ("rdtsc;mov %%eax,%0" : : "g" (tscl_NY));
		asmSobel(src->imageData, dst->imageData , src->width - 2 , src->height -2  , 0, 1);
		__asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (tscl_NY));

		printf("Sobel en Y de grupo RET : %ld \n",tscl_NY);

		//Ahora Sobel Y de OpenCV

		__asm__ __volatile__ ("rdtsc;mov %%eax,%0" : : "g" (tscl_EY));
		cvSobel(src, dst_lib , 0,1,3);
		__asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (tscl_EY));

		printf("Sobel en Y de OpenCV : %ld \n",tscl_EY);

		/*
		 *		Bordes XY
		 */

		dst = cvCreateImage(cvGetSize(src), IPL_DEPTH_8U, 1);
		dst_lib = cvCreateImage(cvGetSize(src), IPL_DEPTH_8U, 1);

		if(dst == NULL || dst_lib == NULL){
			puts("No se pudo crear las imagenes de destino.");
			return;
		}

		__asm__ __volatile__ ("rdtsc;mov %%eax,%0" : : "g" (tscl_NXY));
		asmSobel(src->imageData, dst->imageData , src->width - 2 , src->height -2  , 1, 1);
		__asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (tscl_NXY));

		printf("Sobel en XY de grupo RET : %ld \n",tscl_NXY);

		//Ahora Sobel XY de OpenCV

		__asm__ __volatile__ ("rdtsc;mov %%eax,%0" : : "g" (tscl_EXY));
		cvSobel(src, dst_lib , 1,1,3);
		__asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (tscl_EXY));

		printf("Sobel en XY de OpenCV : %ld \n",tscl_EXY);


		// Imprimo el archivo

		char comando[600];
		sprintf(comando, "echo '%ld, %ld, %ld, %ld, %ld, %ld' >> tabla.xls", tscl_NX, tscl_EX, tscl_NY, tscl_EY, tscl_NXY, tscl_EXY);
		system(comando);
	}

}

