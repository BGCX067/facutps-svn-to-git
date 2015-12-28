
#include <klib.h>


#define MEM_VIDEO 0xB8000 

//unsigned char const *mem_video =(unsigned char *) 0xB8000;
//80 col x 25 filas

void print(char *str, short fila, short col){
    unsigned char *mem_video2 =(unsigned char *) MEM_VIDEO;
	mem_video2 += 160 * fila + 2 * col;
	while(*str != '\0'){
		*mem_video2++ = *str;
		*mem_video2++ = 0x07; /* format byte, white on black */	
		str++;
	}
}

void clear(){
    int f,c;
    unsigned char *mem_video2 =(unsigned char *) MEM_VIDEO;
    for(f = 0; f <= 25 ; f++){
        for(c = 0 ; c <= 80 ; c++){
           	*mem_video2++ = ' ';
		    *mem_video2++ = 0xFF; /* format byte, white on black */	
        }
    }
}
	
