#include <iostream>
#include <cstdlib>
#include <ctime> // Para utilizar time(0) y clock() en srand()
#include <climits>
using namespace std;

int next(int max) {
    return rand() % max; // Generar valores entre 0 y max-1
}

void imprimeCadena(int n){
    for (int i = 0; i < n; i++) {
        int random = next(26) + (int)'a'; // Generar números entre 0 y 25 (letras minúsculas)
        cout << char(random);
    }
    cout << endl;
}

int main() {
    srand(static_cast<unsigned int>(time(0)) ^ static_cast<unsigned int>(clock())); // Inicializar la semilla para rand()
    
    long int n = rand()%(1000000 - 10000) + 10000, m = n/1000;
    cout << n << " " << m << endl; 
    
    imprimeCadena(n);
    imprimeCadena(n);

    return 0;
}
