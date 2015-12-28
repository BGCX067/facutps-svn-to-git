package sisop;

import java.util.LinkedList;
import java.util.List;

/**
 * Implementacion de un scheduler Round Robin.
 */

public class RR extends Scheduler {

    protected int current_time;
    protected Task current_task;
    protected int remaining_clock;
    protected LinkedList<Task> finished_tasks;

    private int quantum = DEFAULT_QUANTUM;
    private LinkedList<Task> ready_tasks;

    /**
     * Valor del quantum por defecto.
     */
    public static final int DEFAULT_QUANTUM = 5;

    /*
     * Constructores
     */

    public RR() {
        super("RR");
    }

    /**
     * Construye un planificador Round Robin
     *
     * @param scheduler_name s
     */
    public RR(String scheduler_name) {
        super(scheduler_name);
    }

    protected void scheduler_init() {
        this.ready_tasks = new LinkedList<Task>();
        this.finished_tasks = new LinkedList<Task>();
        this.current_time = -1;
        this.current_task = Task.NULL_TASK;
        this.remaining_clock = quantum;
    }

    public String scheduler_next() {
        current_time++;

        updateReadyTasks();
        //aca entra la primera vez
        if (current_task == Task.NULL_TASK)
            return taskSwitching().name;


        // Context switching
        if (current_task == Task.CONTEXT_SWITCHING_TASK) {
            if (current_task.finished())
                taskSwitching();
            else {
                current_task.ttime++;
                remaining_clock--;
            }
            return current_task.name;
        }

        // IDLE TASK
        if (current_task == Task.IDLE_TASK) {
            if (nextTask() != Task.IDLE_TASK) {
                return taskSwitching().name;
            } else {
                return current_task.name;
            }
        }

        // El caso de que es una tarea cualquiera
        if (current_task.finished()) {
            // Terminar la tarea
            current_task.finalize(current_time);
            finished_tasks.add(current_task);
            currentQueue().removeFirst();
            // Asignar nueva tarea
            return taskSwitching().name;
        }


        if (remaining_clock == 0) {
            // Se le termino el tiempo de proceso
            // Hay que obligar un task switching, luego de agregar la tarea al final de la cola
            enqueue();
            return taskSwitching().name;
        }

        // Si llega hasta aca, es que tiene tiempo de proceso y no termino
        current_task.ttime++;
        remaining_clock--;
        return current_task.name;
    }

    /*
      * Auxiliares
      */

    /**
     * @return la proxima tarea que usara el CPU o null si terminaron todas las tareas.
     */
    protected Task taskSwitching() {
        if (current_task == Task.CONTEXT_SWITCHING_TASK || current_task == Task.NULL_TASK) {
            //Hay que pasar a la proxima tarea o a IDLE
            Task.CONTEXT_SWITCHING_TASK.ttime = 0;
            this.remaining_clock = this.quantum;
            this.current_task = nextTask();
        } else {
            // no importa setear el remaining_clock, pues si es NULL termina y si es CSW lo ignora.
            this.current_task = noMoreTasks() ? Task.NULL_TASK : Task.CONTEXT_SWITCHING_TASK;
        }

        // La tarea pasa su primer clock de CPU en ejecucion
        this.current_task.ttime++;
        this.remaining_clock--;
        return this.current_task;
    }

    /**
     * @return la tarea que ocupara el CPU
     */
    protected Task nextTask() {
        if (currentQueue().isEmpty())
            return Task.IDLE_TASK;
        else
            return currentQueue().getFirst();
    }

    /**
     * Compara la cantidad de Tareas del TaskSet con las tareas finalizadas.
     *
     * @return @true si se ejecutaron todas las tareas.
     */
    protected boolean noMoreTasks() {
        return task_set.size() == finished_tasks.size();
    }

    /**
     * Encola la Current task en la cola correspondiente de tareas esperando por el uso de CPU
     */
    protected void enqueue() {
        currentQueue().add(currentQueue().removeFirst());
    }

    /*
      * Agrega las tareas que estan listas para ejecutarse en current_time al final de la cola correspondiente.
      */

    protected void updateReadyTasks() {
        List<Task> newly_released_tasks = task_set.get_released_tasks_at_time(current_time);
        if (!newly_released_tasks.isEmpty())
            currentQueue().addAll(newly_released_tasks);
    }

    /*
      * Getters & Setters
      */

    protected LinkedList<Task> currentQueue() {
        return this.ready_tasks;
    }

    @Override
    protected LinkedList<Task> getFinishedTasks() {
        return finished_tasks;
    }

    /**
     * Permite indicar el valor del quantum deseado para la planificacion
     *
     * @param q valor deseado para la planificacion
     */
    public void set_quantum(int q) {
        this.quantum = q;
    }

}
