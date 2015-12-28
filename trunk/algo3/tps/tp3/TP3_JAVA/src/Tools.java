package src;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;

public class Tools {

	public final static int ORDEN_ASCENDENTE 	= 0;
	public final static int ORDEN_DESCENDENTE 	= 1;
	
	public final static int POR_PESO 			= 2;
	public final static int POR_NUMERO			= 3;
	
	/**
	 * Implementacion de Quicksort para un listado de Vertices. Ordena por peso.
	 * @param vertices lista de vertices a ordenar
	 * @param orden ASCENDENTE o DESCENDENTE
	 * @return listado de los vertices ordenados por peso segun el orden.
	 */
	public static ArrayList<Vertice> quicksort(ArrayList<Vertice> vertices, int orden) {
		return quickSort(vertices, orden, POR_PESO);
	}
	
	/**
	 * Implementacion de Quicksort para un listado de Vertices. 
	 * @param vertices lista de vertices a ordenar
	 * @param orden ASCENDENTE o DESCENDENTE
	 * @param op = POR_PESO o POR_NUMERO
	 * @return listado de los vertices ordenados por peso segun el orden.
	 */
	public static ArrayList<Vertice> quicksort(ArrayList<Vertice> vertices, int orden, int op) {
		return quickSort(vertices, orden, op);
	}
	
