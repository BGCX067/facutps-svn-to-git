package src;

import java.util.ArrayList;
import java.util.List;

public class GeneradorConCC extends GeneradorGrafos {
	
	private int componentesConexas;
	private List<List<Integer>> cc;

	/** 
	 * Genera un grafo con exactamente una cantidad x de componentes conexas, que se pasa como parametro y lo escribe en un archivo.
	 */
	
	public GeneradorConCC(int nodos, int componentesConexas, int pesoMin, int pesoMax, String fileName){
		this.componentesConexas = componentesConexas;
		setNodos(nodos);
		setAdyacencias(new int[nodos][nodos]);
		setPesoMin(pesoMin);
		setPesoMax(pesoMax);
		setFileName(fileName);
	}
	
	public void generar(int densidad){
		separarEnComponentesConexas();
		for (List<Integer> compCon : cc){		
			generarArbol(compCon);
			completarArbol(compCon, densidad);
		}		
	}

	private void separarEnComponentesConexas(){
		cc = new ArrayList<List<Integer>>(this.componentesConexas);
		ArrayList<Integer> vertices = new ArrayList<Integer>();
		
		for (int i=0; i<this.getNodos(); i++){
			vertices.add(i);
		}
		
		for (int i=0; i<this.componentesConexas; i++){ // Agrego un nodo a cada componente conexa, y lo saco de la lista vertices
			int index = ((Double)(Math.random() * vertices.size())).intValue();
			List<Integer> componente = new ArrayList<Integer>();
			componente.add(vertices.get(index));
			cc.add(componente);
			vertices.remove(index);
		}

		while (vertices.size()>0){
			int index = ((Double)(Math.random() * this.componentesConexas)).intValue();
			cc.get(index).add(vertices.get(0));
			vertices.remove(0);
		}
		System.out.println("Nodos de las CC: " + cc);
	}
	
	private void generarArbol(List<Integer> list){
		List<Integer> vertices = new ArrayList<Integer>();
		vertices.addAll(list);
		int index = ((Double)(Math.random() * vertices.size())).intValue();
		int nodoA = vertices.get(index);
		vertices.remove(index);
		while (vertices.size()>0){
			index = ((Double)(Math.random() * vertices.size())).intValue();
			int nodoB = vertices.get(index);
			vertices.remove(index);
			this.getAdyacencias()[nodoA][nodoB] = 1;
			this.getAdyacencias()[nodoB][nodoA] = 1;
			nodoA = nodoB;
		}
	}
	
	private void completarArbol(List<Integer> list, int densidad){
		int aristas = list.size() - 1;
		int mCompleto;
		int totalAristas;
		int nodoA;
		int nodoB;
	
		if (densidad == 100){
			for (int i=0; i<list.size(); i++){
				for (int k=0; k<list.size(); k++)
					if (k != i)
						this.getAdyacencias()[list.get(i)][list.get(k)] = this.getAdyacencias()[list.get(k)][list.get(i)] = 1;
			}	
		} else {
			
			mCompleto = this.getNodos()*(this.getNodos()-1)/2;
			totalAristas = mCompleto * densidad / 100;
			aristas = this.getNodos()- 1; 
			
			if (this.getNodos() <= 2) 
				return;
			
			while (aristas <= totalAristas) {
				nodoA = list.get(((Double)(Math.random() * list.size())).intValue());
				nodoB = list.get(((Double)(Math.random() * list.size())).intValue());
				
				if (nodoA != nodoB){				
					this.getAdyacencias()[nodoA][nodoB] = this.getAdyacencias()[nodoB][nodoA] = 1;
					aristas++;
				}
			}
		}		
	}
	
}

