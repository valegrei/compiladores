#ifndef GRAFO_HEADER
#define GRAFO_HEADER

#include <iostream>
#include <list>
using namespace std;
struct par{
    int dest;
    int peso;
};
typedef par fila;

class Graph{
    private:
        //Lista de adyacencia
        int N = 10000;
        int nroVertices;
        list<fila> *listaAdyacencia;
        bool esDigrafo;
    
    public:
        Graph(int, bool);
        ~Graph();
        void insertarArista(int, int, int);
        void imprimirListaAdyacencia();
        void reiniciarVisitas();
        void dfs(int, bool*);
        void bfs(int);
        bool existeCircuito();
        bool buscaCircuitoDfs(int, int, bool*);
        bool bicolorable();
        bool dfsColor(int, int, int*);
        int minDistance(int*, bool*);
        void dijkstra(int);
};
#endif