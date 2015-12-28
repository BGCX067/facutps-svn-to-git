#include <cv.h>
#include <highgui.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <unistd.h>
#include <termio.h>

extern void asmSobel(const char* src, char* dst, int ancho, int alto, int xorder, int yorder);
extern void asmSobel_tp1(const char* src, char* dst, int ancho, int alto, int xorder, int yorder);
extern void asmPrewitt(const char* src, char* dst, int ancho, int alto);
extern void asmRoberts(const char* src, char* dst, int ancho, int alto);
extern void asmFrei_Chen(const char* src, char* dst, int ancho, int alto);

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
					asmRoberts(src->imageData, dst->imageData , src->width , src->height);
					strcat(outFilename, "roberts_");
					break;
				}case 2:{
					asmPrewitt(src->imageData, dst->imageData , src->width , src->height);
					strcat(outFilename, "prewitt_");
					break;
				}case 3: {
					asmSobel(src->imageData, dst->imageData , src->width , src->height , 1, 0);
					strcat(outFilename, "sobelX_");
					break;
				}case 4: {
					asmSobel(src->imageData, dst->imageData , src->width, src->height , 0, 1);
					strcat(outFilename, "sobelY_");
					break;
				}case 5: {
					asmSobel(src->imageData, dst->imageData , src->width , src->height , 1, 1);
					strcat(outFilename, "sobelXY_");
					break;
				}case 6: {
					asmFrei_Chen(src->imageData, dst->imageData , src->width, src->height);
					strcat(outFilename, "freiChen_");
					break;
				}case 7: {
					compararTiempos(src);
					break;
				}
			}
			
			strcat(outFilename, (filename+7));
			printf("Imagen \"%s\" procesada. \n \n", outFilename);
			if(option != 7){
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
	cvShowImage( filename, *img ); 		// representamos la imagen en la ventana
	cvWaitKey(000); 					// se pulsa tecla para terminar
	cvDestroyWindow(filename); 			// destruimos todas las ventanas
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
		puts("6. Realzar los bordes con el operador Frei-Chen, derivacion solo en X ");
		puts("7. Comparar tiempos con la libreria OpenCV.");
		puts("0. Salir del programa \n ");

		printf("\n Ingrese el numero de operacion que quiere realizar: ");
		scanf("%d", option);
		
		opcionValida = ((*option >= 0) && (*option <= 7))? 1 : 0;
		
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
	long int tscl_1X, tscl_1Y, tscl_1XY;
	IplImage *dst = 0, *dst_lib = 0, *dst_tp1 = 0;
	dst = cvCreateImage(cvGetSize(src), IPL_DEPTH_8U, 1);
	dst_lib = cvCreateImage(cvGetSize(src), IPL_DEPTH_8U, 1);
	dst_tp1 = cvCreateImage(cvGetSize(src), IPL_DEPTH_8U, 1);

	if(dst == NULL || dst_lib == NULL){
		puts("No se pudo crear las imagenes de destino.");
		return;
	}

	system("echo 'Nuesto_X, openCV_X, TP1_X, Nuestro_Y, OpenCV_Y, TP1_Y, Nuestro_XY, OpenCV_XY, TP1_XY' > tabla.xls");

	int i=0;
	for (i=0; i<20;i++){
		printf("%d \n", i);	
		/*
		 *		Bordes X
		 */

		__asm__ __volatile__ ("rdtsc;mov %%eax,%0" : : "g" (tscl_NX));
		asmSobel(src->imageData, dst->imageData , src->width, src->height, 1, 0);
		__asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (tscl_NX));

		printf("Sobel en X de grupo RET : %ld \n",tscl_NX);

		//Ahora Sobel X de OpenCV

		__asm__ __volatile__ ("rdtsc;mov %%eax,%0" : : "g" (tscl_EX));
		cvSobel(src, dst_lib , 1,0,3);
		__asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (tscl_EX));

		printf("Sobel en X de OpenCV : %ld \n",tscl_EX);

		//Ahora Sobel X de TP1

		__asm__ __volatile__ ("rdtsc;mov %%eax,%0" : : "g" (tscl_1X));
		asmSobel_tp1(src->imageData, dst->imageData , src->width - 2 , src->height -2  , 1, 0);
		__asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (tscl_1X));

		printf("Sobel en X deTP1 : %ld \n",tscl_1X);


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
		asmSobel(src->imageData, dst->imageData , src->width  , src->height, 0, 1);
		__asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (tscl_NY));

		printf("Sobel en Y de grupo RET : %ld \n",tscl_NY);

		//Ahora Sobel Y de OpenCV

		__asm__ __volatile__ ("rdtsc;mov %%eax,%0" : : "g" (tscl_EY));
		cvSobel(src, dst_lib , 0,1,3);
		__asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (tscl_EY));

		printf("Sobel en Y de OpenCV : %ld \n",tscl_EY);

		//Ahora Sobel Y de TP1

		__asm__ __volatile__ ("rdtsc;mov %%eax,%0" : : "g" (tscl_1Y));
		asmSobel_tp1(src->imageData, dst->imageData , src->width - 2 , src->height -2  , 0, 1);
		__asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (tscl_1Y));

		printf("Sobel en Y de TP1 : %ld \n",tscl_1Y);

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
		asmSobel(src->imageData, dst->imageData , src->width , src->height  , 1, 1);
		__asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (tscl_NXY));

		printf("Sobel en XY de grupo RET : %ld \n",tscl_NXY);

		//Ahora Sobel XY de OpenCV

		__asm__ __volatile__ ("rdtsc;mov %%eax,%0" : : "g" (tscl_EXY));
		cvSobel(src, dst_lib , 1,1,3);
		__asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (tscl_EXY));

		printf("Sobel en XY de OpenCV : %ld \n",tscl_EXY);

		//Ahora Sobel XY de TP1

		__asm__ __volatile__ ("rdtsc;mov %%eax,%0" : : "g" (tscl_1XY));
		asmSobel_tp1(src->imageData, dst->imageData , src->width - 2 , src->height -2  , 1, 1);
		__asm__ __volatile__ ("rdtsc;sub %0,%%eax;mov %%eax,%0" : : "g" (tscl_1XY));

		printf("Sobel en XY de TP1 : %ld \n",tscl_1XY);


		// Imprimo el archivo

		char comando[600];
		sprintf(comando, "echo '%ld, %ld, %ld, %ld, %ld, %ld, %ld, %ld, %ld' >> tabla.xls", tscl_NX, tscl_EX, tscl_1X, tscl_NY, tscl_EY, tscl_1Y, tscl_NXY, tscl_EXY, tscl_1XY);
		system(comando);
				
		
	}
	
	system("echo '' >> tabla.xls");
	system("echo '=AVERAGE(A2:A21), =AVERAGE(C2:C21), =AVERAGE(E2:E21), =AVERAGE(G2:G21), =AVERAGE(I2:I21), =AVERAGE(K2:K21), =AVERAGE(M2:M21), =AVERAGE(O2:O21), =AVERAGE(Q2:Q21)' >> tabla.xls ");
	system("echo '=A23/1000, =C23/1000, =E23/1000, =G23/1000, =I23/1000, =K23/1000, =M23/1000, =O23/1000, =Q23/1000' >> tabla.xls ");

}

