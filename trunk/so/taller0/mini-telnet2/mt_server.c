#include "mt.h"
int main(){
  int sock, s1, socket_size, n,r1,r2;
  int s2 = 0;	
  struct sockaddr_in name;
  char buf[MAX_MSG_LENGTH];

  /* Crear socket sobre el que se lee. */
  sock = socket(AF_INET, SOCK_STREAM, 0);
  if (sock < 0) {
    perror("abriendo socket");
    exit(1);
  }

  /* Crear nombre, usamos INADDR_ANY para indicar que cualquiera puede enviar aquí. */
  name.sin_family = AF_INET;
  name.sin_addr.s_addr = INADDR_ANY;
  name.sin_port = htons(PORT);

  if (bind(sock, (void*) &name, sizeof(name))) {
    perror("binding datagram socket");
    exit(1);
  }

  /* Escuchar en el socket y permitir 1 conexion en espera. */
  if (listen(sock, 1) == -1) {
    perror("escuchando");
    exit(1);
  }

  /* Aceptar  conexión entrante. */
  socket_size = sizeof(name);
  if ((s1 = accept(sock, (struct sockaddr*) &name, (socklen_t*) &socket_size)) == -1) {
    perror("aceptando la conexión entrante");
    exit(1);
  }
  /* Recibimos mensajes hasta que alguno sea el que marca el final. */
  r1 = dup2(1,s2); // apuntamos s2 al stdout del server para imprimir los comandos
  r2 = dup2(s1,1); // apuntamos el stdout del server al s1
  if(r1 == -1 || r2 == -1){
	    perror("duplicando los files descriptors.");
	}
  for (;;) {
    n = recv(s1, buf, MAX_MSG_LENGTH, 0);
    if (n == 0)
      break;
    if (n < 0) {
      perror("recibiendo");
      exit(1);
    }

    if (strncmp(buf, END_STRING, n) == 0)
      break;

    write(s2, buf, n); // Escribimos en el server, el comando a ejecutar
    system(buf); // Ejecutar el comando en bash
  }
  close(s2);
  close(s1);
  /* Cerrar socket de recepción. */
  close(sock);
  return 0;
}

