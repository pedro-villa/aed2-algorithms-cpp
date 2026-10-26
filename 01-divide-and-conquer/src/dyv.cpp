#include <iostream>
#include <vector>
#include <string>
#include <cmath>
#include <algorithm>

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

pair<int, int> divideYVenceras(int dife[], int n, int posInicial, int posFinal, int m){
	if(posFinal <= posInicial){
		pair<int, int> aux{0, 0};
		return aux;
	}
	else if(m==n || posFinal - posInicial < 2*m){
		return resolucionDirecta(dife, posInicial, posFinal, m);
	}
	int puntoMedio = posInicial + (posFinal-posInicial) / 2;
	pair<int, int> s1 = divideYVenceras(dife, n, posInicial, puntoMedio, m);
	pair<int, int> s2 = divideYVenceras(dife, n, puntoMedio, posFinal, m);
	pair<int, int> s3 = resolucionDirecta(dife, max(posInicial, puntoMedio - m + 1), min(posFinal, puntoMedio + m), m);
	int maximo = max(s1.second, max(s2.second, s3.second));
	if(maximo == s1.second){
		return s1;
	} else if(maximo == s3.second){
		return s3;
	} else {	
		return s2;
	}
}

pair<int, int> ejercicio2 (int n, int m, const string& A, const string& B){
	vector<int> dife(n);
	for(int i = 0; i<n; i++){
		dife[i] = abs((int)A[i] - (int)B[i]);
	}
	return divideYVenceras(dife.data(), n, 0, n, m);
}

int main (){
	int n, m;
	cin >> n >> m;
	string A, B;
	cin >> A;
	cin >> B;

	pair<int, int> solucion = ejercicio2(n, m, A, B);	
	cout << "posición de inicio igual a " << solucion.first + 1 << ", y diferencia total igual a "+ to_string(solucion.second) << endl;

}
