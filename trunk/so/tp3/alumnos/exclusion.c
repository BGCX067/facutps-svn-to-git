#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mpi.h"

#define TAG_TERMINO      14
#define TAG_SERVPED      13
#define TAG_SERVRES      12
#define TAG_PEDIDO       11
#define TAG_LIBERO       10
#define FALSE 0
#define TRUE  1

/* Variables globales. */
int np, rank;                   /* Variables de MPI. */
static MPI_Comm igualesami;     /* Communicator para todos los clientes (sincronizar ejec. de programas exclusion) */


void servidorcontrol(int micliente) {
   MPI_Status status;
   int origen, tag;
   int cantserv= np/2;   // np = #servers y clientes

   /* Variables utilizadas por los servidores */
   int seqnrorecibida;

   int aux;
   int ourSeqNumber = 0;
   int highestSeqNum = 0;
   int outstandingReplycount;
   char requestingCriticalSection = FALSE;
   char replyDeferred[cantserv];
   char deferIt;


   // Inicializamos el replyDeferred
   for(aux=0; aux < cantserv; aux++)
     replyDeferred[0] = FALSE;

   while (1){
      MPI_Recv(&seqnrorecibida, 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
      origen=status.MPI_SOURCE;
      tag=status.MPI_TAG;

      // Interaccion con Clientes
      if (tag == TAG_PEDIDO)  {
        requestingCriticalSection = TRUE;
        outstandingReplycount = cantserv - 1;
        ourSeqNumber = highestSeqNum + 1;

        for(aux=0; aux < cantserv; aux++)
          if (aux*2 != micliente-1)
            MPI_Send(&ourSeqNumber, 1, MPI_INT, aux*2, TAG_SERVPED, MPI_COMM_WORLD);

        continue;
      }

      if (tag == TAG_LIBERO) {
        requestingCriticalSection = FALSE;
        for(aux=0; aux < cantserv; aux++){
          if(replyDeferred[aux]){
            replyDeferred[aux] = FALSE;
            MPI_Send(&ourSeqNumber, 1, MPI_INT, aux*2, TAG_SERVRES, MPI_COMM_WORLD);
          }
        }
        continue;
      }

      // Si es TAG_TERMINO
      if (tag == TAG_TERMINO) {
        printf("Servidor %d: Mi cliente me pidio terminar.\n",rank/2);
        break;
      }

      // Interaccion con servidores
      if(tag == TAG_SERVPED) {
        // Actualizamos el numero mas grande con cada pedido.
        highestSeqNum = (highestSeqNum > seqnrorecibida)? highestSeqNum : seqnrorecibida;

        // Definimos si respondemos los pedidos ahora o luego.
        deferIt = requestingCriticalSection && (( seqnrorecibida > ourSeqNumber) ||
                  ((seqnrorecibida == ourSeqNumber) && (origen > micliente-1)));

        if (deferIt)
          replyDeferred[origen/2] = TRUE;
        else
          MPI_Send(&ourSeqNumber, 1, MPI_INT, origen, TAG_SERVRES, MPI_COMM_WORLD);

        continue;
      }

      if(tag == TAG_SERVRES){
        if(--outstandingReplycount == 0)
          MPI_Send(&ourSeqNumber, 1, MPI_INT, micliente, TAG_PEDIDO, MPI_COMM_WORLD);

        continue;
      }
   }
   MPI_Barrier(MPI_COMM_WORLD);
}

void cliente(int miserv) {
  int env=-1;
  FILE *fichero;
  char linea[82];
  char nombre[10] = "datos";
  char comando[4][10] = {"pedir","liberar", "escribir", "nada"};
  char seccion_critica = FALSE;
  MPI_Status status;

  /* Abro el archivo que me indica los pasos a seguir.
           Se enumeran los archivos de clientes de 0 a n sin tomar en cuenta los servidores */
  sprintf(nombre,"datos%d.txt",rank/2);
  fichero=fopen(nombre,"r");
  if (fichero==NULL){
    printf("ERROR: No se pudo abrir el archivo %s\n", nombre);
    exit(1);
  }

  /* Espero a todos los electores a que lleguen a este lugar para poder hacer pedidos simultaneos y ver como responde el algoritmo.*/
  MPI_Barrier(igualesami);
  printf("Cliente %d: Comienzo ejecucion de programa.\n",rank/2);

  fgets(linea,80,fichero);
  while (!feof(fichero)){
    if (strncmp (linea, comando[3], strlen(comando[3]))==0) {
      printf("Cliente %d: No hace nada \n", rank/2);
      sleep(1);
    }

    if (strncmp (linea, comando[0], strlen(comando[0]))==0) {
      // Envio pedido de ingreso a la seccion critica.
      // Se le envia un mensaje a myrank -1, que es el servidor del nodo
      // para que haga el manejo de pedidos en forma global.
      printf("Cliente %d: Pedido de ingreso a la seccion critica.\n", rank/2);
      MPI_Send(&env, 1, MPI_INT, miserv, TAG_PEDIDO, MPI_COMM_WORLD);
      printf("Cliente %d: Esperando el acceso a la seccion critica.\n",rank/2);
      MPI_Recv(&env, 1, MPI_INT, miserv, TAG_PEDIDO, MPI_COMM_WORLD, &status);
      printf("Cliente %d: Posecion de la seccion critica.\n",rank/2);
      seccion_critica = TRUE;
    }

    if (strncmp(linea, comando[1], strlen(comando[1]))==0) {
      // Envio de liberacion de la sección critica.
      // Se le envia un mensaje a myrank -1, que es el servidor del nodo
      // para que haga el manejo de pedidos en forma global.
      printf("Cliente %d: Liberacion de la seccion critica.\n", rank/2);
      MPI_Send(&env, 1, MPI_INT, miserv, TAG_LIBERO, MPI_COMM_WORLD);
      seccion_critica = FALSE;
    }

    /// Si el comando es "escribir".
    if (strncmp (linea, comando[2], strlen(comando[2]))==0) {
      // Se escribe en pantalla el numero de cliente y la linea leida.
      // Esto deberia llamarse unicamente dentro de la seccion critica.
      if (!seccion_critica)
        printf("Cliente %d: ERROR! Pedido de escritura sin estar en seccion critica.\n", rank/2);
      else
        printf("Cliente %d: %s\n",rank/2,linea);
    }
    fgets(linea,80,fichero);
  }

  printf("Cliente %d: Finalizacion del programa.\n",rank/2);
  fclose(fichero);

  // Espero a todos los clientes para hacer que terminen los servidores de cada uno de ellos.
  MPI_Barrier(igualesami);
  MPI_Send(&env, 1, MPI_INT, miserv, TAG_TERMINO, MPI_COMM_WORLD);
  MPI_Barrier(MPI_COMM_WORLD);
}


int main(int argc, char *argv[]) {
  int status;
  int tipo;

  /* Inicializo MPI. */
  status= MPI_Init(&argc, &argv);
  if (status!=MPI_SUCCESS) {
    fprintf(stderr, "Error de MPI al inicializar.\n");
    MPI_Abort(MPI_COMM_WORLD, status);
  }

  MPI_Comm_size(MPI_COMM_WORLD, &np);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  tipo=rank % 2;
  MPI_Comm_split(MPI_COMM_WORLD, tipo, rank, &igualesami);

  /* Control el buffering: sin buffering.
    NOTA: Descomentar las siguientes lineas para poder ver los printf de los procesos
    cuando son realizados y no agrupados al final */
  setbuf(stdout, NULL);
  setbuf(stderr, NULL);

  printf("\nLanzando proceso %u\n", rank);
  if (tipo==0) {
    /* Soy el proceso que recibe los pedidos de seccion critica. */
    servidorcontrol(rank+1);
  } else if (tipo==1) {
    /* Soy el proceso que ejecuta en el nodo y desea ingresar a la seccion critica. */
    cliente(rank-1);
  }

  /* Limpio MPI. */
  MPI_Finalize();
  return 0;
}
