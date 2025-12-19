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
  affiliation: "3"
bibliography: paper.bib
citation_author: Sattler and Rosenbaum
affiliations:
- index:  "1"
  name: Department of Statistics, TU Dortmund University, Germany
- index:  "2" 
  name: Institute of Statistics, RWTH Aachen University, Aachen, Germany
- index:  "3"
  name: Institute of Statistics, Ulm University, Helmholtzstrasse 20, 89081 Ulm, Germany
output: rticles::joss_article
keep_tex: true
latex_engine: pdflatex

journal: JOSS
---

# Summary



**HypoShrink** is an R package developed for optimizing and comparing linear
hypotheses in the context of quadratic forms, particularly focusing on 
ANOVA-type-statistics (ATS). These hypotheses and quadratic forms are widely used
across different fields and for various parameters, and are also part of numerous existing
packages and procedures. Nevertheless, the used hypothesis matrices are rarely regarded 
as worthy of scientifical discussion. Additionally, in classical hypothesis testing
with ATS, different hypothesis matrices may encode the same null hypothesis but 
yield different test statistic values and, consequently, leading to different test
results. Notably, their computational efficiency, rank, or numerical stability 
can vary substantially.
These issues can be addressed with **HypoShrink**.

Based on the theoretical foundation by Sattler & Rosenbaum [@sattler2025], 
**HypoShrink**  provides practical tools for constructing *companion hypothesis matrices*,
which not only capture the same hypotheses but also yield the identical test 
statistics and hence lead to the same test decisions. Essentially, this is achieved
with the minimal number of rows, avoiding redundant hypothesis specifications, and thereby
considerably lower the computational effort. 

In particular, **HypoShrink** provides:
\begin{itemize}
\item   Equivalence checking under various ATS types,
\item   Explicit companion matrix generation for the centering matrix,
\item   Hypothesis transformation into companion form,
\item   Quantification of computational savings via dimension reduction.
\end{itemize}

