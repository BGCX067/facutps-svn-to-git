package src;

import java.util.ArrayList;

public class HeuristicaBusquedaLocal extends Ejercicio {

	private HeuristicaConstructiva heuristicaConstructiva;

	public final static String OUT_FILE_NAME = "TP3hbl_conclusion.out";

	/*
	 * Constructores
	 */

	public HeuristicaBusquedaLocal(int i){
		this.outFileName = OUT_FILE_NAME + i;
		Tools.leerArchivo(this, "TP3_concl_nodos.in_"+i);
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
		this.solucionGlobal = busquedaLocalPRUEBA2(this.solucionGlobal);
	}
	
	/**
	 * Aplica la busqueda local a partir de la solucion dada.
	 */
	public Solucion buscarSolucion(Solucion solucionInicial){
		this.solucionGlobal = busquedaLocalPRUEBA2(solucionInicial);
		return this.solucionGlobal;
	}
	
	/*
	 * Auxiliares
	 */

	/**
	 * Devuelve la mejor solucion que encuentra haciendo busqueda local, partiendo de la solucion que recibe.
	 */
	private Solucion busquedaLocal(Solucion solucionInicial){
		int mejoras =0;
		int repeticiones=0;
		boolean mejora= true;
		
		for(ArrayList<Vertice> conjunto : this.componentesConexas){Global.comp++;
			while(mejora && repeticiones < 50){Global.comp++;
				repeticiones++;Global.comp++;
				mejora = false;Global.comp++;
				Solucion mejorSolucion = new Solucion(solucionInicial);
			
				// Tomar conjuntos de a 2
				for(int i=0; i < conjunto.size() - 1; i++){Global.comp++;
					if(solucionInicial.getConjunto().contains(conjunto.get(i))){Global.comp++;
						for(int j=i+1; j < conjunto.size() ; j++){Global.comp++;
							if(solucionInicial.getConjunto().contains(conjunto.get(j))){
								Solucion solucionVecina = new Solucion(solucionInicial);Global.comp++;
								
								solucionVecina.sacarDeSolucion(conjunto.get(j));
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
				solucionInicial = mejorSolucion;
			}
			
			System.gc();
			System.runFinalization();
			
		}

		return solucionInicial;
	}
	
	/**
	 * Probando!!!
	 */
	private Solucion busquedaLocalPRUEBA(Solucion solucionInicial){
		int mejoras =0;
		int repeticiones=0;
		boolean mejora= true;
		
		for(ArrayList<Vertice> conjunto : this.componentesConexas){Global.comp++;
			while(mejora && repeticiones < 1000000){Global.comp++;
				repeticiones++;Global.comp++;
				mejora = false;Global.comp++;
				Solucion mejorSolucion = new Solucion(solucionInicial);
			
				// Tomar conjuntos de a 2
				for(int i=0; i < solucionInicial.getConjunto().size() - 1; i++){Global.comp++;
					if(conjunto.contains(solucionInicial.getVertice(i))){Global.comp++;
						for(int j=i+1; j < solucionInicial.getConjunto().size() ; j++){Global.comp++;
							if(conjunto.contains(solucionInicial.getVertice(j))){
								Solucion solucionVecina = new Solucion(solucionInicial);Global.comp++;
								
								solucionVecina.sacarDeSolucion(solucionInicial.getVertice(j));
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
				solucionInicial = mejorSolucion;
			}
			
			System.gc();
			System.runFinalization();
			
		}

		return solucionInicial;
	}
	
	private Solucion busquedaLocalPRUEBA2(Solucion solucionInicial){
		int mejoras =0;
		int repeticiones=0;
		
		int maxIteracion = 0;
		
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
									maxIteracion = repeticiones;
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
		
		Global.iteraciones[maxIteracion]++;

		return solucionInicial;
	}
	
	
	/*
	 * Auxiliares
	 */

	/**
	 *  Devuelve una lista con los nodos a agregar como mucho 3. 
	 */
	private ArrayList<Vertice> getConjuntoMejor(Solucion solucion){
		ArrayList<Vertice> mejorConjunto = new ArrayList<Vertice>();
		ArrayList<Vertice> conjunto = new ArrayList<Vertice>();
		int posiblesSize = solucion.getPosibles().size();
		int mejorPeso = 0;
		int peso = 0;
		
		for(int a=0; a < posiblesSize; a++){
			Vertice va = solucion.getVerticePosible(a);Global.comp++;
			conjunto.clear();
			conjunto.add(va);Global.comp++;
			peso = va.getPeso();Global.comp++;

			if(peso> mejorPeso){
				mejorConjunto.clear();
				mejorConjunto.addAll(conjunto);
				mejorPeso = peso;
			}
			for(int b=a+1; b < posiblesSize; b++){Global.comp++;
				Vertice vb = solucion.getVerticePosible(b);Global.comp++;
				if(!va.getVecinos().contains(vb)){
					conjunto.add(vb);Global.comp++;
					peso+=vb.getPeso();Global.comp++;
					if(peso> mejorPeso){
						mejorConjunto.clear();
						mejorConjunto.addAll(conjunto);Global.comp++;Global.comp++;
						mejorPeso = peso;
					}Global.comp++;					
					for(int c=b+1; c < (posiblesSize); c++){Global.comp++;
						Vertice vc = solucion.getVerticePosible(c);Global.comp++;
						if(!va.getVecinos().contains(vc) && !vb.getVecinos().contains(vc)){
							conjunto.add(vc);
							if(peso> mejorPeso){
								mejorConjunto.clear();Global.comp++;
								mejorConjunto.addAll(conjunto);Global.comp++;Global.comp++;Global.comp++;
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
