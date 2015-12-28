#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/reg.h>
#include <sys/user.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

//sysfork = 2 / 57
//sysclone = 120 / 56

int main(int argc, char* argv[]) {
  int status;
  pid_t child;

  if (argc <= 1) {
    fprintf(stderr, "Uso: %s commando [argumentos ...]\n", argv[0]);
    exit(1);
  }

  /* Fork en dos procesos */
  child = fork();
  if (child == -1) {
    perror("ERROR fork");
    return 1;
  }

  if (child == 0) {
    /* Solo se ejecuta en el Hijo */
    ptrace(PTRACE_TRACEME, 0, NULL, NULL);

    execvp(argv[1], argv+1);
    /* Si vuelve de exec() hubo un error */
    perror("ERROR child exec(...)");
    exit(1);
  } else {
    /* Solo se ejecuta en el Padre */
    while(1) {
      if (wait(&status) < 0) {
        perror("waitpid");
        break;
      }
      if (WIFEXITED(status))
        break; /* Proceso terminado */

      int sysno = ptrace(PTRACE_PEEKUSER,child,4 * ORIG_EAX,NULL);
      ptrace(PTRACE_SYSCALL, child, NULL, NULL); /* contina */

      // Si es alguna de las syscalls no permitidas, terminamos el proceso
      if(sysno == 120 || sysno == 2 ){
        printf("Syscall prohibida \n");
        ptrace(PTRACE_KILL,child, NULL, NULL);
        break;
      }
    }
    ptrace(PTRACE_DETACH, child, NULL, NULL); /*Liberamos al hijo*/
  }
  return 0;
}
