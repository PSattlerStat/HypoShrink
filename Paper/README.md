---
title: 'The R package HypoShrink: Optimize Your Hypotheses. Keep What Matters.'
tags:
- R
- statistics
- linear models
- hypothesis testing
- approximate test statistic
- companion matrix
date: \today
authors:
- name: Paavo Sattler
  orcid: "0000-0001-8731-0893"
  affiliation:
  - "1"
  - "2"
- name: Manuel Rosenbaum
  orcid: "0009-0008-6793-869X"
  affiliation:
  - "3"
bibliography: paper.bib
citation_author: Sattler and Rosenbaum
affiliations:
- index: "1"
  name: Department of Statistics, TU Dortmund University, Germany
- index: "2"
  name: Institute of Statistics, RWTH Aachen University, Aachen, Germany
- index: "3"
  name: Institute of Statistics, Ulm University, Helmholtzstrasse 20, 89081 Ulm, Germany
output: rticles::joss_article
keep_tex: true
latex_engine: pdflatex
journal: JOSS
---

# Summary
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

