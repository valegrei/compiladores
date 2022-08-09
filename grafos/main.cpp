#include "grafo.h"
#include <iostream>
using namespace std;

int main(){
    Graph g = Graph(7,false);
	g.insertarArista(0,1,1);
	g.insertarArista(0,4,1);
	g.insertarArista(1,5,1);
	g.insertarArista(2,3,1);
	g.insertarArista(3,6,1);
	g.insertarArista(4,5,1);
	g.insertarArista(5,6,1);
    g.imprimirListaAdyacencia();
    cout << "DFS" << endl;
    g.dfs(0,NULL);
    cout << endl << "BFS" << endl;
    g.bfs(0);
    cout << endl << "Hay circuitos: "<< (g.existeCircuito()?"Si":"No") << endl;
    cout << endl << "Es bicolorable: "<< (g.bicolorable()?"Si":"No") << endl;
    return 0;
}