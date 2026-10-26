CXX      := g++
CXXFLAGS := -std=c++17 -O3 -Wall -Wextra -Wpedantic

BIN_DIR  := bin

# Module 1: Divide and Conquer vs Direct Sliding Window
DYV_SRC      := 01-divide-and-conquer/src/dyv.cpp
DIRECT_SRC   := 01-divide-and-conquer/src/resolucionDirecta.cpp
GEN_CHAR_SRC := 01-divide-and-conquer/src/generadorChar.cpp

DYV_TIME_SRC      := 01-divide-and-conquer/benchmark/dyvTiempo.cpp
DIRECT_TIME_SRC   := 01-divide-and-conquer/benchmark/resolucionDirectaTiempo.cpp
GEN_CHAR_TIME_SRC := 01-divide-and-conquer/benchmark/generadorCharTiempo.cpp

# Module 2: Greedy and Backtracking
GREEDY_SRC      := 02-greedy-and-backtracking/greedy/src/arD.cpp
GREEDY_TIME_SRC := 02-greedy-and-backtracking/greedy/benchmark/vorazDtiempos.cpp
BACK_SRC        := 02-greedy-and-backtracking/backtracking/src/backE.cpp
BACK_TIME_SRC   := 02-greedy-and-backtracking/backtracking/benchmark/backEtiempos.cpp

TARGETS := \
	$(BIN_DIR)/dyv \
	$(BIN_DIR)/resolucionDirecta \
	$(BIN_DIR)/generadorChar \
	$(BIN_DIR)/dyvTiempo \
	$(BIN_DIR)/resolucionDirectaTiempo \
	$(BIN_DIR)/generadorCharTiempo \
	$(BIN_DIR)/arD \
	$(BIN_DIR)/vorazDtiempos \
	$(BIN_DIR)/backE \
	$(BIN_DIR)/backEtiempos

.PHONY: all clean test

all: $(TARGETS)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(BIN_DIR)/dyv: $(DYV_SRC) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

$(BIN_DIR)/resolucionDirecta: $(DIRECT_SRC) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

$(BIN_DIR)/generadorChar: $(GEN_CHAR_SRC) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

$(BIN_DIR)/dyvTiempo: $(DYV_TIME_SRC) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

$(BIN_DIR)/resolucionDirectaTiempo: $(DIRECT_TIME_SRC) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

$(BIN_DIR)/generadorCharTiempo: $(GEN_CHAR_TIME_SRC) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

$(BIN_DIR)/arD: $(GREEDY_SRC) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

$(BIN_DIR)/vorazDtiempos: $(GREEDY_TIME_SRC) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

$(BIN_DIR)/backE: $(BACK_SRC) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

$(BIN_DIR)/backEtiempos: $(BACK_TIME_SRC) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

test: all
	@echo "=== [1/3] Differential Test: Divide & Conquer vs Sliding Window ==="
	@./$(BIN_DIR)/generadorChar > temp.txt
	@./$(BIN_DIR)/dyv < temp.txt > $(BIN_DIR)/out_dyv.txt
	@./$(BIN_DIR)/resolucionDirecta < temp.txt > $(BIN_DIR)/out_dir.txt
	@diff -u $(BIN_DIR)/out_dyv.txt $(BIN_DIR)/out_dir.txt
	@rm -f temp.txt $(BIN_DIR)/out_dyv.txt $(BIN_DIR)/out_dir.txt
	@echo "PASS: Divide & Conquer matches Direct Resolution."
	@echo "=== [2/3] Functional Test: Greedy Aircraft Scheduling (arD) ==="
	@printf "1\n3 4\n2 1 2 1\n100 19 27 25\n" | ./$(BIN_DIR)/arD > $(BIN_DIR)/out_arD.txt
	@grep -q "^127$$" $(BIN_DIR)/out_arD.txt
	@rm -f $(BIN_DIR)/out_arD.txt
	@echo "PASS: Greedy solver returned expected optimal profit (127)."
	@echo "=== [3/3] Functional Test: Backtracking Maximum Diversity (backE) ==="
	@printf "1\n4 2\n0 10 1 1\n10 0 1 1\n1 1 0 2\n1 1 2 0\n" | ./$(BIN_DIR)/backE > $(BIN_DIR)/out_backE.txt
	@grep -q "^20$$" $(BIN_DIR)/out_backE.txt
	@rm -f $(BIN_DIR)/out_backE.txt
	@echo "PASS: Backtracking solver returned expected maximum diversity (20)."

clean:
	rm -rf $(BIN_DIR) temp.txt datosEntrada.txt distanciasPrueba.txt
