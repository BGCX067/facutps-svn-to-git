package src;

import java.util.ArrayList;

public class HeuristicaConstructiva extends Ejercicio {
	
	public final static String OUT_FILE_NAME = "TP3hc_conclusion_.out";
	
	/*
	 * Constructores
	 */
	
	/**
	 * Constructor que lee directamente el archivo
	 */
	public HeuristicaConstructiva(int i){
		this.outFileName = OUT_FILE_NAME  + i;
		Tools.leerArchivo(this, "TP3_concl_nodos.in_"+i);
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

		for(Vertice aux : this.vertices){
			if(this.solucionGlobal.puedoAgregar(aux))
				this.solucionGlobal.agregarASolucion(aux);
			Global.comp++;
		}

	}

	@Override
	public void separarComponentesConexas() {
		// No tiene que hacer nada pues no usamos las componentes conexas en esta heuristica.		
	}
	
	/*
	 * Auxiliares
	 */

}