**HypoShrink** is designed for applied statisticians, data analysts, and
researchers working in the field of multivariate statistic where hypothesis
specification needs to be both rigorous and efficient. This is
especially relevant for resampling methods, permutation tests, and
high-dimensional settings. The package is 
available on GitHub at
[https://github.com/PSattlerStat/HypoShrink](https://github.com/PSattlerStat/HypoShrink).


# Statement of Need
ANOVA-type-statistics (ATS) are widely used in applied research for testing multivariate hypotheses, including in fields such as psychology,
medicine, and social sciences. This makes efficient and reliable handling of hypothesis matrices critical in practice.

Linear hypotheses in multivariate statistics (e.g., in MANOVA or GLM
frameworks) are often specified via a matrix-vector pair $(\mathbf{H}, \mathbf{c})$, where
the hypothesis matrix $\mathbf{H}$ represents linear combinations of parameters
and $\mathbf{c}$ is a corresponding vector. This involves the full spectrum of multivariate parameters, ranging from high-dimensional mean vectors [@sattler2021] and vectorized correlation matrices [@sattler2023] to relative effects [@thiel2025], 
to name just a few. However, these specifications are not unique — multiple different $(\mathbf{H}, \mathbf{c})$ pairs may encode the same null hypothesis.
The choice of matrix can influence the value of the test statistic and hence the final test decision, as well as numerical properties, computational cost, and interpretability. 
Notably, the vast majority of hypothesis matrices do not have full rank, the most prominent example may be the centering matrix, which is widely used. For instance, comparing two $d$-dimensional vectors typically employs the centering matrix for two groups and its companion,

\[
P_2 = \frac12 \begin{pmatrix}1 & -1 \\ -1 & 1 \end{pmatrix}, \qquad
L = \left(\frac{1}{\sqrt{2}}, -\frac{1}{\sqrt{2}}\right)
\]

which, when combined with the $d$-dimensional identity, produce Kronecker products

\[
P_2 \otimes I_d =
\frac12
\begin{pmatrix}
 I_d & -I_d\\
 -I_d & I_d
\end{pmatrix}, \qquad
L \otimes I_d =
\frac{1}{\sqrt{2}}
\begin{pmatrix}
I_d & -I_d 
\end{pmatrix}
\]
For this centering matrix it even comes at no cost, as the reduction of rows is readily calculated and implemented, thereby facilitating valuable savings considering its widespread application. 
These tangible runtime savings for 4 usual common forms are illustrated exemplary in Figure 1 for $d=5$ and $d=10$.

Measured runtime savings are subject to minor variability across systems and runs;
this was accounted by \texttt{duration = 2000} and therefore averaging runtimes for a
high number of iterations in \texttt{HypothesisPotential} and thus reducing the variability.


![Relative runtime savings achieved by replacing the centering hypothesis
$P_2 \otimes I_d$ with its companion form for two representative dimensions
$d = 5$ and $d = 10$, each averaged over a large time of runs (duration = 2000). 
Results are shown for three ANOVA-type statistics (ATS, ATS$_s$, ATS$_f$)
and the Wald-type statistic (WTS); see [@sattler2025] for formal definitions of the underlying quadratic forms.
Runtime savings were computed using the \texttt{HypothesisPotential} function.](Rplot.png){ width=70% }


In general, **HypoShrink** aims to realize this potential by elaborating the systematic procedure, introduced in (Sattler and Rosenbaum 2025) for the reduction of such hypotheses via companion matrices that preserve statistical equivalence under ATS. This work builds on and complements earlier research by Sattler & Zimmermann [@sattler2024] on the Wald-type-statistic (WTS). Despite the theoretical and practical importance of these results, no software package in R or other environments offered direct access to these tools yet.

This gap is filled by **HypoShrink**, which enables the simplification of hypothesis specification through the creation of companion matrices that are equivalent under ATS and therefore do not alter the test outcomes.
Furthermore, the equivalence of two hypotheses can be generally verified, and tools for the assessment of efficiency potentials as well as analytical comparisons of different hypothesis formulations are provided.

This contributes to improved reproducibility, especially for resampling methods, permutation
tests, and high-dimensional settings with potentially large computational burden. 
Furthermore, connecting efficient computations with interpretability in applied statistical modelling.
These are important tools that could be easily integrated
into existing packages like [@manova], [@covcortest] to 
optimize running times.


# Features

| Function | Purpose |
|-------------------|-----------------------------------------------------|
| `CenteringCompanion(d)` | Returns the companion for standard centering matrix of dimension $d$. |
| `CompanionHypothesis()` | Transforms a given hypothesis $(H, c)$ into an equivalent companion. |
| `CompareHypotheses()` | Compares two hypotheses for equivalence under four ATS quadratic forms. |
| `HypothesisPotential()` | Computes relative savings in complexity/dimension from companion usage. |

# Usage Examples

```r
library(HypoShrink)

# 1. Construct the companion matrix of the 4-dimensional centering matrix.
#    Companion matrices allow testing the same hypothesis with a
#    minimal number of rows in the hypothesis matrix while preserving
#    the original ATS value.
P <- CenteringCompanion(d = 4)

# 2. Transform a linear hypothesis of the form Hx = c into its companion 
#    form.
H <- matrix(c(1, -1, 0, 0,
              0,  0, 1, -1), byrow = TRUE, nrow = 2)
c <- c(0, 0)
comp <- CompanionHypothesis(H, c)

# 3. Investigate whether the ATS values differ between two hypothesis 
#    matrices.
H2 <- matrix(c(1,  0, -1, 0,
               0,  1,  0, -1), byrow = TRUE, nrow = 2)
c2 <- c(0, 0)
CompareHypotheses(H, c, H2, c2)

# 4. Assess the potential computational gain achieved by using the 
#    companion form.
HypothesisPotential(H, c)


```

# References
