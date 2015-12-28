package src;

import java.util.ArrayList;

public class HeuristicaBusquedaLocal extends Ejercicio {

	private HeuristicaConstructiva heuristicaConstructiva;

	public final static String OUT_FILE_NAME = "TP3hbl.out";

	/**
	 * Main principal
	 */
	public static void main(String[] args) {
		new HeuristicaBusquedaLocal();
	}
	
	/*
	 * Constructores
	 */

	public HeuristicaBusquedaLocal(){
		this.outFileName = OUT_FILE_NAME;
		Tools.leerArchivo(this);
	}

	/**
	 * 
	 * @param vertices= si es NULL no se define la heuristicaContructiva, 
	 * pues la solucion inicial viene dada por un factor externo.
	 */
	public HeuristicaBusquedaLocal( ArrayList<Vertice> vertices){
		this.outFileName = OUT_FILE_NAME;
		if(vertices != null){
			this.heuristicaConstructiva = new HeuristicaConstructiva(vertices);
			setVertices(vertices);
		}
	}

	/*
	 * Operadores
	 */
	
	/**
	 * Aplica la busqueda local generando una solucion inicial con la heuristica constructiva.
	 */
	public void buscarSolucion(){
		this.heuristicaConstructiva = new HeuristicaConstructiva(this.vertices);
		this.heuristicaConstructiva.buscarSolucion();
		this.solucionGlobal = heuristicaConstructiva.getSolucionGlobal();
		this.solucionGlobal = busquedaLocal(this.solucionGlobal);
	}
	
	/**
	 * Aplica la busqueda local a partir de la solucion dada.
	 */
	public Solucion buscarSolucion(Solucion solucionInicial){
		this.solucionGlobal = busquedaLocal(solucionInicial);
		return this.solucionGlobal;
	}
	
	/*
	 * Auxiliares
	 */

	/**
	 * Devuelve la mejor solucion que encuentra haciendo busqueda local, partiendo de la solucion que recibe y
	 * buscando por componente conexa.
	 */
	private Solucion busquedaLocal(Solucion solucionInicial){
		int mejoras =0;
		int repeticiones=0;
		boolean mejora= true;
		
		for(ArrayList<Vertice> conjunto : this.componentesConexas){
			while(mejora && repeticiones < 50){
				repeticiones++;
				mejora = false;
				Solucion mejorSolucion = new Solucion(solucionInicial);
			
				// Tomar conjuntos de a 2
				for(int i=0; i < solucionInicial.getConjunto().size() - 1; i++){
					if(conjunto.contains(solucionInicial.getVertice(i))){
						for(int j=i+1; j < solucionInicial.getConjunto().size() ; j++){
							if(conjunto.contains(solucionInicial.getVertice(j))){
								Solucion solucionVecina = new Solucion(solucionInicial);
								
								solucionVecina.sacarDeSolucion(solucionInicial.getVertice(j));
								solucionVecina.sacarDeSolucion(solucionInicial.getVertice(i));
								
								for(Vertice vb: mejorConjunto(solucionVecina))
									solucionVecina.agregarASolucion(vb);
								
								solucionVecina.completarSolucionConPosibles();
								
								if(solucionVecina.getPeso() > mejorSolucion.getPeso()){
									mejorSolucion = solucionVecina;
									mejoras++;
									mejora = true;
								}
							}
					    }
					}
				}
				solucionInicial = mejorSolucion;
			}

			System.gc();
			System.runFinalization();

		}
		return solucionInicial;
	}
		
	/*
	 * Auxiliares
	 */

	/**
	 *  Devuelve una lista con los nodos a agregar que forman el mayor peso, de 1 2 o 3 elementos. 
	 */
	private ArrayList<Vertice> mejorConjunto(Solucion solucion){
		ArrayList<Vertice> mejorConjunto = new ArrayList<Vertice>();
		ArrayList<Vertice> conjunto = new ArrayList<Vertice>();
		int posiblesSize = solucion.getPosibles().size();
		int mejorPeso = 0;
		int peso = 0;
		
		for(int a=0; a < posiblesSize; a++){
			Vertice va = solucion.getVerticePosible(a);
			conjunto.clear();
			conjunto.add(va);
			peso = va.getPeso();

			if(peso> mejorPeso){
				mejorConjunto.clear();
				mejorConjunto.addAll(conjunto);
				mejorPeso = peso;
			}
			for(int b=a+1; b < posiblesSize; b++){
				Vertice vb = solucion.getVerticePosible(b);
				if(!va.getVecinos().contains(vb)){
					conjunto.add(vb);
					peso+=vb.getPeso();
					if(peso> mejorPeso){
						mejorConjunto.clear();
						mejorConjunto.addAll(conjunto);
						mejorPeso = peso;
					}					
					for(int c=b+1; c < (posiblesSize); c++){
						Vertice vc = solucion.getVerticePosible(c);
						if(!va.getVecinos().contains(vc) && !vb.getVecinos().contains(vc)){
							conjunto.add(vc);
							if(peso> mejorPeso){
								mejorConjunto.clear();
								mejorConjunto.addAll(conjunto);
								mejorPeso = peso;
							}
							conjunto.remove(vc);
						}
					}
					conjunto.remove(vb);
				}
			}
			conjunto.remove(va);
		} 

		return mejorConjunto;
	}
	
}
