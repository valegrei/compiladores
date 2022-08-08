#include "grafo.h"
#include <queue>

Graph::Graph(int nroVertices){
    this->nroVertices = nroVertices;
    listaAdyacencia = new list<fila>[nroVertices];
}

Graph::~Graph(){
    for(int i=0; i<nroVertices; i++){
        listaAdyacencia[i].~list();
    }
    delete listaAdyacencia;
}

void Graph::insertarArista(int src, int dest, int peso){
    fila f;
    f.dest = dest;
    f.peso = peso;
    listaAdyacencia[src].push_back(f);
}

void Graph::imprimirListaAdyacencia(){
    cout << "Lista de adyacencia:" << endl;
    for (int i = 0; i< nroVertices; i++){
        for( fila f : listaAdyacencia[i]){
            cout << "(" << i << ", " << f.dest << ", " << f.peso << ") ";
        }
        cout << endl;
    }
}

void Graph::dfs(int vertice, bool *visitado){
    if(visitado == NULL)
        visitado = new bool[nroVertices]{false};
    visitado[vertice] = 1;
    cout << vertice << " ";
    
    for(fila i: listaAdyacencia[vertice]){
        if(!visitado[i.dest])
            dfs(i.dest, visitado);
    }
}

void Graph::bfs(int vertice){
    bool visitado[nroVertices] = {false};
    queue<int> q;
    q.push(vertice);

    while(!q.empty()){
        int v = q.front();
        q.pop();
        if(!visitado[v]){
            visitado[v] = true;
            cout << v << " ";
            for(fila f : listaAdyacencia[v]){
                if(!visitado[f.dest])
                    q.push(f.dest);
            }
        }
    }
}

bool Graph::existeCircuito(){
    bool visitado[nroVertices] = {false};
    for(int v=0; v< nroVertices; v++){
        if(!visitado[v]){
            if(buscaCircuitoDfs(v,v, visitado)) return true;
        }
    }
    return false;
}

bool Graph::buscaCircuitoDfs(int v, int padreV, bool *visitado){
    visitado[v] = true;
    for(fila f : listaAdyacencia[v]){
        if(!visitado[f.dest]){
            if(buscaCircuitoDfs(f.dest, v, visitado)) return true;
        }else if(padreV != f.dest){
            return true;
        }
    }
    return false;
}