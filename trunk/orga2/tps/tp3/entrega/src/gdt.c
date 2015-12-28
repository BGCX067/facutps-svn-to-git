#include "gdt.h"
#include "tss.h"


/*
 * Definicion de la GDT
 */
gdt_entry gdt[GDT_COUNT] = {
	/* Descriptor nulo*/
	(gdt_entry){ 
		(unsigned short) 0x0000, 
		(unsigned short) 0x0000,
		(unsigned char) 0x00, 
		(unsigned char) 0x0, 
		(unsigned char) 0, 
		(unsigned char) 0, 
		(unsigned char) 0, 
		(unsigned char) 0x0000,
		(unsigned char) 0,  
		(unsigned char) 0,  
		(unsigned char) 0,  
		(unsigned char) 0, 
		(unsigned char) 0x00 
	},
	
	
	(gdt_entry){ 
		(unsigned short) 0xFFFF, 
		(unsigned short) 0x0000,
		(unsigned char) 0x00, 
		(unsigned char) 10, 
		(unsigned char) 1, 
		(unsigned char) 0, 
		(unsigned char) 1, 
		(unsigned char) 15,
		(unsigned char) 0,  
		(unsigned char) 0,  
		(unsigned char) 1,  
		(unsigned char) 1, 
		(unsigned char) 0x00 
	},//esta es la de codigo
	
	(gdt_entry){ 
		(unsigned short) 0xFFFF, 
		(unsigned short) 0x0000,
		(unsigned char) 0x00, 
		(unsigned char) 2, 
		(unsigned char) 1, 
		(unsigned char) 0, 
		(unsigned char) 1, 
		(unsigned char) 15,
		(unsigned char) 0,  
		(unsigned char) 0,  
		(unsigned char) 0,  
		(unsigned char) 0, 
		(unsigned char) 0x00 
	},//esta es la de datos
    	
/// datos de video b=0x000b8000 l=0xfffff
	(gdt_entry){ 
		(unsigned short) 0xFFFF, 
		(unsigned short) 0x80000,
		(unsigned char) 0x0B, 
		(unsigned char) 2, 
		(unsigned char) 1, 
		(unsigned char) 0, 
		(unsigned char) 1, 
		(unsigned char) 15,
		(unsigned char) 0,  
		(unsigned char) 0,  
		(unsigned char) 1,  
		(unsigned char) 1, 
		(unsigned char) 0x00 
	},
};

/*
 * Definicion del GDTR
 */ 
	gdt_descriptor GDT_DESC = {sizeof(gdt)-1, (unsigned int)&gdt};
