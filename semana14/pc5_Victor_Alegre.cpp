#include <iostream>
#include <queue>
using namespace std;

const int N = 100;

struct tabla
{
	char vertice;
	int fin;
	int temporal;
	char ruta;
};

struct arista
{
	char datoDestino;
	int distancia;
	arista *sgteArista;
};

struct vertice
{
	char datoOrigen;
	arista *adyacente;
	vertice *sgteVertice;
};

typedef tabla tablaInformativa;
typedef arista *parista;
typedef vertice *pvertice;

class grafo
{
private:
	pvertice pGrafo;
	tablaInformativa ti[N];
	int nrovertices, aux;

public:
	grafo();
	~grafo();
	void insertarVertice(char);
	void insertarArista(char, char, int);
	void imprimirGrafo();
	pvertice buscarVertice(char);
	//void distanciaMin(char, char);
	void imprimirTabla();
	//void caminoMinimo(char, char);
    void BFS(char,char);
};

grafo::grafo()
{
	pGrafo = NULL;
	for (aux = 0; aux < N; aux++)
	{
		ti[aux].temporal = 0;
		ti[aux].fin = 0;
	}
	nrovertices = 0;
}

grafo::~grafo()
{
	pvertice p, rp;
	parista r, ra;
	p = pGrafo;
	while (p != NULL)
	{
		r = p->adyacente;
		while (r != NULL)
		{
			ra = r;
			r = r->sgteArista;
			delete ra;
		}
		rp = p;
		p = p->sgteVertice;
		delete rp;
	}
}

void grafo::insertarVertice(char x)
{
	pvertice p;
	p = new vertice;
	p->datoOrigen = x;
	p->adyacente = NULL;
	p->sgteVertice = pGrafo;
	pGrafo = p;
	ti[nrovertices].vertice = x;
	nrovertices++;
}

void grafo::insertarArista(char x, char y, int d)
{
	pvertice p;
	parista a;
	p = pGrafo;
	if (p != NULL)
	{
		while (p->datoOrigen != x && p != NULL)
			p = p->sgteVertice;
		if (p != NULL)
		{
			a = new arista;
			a->datoDestino = y;
			a->distancia = d;
			a->sgteArista = p->adyacente;
			p->adyacente = a;
		}
	}
}

void grafo::imprimirGrafo()
{
	pvertice p;
	parista a;
	p = pGrafo;
	if (p == NULL)
		cout << "Grafo vac�o" << endl;
	else
		while (p != NULL)
		{
			cout << p->datoOrigen << " ";
			a = p->adyacente;
			while (a != NULL)
			{
				cout << " (" << a->datoDestino << " , " << a->distancia << ") ";
				a = a->sgteArista;
			}
			cout << endl;
			p = p->sgteVertice;
		}
}

pvertice grafo::buscarVertice(char x)
{
	pvertice p;
	p = pGrafo;
	while (p != NULL)
	{
		if (p->datoOrigen == x)
			return p;
		p = p->sgteVertice;
	}
	return p;
}

void grafo::imprimirTabla()
{
	for (int i = 0; i < nrovertices; i++)
		cout << ti[i].vertice << " " << ti[i].fin << " " << ti[i].temporal << " " << ti[i].ruta << endl;
}

int existeCaminoDist(grafo G, char s, char t, int d){
    pvertice inicio = G.buscarVertice(s);
    parista siguiente = inicio->adyacente;
    if(siguiente->datoDestino==t){
        if(siguiente->distancia>d){
            //cout<<"Entre al if"<<endl;
            cout << siguiente->datoDestino << " <- " << inicio->datoOrigen ;
            return 1;
        }
        //cout<<"No entre al if"<<endl;
        return 0;
    }
    while(siguiente->sgteArista!=NULL){
        //cout<<"Entre al while"<<endl;
        if(existeCaminoDist(G,siguiente->datoDestino,t,d-siguiente->distancia)) {
            cout << " <- " <<inicio->datoOrigen;
            return 1;
        }
        //cout<<"Recorri a la siguiente arista"<<endl;
        siguiente = siguiente->sgteArista;
    }
    //cout<<"Sali del while"<<endl;
    return 0;
}

int main(int argc, char const *argv[])
{
    /* code */
    grafo g;
	char x, y;
	int d;
	g.insertarVertice('A');
	g.insertarVertice('B');
	g.insertarVertice('C');
	g.insertarVertice('D');
	g.insertarVertice('E');
	g.insertarVertice('F');
	g.insertarVertice('G');
	g.insertarVertice('H');
	g.insertarArista('A', 'B', 3);
	g.insertarArista('A', 'C', 1);
	g.insertarArista('B', 'A', 3);
	g.insertarArista('B', 'D', 1);
	g.insertarArista('B', 'G', 5);
	g.insertarArista('B', 'C', 2);
	g.insertarArista('C', 'A', 1);
	g.insertarArista('C', 'D', 2);
	g.insertarArista('C', 'F', 5);
	g.insertarArista('D', 'B', 1);
	g.insertarArista('D', 'C', 2);
	g.insertarArista('D', 'F', 2);
	g.insertarArista('D', 'E', 4);
	g.insertarArista('E', 'D', 4);
	g.insertarArista('E', 'G', 2);
	g.insertarArista('E', 'H', 1);
	g.insertarArista('F', 'C', 5);
	g.insertarArista('F', 'D', 2);
	g.insertarArista('F', 'H', 3);
	g.insertarArista('G', 'B', 5);
	g.insertarArista('G', 'E', 2);
	g.insertarArista('H', 'F', 3);
	g.insertarArista('H', 'E', 1);
    g.imprimirGrafo();
    int res = existeCaminoDist(g,'A','H',20);
    cout << endl;
    cout << "Respuesta: " << res << endl;
    return 0;
}
