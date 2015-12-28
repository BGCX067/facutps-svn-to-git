#include <signal.h>
#include <errno.h>

#include "biblioteca.h"

pthread_mutex_t mutexAula;
pthread_mutex_t mutexRescatista;
pthread_cond_t  rescatista_cv;

/* Estructura que almacena los datos de una reserva. */
typedef struct {
  int posiciones[ANCHO_AULA][ALTO_AULA];
  int cantidad_de_personas;

  int rescatistas_disponibles;
} t_aula;

//estructura creada para pasarle los parametros a la funcion que se llama cuando se inicia el thread
typedef struct {
  int socket_fd;
  t_aula *el_aula;
} t_arguments;

void t_aula_iniciar_vacia(t_aula *un_aula) {
  int i, j;
  for(i = 0; i < ANCHO_AULA; i++) {
    for (j = 0; j < ALTO_AULA; j++) {
      un_aula->posiciones[i][j] = 0;
    }
  }

  un_aula->cantidad_de_personas = 0;
  un_aula->rescatistas_disponibles = RESCATISTAS;
}

void t_aula_ingresar(t_aula *un_aula, t_persona *alumno) {
  //utilizamos el mutex para controlar el acceso a la memoria
  pthread_mutex_lock(&mutexAula);

  un_aula->cantidad_de_personas++;
  un_aula->posiciones[alumno->posicion_fila][alumno->posicion_columna]++;

  pthread_mutex_unlock(&mutexAula);
}

void t_aula_liberar(t_aula *un_aula, t_persona *alumno) {
  //utilizamos el mutex para controlar el acceso a la memoria
  pthread_mutex_lock(&mutexAula);

  un_aula->cantidad_de_personas--;
  un_aula->posiciones[alumno->posicion_fila][alumno->posicion_columna]--;

  pthread_mutex_unlock(&mutexAula);
}

static void terminar_servidor_de_alumno(int socket_fd, t_aula *aula, t_persona *alumno) {
  printf(">> Se interrumpió la comunicación con una consola.\n");

  close(socket_fd);

  t_aula_liberar(aula, alumno);
  exit(-1);
}


t_comando intentar_moverse(t_aula *el_aula, t_persona *alumno, t_direccion dir) {
  int fila = alumno->posicion_fila;
  int columna = alumno->posicion_columna;
  alumno->salio = direccion_moverse_hacia(dir, &fila, &columna);

  ///char buf[STRING_MAXIMO];
  ///t_direccion_convertir_a_string(dir, buf);
  ///printf("%s intenta moverse hacia %s (%d, %d)... ", alumno->nombre, buf, fila, columna);

  bool entre_limites = (fila >= 0) && (columna >= 0) &&
       (fila < ALTO_AULA) && (columna < ANCHO_AULA);

  //utilizamos el mutex para controlar el acceso a la memoria
  pthread_mutex_lock(&mutexAula);

  bool pudo_moverse = alumno->salio ||
      (entre_limites && el_aula->posiciones[fila][columna] < MAXIMO_POR_POSICION);

  if (pudo_moverse) {
    if (!alumno->salio)
      el_aula->posiciones[fila][columna]++;

    el_aula->posiciones[alumno->posicion_fila][alumno->posicion_columna]--;
    alumno->posicion_fila = fila;
    alumno->posicion_columna = columna;
  }

  pthread_mutex_unlock(&mutexAula);

  //~ if (pudo_moverse)
    //~ printf("OK!\n");
  //~ else
    //~ printf("Ocupado!\n");


  return pudo_moverse;
}

void colocar_mascara(t_aula *el_aula, t_persona *alumno) {
  printf("Esperando rescatista. Ya casi %s!\n", alumno->nombre);

  //mutex para la variable compartida
  pthread_mutex_lock(&mutexRescatista);
  while(el_aula->rescatistas_disponibles < 1){
    /*si no hay rescatistas hacemos una espera hasta que se libere
      cuando se despierta pregunta de nuevo si hay rescatistas.*/
    pthread_cond_wait(&rescatista_cv, &mutexRescatista);
  }
  el_aula->rescatistas_disponibles--;

  pthread_mutex_unlock(&mutexRescatista);
  alumno->tiene_mascara = true;
  pthread_mutex_lock(&mutexRescatista);

  el_aula->rescatistas_disponibles++;
  //hago el signal para despertar si hay alguno esperando
  pthread_cond_signal(&rescatista_cv);
  pthread_mutex_unlock(&mutexRescatista);
}


