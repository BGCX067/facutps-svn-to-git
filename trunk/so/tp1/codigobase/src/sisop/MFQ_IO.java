package sisop;

import java.util.LinkedList;
import java.util.List;
import java.util.Random;

/**
 * Implementacion de un planificador Multilevel Feedback Queue.
 */
class MFQ_IO extends RR {

    private int current_queue;

    private LinkedList<Task> high_tasks;
    private LinkedList<Task> medium_tasks;
    private LinkedList<Task> low_tasks;

    private boolean do_io;
    private Random random;

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

    public MFQ_IO() {
        super("MFQ_IO");
    }

    protected void scheduler_init() {
        this.current_time = -1;
        this.low_tasks = new LinkedList<Task>();
        this.high_tasks = new LinkedList<Task>();
        this.medium_tasks = new LinkedList<Task>();
        this.finished_tasks = new LinkedList<Task>();
        this.current_task = Task.NULL_TASK;
        this.do_io = false;
        this.random = new Random();
    }

    /*
      * Auxiliares
      */

    /**
     * @return la proxima tarea que usara el CPU o null si terminaron todas las tareas.
     */
    protected Task taskSwitching() {
        super.taskSwitching();

        // Usamos random para ver si hace entrada/salida
        if (current_task != Task.CONTEXT_SWITCHING_TASK && current_task != Task.NULL_TASK && current_task != Task.IDLE_TASK) {
            this.do_io = random.nextBoolean();
            if (this.do_io) {
                // Sumamos uno en ambos lados, pues el taskSwitching resta uno al remaining_clock ni bien lo setea.
                this.remaining_clock = random.nextInt(Math.min(this.remaining_clock + 1, current_task.ptime - current_task.ttime + 1));
            }
        }

        return this.current_task;
    }

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
                if (this.do_io)
                    this.high_tasks.add(this.high_tasks.removeFirst());
                else
                    this.medium_tasks.add(this.high_tasks.removeFirst());
                break;
            }
            case MEDIUM_QUEUE: {
                if (this.do_io)
                    this.high_tasks.add(this.medium_tasks.removeFirst());
                else
                    this.low_tasks.add(this.medium_tasks.removeFirst());
                break;
            }
            case LOW_QUEUE: {
                if (this.do_io)
                    this.medium_tasks.add(this.low_tasks.removeFirst());
                else
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
