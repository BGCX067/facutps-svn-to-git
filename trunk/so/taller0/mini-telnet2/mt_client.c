#include "mt.h"
#include <ctype.h>

int isEmpty(char [MAX_MSG_LENGTH], size_t);

int main(int argc, char *argv[]){
  if (argc < 2){
    perror("Ingrese direccion IP como parametro del programa.");
    exit(1);
  }

  int socket_fd,n;
  struct sockaddr_in remote;
  char str[MAX_MSG_LENGTH];

  /* Crear un socket de tipo UNIX con TCP (SOCK_STREAM). */
  if ((socket_fd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
    perror("creando socket");
    exit(1);
  }

  /* Establecer la dirección a la cual conectarse. */
  remote.sin_family = AF_INET;
  remote.sin_port = htons(PORT);
  inet_aton(argv[1], &remote.sin_addr);

  /* Conectarse. */
  if (connect(socket_fd, (struct sockaddr *)&remote, sizeof(remote)) == -1) {
    perror("conectandose");
    exit(1);
  }

  /* Establecer la dirección a la cual conectarse para escuchar. */
  while(printf("> "), fgets(str, MAX_MSG_LENGTH, stdin), !feof(stdin)) {
    if (!isEmpty(str, strlen(str))){
      /* Enviar comando a ejecutar, solo si existe uno. */
      if (send(socket_fd, str, strlen(str)+1 , 0)==-1) {
        perror("error mandando");
        exit(1);
      }
      /* Si el comando es un END_STRING deja de leer el input. */
      if (strncmp(str, END_STRING, strlen(str)+1) == 0) {
        printf("cerrando conexion \n");
        break;
      }

      /* Leer respuesta del servidor */
      n = recv(socket_fd, str, MAX_MSG_LENGTH, 0);
      str[n] = '\0';
      printf("%s", str);
    }
  }

  /* Cerrar el socket. */
  close(socket_fd);

  return 0;
}

/* Verifica si un string es vacio */
int isEmpty(char str[MAX_MSG_LENGTH], size_t str_size){
  unsigned int i=0;
  while(i < str_size && isspace(str[i]))
    i++;

  return i == str_size;
}
