package src;

import java.util.ArrayList;
import java.util.Stack;

public class AlgoritmoExacto extends Ejercicio {

	public final static String OUT_FILE_NAME = "TP3exacto.out";

	/*
	 * Constructores
	 */

	/**
	 * Empieza el algoritmo y lee el archivo.
	 */
	public AlgoritmoExacto(){
		this.outFileName = OUT_FILE_NAME;
		Tools.leerArchivo(this);
	}

	/**
	 * Toma los vertices y los separa por componentes conexas.
	 */
	public AlgoritmoExacto(ArrayList<Vertice> vertices){
		this.vertices = vertices;
		this.outFileName = OUT_FILE_NAME;
		super.separarComponentesConexas();
	}

	/*
	 * Operadores
	 */

	/**
	 * Busca la solucion haciendo Backtracking en las componentes conexas y deja la solucion en this.solucionGlobal.
	 */
	public void buscarSolucion(){
		int nodos = this.vertices.size();
		
		this.solucionGlobal = new Solucion(nodos);
		
		Solucion parcial = new Solucion(nodos);
		boolean termine = true;
		int idx = 0;
		Stack<Integer> pila = new Stack<Integer>();

		for(ArrayList<Vertice> componenteConexa : this.componentesConexas){
			Global.comp++;
			Solucion mejorDeComponenteConexa = new Solucion(nodos);

			int sumaPesoPosible = 0;
			
			while (componenteConexa.size() > 0){
				Global.comp++;

				if((parcial.getConjunto().size() > 0 || termine) ){
					termine = false;

					sumaPesoPosible = 0;
					for(int a=idx; a < componenteConexa.size();a++){
						sumaPesoPosible += componenteConexa.get(a).getPeso();
					}

					if (sumaPesoPosible + parcial.getPeso() >= mejorDeComponenteConexa.getPeso()){
						if(idx < componenteConexa.size()){
							Vertice verticeActual = componenteConexa.get(idx);
							Global.comp++;
							if(parcial.puedoAgregar(verticeActual)){
								parcial.agregarASolucion(verticeActual);
								pila.push(idx);
								Global.comp++;
	
								// Actualizo la global si es mayor
								if(mejorDeComponenteConexa.getPeso() < parcial.getPeso()){
									mejorDeComponenteConexa = new Solucion(parcial);
								}
	
							}
	
							idx++;
						}else{ 
							// Si ya no tengo mas para recorrer,saco el ultimo y sigo recorriendo desde este	
							idx = pila.pop() + 1;
							parcial.sacarDeSolucion(parcial.getVertice(parcial.size() -1));
							Global.comp++;
						}
					}else{
						if(pila.empty()){
							componenteConexa.remove(0);//saco el primero de la lista para recorrer;
							idx = 0; //actualizo para empezar a recorrer desde el principio
							termine = true;
						}else{
							idx = pila.pop() + 1;
							parcial.sacarDeSolucion(parcial.getVertice(parcial.size() -1));
							Global.comp++;
						}
					}

				}else{
					componenteConexa.remove(0);//saco el primero de la lista para recorrer;
					idx = 0; //actualizo para empezar a recorrer desde el principio
					termine = true;
				}
			}
			this.solucionGlobal.agregarASolucion(mejorDeComponenteConexa);			
		}

	}
	
}
