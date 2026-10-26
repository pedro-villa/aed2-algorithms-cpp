#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/../src"

# Crea el directorio salida si no existe
if [ ! -d "$SCRIPT_DIR/salida" ]; then
	mkdir -p "$SCRIPT_DIR/salida"
fi 

# Compilar generadorChar.cpp
if ! g++ -std=c++17 -O3 -Wall -Wextra -Wpedantic "$SRC_DIR/generadorChar.cpp" -o "$SCRIPT_DIR/p1"; then
    echo "Error: No se pudo compilar generadorChar.cpp"	
    exit 1
fi

# Compilar dyv.cpp
if ! g++ -std=c++17 -O3 -Wall -Wextra -Wpedantic "$SRC_DIR/dyv.cpp" -o "$SCRIPT_DIR/p2"; then
    echo "Error: No se pudo compilar dyv.cpp"
    exit 1
fi

# Ejecutar generadorChar.cpp y redirigir la salida a temp.txt
"$SCRIPT_DIR/p1" > "$SCRIPT_DIR/temp.txt"
if [ $? -ne 0 ]; then
    echo "Error: Fallo al ejecutar generadorChar.cpp"
    exit 1
fi

# Ejecutar dyv.cpp tomando la entrada de temp.txt y redirigiendo la salida a salidaDYV.txt
"$SCRIPT_DIR/p2" < "$SCRIPT_DIR/temp.txt" > "$SCRIPT_DIR/salida/salidaDYV.txt"
if [ $? -ne 0 ]; then
    echo "Error: Fallo al ejecutar dyv.cpp"
    exit 1
fi

# Compilar resolucionDirecta.cpp
if ! g++ -std=c++17 -O3 -Wall -Wextra -Wpedantic "$SRC_DIR/resolucionDirecta.cpp" -o "$SCRIPT_DIR/p3"; then
    echo "Error: No se pudo compilar resolucionDirecta.cpp"
    exit 1
fi

# Ejecutar resolucionDirecta tomando la entrada de temp.txt y redirigiendo la salida a salidaResDir.txt
"$SCRIPT_DIR/p3" < "$SCRIPT_DIR/temp.txt" > "$SCRIPT_DIR/salida/salidaResDir.txt"
if [ $? -ne 0 ]; then
    echo "Error: Fallo al ejecutar resolucionDirecta.cpp"
    exit 1
fi

# Eliminar ficheros temporales creados
rm -f "$SCRIPT_DIR/p1" "$SCRIPT_DIR/p2" "$SCRIPT_DIR/p3" "$SCRIPT_DIR/temp.txt"

echo "Proceso completado correctamente"
