cmake_minimum_required(VERSION 3.16)
project(aed2_algorithms_cpp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(MSVC)
    add_compile_options(/W4 /O2)
else()
    add_compile_options(-Wall -Wextra -Wpedantic -O3)
endif()

# Module 1: Divide and Conquer vs Direct Sliding Window
add_executable(dyv 01-divide-and-conquer/src/dyv.cpp)
add_executable(resolucionDirecta 01-divide-and-conquer/src/resolucionDirecta.cpp)
add_executable(generadorChar 01-divide-and-conquer/src/generadorChar.cpp)

# Module 2: Greedy and Backtracking
add_executable(arD 02-greedy-and-backtracking/greedy/src/arD.cpp)
add_executable(backE 02-greedy-and-backtracking/backtracking/src/backE.cpp)

# POSIX timing benchmarks (require <sys/time.h>)
if(UNIX)
    add_executable(dyvTiempo 01-divide-and-conquer/benchmark/dyvTiempo.cpp)
    add_executable(resolucionDirectaTiempo 01-divide-and-conquer/benchmark/resolucionDirectaTiempo.cpp)
    add_executable(generadorCharTiempo 01-divide-and-conquer/benchmark/generadorCharTiempo.cpp)
    add_executable(vorazDtiempos 02-greedy-and-backtracking/greedy/benchmark/vorazDtiempos.cpp)
    add_executable(backEtiempos 02-greedy-and-backtracking/backtracking/benchmark/backEtiempos.cpp)
endif()
