package src;

import java.util.ArrayList;


public class GeneradorGrafoConexo extends GeneradorGrafos {
	
	/**
	 * Genera un grafo conexo, con una densidad pasada como parametro y lo escribe en un archivo.
	 */
	
	public GeneradorGrafoConexo(int nodos, int pesoMin, int pesoMax, String fileName){
		setNodos(nodos);
		setAdyacencias(new int[nodos][nodos]);
		setPesoMin(pesoMin);
		setPesoMax(pesoMax);
		setFileName(fileName);
	}
	
	public void generarConexo(int densidad){ // Genera un grafo conexo
		this.generarConexoMinimo();
		int aristas = this.getNodos() - 1;
		int mCompleto;
		int totalAristas;
		int nodoA;
		int nodoB;
	
		if (densidad == 100){
			for (int i=0; i<this.getNodos(); i++){
				for (int k=0; k<this.getNodos(); k++)
					this.getAdyacencias()[i][k] = this.getAdyacencias()[k][i] = 1;
			}	
		} else {
			
			mCompleto = this.getNodos()*(this.getNodos()-1)/2;
			totalAristas = mCompleto * densidad / 100;
			aristas = this.getNodos() - 1; // porque llamamos a generarConexoMinimo
			
			if (this.getNodos() <= 2) 
				return;
			
			while (aristas <= totalAristas) {
				nodoA = ((Double)(Math.random() * this.getNodos())).intValue();
				nodoB = ((Double)(Math.random() * this.getNodos())).intValue();
				
				if (nodoA != nodoB){				
					this.getAdyacencias()[nodoA][nodoB] = this.getAdyacencias()[nodoB][nodoA] = 1;
					aristas++;
				}
			}
		}
	}
	
	public void generarConexoMinimo(){ // Genera un arbol
		ArrayList<Integer> vertices = new ArrayList<Integer>(this.getNodos());
		ArrayList<Integer> agregados = new ArrayList<Integer>();
		int index;
		for (int i=0; i<this.getNodos(); i++){
			vertices.add(i);
		} // Genero una lista con los numeros de los nodos, de donde los voy a ir sacando para armar el arbol
		index = ((Double)(Math.random() * this.getNodos())).intValue();
		int nodoA = vertices.get(index);
		agregados.add(nodoA);
		vertices.remove(index);
		while (vertices.size()>0){
			index = ((Double)(Math.random() * vertices.size())).intValue();
			int nodoB = vertices.get(index);
			vertices.remove(index);
			this.getAdyacencias()[nodoA][nodoB] = 1;
			this.getAdyacencias()[nodoB][nodoA] = 1;
			nodoA = agregados.get(((Double)(Math.random() * agregados.size())).intValue());
		}
	}
	
}