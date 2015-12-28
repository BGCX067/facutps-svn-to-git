package src;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

/** 
 * Genera varios grafos de acuerdo al parametro diferencia del metodo generar, que representa la diferencia del 
 * del porcentaje de aristas con respecto al grafo completo entre un grafo y el siguiente. Por ejemplo, si  
 * diferencia = 10, el primer grafo tendra un 10% de aristas, el segundo un 20%, y asi hasta completarlo.
 */

public class GeneradorVariosGrafos extends GeneradorGrafos {

	private int aristas;
	private int[] pesos;
	
	/**
	 * Genera y escribe los grafos.
	 */
	
	public GeneradorVariosGrafos(int nodos, int pesoMin, int pesoMax, String fileName){
		setNodos(nodos);
		setAdyacencias(new int[nodos][nodos]);
		this.pesos = new int[nodos];
		for (int i=0; i<nodos; i++){
			pesos[i] = ((Double)(Math.random() * (pesoMax - pesoMin))).intValue() + pesoMin;
		}
		setFileName(fileName);
	}
	
	public GeneradorVariosGrafos(GeneradorGrafoConexo grafo, int aristas, int pesoMin, int pesoMax, String fileName) {
		setNodos(grafo.getNodos());
		setAdyacencias(grafo.getAdyacencias());
		this.aristas = aristas;
		this.pesos = new int[getNodos()];
		for (int i=0; i<this.getNodos(); i++){
			pesos[i] = ((Double)(Math.random() * (pesoMax - pesoMin))).intValue() + pesoMin;
		}
		setFileName(fileName);
	}

	public void generar(int diferencia){
		try {
			int mCompleto = this.getNodos()*(this.getNodos()-1)/2;
			int aristas = this.aristas;
			int cantGrafos = 100/diferencia;
			int nodoA;
			int nodoB;
			BufferedWriter out = new BufferedWriter(new FileWriter(new File(this.getFileName())));
			
			for (int i = 1; i <= cantGrafos; i++) {
				
				while (aristas <= i * mCompleto * diferencia / 100) {
					nodoA = ((Double)(Math.random() * this.getNodos())).intValue();
					nodoB = ((Double)(Math.random() * this.getNodos())).intValue();
					
					if (nodoA != nodoB){
						this.getAdyacencias()[nodoA][nodoB] = this.getAdyacencias()[nodoB][nodoA] = 1;
						aristas++;
					}						
				}
				this.escribirGrafo(out);
				System.out.println("Grafo numero: " + i + " Aristas: " + aristas);
			}
			out.write("0");
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}

	
	private void escribirGrafo(BufferedWriter out) {
		try {
			out.write(String.valueOf(this.getNodos()) + "\n");
			for (int j=0; j<this.getNodos(); j++){
				out.write(pesos[j] + " ");
				out.write(vecinos(j) + "\n");
			}

		} catch (Exception e){
			e.printStackTrace();
		}
	}
	
}