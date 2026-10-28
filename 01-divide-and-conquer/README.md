# Module 01: Divide & Conquer vs. Direct Sliding Window

## 1. Problem Formulation

Given two ASCII character strings $A$ and $B$ of length $n$, and a target substring length $m$ ($1 \le m \le n$):
- The pairwise difference at index $k \in [0, n)$ is defined as the absolute ASCII difference:
  $$\text{dife}[k] = |A[k] - B[k]|$$
- The goal is to find the 1-based starting index $i^* \in \{1, \dots, n - m + 1\}$ of the contiguous substring of length $m$ that maximizes the cumulative difference:
  $$\max_{0 \le i \le n - m} \sum_{k=i}^{i+m-1} \text{dife}[k]$$

---

## 2. Algorithmic Approaches & Complexity Analysis

### 2.1. Direct Resolution via Sliding Window (`resolucionDirecta`)

Instead of recomputing each window sum in $O(m)$ time (which would yield $O(n \cdot m)$), `resolucionDirecta` computes the initial sum of the first $m$ elements and updates the running sum in $O(1)$ per step as the window advances:

$$\text{sumaParcial}_{i} = \text{sumaParcial}_{i-1} - \text{dife}[i-1] + \text{dife}[i+m-1]$$

#### Exact Operation Count
- **Initial window accumulation**: $1 + m + 2$ elementary operations.
- **Sliding loop**: Runs $n - m - 1$ iterations. Each iteration executes 3 arithmetic/comparison operations plus 1 conditional assignment when a new maximum is found.
  - **Worst Case** (strictly increasing window sums):
    $$t_M(n) = (m + 3) + 4(n - m - 1) = 4n - 3m - 1 \in \Theta(n)$$
  - **Best Case** (first window is the maximum):
    $$t_m(n) = (m + 3) + 3(n - m - 1) = 3n - 2m \in \Theta(n)$$

---

### 2.2. Divide and Conquer (`divideYVenceras`)

Given a half-open range $[\text{posInicial}, \text{posFinal})$:
1. **Base Cases**:
   - Empty range ($\text{posFinal} \le \text{posInicial}$): returns $\{0, 0\}$.
   - Small subproblem ($\text{posFinal} - \text{posInicial} < 2m$ or $m == n$): delegates directly to `resolucionDirecta(dife, posInicial, posFinal, m)`.
2. **Recursive Decomposition**:
   - Midpoint: $\text{puntoMedio} = \text{posInicial} + \lfloor (\text{posFinal} - \text{posInicial}) / 2 \rfloor$.
   - **Left subproblem (`s1`)**: Recursively solves $[\text{posInicial}, \text{puntoMedio})$.
   - **Right subproblem (`s2`)**: Recursively solves $[\text{puntoMedio}, \text{posFinal})$.
   - **Straddling boundary (`s3`)**: Any substring of length $m$ crossing $\text{puntoMedio}$ must lie within $[\max(\text{posInicial}, \text{puntoMedio} - m + 1), \min(\text{posFinal}, \text{puntoMedio} + m))$. This bounded region of length $2m - 1$ is solved via `resolucionDirecta`.
   - **Combine**: Returns the candidate among `s1`, `s3`, and `s2` with the maximum sum (breaking ties in favor of the leftmost starting index).

#### Recurrence Relation & Asymptotic Solution
Treating $m$ as a fixed window parameter and $N = \text{posFinal} - \text{posInicial}$:

$$
t(N) = \begin{cases}
3 & \text{if } N = 0 \\
4N - 3m - 1 & \text{if } 0 < N < 2m \\
2t(N/2) + t_{\text{direct}}(2m - 1) + 4 = 2t(N/2) + 5m - 5 & \text{if } N \ge 2m
\end{cases}
$$

Substituting $N = 2^k$ into the non-homogeneous recurrence $t_k - 2t_{k-1} = 5m - 5$:
- Characteristic polynomial: $(r - 2)(r - 1) = 0 \implies r_1 = 2, \; r_2 = 1$.
- General solution: $t_k = c_1 2^k + c_2 = c_1 N + c_2 \in \Theta(N)$.

Both algorithms therefore share the exact same asymptotic complexity **$\Theta(n)$** for fixed $m$.

---

## 3. Empirical Performance Study & Hardware Analysis

Timing measurements were collected using POSIX `gettimeofday()` (`<sys/time.h>`) isolating the core algorithmic execution (excluding string I/O and `dife[]` preprocessing) across 50 input sizes from $n = 10$ to $n = 1,920,000$ ($m = \lfloor n / 1000 \rfloor$), averaging 20 runs per input size.

| $n$ | Direct Resolution (ms) | Divide & Conquer (ms) | $n$ | Direct Resolution (ms) | Divide & Conquer (ms) |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 10 | 0.00010 | 0.00066 | 1,000,000 | 1.37258 | 2.43740 |
| 100 | 0.00024 | 0.00204 | 1,120,000 | 1.50376 | 2.75082 |
| 1,000 | 0.00148 | 0.01590 | 1,240,000 | 1.64946 | 3.07226 |
| 10,000 | 0.01276 | 0.07502 | 1,360,000 | 1.88346 | 3.32402 |
| 100,000 | 0.12914 | 0.36436 | 1,480,000 | 1.93952 | 3.56204 |
| 280,000 | 0.42144 | 0.91602 | 1,600,000 | 2.22794 | 4.18240 |
| 520,000 | 0.70780 | 1.46230 | 1,760,000 | 2.17116 | 3.92304 |
| 760,000 | 0.95848 | 1.92254 | 1,920,000 | 2.46112 | 4.68250 |

*(Full 50-row dataset available in [`benchmark/data/ejemploTiemposSalida.txt`](./benchmark/data/ejemploTiemposSalida.txt))*

![Empirical Execution Time Plot](./benchmark/data/tiempos_grafica.svg)

### Why Direct Sliding Window Outperforms Divide & Conquer (~1.9x)
1. **Redundant Boundary Re-evaluation**: At each internal node of the recursion tree, `divideYVenceras` invokes `resolucionDirecta` over a straddling interval of size $2m - 1$, re-reading elements already visited in the left and right subtrees.
2. **Function Call & Stack Frame Overhead**: The recursion tree has depth $\approx \log_2(n/m)$ and $\approx n/m$ leaves, incurring call-stack prologue/epilogue instructions and branch mispredictions.
3. **Cache & Prefetcher Efficiency**: `resolucionDirecta` performs a strictly monotonic stride-1 traversal from `dife[0]` to `dife[n-1]`, which is optimal for L1d cache lines (64 bytes = 16 `int`s) and hardware stream prefetchers.

## Collaborators

- **Marta Tomás** ([@MartaTR13](https://github.com/MartaTR13))
- **Pedro Villa** ([@pedro-villa](https://github.com/pedro-villa))