void *atendedor_de_alumno(void *threadarg) {

  //pasamos la informacion desde el struct utilizado a variables
  t_arguments *my_data;
  my_data = (t_arguments *) threadarg;
  int socket_fd = my_data->socket_fd;
  t_aula *el_aula = my_data->el_aula;

  t_persona alumno;
  t_persona_inicializar(&alumno);

  if (recibir_nombre_y_posicion(socket_fd, &alumno) != 0) {
    /* O la consola cortó la comunicación, o hubo un error. Cerramos todo. */
    terminar_servidor_de_alumno(socket_fd, NULL, NULL);
  }

  printf("Atendiendo a %s en la posicion (%d, %d)\n",
      alumno.nombre, alumno.posicion_fila, alumno.posicion_columna);

  t_aula_ingresar(el_aula, &alumno);

  /// Loop de espera de pedido de movimiento.
  for(;;) {
    t_direccion direccion;

    /// Esperamos un pedido de movimiento.
    if (recibir_direccion(socket_fd, &direccion) != 0) {
      /* O la consola cortó la comunicación, o hubo un error. Cerramos todo. */
      terminar_servidor_de_alumno(socket_fd, el_aula, &alumno);
    }

    /// Tratamos de movernos en nuestro modelo
    bool pudo_moverse = intentar_moverse(el_aula, &alumno, direccion);

    printf("%s se movio a: (%d, %d)\n", alumno.nombre, alumno.posicion_fila, alumno.posicion_columna);

    /// Avisamos que ocurrio
    enviar_respuesta(socket_fd, pudo_moverse ? OK : OCUPADO);
    //printf("aca3\n");

    if (alumno.salio)
      break;
  }

  colocar_mascara(el_aula, &alumno);

  t_aula_liberar(el_aula, &alumno);
  enviar_respuesta(socket_fd, LIBRE);

  printf("Listo, %s es libre!\n", alumno.nombre);

  return NULL;
}


int main(void) {
  int nose;
  //signal(SIGUSR1, signal_terminar);
  int socketfd_cliente, socket_servidor, socket_size;
  int rc;
  struct sockaddr_in local, remoto;
  //struct para pasarle la informacion a la funcion del thread
  t_arguments *arguments;
  pthread_t threadId;

  /* Crear un socket de tipo INET con TCP (SOCK_STREAM). */
  if ((socket_servidor = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
    perror("creando socket");
  }

  /* Crear nombre, usamos INADDR_ANY para indicar que cualquiera puede conectarse aquí. */
  local.sin_family = AF_INET;
  local.sin_addr.s_addr = INADDR_ANY;
  local.sin_port = htons(PORT);

  // Solucion a la espera de liberacion de sockets
  setsockopt(socket_servidor, SOL_SOCKET, SO_REUSEADDR, &nose, sizeof(nose));

  if (bind(socket_servidor, (struct sockaddr *)&local, sizeof(local)) == -1) {
    perror("haciendo bind");
  }

  /* Escuchar en el socket y permitir 5 conexiones en espera. */
  if (listen(socket_servidor, 5) == -1) {
    perror("escuchando");
  }

  t_aula el_aula;
  t_aula_iniciar_vacia(&el_aula);

  /// Aceptar conexiones entrantes.
  socket_size = sizeof(remoto);
  for(;;){
    if (-1 == (socketfd_cliente = accept(socket_servidor, (struct sockaddr*) &remoto, (socklen_t*) &socket_size))){
      printf("!! Error al aceptar conexion\n");
    }
    else{

      //pedimos, mediante malloc, memoria para un nuevo t_argument
      arguments = malloc(sizeof(t_arguments));

      if(arguments == NULL){
        printf("ERROR; not enough memory to be allocated");
        return -1;
       }

      //guardamos la informacion en el struct
      arguments->socket_fd = socketfd_cliente;
      arguments->el_aula = &el_aula;

      //creamos un nuevo thread
      rc = pthread_create(&threadId, NULL, atendedor_de_alumno, (void *) arguments);
      if (rc){
        printf("ERROR; return code from pthread_create() is %d\n", rc);
        exit(-1);
      }
    }
  }
  return 0;
}
