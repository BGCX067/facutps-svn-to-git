package src;

import java.util.ArrayList;

public class HeuristicaGrasp extends Ejercicio {

	public final static String OUT_FILE_NAME 	= "TP3grasp.out";
	private final static double PORCENTAJE 		= 0.2;
		
	/**
	 * Main principal
	 */
	public static void main(String[] args) {
		new HeuristicaGrasp();
	}
	
	/*
	 * Constructores
	 */
	
	public HeuristicaGrasp(){
		this.outFileName = OUT_FILE_NAME;
		Tools.leerArchivo(this);
	}
	
	public HeuristicaGrasp(ArrayList<Vertice> vertices) {
		this.outFileName = OUT_FILE_NAME;
		this.vertices = vertices;
		separarComponentesConexas();
	}

	/*
	 * Operadores
	 */

	@SuppressWarnings("unchecked")
	public void buscarSolucion(){
		this.solucionGlobal = new Solucion(this.vertices.size());
		for (int i = 0; i < 200; i++) {
			Solucion solucionGrasp = busquedaLocalCC(solucionHeuristica((ArrayList<Vertice>) this.vertices.clone()));

			if(this.solucionGlobal.getPeso() < solucionGrasp.getPeso())
				this.solucionGlobal = solucionGrasp;
		}
		
	}
	
	/**
	 * Devuelve la mejor solucion que encuentra haciendo busqueda local (mismo codigo que busqueda local)
	 */
	private Solucion busquedaLocalCC(Solucion solucionInicial){
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
								
								completarSolucion(solucionVecina);
								
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
	private void completarSolucion(Solucion solucionVecina) {
			solucionVecina.completarSolucionConPosibles();
		}
	
	/**
	 * Heuristica por construccion con el factor random para que no genere las mismas instancias.
	 */
	private Solucion solucionHeuristica(ArrayList<Vertice> arrayList) {
		Solucion heuristica = new Solucion(arrayList.size());
		
		while (! arrayList.isEmpty()) {			
			int elem = ((Double) (Math.random() * (arrayList.size() * PORCENTAJE))).intValue();
			Vertice aux = arrayList.get(elem);

			if(heuristica.puedoAgregar(aux))
				heuristica.agregarASolucion(aux);

			arrayList.remove(elem);
		}
		
		return heuristica;
	}
	
	/**
	 *  Devuelve una lista con los nodos a agregar como mucho 3. 
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
