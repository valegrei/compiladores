#include "grafo.h"
#include <queue>

Graph::Graph(int nroVertices, bool esDigrafo){
    this->nroVertices = nroVertices;
    this->esDigrafo = esDigrafo;
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
    if(!esDigrafo){
        fila f2;
        f2.dest = src;
        f2.peso = peso;
        listaAdyacencia[dest].push_back(f2);
    }
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
    if(visitado == NULL){
        visitado = new bool[nroVertices];
        fill_n(visitado, nroVertices, false);
    }
    visitado[vertice] = 1;
    cout << vertice << " ";
    
    for(fila i: listaAdyacencia[vertice]){
        if(!visitado[i.dest])
            dfs(i.dest, visitado);
    }
}

void Graph::bfs(int vertice){
    bool visitado[nroVertices];
    fill_n(visitado, nroVertices, false);

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
    bool visitado[nroVertices];
    fill_n(visitado, nroVertices, false);

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

bool Graph::bicolorable(){
    int colores[nroVertices];
    fill_n(colores, nroVertices, -1);

    for(int v=0; v < nroVertices; v++){
        if(colores[v] == -1){
            if(!dfsColor(v, 0, colores)) return false;
        }
    }
    return true;
}

bool Graph::dfsColor(int v, int color, int *colores){
    colores[v] = color;
    for(fila f : listaAdyacencia[v]){
        if(colores[f.dest] == -1){
            if(!dfsColor(f.dest, 1 - color, colores)) return false;
        }else if(colores[f.dest] == color) return false;
    }
    return true;
}

int Graph::minDistance(int *dist, bool *sptSet){
    int min = N, min_index = -1;

    for(int v = 0; v < nroVertices; v++){
        if(dist[v] < min && !sptSet[v]){
            min = dist[v];
            min_index = v;
        }
    }
    return min_index;
}

void Graph::dijkstra(int src){
    int dist[nroVertices];
    bool sptSet[nroVertices];
    fill_n(dist,nroVertices,N);
    fill_n(sptSet,nroVertices,false);
}