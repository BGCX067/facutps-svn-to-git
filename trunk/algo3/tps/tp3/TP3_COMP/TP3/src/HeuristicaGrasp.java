package src;

import java.util.ArrayList;

public class HeuristicaGrasp extends Ejercicio {

	public final static String OUT_FILE_NAME 	= "TP3grasp_conclusion.out";
	private final static double PORCENTAJE 		= 0.2;
	
	
	/*
	 * Constructores
	 */
	
	public HeuristicaGrasp(int i){
		this.outFileName = OUT_FILE_NAME + i;
		Tools.leerArchivo(this, "TP3_concl_nodos.in_"+i);
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
		int iteracionMAX = 0;
		for (int i = 0; i < 100; i++) {Global.comp++;
//			Solucion solucionGrasp = busquedaLocalCC(solucionHeuristica((ArrayList<Vertice>) this.vertices.clone()));
//			Solucion solucionGrasp = busquedaLocalPRUEBA(solucionHeuristica((ArrayList<Vertice>) this.vertices.clone()));
			Solucion solucionGrasp = busquedaLocalPRUEBA2(solucionHeuristica((ArrayList<Vertice>) this.vertices.clone()));
			
//			Solucion solucionGrasp = solucionHeuristica((ArrayList<Vertice>) this.vertices.clone());
		
			if(this.solucionGlobal.getPeso() < solucionGrasp.getPeso()){
				this.solucionGlobal = solucionGrasp;
				Global.comp++;
				iteracionMAX = i;
			}
		}
		Global.iteraciones[iteracionMAX]++;
		
	}
	
	/**
	 * Devuelve la mejor solucion que encuentra haciendo busqueda local, partiendo de la solucion que recibe.
	 */
	private Solucion busquedaLocalCC(Solucion solucionInicial){
		int mejoras =0;
		int repeticiones=0;
		boolean mejora= true;
		
		for(ArrayList<Vertice> conjunto : this.componentesConexas){
			while(mejora && repeticiones < 5){Global.comp++;
				repeticiones++;Global.comp++;
				mejora = false;Global.comp++;
				Solucion mejorSolucion = new Solucion(solucionInicial);
			
				for(int i=0; i < conjunto.size() - 1; i++){Global.comp++;
					if(solucionInicial.getConjunto().contains(conjunto.get(i))){Global.comp++;
						for(int j=i+1; j < conjunto.size() ; j++){Global.comp++;
							if(solucionInicial.getConjunto().contains(conjunto.get(j))){Global.comp++;Global.comp++;
								Solucion solucionVecina = new Solucion(solucionInicial);
								
								solucionVecina.sacarDeSolucion(conjunto.get(j));Global.comp++;
								solucionVecina.sacarDeSolucion(conjunto.get(i));
								
								for(Vertice vb: getConjuntoMejor(solucionVecina)){
									solucionVecina.agregarASolucion(vb);
									Global.comp++;
								}
								Global.comp++;
								if(solucionVecina.getPeso() > mejorSolucion.getPeso()){
									mejorSolucion = solucionVecina;Global.comp++;
									mejoras++;
									mejora = true;
								}
							}
					    }
					}
				}
				solucionInicial = mejorSolucion;Global.comp++;
			}
			
			System.gc();
			System.runFinalization();
			
		}
//		System.out.println("Mejoro " + mejoras);
		return solucionInicial;
	}
	
	
	private Solucion busquedaLocalPRUEBA(Solucion solucionInicial){
		int mejoras =0;
		int repeticiones=0;
		boolean mejora= true;
		
		for(ArrayList<Vertice> conjunto : this.componentesConexas){
			while(mejora && repeticiones < 5){	Global.comp++;
				repeticiones++;Global.comp++;
				mejora = false;Global.comp++;
				Solucion mejorSolucion = new Solucion(solucionInicial);
			
				for(int i=0; i < solucionInicial.getConjunto().size() - 1; i++){Global.comp++;
					if(conjunto.contains(solucionInicial.getVertice(i))){Global.comp++;
						for(int j=i+1; j < solucionInicial.getConjunto().size() ; j++){Global.comp++;
							if(conjunto.contains(solucionInicial.getVertice(j))){Global.comp++;Global.comp++;
								Solucion solucionVecina = new Solucion(solucionInicial);
								
								solucionVecina.sacarDeSolucion(solucionInicial.getVertice(j));Global.comp++;
								solucionVecina.sacarDeSolucion(solucionInicial.getVertice(i));
								
								for(Vertice vb: getConjuntoMejor(solucionVecina)){
									solucionVecina.agregarASolucion(vb);
									Global.comp++;
								}
								Global.comp++;
								if(solucionVecina.getPeso() > mejorSolucion.getPeso()){
									mejorSolucion = solucionVecina;Global.comp++;
									mejoras++;
									mejora = true;
								}
							}
					    }
					}
				}
				solucionInicial = mejorSolucion;Global.comp++;
			}

			System.gc();
			System.runFinalization();

		}
//		System.out.println("Mejoro " + mejoras);
		return solucionInicial;
	}
	
	
	private Solucion busquedaLocalPRUEBA2(Solucion solucionInicial){
		int mejoras =0;
		int repeticiones=0;
		boolean mejora= true;
		
		for(ArrayList<Vertice> conjunto : this.componentesConexas){
			while(mejora && repeticiones < 30){	Global.comp++;
				repeticiones++;Global.comp++;
				mejora = false;Global.comp++;
				Solucion mejorSolucion = new Solucion(solucionInicial);
			
				for(int i=0; i < solucionInicial.getConjunto().size() - 1 && !mejora; i++){Global.comp++;
					if(conjunto.contains(solucionInicial.getVertice(i))){Global.comp++;
						for(int j=i+1; j < solucionInicial.getConjunto().size() && !mejora; j++){Global.comp++;
							if(conjunto.contains(solucionInicial.getVertice(j))){Global.comp++;Global.comp++;
								Solucion solucionVecina = new Solucion(solucionInicial);
								
								solucionVecina.sacarDeSolucion(solucionInicial.getVertice(j));Global.comp++;
								solucionVecina.sacarDeSolucion(solucionInicial.getVertice(i));
								
								for(Vertice vb: getConjuntoMejor(solucionVecina)){
									solucionVecina.agregarASolucion(vb);
									Global.comp++;
								}
								
								solucionVecina.completarSolucionConPosibles();
								
								Global.comp++;
								if(solucionVecina.getPeso() > mejorSolucion.getPeso()){
									mejorSolucion = solucionVecina;Global.comp++;
									mejoras++;
									mejora = true;
								}
							}
					    }
					}
				}
				solucionInicial = mejorSolucion;Global.comp++;
			}

			System.gc();
			System.runFinalization();

		}
//		System.out.println("Mejoro " + mejoras);
		
		return solucionInicial;
	}
	
