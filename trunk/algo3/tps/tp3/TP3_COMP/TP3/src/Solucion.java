package src;

import java.util.ArrayList;

public class Solucion {

	private ArrayList<Vertice> conjunto;
	private ArrayList<Vertice> posibles;
	private int[] adyacencia;
	private int peso;
	
	/*
	 * Constructores
	 */

	public Solucion(){
		this.conjunto = new ArrayList<Vertice>();
		this.posibles = new ArrayList<Vertice>();
		this.peso = 0;
	}
	
	public Solucion(int nodos){
		this.conjunto = new ArrayList<Vertice>();
		this.posibles = new ArrayList<Vertice>();
		this.adyacencia = new int[nodos];
		this.peso = 0;
	}
	
	/**
	 * Clona todos los objetos de la Solucion parametro, excepto posibles que genera una instancia vacia. 
	 */
	@SuppressWarnings("unchecked")
	public Solucion(Solucion copy){
		this.conjunto = (ArrayList<Vertice>) copy.getConjunto().clone();
		this.adyacencia = copy.getAdyacencia().clone();
		//this.posibles = (ArrayList<Vertice>) copy.getPosibles().clone();		
		this.posibles = new ArrayList<Vertice>();
		this.peso = copy.getPeso();
	}
	
	/**
	 * Asigna los parametros y crea un ArrayList vacio para los posibles. 
	 */
	public Solucion(ArrayList<Vertice> conjunto, int[] adyacencia, int peso){
		this.conjunto = conjunto;
		this.adyacencia = adyacencia;
		this.posibles = new ArrayList<Vertice>();
		this.peso = peso;
	}
	
	/**
	 * Full Constructor 
	 */
	public Solucion(ArrayList<Vertice> conjunto, int[] adyacencia, ArrayList<Vertice> posibles, int peso){
		this.conjunto = conjunto;
		this.adyacencia = adyacencia;
		this.posibles = posibles;
		this.peso = peso;
	}
	
	/*
	 * Operadores
	 */
	
	/**
	 * Arma la solucion con los vertices que tiene como posibles. 
	 * Primero ordena los vertices posibles de forma ascendente.
	 * Luego recorre cada uno y si lo puede agregar a la solucion, lo agrega.
	 */
	public void completarSolucionConPosibles() {
		this.ordenarPosibles(Tools.ORDEN_DESCENDENTE);
    	for(Vertice aux : getPosibles())
    		if (puedoAgregar(aux))
    			agregarASolucion(aux);
	}
	
	/**
	 * Agrega el vertice a la lista de posibles.
	 */
	public void addPosible(Vertice posible){
		this.posibles.add(posible);		
	}
	
	/**
	 * Agrega el vertice a la solucion y actualiza con sus vecinos.
	 * - Agrega el vertice al conjunto de solucion
	 * - Suma el peso del vertice
	 * - Incrementa su adyacencia
	 * - Incrementa la adyacencia de los vecinos
	 */
	public void agregarASolucion(Vertice agregar){
		this.conjunto.add(agregar);
		this.peso += agregar.getPeso();
		this.adyacencia[agregar.getNumero() -1]++;

		for (Vertice vx : agregar.getVecinos()){
			this.adyacencia[vx.getNumero() - 1]++;
			Global.comp++;
		}
	}
	
	/**
	 * Agrega el conjunto de la solucion y actualiza la actual.
	 * - Agrega los vertice al conjunto de solucion
	 * - Suma el peso de la solucion
	 * - Incrementa su adyacencia
	 * - Incrementa la adyacencia de los vecinos
	 */
	public void agregarASolucion(Solucion aAgregar){
		for(Vertice agregar : aAgregar.getConjunto()){
			agregarASolucion(agregar);
			Global.comp++;
		}
	}

	/**
	 * Ordena los vertices del conjunto de solucion con el orden indicado.
	 */
	public void ordenarConjuntoSolucion(int orden){
		this.conjunto = Tools.quicksort(this.conjunto, orden);
	}
	
	/**
	 * Ordena los vertices del conjunto de solucion con el orden indicado y por el criterio indicado.
	 */
	public void ordenarConjuntoSolucion(int orden, int criterio){
		this.conjunto = Tools.quicksort(this.conjunto, orden, criterio);
	}
	
	/**
	 * Ordena los vertices posibles con el orden indicado.
	 */
	public void ordenarPosibles(int orden){
		this.posibles = Tools.quicksort(this.posibles, orden);
	}
	
	/**
	 * Ordena los vertices posibles con el orden indicado y el criterio indicado.
	 */
	public void ordenarPosibles(int orden, int criterio){
		this.posibles = Tools.quicksort(this.posibles, orden, criterio);
	}

	/**
	 * Si el vertice vale 0 en la adyacencia, se puede agregar.
	 */
	public boolean puedoAgregar(Vertice v) {
		return this.adyacencia[v.getNumero() - 1] == 0;
	}
	
	/**
	 * Remueve el vertice de la lista de posibles.
	 */
	public boolean removePosible(Vertice remove){
		return this.posibles.remove(remove);
	}
	
	/**
	 * Remueve el vertice de la solucion, pero llena el array de los vertices posibles.
	 */
	public void sacarDeSolucion(Vertice v) {
		this.conjunto.remove(v);
		this.adyacencia[v.getNumero() - 1]--;
		this.peso -= v.getPeso();
		for (Vertice vx : v.getVecinos()) {
			this.adyacencia[vx.getNumero() - 1]--;
			if (puedoAgregar(vx))
				addPosible(vx);
			Global.comp++;
		}
	}
	
	/**
	 * Devuelve el tamaño del conjunto de solucion.
	 */
	public int size(){
		return this.conjunto.size();
	}
	
	/**
	 * Imprime el Peso y el Conjunto de la solucion.
	 */
	@Override
	public String toString() {
		StringBuilder s = new StringBuilder();
		s.append(this.peso + "\r\n");
		for(Vertice v : this.conjunto)
			s.append(v.getNumero() + " ");
		
		
		return s.deleteCharAt(s.length()-1).append("\r\n").toString();
	}
	
	/*
	 * Auxiliares
	 */
	
	/*
	 * Getters y Setters
	 */
	
	/**
	 * Devuelve el vertice de indice elem en el conjunto de solucion.
	 */
	public Vertice getVertice(int elem){
		return this.conjunto.get(elem);
	}
	
	/**
	 * Devuelve el vertice de indice elem en el conjunto de posibles.
	 */
	public Vertice getVerticePosible(int elem){
		return this.posibles.get(elem);
	}
	
	public int[] getAdyacencia() {
		return adyacencia;
	}
	
	public void setAdyacencia(int[] adyacencia) {
		this.adyacencia = adyacencia;
	}
	
	public ArrayList<Vertice> getConjunto() {
		return conjunto;
	}
	
	public void setConjunto(ArrayList<Vertice> conjunto) {
		this.conjunto = conjunto;
	}
	
	public int getPeso() {
		return peso;
	}
	
	public void setPeso(int peso) {
		this.peso = peso;
	}
	
	public ArrayList<Vertice> getPosibles() {
		return posibles;
	}
	
	public void setPosibles(ArrayList<Vertice> posibles) {
		this.posibles = posibles;
	}
	
}
