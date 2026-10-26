#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Tamaños de entrada para evaluar
tamanos=(2 4 6 8 10 12 14 16 18 20 22 24)

# Número de ejecuciones por tamaño de entrada
nEjec=5

# Archivo para almacenar los resultados
fichero="$SCRIPT_DIR/resultados.txt"

# Elimina el archivo de resultados si ya existe
rm -f "$fichero"

# Compila el código C++
if ! g++ -std=c++17 -O3 -Wall -Wextra -Wpedantic -o "$SCRIPT_DIR/back" "$SCRIPT_DIR/backEtiempos.cpp"; then
    echo "Error: No se pudo compilar backEtiempos.cpp"
    exit 1
fi

# Ejecuta el código C++ con diferentes tamaños de entrada y registra los tiempos
for tamano in "${tamanos[@]}"
do
    echo "Tamaño de entrada: $tamano" >> "$fichero"
    for ((i=1; i<=$nEjec; i++))
    do
    	m=$(( (RANDOM % ($tamano - 1)) + 1 ))
        echo "Ejecución $i: (n=$tamano, m=$m)" >> "$fichero"
        # Escribe n y m en el archivo temporal
        echo "$tamano $m" > "$SCRIPT_DIR/distanciasPrueba.txt"
        # Genera y escribe la matriz de distancias aleatorias en el archivo temporal
        for ((row=0; row<$tamano; row++))
        do
            for ((col=0; col<$tamano; col++))
            do
                val=$(( ( RANDOM % 100 ) + 1 ))
                echo -n "$val " >> "$SCRIPT_DIR/distanciasPrueba.txt"
            done
            echo "" >> "$SCRIPT_DIR/distanciasPrueba.txt"
        done
        # Ejecuta el algoritmo en C++ con la matriz de distancias generada
        "$SCRIPT_DIR/back" < "$SCRIPT_DIR/distanciasPrueba.txt" >> "$fichero"
        # Elimina el archivo temporal de la matriz de distancias
        rm -f "$SCRIPT_DIR/distanciasPrueba.txt"
    done
    echo "" >> "$fichero"
done

rm -f "$SCRIPT_DIR/back"

echo "Experimento completado. Los resultados se han almacenado en el archivo $fichero."
