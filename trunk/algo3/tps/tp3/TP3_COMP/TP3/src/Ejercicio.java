package src;

import java.sql.Timestamp;
import java.util.ArrayList;

public abstract class Ejercicio {

	protected ArrayList<Vertice> vertices;
	protected Solucion solucionGlobal;
	protected String outFileName;
	protected ArrayList<ArrayList<Vertice>> componentesConexas;
	
	protected Timestamp inicio;
	protected Timestamp fin;
	protected long cantidadAristas;
	
	public final static String IN_PATH = "";
	public final static String OUT_PATH = "";
	public final static String IN_FILE_NAME = "Tp3_local.in";
	
	/*
	 * Operadores
	 */
	
	public abstract void buscarSolucion();
	
	/**
	 * Escribe la solucion en el archivo de salida correspondiente.
	 */
	public void escribirSolucion(){
//		System.out.println(this.outFileName + " " + this.solucionGlobal.getPeso()); // sacar esta linea
//		System.out.println("cantidad de comparaciones de " + this.outFileName + "  " + Global.comp);
//		System.out.println("Tiempo" + getTiempo());
//		Tools.escribirSolucion(this.solucionGlobal, this.outFileName);
		Tools.escribirSolucionXLS(this);
//		Tools.escribirTablas(this);
		Global.comp = 0;
	}

	/**
	 * Separa en componentes conexas los vertices que tiene la instancia.
	 *
	 */
	public void separarComponentesConexas(){
		this.componentesConexas = Tools.separarEnComponentesConexas(this.vertices);
	}

	/**
	 * Devuelve el tiempo que tardo el algoritmo.
	 */
	public double getTiempo(){
		double dif = (getFin().getTime() - getInicio().getTime()) / 1000.0;

		return dif;
	}
	
	public void validarSolucion(){
//		System.out.println("Empieza la validacion");
		for(Vertice v : this.solucionGlobal.getConjunto()){
			for(Vertice u : v.getVecinos()){
				if ( this.solucionGlobal.getConjunto().contains(u))
					System.out.println("@@@@@@@@@@@@@@@@ Gilllllllll no es CI");
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
		return OUT_PATH + outFileName;
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

	public void setComponentesConexas(
			ArrayList<ArrayList<Vertice>> componentesConexas) {
		this.componentesConexas = componentesConexas;
	}

	public Timestamp getFin() {
		return fin;
	}

	public void setFin(Timestamp fin) {
		this.fin = fin;
	}

	public Timestamp getInicio() {
		return inicio;
	}

	public void setInicio(Timestamp inicio) {
		this.inicio = inicio;
	}

	public long getCantidadAristas() {
		return cantidadAristas;
	}

	public void setCantidadAristas(long cantidadAristas) {
		this.cantidadAristas = cantidadAristas;
	}
	
	public String getinFileName() {
		return "Tp3_bql_"+Global.num +"_densidad_" + Global.densidad + ".in";
	}
	
}
