#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/miscdevice.h>
#include <linux/module.h>
#include <linux/vmalloc.h>
#include <linux/time.h>
#include <linux/proc_fs.h>
#include <asm/uaccess.h>

MODULE_LICENSE("GPL");

// Variables globales
int acum_lecturas = 0;
static struct proc_dir_entry *proc_entry;
static unsigned long prev_fib, prev_fib2;
//static char *input_fibos;
static char *input_semilla;
//Funcion generadora de numeros fibonacci.
unsigned long get_fibona(unsigned long m_w, unsigned long m_z)
{
	unsigned long result = m_w + m_z; 
	prev_fib = m_z;
 	prev_fib2 = (m_z + m_w);
	return result;
}


//Funciones de lectura y escritura invocadas por /proc fs.
int cant_lecturas(char * page, char **start, off_t off, int count, int *eof, void *data)
{
    int len;
    len = sprintf(page, "Lecturas realizadas: %d\n", acum_lecturas);
    return len;
}

static ssize_t fibb_write(struct file *filp, const char __user *buff, unsigned long len, void *data)
{
	printk(KERN_ALERT "anteswss");
	if (len < 3)
        return -EINVAL;
    acum_lecturas++;	
	sscanf(buff, "%d %d", &prev_fib, &prev_fib2);
	int lens;
    /*copy_from_user(&prev_fib, buff, l            proc_entry->read_proc=cant_lecturas;en);
	printk(KERN_ALERT "copyy1: %d\n", prev_fib);
	copy_from_user(&prev_fib2, buff + 4, len);
    lens = simple_strtoul(input_semilla, NULL, 10);
    printk(KERN_INFO "probabilidad: Se ha cambiado la semilla\n");
	*/
    return len;
}

//Funciones de lectura invocada por /dev fs
static ssize_t fibb_read(struct file *file, char *buf, size_t count, loff_t *ppos)
{

	
    unsigned int next_fib;
	unsigned int random_pos;
    char *probabilidad_str;
    char random_letter;
    int len;

	char buffer[4];
	
    
    probabilidad_str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    random_letter = probabilidad_str[3];

	next_fib = get_fibona(prev_fib, prev_fib2);

/*
	//sprintf(buffer, "%lu", next_fib);
	count = 1;	

    //if (count < len) return -EINVAL;
    if (*ppos !=0 ){
 			return 0;
	}
    if (copy_to_user(buf, &next_fib, 4))
        return -EINVAL;
*/

    *ppos = 4;
    acum_lecturas++;
    printk(KERN_ALERT "probabilidad: Se ha utilizado la semilla %lu\n", simple_strtoul(input_semilla, NULL, 10));
    return sprintf(buf, "%d", next_fib);
}

// Estructuras utililizadas por la funcion de registro de dispositivos
static const struct file_operations fibb_fops = {
    .owner = THIS_MODULE,
    .read = fibb_read,
	.write = fibb_write
};

static struct miscdevice fibb_dev = {
    MISC_DYNAMIC_MINOR,
    "fibbo",
    &fibb_fops
};

// Funciones utilizadas por la creacion y destruccion del modulo
static int __init fibb_init(void) {
    int ret, prec_random;
    // Registración del device
    ret = misc_register(&fibb_dev);
    if (ret)
    {
        printk(KERN_ERR "No se puede registrar el dispositivo FIBB\n");
    } else
    {
        // Inicializacion de la semilla del random
        struct timespec tv;
        getnstimeofday(&tv);
        prec_random=tv.tv_nsec;
		prev_fib = 0;
		prev_fib2 = 1;
        input_semilla= (char *) vmalloc(PAGE_SIZE);
        memset(input_semilla, 65, PAGE_SIZE);

        // Definicion de la entrada en /proc con la asociacion de funciones de lectura y escritura
        proc_entry = create_proc_entry("fibbo", 0644, NULL);
        if (proc_entry == NULL)
        {
            printk(KERN_INFO "fibbo: No se pudo crear la entrada en /proc\n");
        } else
        {
            proc_entry->read_proc=cant_lecturas;
//            proc_entry->write_proc=cambiar_semilla;
        }
    }
    return ret;
}

static void __exit fibb_exit(void) {
    remove_proc_entry("fibbo", proc_entry);
    vfree(input_semilla);
    misc_deregister(&fibb_dev);
}

// Definicion de constructor y destructor del modulo.
module_init(fibb_init);
module_exit(fibb_exit);

// Todo esto se usa con "echo SEED > /proc/probabilidad"  y "cat /proc/probabilidad"
// para poner la nueva semilla y para ver la cantidad de lecturas realizadas.
// Y con "cat /dev/probabilidad" para ver la letra aleatoria generada.


