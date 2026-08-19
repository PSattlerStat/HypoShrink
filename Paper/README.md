---
output:
  pdf_document: default
  html_document: default
---
# HypoShrink

**HypoShrink** is an R package for optimizing and comparing linear hypotheses in multivariate statistics using companion matrices. It simplifies hypothesis specifications, preserves the relevant quadratic-form-based equivalence conditions, and can reduce computational cost.

## Installation

```r
# install.packages("devtools") # if not already installed
devtools::install_github("PSattlerStat/HypoShrink")
```

## Usage

```r
library(HypoShrink)

# Companion of the four-dimensional centering matrix
L <- centeringCompanion(4)

# Transform a rank-deficient hypothesis to companion form
H <- diag(4) - matrix(1 / 4, 4, 4)
comp <- CompanionHypothesis(H, trapez = "lower")

# Compare two hypothesis representations
H1 <- matrix(c(1, 1, -1, -1), 2, 2)
H2 <- matrix(c(-sqrt(2), sqrt(2)), 1, 2)
CompareHypothesis(H1, H2)

# Assess potential computational gain
HypothesisPotential(H, duration = 1)
```

## License

The manuscript material can be licensed separately as required for publication. The R package itself is distributed under the **GPL-3** license specified in `DESCRIPTION` and `LICENSE`.

## Links

- GitHub repository: [https://github.com/PSattlerStat/HypoShrink](https://github.com/PSattlerStat/HypoShrink)
- Manuscript for JOSS submission: `Paper/paper.md`
