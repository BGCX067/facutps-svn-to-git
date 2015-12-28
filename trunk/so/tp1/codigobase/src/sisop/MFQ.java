package sisop;

import java.util.LinkedList;
import java.util.List;

/**
 * Implementacion de un planificador Multilevel Feedback Queue.
 */
class MFQ extends RR {

    private int current_queue;

    private LinkedList<Task> high_tasks;
    private LinkedList<Task> medium_tasks;
    private LinkedList<Task> low_tasks;

    /**
     * Valor del quantum por defecto.
     */
    public static final int HIGH_QUANTUM = 5;
    public static final int MEDIUM_QUANTUM = 15;
    public static final int LOW_QUANTUM = 45;

    public static final int HIGH_QUEUE = 2;
    public static final int MEDIUM_QUEUE = 1;
    public static final int LOW_QUEUE = 0;

    /*
      * Contructores
      */

    public MFQ() {
        super("MFQ");
    }

    protected void scheduler_init() {
        this.current_time = -1;
        this.low_tasks = new LinkedList<Task>();
        this.high_tasks = new LinkedList<Task>();
        this.medium_tasks = new LinkedList<Task>();
        this.finished_tasks = new LinkedList<Task>();
        this.current_task = Task.NULL_TASK;
    }

    /*
      * Auxiliares
      */

    /**
     * Devuelve la tarea que ocupara el CPU
     */
    protected Task nextTask() {
        if (!high_tasks.isEmpty()) {
            this.current_queue = HIGH_QUEUE;
            this.remaining_clock = HIGH_QUANTUM;
            return high_tasks.getFirst();
        }

        if (!medium_tasks.isEmpty()) {
            current_queue = MEDIUM_QUEUE;
            this.remaining_clock = MEDIUM_QUANTUM;
            return medium_tasks.getFirst();
        }

        if (!low_tasks.isEmpty()) {
            current_queue = LOW_QUEUE;
            this.remaining_clock = LOW_QUANTUM;
            return low_tasks.getFirst();
        }

        return Task.IDLE_TASK;
    }

    /**
     * Encola la Current task en la cola correspondiente de tareas esperando por el uso de CPU
     */
    protected void enqueue() {
        switch (this.current_queue) {
            case HIGH_QUEUE: {
                this.medium_tasks.add(this.high_tasks.removeFirst());
                break;
            }
            case MEDIUM_QUEUE: {
                this.low_tasks.add(this.medium_tasks.removeFirst());
                break;
            }
            case LOW_QUEUE: {
                this.low_tasks.add(this.low_tasks.removeFirst());
                break;
            }
        }
    }

    /*
      * Agrega las tareas que estan listas para ejecutarse en current_time al final de la cola correspondiente.
      */

    protected void updateReadyTasks() {
        List<Task> newly_released_tasks = task_set.get_released_tasks_at_time(current_time);
        if (!newly_released_tasks.isEmpty())
            high_tasks.addAll(newly_released_tasks);
    }

    /*
      * Getters & Setters
      */

    protected LinkedList<Task> currentQueue() {
        switch (this.current_queue) {
            case HIGH_QUEUE:
                return this.high_tasks;
            case MEDIUM_QUEUE:
                return this.medium_tasks;
            default:
                return this.low_tasks;
        }
    }

}
