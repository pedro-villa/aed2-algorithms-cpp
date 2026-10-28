# Module 02: Greedy Algorithms & Backtracking

This module contains two combinatorial optimization solvers implemented in C++17:
1. **Greedy Algorithm (`greedy/src/arD.cpp`)**: Unit-time task scheduling with deadlines and profits (*Aircraft Landing Scheduling*).
2. **Backtracking (`backtracking/src/backE.cpp`)**: Exact combinatorial solver for the NP-hard *Maximum Diversity Problem* (*Heavy $m$-Subgraph*).

---

## 1. Greedy Algorithm: Aircraft Landing Scheduling (`arD.cpp`)

### 1.1. Problem Formulation
Given $Ut$ discrete unit-time landing slots $\{0, 1, \dots, Ut - 1\}$ and $A$ incoming aircraft, where each aircraft $i \in \{0, \dots, A - 1\}$ has:
- A maximum landing deadline $\text{tiempoMax}_i \in [1, \infty)$.
- An economic profit $\text{beneficio}_i > 0$ earned if the aircraft lands at or before its deadline.

Each landing takes exactly 1 time unit, and at most one aircraft can land per time slot. The objective is to select and schedule a subset of aircraft to **maximize total profit**.

### 1.2. Greedy Strategy & Matroid Optimality
1. **Sorting Phase**: Sort all $A$ aircraft in descending order of profit (`a.beneficio > b.beneficio`) using `std::sort` in $O(A \log A)$ time.
2. **Latest-Feasible Slot Allocation**: For each aircraft $i$ in sorted order, scan backwards from slot $j = \min(Ut, \text{tiempoMax}_i) - 1$ down to $0$:
   - Assign the aircraft to the first free slot (`huecosAterrizaje[j] == false`), mark it occupied, and accumulate `aviones[i].beneficio`.
   - If all slots in $[0, \min(Ut, \text{tiempoMax}_i) - 1]$ are occupied, discard the aircraft.

By the matroid greedy-choice and exchange properties of unit-time scheduling with deadlines, scheduling each high-profit task as late as possible preserves earlier slots for tasks with tighter deadlines, guaranteeing a globally optimal schedule.

### 1.3. Complexity
- **Time Complexity**:
  - Best case (every aircraft immediately finds its latest slot free): $\Theta(A \log A)$.
  - Worst case: $O(A \log A + A \cdot \min(Ut, A))$.
- **Space Complexity**: $\Theta(A + Ut)$.

---

## 2. Backtracking: Maximum Diversity / Heavy $m$-Subgraph (`backE.cpp`)

### 2.1. Problem Formulation
Given a set of $n$ elements, a directed/asymmetric pairwise distance matrix $\text{distancias}[n][n]$, and a target subset cardinality $m$ ($1 \le m \le n$), select a subset $S \subseteq \{0, \dots, n - 1\}$ of size $|S| = m$ that maximizes total mutual distance:

$$\max_{\substack{S \subseteq \{0, \dots, n-1\} \\ |S| = m}} \sum_{\substack{i, j \in S \\ i < j}} \left(\text{distancias}[i][j] + \text{distancias}[j][i]\right)$$

### 2.2. Iterative State-Space Tree & Incremental Evaluation
The solver explores a binary decision tree of depth $n$ using an explicit iterative backtracking loop (`do { ... } while (nivel >= 0)`) over a state tuple $s[0 \dots n-1] \in \{-1, 0, 1\}^n$:
- **`Generar(nivel, distancias, s, dact)`**: Transitions $s[\text{nivel}]$ from $-1 \to 0$ (excluded) and $0 \to 1$ (included). When $s[\text{nivel}] == 1$, updates the current accumulated distance `dact` incrementally in $O(\text{nivel})$ time:
  $$\text{dact} \gets \text{dact} + \sum_{0 \le i < \text{nivel}, \, s[i]=1} (\text{distancias}[i][\text{nivel}] + \text{distancias}[\text{nivel}][i])$$
- **`Solucion(nivel, n, m, s)`**: Checks whether the partial tuple has selected exactly $m$ elements (`elegido == m`).
- **`Criterio(nivel, n, m, s)`**: Prunes any branch that has already reached cardinality $m$ (`elegido == m`) or reached the leaf level (`nivel == n - 1`), avoiding redundant expansion of trailing zero-extensions.
- **`MasHermanos(nivel, s)` & `Retroceder(nivel, distancias, s, dact)`**: Reverts the incremental contribution to `dact` in $O(\text{nivel})$ time when backtracking from $s[\text{nivel}] == 1$ and resets $s[\text{nivel}] = -1$.

### 2.3. Complexity
- **Time Complexity**: $O(n \cdot 2^n)$ in the worst case (pruned to $O\left(n \sum_{k=0}^{m} \binom{n}{k}\right)$ states by the cardinality bound `elegido < m`).
- **Space Complexity**: $O(N^2)$ static matrix storage plus $O(N)$ state vector.

## Collaborators

- **Marta Tomás** ([@MartaTR13](https://github.com/MartaTR13))
- **Pedro Villa** ([@pedro-villa](https://github.com/pedro-villa))
