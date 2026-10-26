#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Archivos de código fuente C++
gchar="$SCRIPT_DIR/generadorCharTiempo.cpp"
dyv="$SCRIPT_DIR/dyvTiempo.cpp"
res="$SCRIPT_DIR/resolucionDirectaTiempo.cpp"

# Crea el directorio salidaTiempo si no existe
if [ ! -d "$SCRIPT_DIR/salidaTiempo" ]; then
	mkdir -p "$SCRIPT_DIR/salidaTiempo"
fi 

# Archivo de salida
tiempos_salida="$SCRIPT_DIR/salidaTiempo/tiemposSalida.txt"

# Compilar generadorCharTiempo
if ! g++ -std=c++17 -O3 -Wall -Wextra -Wpedantic "$gchar" -o "$SCRIPT_DIR/ogchar"; then
    echo "Error: No se puede compilar $gchar"
    exit 1
fi

# Compilar res
if ! g++ -std=c++17 -O3 -Wall -Wextra -Wpedantic "$res" -o "$SCRIPT_DIR/ores"; then
    echo "Error: No se puede compilar $res"
    exit 1
fi

# Compilar dyv
if ! g++ -std=c++17 -O3 -Wall -Wextra -Wpedantic "$dyv" -o "$SCRIPT_DIR/odyv"; then
    echo "Error: No se puede compilar $dyv"
    exit 1
fi

# Número de veces a ejecutar ambos programas por cada tamaño de entrada
intentos=20
tamanio=1

for i in $(seq 1 50); do
    sumaRes=0
    sumaDYV=0
    
    # Para las primeras iteraciones escogemos como tamaño potencias de 10 y después múltiplos de 40000	
    if test $i -le 5; then
   	 let tamanio=$tamanio*10
    else 
   	 let tamanio=($i-2)*40000
    fi
    
    for j in $(seq 1 $intentos); do
   	 # Ejecutar generadorCharTiempo y guardar la salida
   	 salidaTemporal=$(echo "$tamanio" | "$SCRIPT_DIR/ogchar")
   	 if [ $? -ne 0 ]; then
  			 echo "Error: Fallo al ejecutar generadorCharTiempo.cpp"
   			 exit 1
   	 fi
   	 
   	 # Ejecutar resolucionDirectaTiempo
   	 tiempoRes=$(echo "$salidaTemporal" | "$SCRIPT_DIR/ores")
   	 if [ $? -ne 0 ]; then
   			 echo "Error: Fallo al ejecutar resolucionDirectaTiempo.cpp"
   			 exit 1
   	 fi
   	 
   	 # Ejecutar dyvTiempo
   	 tiempoDYV=$(echo "$salidaTemporal" | "$SCRIPT_DIR/odyv")
   	 if [ $? -ne 0 ]; then
   			 echo "Error: Fallo al ejecutar dyvTiempo.cpp"
   			 exit 1
   	 fi
   	 
   	 sumaRes=$(echo "$sumaRes + $tiempoRes" | bc)
   	 sumaDYV=$(echo "$sumaDYV + $tiempoDYV" | bc)
    done
    if [ $? -ne 0 ]; then
   		 echo "Error: Fallo al ejecutar el segundo bucle"
   		 exit 1
    fi
    mediaRes=$(echo "scale=5; $sumaRes / $intentos" | bc)
    mediaDYV=$(echo "scale=5; $sumaDYV / $intentos" | bc)
    
    echo "$tamanio;$mediaRes;$mediaDYV"
done > "$tiempos_salida"

if [ $? -ne 0 ]; then
    	echo "Error: Fallo al ejecutar el primer bucle"
    	exit 1
fi

# Elimina los ficheros temporales creados
rm -f "$SCRIPT_DIR/odyv" "$SCRIPT_DIR/ogchar" "$SCRIPT_DIR/ores"

echo "Proceso completado correctamente"
