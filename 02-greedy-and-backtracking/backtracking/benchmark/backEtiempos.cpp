#include <iostream>
#include <algorithm>
#include <sys/time.h>

using namespace std;

const int N = 999;

void Generar(int nivel, int distancias[N][N], int s[N], int& dact) {
    s[nivel] = (s[nivel] + 1) % 2;
    if (s[nivel] == 1) {
        for (int i = 0; i < nivel; ++i) {
            if (s[i] == 1) { 
                dact += distancias[i][nivel] + distancias[nivel][i];
            }
        }
    }
}

bool Solucion(int nivel, int n, int m, int s[N]) {
    (void)nivel;
    int elegido = 0;
    for (int i = 0; i < n; ++i) {
        if (s[i] == 1) {
            elegido++;
        }
    }
    return (elegido == m);
}

bool Criterio(int nivel, int n, int m, int s[N]) {
    int elegido = 0;
    for (int i = 0; i < n; ++i) {
        if (s[i] == 1) {
            elegido++;
        }
    }
    return (nivel < n - 1) && (elegido < m);
}

bool MasHermanos(int nivel, int s[N]) {
    return s[nivel] < 1;
}

void Retroceder(int nivel, int distancias[N][N], int s[N], int& dact) {
    if (s[nivel] == 1) {
        for (int i = 0; i < nivel; ++i) {
            if (s[i] == 1) {
                dact -= distancias[i][nivel] + distancias[nivel][i];
            }
        }
    }
    s[nivel] = -1;
}

int Backtracking(int n, int m, int distancias[N][N]) {
    int nivel = 0;
    int voa = -1;
    int dact = 0;
    int s[N];
    
    for (int i = 0; i < n; ++i) {
    	s[i] = -1;
	}

    do {
        Generar(nivel, distancias, s, dact);
        if (Solucion(nivel, n, m, s) && (dact > voa)) {
            voa = dact;
        }
        if (Criterio(nivel, n, m, s)) {
            nivel++;
        } 
        else {
            while (!MasHermanos(nivel, s) && (nivel >= 0)) {
                Retroceder(nivel, distancias, s, dact);
                nivel--;
            }
        }
    } while (nivel >= 0);
    return voa;
}

int main() {
	int n, m;
    cin >> n >> m;
    static int distancias[N][N];
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            cin >> distancias[i][j];
        }
    }
    struct timeval ti, tf;
    gettimeofday(&ti, NULL);
    int resultado = Backtracking(n, m, distancias);
    (void)resultado;
    gettimeofday(&tf, NULL);
    double tiempo = (tf.tv_sec - ti.tv_sec) * 1000 + (tf.tv_usec - ti.tv_usec) / 1000.0;
    cout << tiempo << endl; 
    
    return 0;
}