	/**
	 * Ordena el conjunto de la solcion de forma ascendente y por numero de nodo 
	 * para luego escribir el archivo correspondiente.
	 *
	 */
	public static void escribirSolucion(Solucion solucionGlobal, String file_name) {
		solucionGlobal.ordenarConjuntoSolucion(Tools.ORDEN_ASCENDENTE, Tools.POR_NUMERO);

		try {
			// El archivo fileName ya esta generado, se le agregan lineas nuevas. 
			BufferedWriter out = new BufferedWriter(new FileWriter(file_name, true));
			out.write(solucionGlobal.toString());
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	
	//TODO: BORRAME
	public static void leerArchivo(Ejercicio ejercicio, String path) {
		try {
			// Creamos el archivo de output vacio.
			new FileWriter(ejercicio.getOutFileName());
			
			// Empieza a leer el archivo
			BufferedReader in = new BufferedReader(new FileReader(path));
			ArrayList<Vertice> vertices;
			
			// Leo los primeros datos
			String line = in.readLine(); 
			String[] datos = line.split(" ");
			while (! line.equals("0")){
				int nodos = Integer.parseInt(datos[0]);
				int[][] matrizAdyacencia = new int[nodos][nodos]; // podemos poner uno mas para el peso?
				
				// Creamos todos los vertices, para que sean unicos y podamos hacer referencia siempre a ellos.
				vertices = new ArrayList<Vertice>();
				for(int j=0; j < nodos ;j++)
					vertices.add(new Vertice(j+1));
				
				//Levantamos los datos, creamos lista de adyacencia  y su matriz				
				for(int j=0; j < nodos ;j++){
					line = in.readLine();
					datos = line.split(" ");

					int peso = Integer.parseInt(datos[0]);
					Vertice nodoActual = vertices.get(j);

					nodoActual.setPeso(peso);

					for(int a=1; a < datos.length; a++){
						int vecino = Integer.parseInt(datos[a])-1;
						matrizAdyacencia[j][vecino] = 1 ;
						nodoActual.addVecino( vertices.get(vecino) );
					}
				}
				
				if((ejercicio instanceof HeuristicaConstructiva)) 
					vertices = Tools.quicksort(vertices, Tools.ORDEN_DESCENDENTE);
				
				ejercicio.setVertices(vertices);
				ejercicio.separarComponentesConexas();
				ejercicio.buscarSolucion();
				
				// Validador
//				ejercicio.validarSolucion();
				
				ejercicio.escribirSolucion();

				line = in.readLine(); 
				datos = line.split(" ");
			}

			in.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 *  Lee el archivo especificado y devuelve un arraylist con los vertices ya cargados.
	 */
	public static void leerArchivo(Ejercicio ejercicio) {
		try {
			// Creamos el archivo de output vacio.
			new FileWriter(ejercicio.getOutFileName());
			
			// Empieza a leer el archivo
			BufferedReader in = new BufferedReader(new FileReader(Ejercicio.IN_FILE_NAME));
			ArrayList<Vertice> vertices;
			
			// Leo los primeros datos
			String line = in.readLine(); 
			String[] datos = line.split(" ");
			while (! line.equals("0")){
				int nodos = Integer.parseInt(datos[0]);
				int[][] matrizAdyacencia = new int[nodos][nodos]; // podemos poner uno mas para el peso?
				
				// Creamos todos los vertices, para que sean unicos y podamos hacer referencia siempre a ellos.
				vertices = new ArrayList<Vertice>();
				for(int j=0; j < nodos ;j++)
					vertices.add(new Vertice(j+1));
				
				//Levantamos los datos, creamos lista de adyacencia  y su matriz				
				for(int j=0; j < nodos ;j++){
					line = in.readLine();
					datos = line.split(" ");

					int peso = Integer.parseInt(datos[0]);
					Vertice nodoActual = vertices.get(j);

					nodoActual.setPeso(peso);

					for(int a=1; a < datos.length; a++){
						int vecino = Integer.parseInt(datos[a])-1;
						matrizAdyacencia[j][vecino] = 1 ;
						nodoActual.addVecino( vertices.get(vecino) );
					}
				}
				
				if((ejercicio instanceof HeuristicaConstructiva)) 
					vertices = Tools.quicksort(vertices, Tools.ORDEN_DESCENDENTE);
				
				ejercicio.setVertices(vertices);
				ejercicio.separarComponentesConexas();
				ejercicio.buscarSolucion();
				
				// Validador
//				ejercicio.validarSolucion();
				
				ejercicio.escribirSolucion();

				line = in.readLine(); 
				datos = line.split(" ");
			}

			in.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
	
	/**
	 * Separa los vertices en las componentesConexas, aplicando DFS. 
	 */
	public static ArrayList<ArrayList<Vertice>> separarEnComponentesConexas(ArrayList<Vertice> vertices){
		ArrayList<ArrayList<Vertice>> componentesConexas = new ArrayList<ArrayList<Vertice>>();
		ArrayList<Vertice> dfs = new ArrayList<Vertice>();
		
		int numero_componentes_conexas = 1;
		
		for(Vertice va : vertices){
			if(va.getComponenteConexa() == 0){
				va.setComponenteConexa(numero_componentes_conexas);
				dfs.add(va);
				
				// Empieza una nueva componente Conexa
				ArrayList<Vertice> nuevaCC = new ArrayList<Vertice>();
				nuevaCC.add(va);
				
				while(! dfs.isEmpty()){
					Vertice vb = dfs.get(0);

					for( Vertice vn : vb.getVecinos()){
						if((vn.getComponenteConexa() == 0)){
							vn.setComponenteConexa(numero_componentes_conexas);
							nuevaCC.add(vn);
							dfs.add(vn);
						}
					}

					dfs.remove(vb);

				}
				// Agrega a componentes Conexas
				componentesConexas.add(nuevaCC);
				numero_componentes_conexas++; // Incrementamos el numero de componentes Conexas
			}
		}
		
		System.gc();
		System.runFinalization();
		return componentesConexas;
	}
	
	/*
	 * Auxiliares
	 */
	
	/**
	 * 
	 * @param vertices = los vertices a ordenar.
	 * @param orden = ascendente o descendente
	 * @param op = Ordenar por, elije el parametro por cual ordenar
	 * @return los vertices ordenados.
	 */
	private static ArrayList<Vertice> quickSort(ArrayList<Vertice> vertices, int orden, int op) {
		if (vertices.size() <= 1)
			return vertices;
		int pivot = vertices.size() / 2;
		ArrayList<Vertice> lesser = new ArrayList<Vertice>();
		ArrayList<Vertice> greater = new ArrayList<Vertice>();
		ArrayList<Vertice> equal = new ArrayList<Vertice>();
		
		if(orden == ORDEN_ASCENDENTE){
			for (Vertice vertice : vertices) {
	            if (valor(op,vertice) > valor(op,vertices.get(pivot)))
	                greater.add(vertice);
	            else if (valor(op,vertice) < valor(op,vertices.get(pivot)))
	                lesser.add(vertice);
	            else
	            	equal.add(vertice);
	        }
		}else if(orden == ORDEN_DESCENDENTE){
			for (Vertice vertice : vertices) {
	            if (valor(op,vertice) < valor(op,vertices.get(pivot)))
	                greater.add(vertice);
	            else if (valor(op,vertice) > valor(op,vertices.get(pivot)))
	                lesser.add(vertice);
	            else
	            	equal.add(vertice);
	        }
		}
		lesser = quickSort(lesser, orden, op);
		for (Vertice Vertice : equal)
			lesser.add(Vertice);
		greater = quickSort(greater, orden, op);
		ArrayList<Vertice> sorted = new ArrayList<Vertice>();
		for (Vertice Vertice : lesser)
			sorted.add(Vertice);
		for (Vertice Vertice : greater)
			sorted.add(Vertice);
		return sorted;
	}
	
	/**
	 * Devuelve el valor para ordenar, dependiendo por que parametro se quiere ordenar.
	 */
	private static int valor(int ordenarPor, Vertice v){
		if(ordenarPor == POR_PESO)
			return v.getPeso();
		else
			return v.getNumero();		
		
	}
	
}
