package src;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;

/**
 * Generadores de Grafos:
 * - GeneradorConCC: llamar al constructor de la clase. Este generara y escribira en un archivo un solo grafo con la cantidad de componentes
 *   conexas que se paso como parametro.
 * - GeneradorGrafoConexo: llamar al constructor de la clase. Este generara y escribira en un archivo un solo grafo. Si quiero crear varios grafos 
 * 	 conexos y escribirlos todos en un solo archivo, llamar al metodo escribirVariosGrafosConexos, sino, se escribira cada grafo en un archivo 
 *   distinto.
 * - GeneradorVariosGrafos: llamar al constructor de la clase. Este generara y escribira en un solo archivo varios grafos con la cantidad de nodos
 *   que se envio como parametro y cada grafo tendra un porcentaje mas de aristas con respecto al anterior, de acuerdo al valor pasado como 
 *   parametro. Todos los grafos tienen la misma cantidad de nodos, y cada nodo tiene el mismo peso en todos los grafos.
 */


public class GeneradorGrafos {
	
	private int[][] adyacencias;
	private int nodos;
	private int pesoMin;
	private int pesoMax;
	private String fileName;
	
	public static final int DENSIDAD_BAJISIMA  	= 10;
	public static final int DENSIDAD_BAJA  		= 20;
	public static final int DENSIDAD_MEDIA 		= 40;
	public static final int DENSIDAD_ALTA  		= 80;
	public static final int DENSIDAD_COMPLETA  	= 100;

	public static void main(String[] args) {
		generarUnGrafoConCC(40, 17, 10, 23, 1, "Tp3.in");
		TP3.main(args);
	}
	
	/**
	 * Genera y escribe varios grafos conexos en UN SOLO ARCHIVO. Todos tienen la misma cantidad de nodos, el mismo rango para el peso y 
	 * la misma densidad. 
	 */
	
	public static void escribirVariosGrafosConexos(int cantidad, int nodos, int pesoMin, int pesoMax, int densidad, String fileName){
		try {
			BufferedWriter out = new BufferedWriter(new FileWriter(new File(fileName)));
			for (int i=0; i<cantidad; i++){
				GeneradorGrafoConexo grafo = new GeneradorGrafoConexo(nodos, pesoMin, pesoMax, fileName);
				grafo.generarConexo(densidad);
				out.write(String.valueOf(grafo.getNodos()) + "\n");
				for (int j=0; j<grafo.getNodos(); j++){
					int peso = ((Double)(Math.random() * (pesoMax - pesoMin))).intValue() + pesoMin;
					out.write(peso + " ");
					out.write(grafo.vecinos(j) + "\n");
				}
			}
			out.write("0");
			out.close();
		} catch (Exception e){
			e.printStackTrace();
		}
	}
	
	/**
	 * Genera varios grafos conexos en un mismo archivo
	 */
	public static void generarGrafosConexosIncrementandoAristas(int nodos, int pesoMin, int pesoMax, int diferencia, String fileName){
		GeneradorGrafoConexo grafo = new GeneradorGrafoConexo(nodos, pesoMin, pesoMax, fileName);
		grafo.generarConexoMinimo();
		GeneradorVariosGrafos grafos = new GeneradorVariosGrafos(grafo, grafo.getNodos()-1, pesoMin, pesoMax, fileName);
		grafos.generar(diferencia);
	}
	
	/**
	 * Genera un grafo conexo y lo escribe en un archivo
	 */
	public static void generarUnGrafoConexo(int nodos, int pesoMin, int pesoMax, int densidad, String fileName){
		GeneradorGrafoConexo grafo = new GeneradorGrafoConexo(nodos, pesoMin, pesoMax, fileName);
		grafo.generarConexo(densidad);
		grafo.escribirGrafo();
	}
	
	/**
	 * Genera un grafo con componentes conexas y lo escribe en un archivo
	 */
	public static void generarUnGrafoConCC(int nodos, int componentesConexas, int pesoMin, int pesoMax, int densidad, String fileName){
		GeneradorConCC grafo = new GeneradorConCC(nodos, componentesConexas, pesoMin, pesoMax, fileName);
		grafo.generar(densidad);
		grafo.escribirGrafo();
	}
	
	/**
	 * Genera varios grafos no necesariamente conexos en un mismo archivo
	 */
	public static void generarVariosGrafos(int nodos, int pesoMin, int pesoMax, int diferencia, String fileName){
		GeneradorVariosGrafos grafos = new GeneradorVariosGrafos(nodos, pesoMin, pesoMax, fileName);
		grafos.generar(diferencia);
	}
	
	public void escribirGrafo() {
		try {
			BufferedWriter out = new BufferedWriter(new FileWriter(new File(fileName)));
			out.write(String.valueOf(this.nodos) + "\n");
			for (int j=0; j<this.nodos; j++){
				int peso = ((Double)(Math.random() * (pesoMax - pesoMin))).intValue() + pesoMin;
				out.write(peso + " ");
				out.write(vecinos(j) + "\n");
			}
			out.write("0");
			out.close();
		} catch (Exception e){
			e.printStackTrace();
		}
	}
	
	public void imprimirGrafo(){
		for (int i = 0; i< this.nodos; i++)
			System.out.print(i + " ");
		System.out.println("\n");
		for (int i=0; i<this.nodos; i++){
			for (int k=0; k<this.nodos; k++){
				System.out.print(this.adyacencias[i][k] + " ");
			}
			System.out.println("");
		}
	}
	
	public String vecinos(int nodo){
		String vecinos = "";
		for (int i=0; i<this.nodos; i++){
			if (this.adyacencias[nodo][i] == 1)
				vecinos = vecinos + (i + 1) + " ";
		}
		return vecinos;
	}
	
	public int[][] getAdyacencias() {
		return adyacencias;
	}


	public void setAdyacencias(int[][] adyacencias) {
		this.adyacencias = adyacencias;
	}


	public int getNodos() {
		return nodos;
	}


	public void setNodos(int nodos) {
		this.nodos = nodos;
	}


	public int getPesoMin() {
		return pesoMin;
	}


	public void setPesoMin(int pesoMin) {
		this.pesoMin = pesoMin;
	}


	public int getPesoMax() {
		return pesoMax;
	}


	public void setPesoMax(int pesoMax) {
		this.pesoMax = pesoMax;
	}


	public String getFileName() {
		return fileName;
	}


	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
}