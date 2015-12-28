package src;

public class TP3 {
	
	public static final int DENSIDAD_BAJISIMA  	= 10;
	public static final int DENSIDAD_BAJA  		= 20;
	public static final int DENSIDAD_MEDIA 		= 40;
	public static final int DENSIDAD_ALTA  		= 80;
	public static final int DENSIDAD_COMPLETA  	= 100;
	
	public static void main(String[] args) {
		empezar();
	}

	private static void empezar(){
		new AlgoritmoExacto();
		new HeuristicaConstructiva();
		new HeuristicaBusquedaLocal();
		new HeuristicaGrasp();
	}
	
	/*
	 * Auxiliares
	 */
	

}
