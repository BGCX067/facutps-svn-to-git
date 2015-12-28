#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

static int __init hello_init(void) {
printk(KERN_ALERT "Hola, Sistemas Operativos!\n");
return 0;
}

static void __exit hello_exit(void) {
printk(KERN_ALERT "Adios, mundo cruel...\n");
}

static void  hello_saludo(void) {
printk(KERN_ALERT "Saludandooo...\n");
}


module_init(hello_init);
module_exit(hello_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Pablo Antonio");
MODULE_DESCRIPTION("Una suerte de ’Hola, mundo’");

