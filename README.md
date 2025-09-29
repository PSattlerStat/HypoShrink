# HypoShrink

**Optimize your hypotheses. Keep what matters.**
An R package for simplifying and comparing linear hypotheses while preserving statistical test results.

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![DOI (Sattler & Rosenbaum, 2025)](https://img.shields.io/badge/DOI-10.1016%2Fj.spl.2025.110356-blue)](https://doi.org/10.1016/j.spl.2025.110356)
[![arXiv](https://img.shields.io/badge/arXiv-2310.11799-b31b1b.svg)](https://arxiv.org/abs/2310.11799)

---

## 🔍 Overview

**HypoShrink** provides tools to **reduce the dimensionality** of linear hypotheses in the context of **quadratic form based teststatistics **, such as:

- Wald-type Statistic (**WTS**),
- Modified ANOVA-type Statistic (**MATS**),
- and variants of the ANOVA-type Statistic (**ATS**).

The package constructs so-called **companion hypotheses** — simplified versions of the original hypothesis matrix that **yield identical test decisions** but with fewer rows, improving computational efficiency.

It supports:
- Automatic companion hypothesis generation,
- A formula to generate the companion of the centering matrix,
- Comparison of different hypotheses under multiple ATS variants,
- Quantification of potential simplification savings.

---

## 📦 Installation

Install the development version from GitHub:

```r
install.packages("devtools")
devtools::install_github("PSattlerStat/HypoShrink")
```

## 🎯 Key Features

| Function                   | Description                                                                                           |
|---------------------------|-------------------------------------------------------------------------------------------------------|
| `CenteringCompanion(d)`   | Returns the centering companion matrix \( P_d \in \mathbb{R}^{d \times d} \), in upper trapezoidal form. |
| `CompanionHypothesis(H, c, utrapez = TRUE)` | Transforms a hypothesis \((H, c)\) into an equivalent companion hypothesis. Returns an upper trapezoidal matrix if numerically possible. |
| `CompareHypotheses(H1, c1, H2, c2)` | Checks whether two hypotheses lead to the same test result under various ATS types. |
| `HypothesisPotential(H, c)` | Estimates the relative computational savings when using a companion matrix instead of the original hypothesis. |


## 📘 Example Usage
```
library(HypoShrink)

# 1. Companion matrix of size d = 4
P <- CenteringCompanion(d = 4)

# 2. Transform a hypothesis to its companion form
H <- matrix(c(1, -1, 0, 0, 0,
              0, 1, -1, 0, 0), byrow = TRUE, nrow = 2)
c <- c(0, 0)
companion <- CompanionHypothesis(H, c, utrapez = TRUE)

# 3. Compare two hypotheses under four ATS types
H2 <- matrix(c(1, 0, -1, 0, 0,
               0, 1, 0, -1, 0), byrow = TRUE, nrow = 2)
c2 <- c(0, 0)
CompareHypotheses(H, c, H2, c2)

# 4. Evaluate dimension reduction potential
HypothesisPotential(H, c)
```

## 🧪 Use Cases

- Simplify linear hypotheses in **MANOVA**, **GLM**, or **repeated measures** designs.
- Improve computational performance in simulation or bootstrap settings.
- Analyze whether different formulations of hypotheses are statistically equivalent.
- Teach matrix-based hypothesis formulation and optimization techniques.



## 📚 Theoretical Background

In linear hypothesis testing, different hypothesis matrices (H, c) can represent the same null hypothesis but may differ in:
- matrix rank,
- computational cost,
- numerical stability.

Based on:

- Sattler & Rosenbaum (2025),
  "On companion hypotheses and their applications in quadratic form-based testing",
  *Statistics & Probability Letters*, DOI: 10.1016/j.spl.2025.110356



**HypoShrink** implements the concept of companion hypotheses — equivalent hypothesis forms that preserve test statistics while reducing redundancy.

Benefits include:
- improved simulation performance,
- computational efficiency in large designs,
- enhanced reproducibility in hypothesis specification.


## 👨‍🔬 Authors

- **Paavo Sattler**
  Department of Statistics, TU Dortmund University
  [paavo.sattler@tu-dortmund.de](mailto:paavo.sattler@tu-dortmund.de)
  [ORCID: 0000-0001-8731-0893](https://orcid.org/0000-0001-8731-0893)

- **Manuel Rosenbaum**
  Institute of Statistics, Ulm University
