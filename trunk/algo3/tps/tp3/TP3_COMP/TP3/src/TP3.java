package src;

public class TP3 {
	
	public static final int DENSIDAD_BAJISIMA  	= 10;
	public static final int DENSIDAD_BAJA  		= 20;
	public static final int DENSIDAD_MEDIA 		= 40;
	public static final int DENSIDAD_ALTA  		= 80;
	public static final int DENSIDAD_COMPLETA  	= 100;
	
	
	public static void main(String[] args) {
//		for(int i=0;i < 10;i++){
//			GeneradorGrafos.generarGrafosConexosIncrementandoAristas(500, 10, 500, 5, "TP3_concl_nodos.in_" + i);
//			System.out.println("Genere el archivo " + i);
//		}
		empezar();
	}

	private static void empezar(){
//		new AlgoritmoExacto();
		for(int i=0;i < 10;i++){
			System.out.println("HC");
			new HeuristicaConstructiva(i);
			System.out.println("HBL");
			new HeuristicaBusquedaLocal(i);
			System.out.println("GRASP");
			new HeuristicaGrasp(i);
		}
	}

}