#include "grafo.h"
#include <iostream>
using namespace std;

int main(){
    Graph g = Graph(7);
    g.insertarArista(0, 1, 3);
	g.insertarArista(0, 2, 1);
	g.insertarArista(1, 0, 3);
	g.insertarArista(1, 3, 1);
	g.insertarArista(1, 6, 5);
	g.insertarArista(1, 2, 2);
	g.insertarArista(2, 0, 1);
	g.insertarArista(2, 3, 2);
	g.insertarArista(2, 5, 5);
	g.insertarArista(3, 1, 1);
	g.insertarArista(3, 2, 2);
	g.insertarArista(3, 5, 2);
	g.insertarArista(3, 4, 4);
	g.insertarArista(4, 3, 4);
	g.insertarArista(4, 6, 2);
	g.insertarArista(4, 7, 1);
	g.insertarArista(5, 2, 5);
	g.insertarArista(5, 3, 2);
	g.insertarArista(5, 7, 3);
	g.insertarArista(6, 1, 5);
	g.insertarArista(6, 4, 2);
	g.insertarArista(7, 5, 3);
	g.insertarArista(7, 4, 1);
    g.imprimirListaAdyacencia();
    cout << "DFS" << endl;
    g.dfs(0,NULL);
    cout << endl << "BFS" << endl;
    g.bfs(0);
    cout << endl << "Hay circuitos: "<< g.existeCircuito() << endl;
    return 0;
}