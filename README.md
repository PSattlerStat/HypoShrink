# HypoShrink

**Optimize your hypotheses. Keep what matters.**

An R package for simplifying and comparing linear hypotheses while preserving the relevant quadratic-form-based test results.

[![License: GPL-3](https://img.shields.io/badge/License-GPL--3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![DOI (Sattler & Rosenbaum, 2025)](https://img.shields.io/badge/DOI-10.1016%2Fj.spl.2025.110356-blue)](https://doi.org/10.1016/j.spl.2025.110356)

---

## Overview

**HypoShrink** provides tools to reduce the dimensionality of linear hypotheses in the context of quadratic-form-based test statistics, including:

- Wald-type statistic (WTS),
- modified ANOVA-type statistic (MATS),
- and variants of the ANOVA-type statistic (ATS).

The package constructs so-called **companion hypotheses**: reduced representations of a hypothesis matrix that use the minimal number of rows while preserving the relevant quadratic forms.

It supports:

- numerical construction of companion hypotheses,
- lower- and upper-trapezoidal companion representations,
- an explicit companion for the centering matrix,
- comparison of hypothesis representations under ATS variants,
- and benchmarking of the computational savings from row reduction.

## Installation

Install the development version from GitHub:

```r
install.packages("devtools")
devtools::install_github("PSattlerStat/HypoShrink")
```

## Key functions

| Function | Description |
|---|---|
| `centeringCompanion(d)` | Returns the explicit `(d - 1) x d` companion of the centering matrix. The matrix is lower trapezoidal with bandwidth 1. |
| `CompanionHypothesis(H, y, trapez = "lower")` | Constructs a minimal-row companion using a direct SVD of `H`. Optional lower/upper trapezoidal forms are obtained by orthogonal transformations. |
| `CompareHypothesis(H1, H2, y1, y2)` | Checks whether two hypothesis representations yield identical classical ATS values or identical standardized ATS versions. |
| `HypothesisPotential(H, duration = 10)` | Benchmarks the relative computation-time savings obtained from replacing `H` by its companion. |

The legacy argument `utrapez` in `CompanionHypothesis()` is retained for backward compatibility. New code should use the more explicit `trapez = "lower"`, `"upper"`, or `"none"` option.

## Example usage

```r
library(HypoShrink)

# 1. Explicit companion of the four-dimensional centering matrix
L_center <- centeringCompanion(4)

# 2. Transform a rank-deficient hypothesis into companion form
H <- diag(4) - matrix(1 / 4, 4, 4)
companion <- CompanionHypothesis(H, trapez = "lower")

# Check the defining quadratic-form identity
all.equal(crossprod(companion$L), crossprod(H))

# 3. Compare two equivalent representations
H1 <- matrix(c(1, 1, -1, -1), 2, 2)
H2 <- matrix(c(-sqrt(2), sqrt(2)), 1, 2)
CompareHypothesis(H1, H2)

# 4. Evaluate the potential computation-time saving
HypothesisPotential(H, duration = 1)
```

## Numerical construction

For a matrix `H` with numerical rank `r`, `CompanionHypothesis()` computes a compact singular value decomposition

`H = U_r D_r V_r^T`

and starts from

`L = D_r V_r^T`.

Thus `L` has exactly `r` rows and satisfies `crossprod(L) = crossprod(H)` up to floating-point accuracy. Importantly, the function no longer forms and decomposes `crossprod(H)` to construct `L`; this avoids the numerical deterioration associated with squaring the condition number.

If a lower- or upper-trapezoidal representation is requested, orthogonal Givens row rotations are applied to `L` and to the transformed right-hand side. These rotations preserve the companion conditions.

## Use cases

- Simplify linear hypotheses in MANOVA, GLM, and repeated-measures designs.
- Reduce computational effort in simulation, bootstrap, and permutation procedures.
- Compare different formulations of the same hypothesis.
- Work with structured hypothesis matrices while retaining a minimal-row representation.

## Theoretical background

The package is based on:

Sattler, P. & Rosenbaum, M. (2025). *Choice of the hypothesis matrix for using the Anova-type-statistic*. Statistics & Probability Letters, 219, 110356. DOI: 10.1016/j.spl.2025.110356.

## Authors

- Paavo Sattler
- Manuel Rosenbaum

## How to cite

Use:

```r
citation("HypoShrink")
```

The package metadata and `LICENSE` file specify the GPL-3 license.
