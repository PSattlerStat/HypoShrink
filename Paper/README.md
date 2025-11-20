---
output:
  pdf_document: default
  html_document: default
---
# HypoShrink

**HypoShrink** is an R package for optimizing and comparing linear hypotheses in multivariate statistics using *companion matrices* under ANOVA-type statistics (ATS). It simplifies hypothesis specifications, preserves statistical equivalence, and can reduce computational cost.

## Installation

You can install the development version directly from GitHub:

```r
# install.packages("devtools") # if not already installed
devtools::install_github("PSattlerStat/HypoShrink")

```

## Usage

```r
library(HypoShrink)

# Companion matrix of size 4
P <- CenteringCompanion(d = 4)

# Transform hypothesis to companion form
H <- matrix(c(1, -1, 0, 0, 0,
              0, 1, -1, 0, 0), byrow = TRUE, nrow = 2)
c <- c(0, 0)
comp <- CompanionHypothesis(H, c, utrapez = TRUE)

# Compare two hypotheses under ATS
H2 <- matrix(c(1, 0, -1, 0, 0,
               0, 1, 0, -1, 0), byrow = TRUE, nrow = 2)
c2 <- c(0, 0)
CompareHypotheses(H, c, H2, c2)

# Assess potential computational gain
HypothesisPotential(H, c)
```

## License

The content of this repository (manuscript, examples) is licensed under **CC-BY 4.0**.  
The software itself is licensed under **MIT License** and maintained in [PSattlerStat/HypoShrink](https://github.com/PSattlerStat/HypoShrink).

## Links

- GitHub repository: [https://github.com/PSattlerStat/HypoShrink](https://github.com/PSattlerStat/HypoShrink)  
- Manuscript for JOSS submission: `paper/paper.md`
