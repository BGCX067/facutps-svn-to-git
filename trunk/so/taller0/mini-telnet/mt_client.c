#include "mt.h"

int main(int argc, char *argv[]){
	int s,atonOk;
	struct sockaddr_in remote;
	char str[MAX_MSG_LENGTH];

  if (argc < 2){
    perror("Ingrese direccion IP como parametro del programa.");
    exit(1);
  }
	/* Establecer la dirección a la cual conectarse. */
	remote.sin_family = AF_INET;
	remote.sin_port = htons(PORT);
	atonOk = inet_aton(argv[1], &remote.sin_addr);
	if(atonOk == 0){
		perror("creando direccion ip");
	}

  /* Crear un socket de tipo UNIX con TCP (SOCK_STREAM). */
  if ((s = socket(AF_INET, SOCK_DGRAM, 0)) == -1) {
    perror("creando socket");
    exit(1);
  }

  /* Establecer la dirección a la cual conectarse. */
  remote.sin_family = AF_INET;
  remote.sin_port = htons(PORT);
  inet_aton(argv[1], &remote.sin_addr);

  /* Conectarse. */
  if (connect(s, (struct sockaddr *)&remote, sizeof(remote)) == -1) {
    perror("conectandose");
    exit(1);
  }

  /* Establecer la dirección a la cual conectarse para escuchar. */
  while(printf("> "), fgets(str, MAX_MSG_LENGTH, stdin), !feof(stdin)) {
    if (sendto(s, str, strlen(str)+1, 0, (struct sockaddr *)&remote, sizeof(remote)) == -1) {
      perror("enviando");
      exit(1);
    }
    /* Cerramos la conexion si se envia el comando de salida. */
    if (strncmp(str, END_STRING, MAX_MSG_LENGTH) == 0) {
      printf("cerrando conexion \n");
      break;
    }
  }

  /* Cerrar el socket. */
  close(s);

  return 0;
}
