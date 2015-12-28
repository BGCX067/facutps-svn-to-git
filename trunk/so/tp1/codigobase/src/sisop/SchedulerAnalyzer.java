package sisop;

/**
 * Permite extraer estadisticas de la planificacion.
 * Esta clase es invocada una vez finalizada
 * la planificacion.
 */
class SchedulerAnalyzer {

    private TaskSet task_set;

    /**
     * Construye un nuevo analizador usando
     * un TaskSet producto de una planificacion
     * terminada
     */
    public SchedulerAnalyzer(TaskSet task_set) {
        this.task_set = task_set;
    }

    /**
     * Retorna el waiting time promedio de
     * una tarea.
     */
    public double get_avg_wtime() {
        double avg = 0.0;
        for (Task t : this.task_set){
            avg += t.wtime;
            System.out.println("task = " + t + " finish = " + t.ftime );
        }

        return avg / this.task_set.size();
    }

}