	/*
	 * Auxiliares
	 */
	
	/**
	 * Heuristica por construccion con el factor random para que no genere las mismas instancias.
	 */
	@SuppressWarnings("unchecked")
	private Solucion solucionHeuristica(ArrayList<Vertice> arrayList) {
		Solucion heuristica = new Solucion(arrayList.size());
		
		while (! arrayList.isEmpty()) {	Global.comp++;		
			int elem = ((Double) (Math.random() * (arrayList.size() * PORCENTAJE))).intValue();
			Vertice aux = arrayList.get(elem);Global.comp++;
			Global.comp++;
			if(heuristica.puedoAgregar(aux))
				heuristica.agregarASolucion(aux);

			arrayList.remove(elem);Global.comp++;
		}
		
		return heuristica;
	}
	
	/**
	 *  Devuelve una lista con los nodos a agregar como mucho 3. 
	 */
	private ArrayList<Vertice> getConjuntoMejor(Solucion solucion){
		ArrayList<Vertice> mejorConjunto = new ArrayList<Vertice>();
		ArrayList<Vertice> conjunto = new ArrayList<Vertice>();
		int posiblesSize = solucion.getPosibles().size();
		int mejorPeso = 0;
		int peso = 0;
		Global.comp++;Global.comp++;Global.comp++;Global.comp++;
		for(int a=0; a < posiblesSize; a++){
			Vertice va = solucion.getVerticePosible(a);
			conjunto.clear();
			conjunto.add(va);Global.comp++;Global.comp++;Global.comp++;
			peso = va.getPeso();

			if(peso> mejorPeso){
				mejorConjunto.clear();
				mejorConjunto.addAll(conjunto);
				mejorPeso = peso;
			}Global.comp++;
			for(int b=a+1; b < posiblesSize; b++){Global.comp++;
				Vertice vb = solucion.getVerticePosible(b);Global.comp++;Global.comp++;
				if(!va.getVecinos().contains(vb)){
					conjunto.add(vb);Global.comp++;
					peso+=vb.getPeso();
					if(peso> mejorPeso){
						mejorConjunto.clear();Global.comp++;
						mejorConjunto.addAll(conjunto);
						mejorPeso = peso;
					}					
					for(int c=b+1; c < (posiblesSize); c++){Global.comp++;Global.comp++;
						Vertice vc = solucion.getVerticePosible(c);
						if(!va.getVecinos().contains(vc) && !vb.getVecinos().contains(vc)){
							conjunto.add(vc);
							if(peso> mejorPeso){
								mejorConjunto.clear();Global.comp++;
								mejorConjunto.addAll(conjunto);
								mejorPeso = peso;
							}
							conjunto.remove(vc);Global.comp++;
						}
					}
					conjunto.remove(vb);Global.comp++;
				}
			}
			conjunto.remove(va);Global.comp++;
		} 

		return mejorConjunto;
	}
	
}
