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
MODULE_AUTHOR("Alejandro Mataloni, Emiliano Mancuso");
MODULE_DESCRIPTION("Taller 3: char device driver");

// Variables globales
int acum_lecturas = 0;
static struct proc_dir_entry *proc_entry;
unsigned int prev_fib, prev_fib2;
static char *input_fibos;

//Funcion generadora de numeros aleatorios.
unsigned int get_fibonacci(unsigned int m_w, unsigned int m_z)
{
  return (m_z + m_w);
}

//Funciones de lectura y escritura invocadas por /proc fs.
int cant_lecturas(char * page, char **start, off_t off, int count, int *eof, void *data)
{
  int len;
  len = sprintf(page, "Lecturas/Escrituras realizadas: %d\n", acum_lecturas);
  return len;
}

static ssize_t fibonacci_write(struct file *filp, const char __user *buff, unsigned long len, void *data)
{
  printk(KERN_ALERT "fibonacci: cambiamos el inicio de la sucesion");
  if (len < 3)
    return -EINVAL;
  acum_lecturas++;
  sscanf(buff, "%d %d", &prev_fib2, &prev_fib);
  return len;
}

//Funciones de lectura invocada por /dev fs
static ssize_t fibonacci_read(struct file *file, char *buf, size_t count, loff_t *ppos)
{
  unsigned int next_fib;
  int len;

  next_fib = get_fibonacci(prev_fib, prev_fib2);
  prev_fib2 = prev_fib;
  prev_fib = next_fib;

  len = sprintf(buf,"%d",next_fib);

  *ppos = len;
  acum_lecturas++;
  return len;
}

// Estructuras utililizadas por la funcion de registro de dispositivos
static const struct file_operations fibonacci_fops = {
  .owner = THIS_MODULE,
  .read = fibonacci_read,
  .write = fibonacci_write
};

static struct miscdevice fibonacci_dev = {
  MISC_DYNAMIC_MINOR,
  "fibonacci",
  &fibonacci_fops
};

// Funciones utilizadas por la creacion y destruccion del modulo
static int __init fibonacci_init(void) {
  int ret;
  // Registración del device
  ret = misc_register(&fibonacci_dev);
  if (ret)
    printk(KERN_ERR "No se puede registrar el dispositivo FIBONACCI\n");
  else{
    input_fibos= (char *) vmalloc(PAGE_SIZE);
    memset(input_fibos, 0, PAGE_SIZE);
    prev_fib=1;
    prev_fib2=0;
    // Definicion de la entrada en /proc con la asociacion de funciones de lectura y escritura
    proc_entry = create_proc_entry("fibonacci", 0644, NULL);
    if (proc_entry == NULL)
      printk(KERN_INFO "fibonacci: No se pudo crear la entrada en /proc\n");
    else
      proc_entry->read_proc=cant_lecturas;
  }
  return ret;
}

static void __exit fibonacci_exit(void) {
  remove_proc_entry("fibonacci", proc_entry);
  vfree(input_fibos);
  misc_deregister(&fibonacci_dev);
}

// Definicion de constructor y destructor del modulo.
module_init(fibonacci_init);
module_exit(fibonacci_exit);

// Todo esto se usa con "echo SEED > /proc/probabilidad"  y "cat /proc/probabilidad"
// para poner la nueva semilla y para ver la cantidad de lecturas realizadas.
// Y con "cat /dev/probabilidad" para ver la letra aleatoria generada.

