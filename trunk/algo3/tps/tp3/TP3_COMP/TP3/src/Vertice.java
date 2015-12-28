package src;

import java.util.ArrayList;

public class Vertice {
	private int numero; // Numero del nodo mismo
	private int peso;
	private int componenteConexa;
	ArrayList<Vertice> vecinos;
	
	
	public Vertice(){
		this.vecinos = new ArrayList<Vertice>();
	}
	
	public Vertice(int numero){
		this.numero = numero;
		this.vecinos = new ArrayList<Vertice>();
	}
	
	public Vertice(int numero, int peso){
		this.numero = numero;
		this.peso = peso;
		this.vecinos = new ArrayList<Vertice>();
	}
	
	/*
	 * Auxiliares 
	 */
	
	@Override
	public String toString() {
		return String.valueOf(numero) + "(" + String.valueOf(peso) + ")";
	}
	
	public void addVecino(Vertice v){
		this.vecinos.add(v);
	}
	
	/*
	 * Getters y Setters
	 */
	
	public int getNumero() {
		return numero;
	}

	public void setNumero(int numero) {
		this.numero = numero;
	}

	public int getPeso() {
		return peso;
	}

	public void setPeso(int peso) {
		this.peso = peso;
	}

	public ArrayList<Vertice> getVecinos() {
		return vecinos;
	}

	public void setVecinos(ArrayList<Vertice> vecinos) {
		this.vecinos = vecinos;
	}

	public int getComponenteConexa() {
		return componenteConexa;
	}

	public void setComponenteConexa(int componenteConexa) {
		this.componenteConexa = componenteConexa;
	}
	
}
