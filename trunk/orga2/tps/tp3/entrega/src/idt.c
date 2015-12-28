#include "isr.h"
#include "idt.h"


/*
 * Metodo para inicializar los descriptores de la IDT 
 */
void idtFill() {
	idt[0].offset_0_15 = (unsigned short) ((unsigned int)(&_isr0) & (unsigned int) 0xFFFF); \
	idt[0].segsel = (unsigned short) 0x0008; \
	idt[0].attr = (unsigned short) 0x8E00; \
	idt[0].offset_16_31 = (unsigned short) ((unsigned int)(&_isr0) >> 16 & (unsigned int) 0xFFFF);
	
	idt[1].offset_0_15 = (unsigned short) ((unsigned int)(&_isr1) & (unsigned int) 0xFFFF); \
	idt[1].segsel = (unsigned short) 0x0008; \
	idt[1].attr = (unsigned short) 0x8E00; \
	idt[1].offset_16_31 = (unsigned short) ((unsigned int)(&_isr1) >> 16 & (unsigned int) 0xFFFF);
	
	idt[2].offset_0_15 = (unsigned short) ((unsigned int)(&_isr2) & (unsigned int) 0xFFFF); \
	idt[2].segsel = (unsigned short) 0x0008; \
	idt[2].attr = (unsigned short) 0x8E00; \
	idt[2].offset_16_31 = (unsigned short) ((unsigned int)(&_isr2) >> 16 & (unsigned int) 0xFFFF);
	
	idt[3].offset_0_15 = (unsigned short) ((unsigned int)(&_isr3) & (unsigned int) 0xFFFF); \
	idt[3].segsel = (unsigned short) 0x0008; \
	idt[3].attr = (unsigned short) 0x8E00; \
	idt[3].offset_16_31 = (unsigned short) ((unsigned int)(&_isr3) >> 16 & (unsigned int) 0xFFFF);
	
	idt[4].offset_0_15 = (unsigned short) ((unsigned int)(&_isr4) & (unsigned int) 0xFFFF); \
	idt[4].segsel = (unsigned short) 0x0008; \
	idt[4].attr = (unsigned short) 0x8E00; \
	idt[4].offset_16_31 = (unsigned short) ((unsigned int)(&_isr4) >> 16 & (unsigned int) 0xFFFF);
	
	idt[5].offset_0_15 = (unsigned short) ((unsigned int)(&_isr5) & (unsigned int) 0xFFFF); \
	idt[5].segsel = (unsigned short) 0x0008; \
	idt[5].attr = (unsigned short) 0x8E00; \
	idt[5].offset_16_31 = (unsigned short) ((unsigned int)(&_isr5) >> 16 & (unsigned int) 0xFFFF);
	
	idt[6].offset_0_15 = (unsigned short) ((unsigned int)(&_isr6) & (unsigned int) 0xFFFF); \
	idt[6].segsel = (unsigned short) 0x0008; \
	idt[6].attr = (unsigned short) 0x8E00; \
	idt[6].offset_16_31 = (unsigned short) ((unsigned int)(&_isr6) >> 16 & (unsigned int) 0xFFFF);
	
	idt[7].offset_0_15 = (unsigned short) ((unsigned int)(&_isr7) & (unsigned int) 0xFFFF); \
	idt[7].segsel = (unsigned short) 0x0008; \
	idt[7].attr = (unsigned short) 0x8E00; \
	idt[7].offset_16_31 = (unsigned short) ((unsigned int)(&_isr7) >> 16 & (unsigned int) 0xFFFF);
	
	idt[8].offset_0_15 = (unsigned short) ((unsigned int)(&_isr8) & (unsigned int) 0xFFFF); \
	idt[8].segsel = (unsigned short) 0x0008; \
	idt[8].attr = (unsigned short) 0x8E00; \
	idt[8].offset_16_31 = (unsigned short) ((unsigned int)(&_isr8) >> 16 & (unsigned int) 0xFFFF);
	
	idt[9].offset_0_15 = (unsigned short) ((unsigned int)(&_isr9) & (unsigned int) 0xFFFF); \
	idt[9].segsel = (unsigned short) 0x0008; \
	idt[9].attr = (unsigned short) 0x8E00; \
	idt[9].offset_16_31 = (unsigned short) ((unsigned int)(&_isr9) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x0a].offset_0_15 = (unsigned short) ((unsigned int)(&_isr0a) & (unsigned int) 0xFFFF); \
	idt[0x0a].segsel = (unsigned short) 0x0008; \
	idt[0x0a].attr = (unsigned short) 0x8E00; \
	idt[0x0a].offset_16_31 = (unsigned short) ((unsigned int)(&_isr0a) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x0b].offset_0_15 = (unsigned short) ((unsigned int)(&_isr0b) & (unsigned int) 0xFFFF); \
	idt[0x0b].segsel = (unsigned short) 0x0008; \
	idt[0x0b].attr = (unsigned short) 0x8E00; \
	idt[0x0b].offset_16_31 = (unsigned short) ((unsigned int)(&_isr0b) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x0c].offset_0_15 = (unsigned short) ((unsigned int)(&_isr0c) & (unsigned int) 0xFFFF); \
	idt[0x0c].segsel = (unsigned short) 0x0008; \
	idt[0x0c].attr = (unsigned short) 0x8E00; \
	idt[0x0c].offset_16_31 = (unsigned short) ((unsigned int)(&_isr0c) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x0d].offset_0_15 = (unsigned short) ((unsigned int)(&_isr0d) & (unsigned int) 0xFFFF); \
	idt[0x0d].segsel = (unsigned short) 0x0008; \
	idt[0x0d].attr = (unsigned short) 0x8E00; \
	idt[0x0d].offset_16_31 = (unsigned short) ((unsigned int)(&_isr0d) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x0e].offset_0_15 = (unsigned short) ((unsigned int)(&_isr0e) & (unsigned int) 0xFFFF); \
	idt[0x0e].segsel = (unsigned short) 0x0008; \
	idt[0x0e].attr = (unsigned short) 0x8E00; \
	idt[0x0e].offset_16_31 = (unsigned short) ((unsigned int)(&_isr0e) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x0f].offset_0_15 = (unsigned short) ((unsigned int)(&_isr0f) & (unsigned int) 0xFFFF); \
	idt[0x0f].segsel = (unsigned short) 0x0008; \
	idt[0x0f].attr = (unsigned short) 0x8E00; \
	idt[0x0f].offset_16_31 = (unsigned short) ((unsigned int)(&_isr0f) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x10].offset_0_15 = (unsigned short) ((unsigned int)(&_isr10) & (unsigned int) 0xFFFF); \
	idt[0x10].segsel = (unsigned short) 0x0008; \
	idt[0x10].attr = (unsigned short) 0x8E00; \
	idt[0x10].offset_16_31 = (unsigned short) ((unsigned int)(&_isr10) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x11].offset_0_15 = (unsigned short) ((unsigned int)(&_isr11) & (unsigned int) 0xFFFF); \
	idt[0x11].segsel = (unsigned short) 0x0008; \
	idt[0x11].attr = (unsigned short) 0x8E00; \
	idt[0x11].offset_16_31 = (unsigned short) ((unsigned int)(&_isr11) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x12].offset_0_15 = (unsigned short) ((unsigned int)(&_isr12) & (unsigned int) 0xFFFF); \
	idt[0x12].segsel = (unsigned short) 0x0008; \
	idt[0x12].attr = (unsigned short) 0x8E00; \
	idt[0x12].offset_16_31 = (unsigned short) ((unsigned int)(&_isr12) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x13].offset_0_15 = (unsigned short) ((unsigned int)(&_isr13) & (unsigned int) 0xFFFF); \
	idt[0x13].segsel = (unsigned short) 0x0008; \
	idt[0x13].attr = (unsigned short) 0x8E00; \
	idt[0x13].offset_16_31 = (unsigned short) ((unsigned int)(&_isr13) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x14].offset_0_15 = (unsigned short) ((unsigned int)(&_isr14) & (unsigned int) 0xFFFF); \
	idt[0x14].segsel = (unsigned short) 0x0008; \
	idt[0x14].attr = (unsigned short) 0x8E00; \
	idt[0x14].offset_16_31 = (unsigned short) ((unsigned int)(&_isr14) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x15].offset_0_15 = (unsigned short) ((unsigned int)(&_isr15) & (unsigned int) 0xFFFF); \
	idt[0x15].segsel = (unsigned short) 0x0008; \
	idt[0x15].attr = (unsigned short) 0x8E00; \
	idt[0x15].offset_16_31 = (unsigned short) ((unsigned int)(&_isr15) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x16].offset_0_15 = (unsigned short) ((unsigned int)(&_isr16) & (unsigned int) 0xFFFF); \
	idt[0x16].segsel = (unsigned short) 0x0008; \
	idt[0x16].attr = (unsigned short) 0x8E00; \
	idt[0x16].offset_16_31 = (unsigned short) ((unsigned int)(&_isr16) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x17].offset_0_15 = (unsigned short) ((unsigned int)(&_isr17) & (unsigned int) 0xFFFF); \
	idt[0x17].segsel = (unsigned short) 0x0008; \
	idt[0x17].attr = (unsigned short) 0x8E00; \
	idt[0x17].offset_16_31 = (unsigned short) ((unsigned int)(&_isr17) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x18].offset_0_15 = (unsigned short) ((unsigned int)(&_isr18) & (unsigned int) 0xFFFF); \
	idt[0x18].segsel = (unsigned short) 0x0008; \
	idt[0x18].attr = (unsigned short) 0x8E00; \
	idt[0x18].offset_16_31 = (unsigned short) ((unsigned int)(&_isr18) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x19].offset_0_15 = (unsigned short) ((unsigned int)(&_isr19) & (unsigned int) 0xFFFF); \
	idt[0x19].segsel = (unsigned short) 0x0008; \
	idt[0x19].attr = (unsigned short) 0x8E00; \
	idt[0x19].offset_16_31 = (unsigned short) ((unsigned int)(&_isr19) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x1a].offset_0_15 = (unsigned short) ((unsigned int)(&_isr1a) & (unsigned int) 0xFFFF); \
	idt[0x1a].segsel = (unsigned short) 0x0008; \
	idt[0x1a].attr = (unsigned short) 0x8E00; \
	idt[0x1a].offset_16_31 = (unsigned short) ((unsigned int)(&_isr1a) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x1b].offset_0_15 = (unsigned short) ((unsigned int)(&_isr1b) & (unsigned int) 0xFFFF); \
	idt[0x1b].segsel = (unsigned short) 0x0008; \
	idt[0x1b].attr = (unsigned short) 0x8E00; \
	idt[0x1b].offset_16_31 = (unsigned short) ((unsigned int)(&_isr1b) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x1c].offset_0_15 = (unsigned short) ((unsigned int)(&_isr1c) & (unsigned int) 0xFFFF); \
	idt[0x1c].segsel = (unsigned short) 0x0008; \
	idt[0x1c].attr = (unsigned short) 0x8E00; \
	idt[0x1c].offset_16_31 = (unsigned short) ((unsigned int)(&_isr1c) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x1d].offset_0_15 = (unsigned short) ((unsigned int)(&_isr1d) & (unsigned int) 0xFFFF); \
	idt[0x1d].segsel = (unsigned short) 0x0008; \
	idt[0x1d].attr = (unsigned short) 0x8E00; \
	idt[0x1d].offset_16_31 = (unsigned short) ((unsigned int)(&_isr1d) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x1e].offset_0_15 = (unsigned short) ((unsigned int)(&_isr1e) & (unsigned int) 0xFFFF); \
	idt[0x1e].segsel = (unsigned short) 0x0008; \
	idt[0x1e].attr = (unsigned short) 0x8E00; \
	idt[0x1e].offset_16_31 = (unsigned short) ((unsigned int)(&_isr1e) >> 16 & (unsigned int) 0xFFFF);
	
	idt[0x1f].offset_0_15 = (unsigned short) ((unsigned int)(&_isr1f) & (unsigned int) 0xFFFF); \
	idt[0x1f].segsel = (unsigned short) 0x0008; \
	idt[0x1f].attr = (unsigned short) 0x8E00; \
	idt[0x1f].offset_16_31 = (unsigned short) ((unsigned int)(&_isr1f) >> 16 & (unsigned int) 0xFFFF);
	
	idt[32].offset_0_15 = (unsigned short) ((unsigned int)(&_isr32) & (unsigned int) 0xFFFF); \
	idt[32].segsel = (unsigned short) 0x0008; \
	idt[32].attr = (unsigned short) 0x8E00; \
	idt[32].offset_16_31 = (unsigned short) ((unsigned int)(&_isr32) >> 16 & (unsigned int) 0xFFFF);
	
	
	idt[33].offset_0_15 = (unsigned short) ((unsigned int)(&_isr33) & (unsigned int) 0xFFFF); \
	idt[33].segsel = (unsigned short) 0x0008; \
	idt[33].attr = (unsigned short) 0x8E00; \
	idt[33].offset_16_31 = (unsigned short) ((unsigned int)(&_isr33) >> 16 & (unsigned int) 0xFFFF);
	
}

/*
 * IDT
 */ 
idt_entry idt[34] = {};

/*
 * Descriptor de la IDT (para cargar en IDTR)
 */
idt_descriptor IDT_DESC = {sizeof(idt)-1, (unsigned int)&idt};

