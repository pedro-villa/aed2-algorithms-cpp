#include <iostream>
#include <vector>
#include <string>
#include <cmath>
#include <sys/time.h>

using namespace std; 

pair<int, int> resolucionDirecta (int dife[], int posInicial, int posFinal, int m){
	int sumaParcial = 0; 
	for (int j = posInicial; j<posInicial + m; j++){
		sumaParcial += dife[j];
	}
	pair<int, int> solucion{posInicial, sumaParcial};
	
	for(int i = posInicial + 1; i <= posFinal - m; i++){
		sumaParcial = sumaParcial - dife[i-1] + dife[i+m-1];
		
		if(sumaParcial > solucion.second)
			solucion = {i, sumaParcial};
	}
	
	return solucion;
}


double ejercicio2 (int n, int m, const string& A, const string& B){
	vector<int> dife(n);
	for(int i = 0; i<n; i++){
		dife[i] = abs((int)A[i] - (int)B[i]);
	}
	
	// Se mide el tiempo del algoritmo
	struct timeval ti, tf;
	double tiempo;
	gettimeofday(&ti, NULL);
	
	resolucionDirecta(dife.data(), 0, n, m);
	
	gettimeofday(&tf, NULL);
	tiempo = (tf.tv_sec - ti.tv_sec) * 1000 + (tf.tv_usec - ti.tv_usec) / 1000.0;
	
	return tiempo;
	
}

int main (){
	int n, m;
	cin >> n >> m;
	string A, B;
	cin >> A;
	cin >> B;

	double solucion = ejercicio2(n, m, A, B);	
	cout << solucion << endl;

}
