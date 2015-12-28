package src;

import java.util.ArrayList;

public class HeuristicaConstructiva extends Ejercicio {
	
	public final static String OUT_FILE_NAME = "TP3hc.out";
	
	/**
	 * Main principal
	 */
	public static void main(String[] args) {
		new HeuristicaConstructiva();
	}
	
	/*
	 * Constructores
	 */
	
	/**
	 * Constructor que lee directamente el archivo
	 */
	public HeuristicaConstructiva(){
		this.outFileName = OUT_FILE_NAME;
		Tools.leerArchivo(this);
	}
	
	public HeuristicaConstructiva(ArrayList<Vertice> vertices){
		this.outFileName = OUT_FILE_NAME;
		this.vertices = vertices;
	}

	/*
	 * Operadores
	 */

	public void buscarSolucion() {
		this.solucionGlobal = new Solucion(this.vertices.size());

		for(Vertice aux : this.vertices)
			if(this.solucionGlobal.puedoAgregar(aux))
				this.solucionGlobal.agregarASolucion(aux);

	}

	@Override
	public void separarComponentesConexas() {
		// No tiene que hacer nada pues no usamos las componentes conexas en esta heuristica.		
	}
	
	/*
	 * Auxiliares
	 */

}
