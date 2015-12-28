#include <linux/module.h>     /* needed by all modules */
#include <linux/init.h>     /* needed for macros */
#include <linux/kernel.h>     /* needed for printk */


MODULE_LICENSE("GPL");
MODULE_AUTHOR(" Prabu Surendra, [surendra_prabu@emc.com]");
MODULE_DESCRIPTION("Hello World  Module");


int my_entry_fn_name()
{
    printk(KERN_INFO "Hello World \n");
    return 0;         /* return zero on successful loading*/
}

void my_exit_fn_name()
{
    printk(KERN_INFO "Good Bye World \n");
}

module_init(my_entry_fn_name);
modue_exit(my_exit_fn_name);

