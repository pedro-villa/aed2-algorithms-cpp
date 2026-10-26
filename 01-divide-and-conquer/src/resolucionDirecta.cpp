#include <iostream>
#include <vector>
#include <string>
#include <cmath>

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


pair<int, int> ejercicio2 (int n, int m, const string& A, const string& B){
	vector<int> dife(n);
	for(int i = 0; i<n; i++){
		dife[i] = abs((int)A[i] - (int)B[i]);
	}
	return resolucionDirecta(dife.data(), 0, n, m);
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
