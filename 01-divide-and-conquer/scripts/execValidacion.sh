#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/../src"
OUT_DIR="$SCRIPT_DIR/salidaValidacion"

# Crea el directorio salidaValidacion si no existe
if [ ! -d "$OUT_DIR" ]; then
	mkdir -p "$OUT_DIR"
fi 

# Vaciar ficheros de salida en caso de que ya existan
: > "$OUT_DIR/salidaDYV.txt"
: > "$OUT_DIR/salidaDirecta.txt"

# Compilar generadorChar.cpp una sola vez fuera del bucle
if ! g++ -std=c++17 -O3 -Wall -Wextra -Wpedantic "$SRC_DIR/generadorChar.cpp" -o "$SCRIPT_DIR/p1"; then
    echo "Error: No se pudo compilar generadorChar.cpp"	
    exit 1
fi

# Compilar dyv.cpp
if ! g++ -std=c++17 -O3 -Wall -Wextra -Wpedantic "$SRC_DIR/dyv.cpp" -o "$SCRIPT_DIR/p2"; then
    echo "Error: No se pudo compilar dyv.cpp"
    exit 1
fi

# Compilar resolucionDirecta.cpp
if ! g++ -std=c++17 -O3 -Wall -Wextra -Wpedantic "$SRC_DIR/resolucionDirecta.cpp" -o "$SCRIPT_DIR/p3"; then
    echo "Error: No se pudo compilar resolucionDirecta.cpp"
    exit 1
fi

for i in $(seq 1 1000)
do 
	# Ejecutar generadorChar.cpp y redirigir la salida a temp.txt
	"$SCRIPT_DIR/p1" > "$SCRIPT_DIR/temp.txt"
	if [ $? -ne 0 ]; then
   		echo "Error: Fallo al ejecutar generadorChar.cpp"
    	exit 1
	fi
	# Ejecutar dyv.cpp tomando la entrada de temp.txt
	"$SCRIPT_DIR/p2" < "$SCRIPT_DIR/temp.txt" >> "$OUT_DIR/salidaDYV.txt"
	if [ $? -ne 0 ]; then
	    echo "Error: Fallo al ejecutar dyv.cpp"
	    exit 1
	fi
	# Ejecutar resolucionDirecta tomando la entrada de temp.txt
	"$SCRIPT_DIR/p3" < "$SCRIPT_DIR/temp.txt" >> "$OUT_DIR/salidaDirecta.txt"
	if [ $? -ne 0 ]; then
    	echo "Error: Fallo al ejecutar resolucionDirecta.cpp"
    	exit 1
	fi
done

# Eliminar ficheros temporales creados
rm -f "$SCRIPT_DIR/p1" "$SCRIPT_DIR/p2" "$SCRIPT_DIR/p3" "$SCRIPT_DIR/temp.txt"

# Verificar que ambos algoritmos producen exactamente la misma salida en los 1000 casos
if diff -u "$OUT_DIR/salidaDYV.txt" "$OUT_DIR/salidaDirecta.txt" > /dev/null; then
    echo "Proceso completado correctamente: 1000/1000 casos coinciden exactamente."
else
    echo "Error: Se encontraron discrepancias entre Divide y Vencerás y Resolución Directa."
    exit 1
fi
