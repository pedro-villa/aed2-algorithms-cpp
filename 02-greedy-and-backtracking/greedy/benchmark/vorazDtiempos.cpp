#include <iostream>
#include <sys/time.h>
#include <algorithm>
#include <vector>

using namespace std;

struct Avion {
    int tiempoMax;
    int beneficio;
};

bool comparar(const Avion& a, const Avion& b) {
    return a.beneficio > b.beneficio;
}

int maxBeneficio(Avion aviones[], int A, int Ut) {
    sort(aviones, aviones + A, &comparar);
    vector<bool> huecosAterrizaje(Ut, false);
    
    int beneficioTotal = 0;
    
    int i = 0;
    while(i < A){
    	int j = min(Ut, aviones[i].tiempoMax) - 1;
    	while(j >= 0){
    		if (huecosAterrizaje[j] == false) {
                huecosAterrizaje[j] = true;
                beneficioTotal += aviones[i].beneficio;
                break;
            }
    		j--;
    	}
    	i++;
    }

    return beneficioTotal;
}

int main(void) {
	int Ut, A; 
    cin >> Ut >> A;
    vector<Avion> aviones(A);
    
    for (int j = 0; j < A; j++) {
        cin >> aviones[j].tiempoMax;
    }

    for (int j = 0; j < A; j++) {
        cin >> aviones[j].beneficio;
    }    
    
	struct timeval ti, tf;
	double tiempo;
	gettimeofday(&ti, NULL);
	
    maxBeneficio(aviones.data(), A, Ut);
        
    gettimeofday(&tf, NULL);
	tiempo = (tf.tv_sec - ti.tv_sec) * 1000 + (tf.tv_usec - ti.tv_usec) / 1000.0;
    cout << tiempo << endl;

    return 0;
}
