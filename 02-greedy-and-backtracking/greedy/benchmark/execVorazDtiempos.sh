#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Tamaños de entrada para evaluar
tamanos=(100 500 1000 2000 5000 10000)

# Número de ejecuciones por tamaño de entrada
nEjec=5

# Archivo para almacenar los resultados
fichero="$SCRIPT_DIR/resultados.txt"

# Elimina el archivo de resultados si ya existe
rm -f "$fichero"

# Compila el código C++
if ! g++ -std=c++17 -O3 -Wall -Wextra -Wpedantic -o "$SCRIPT_DIR/voraz" "$SCRIPT_DIR/vorazDtiempos.cpp"; then
    echo "Error: No se pudo compilar vorazDtiempos.cpp"
    exit 1
fi

# Ejecuta el código C++ con diferentes tamaños de entrada y registra los tiempos
for tamano in "${tamanos[@]}"
do
    echo "Tamaño de entrada: $tamano" >> "$fichero"
    for ((i=1; i<=$nEjec; i++))
    do
        A=$(( (RANDOM % ($tamano - 1)) + 1 ))
        echo "Caso $i: Unidades de tiempo disponibles (Ut) = $tamano, Número de aviones (A) = $A" >> "$fichero"
        # Escribe Ut y A en el archivo temporal
        echo "$tamano $A" > "$SCRIPT_DIR/datosEntrada.txt"
        # Genera los tiempos máximos para aterrizar (T) y los beneficios (B) de cada avión
    	for ((j=0; j<$A; j++))
    	do
        	T=$(( $RANDOM % 10000 + 1 ))
        	echo "$T" >> "$SCRIPT_DIR/datosEntrada.txt"
    	done

    	for ((j=0; j<$A; j++))
    	do
    	    B=$(( $RANDOM % 10000 + 1 ))
    	    echo "$B" >> "$SCRIPT_DIR/datosEntrada.txt"
    	done
        # Ejecuta el algoritmo en C++
        "$SCRIPT_DIR/voraz" < "$SCRIPT_DIR/datosEntrada.txt" >> "$fichero"
        # Elimina el archivo temporal
        rm -f "$SCRIPT_DIR/datosEntrada.txt"
    done
    echo "" >> "$fichero"
done

rm -f "$SCRIPT_DIR/voraz"

echo "Experimento completado. Los resultados se han almacenado en el archivo $fichero."
