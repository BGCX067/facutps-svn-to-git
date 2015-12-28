package src;

import java.util.ArrayList;

public abstract class Ejercicio {

	protected ArrayList<Vertice> vertices;
	protected Solucion solucionGlobal;
	protected String outFileName;
	protected ArrayList<ArrayList<Vertice>> componentesConexas;
		
	public final static String IN_FILE_NAME = "Tp3.in";
	
	/*
	 * Operadores
	 */
	
	public abstract void buscarSolucion();
	
	/**
	 * Escribe la solucion en el archivo de salida correspondiente.
	 */
	public void escribirSolucion(){
		Tools.escribirSolucion(this.solucionGlobal, this.outFileName);
	}

	/**
	 * Separa en componentes conexas los vertices que tiene la instancia.
	 */
	public void separarComponentesConexas(){
		this.componentesConexas = Tools.separarEnComponentesConexas(this.vertices);
	}
	
	public void validarSolucion(){
		for(Vertice v : this.solucionGlobal.getConjunto()){
			for(Vertice u : v.getVecinos()){
				if ( this.solucionGlobal.getConjunto().contains(u))
					System.out.println("Gilllllllll no es CI");
			}
		}
//		System.out.println("Esta todo bien.. es CI");
	}
	
	/*
	 * Getters y Setters
	 */
	
	public ArrayList<Vertice> getVertices() {
		return vertices;
	}

	public void setVertices(ArrayList<Vertice> vertices) {
		this.vertices = vertices;
	}

	public String getOutFileName() {
		return outFileName;
	}

	public void setOutFileName(String file_name) {
		this.outFileName = file_name;
	}

	public Solucion getSolucionGlobal() {
		return solucionGlobal;
	}

	public void setSolucionGlobal(Solucion solucionGlobal) {
		this.solucionGlobal = solucionGlobal;
	}

	public ArrayList<ArrayList<Vertice>> getComponentesConexas() {
		return componentesConexas;
	}

	public void setComponentesConexas(ArrayList<ArrayList<Vertice>> componentesConexas) {
		this.componentesConexas = componentesConexas;
	}
	
}
