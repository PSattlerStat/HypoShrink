% Generated from R/CompanionHypothesis.R
\name{CompanionHypothesis}
\alias{CompanionHypothesis}
\title{Companion Hypothesis Matrix Transformation}
\usage{
CompanionHypothesis(H, y = NULL, utrapez = TRUE, trapez = NULL)
}
\arguments{
\item{H}{A numeric hypothesis matrix of size \code{m x d}.}

\item{y}{An optional numeric vector of length \code{m}. If omitted, the zero vector is used. The solution set \code{H \%*\% theta = y} must be non-empty.}

\item{utrapez}{Legacy logical/binary option kept for backward compatibility. If \code{trapez} is \code{NULL}, \code{TRUE} (or 1) requests an upper-trapezoidal companion and \code{FALSE} (or 0) requests no trapezoidal transformation. New code should use \code{trapez}.}

\item{trapez}{Optional character string specifying the structure of the companion matrix: \code{"lower"}, \code{"upper"}, or \code{"none"}. If specified, this argument takes precedence over \code{utrapez}.}
}
\value{
A list with two components:
\itemize{
\item \code{L}: a numeric matrix with \code{rank(H)} rows satisfying \code{t(L) \%*\% L = t(H) \%*\% H} up to floating-point accuracy.
\item \code{ytilde}: a numeric vector of length \code{rank(H)} satisfying the corresponding companion conditions.
}
}
\description{
Constructs a companion representation of a linear hypothesis \code{H \%*\% theta = y} with the minimal number of rows. The numerical rank is determined by \code{qr(H)$rank}. The compact root is computed from a singular value decomposition of \code{H} directly, avoiding the formation and decomposition of \code{t(H) \%*\% H}.
}
\details{
Let \code{r = rank(H)} and consider the compact singular value decomposition \code{H = U_r D_r V_r^T}. The initial companion is \code{L = D_r V_r^T}. For a non-empty hypothesis, \code{ytilde = t(U_r) \%*\% y} additionally satisfies \code{t(L) \%*\% ytilde = t(H) \%*\% y} and preserves the Euclidean norm of the right-hand side.

If a trapezoidal form is requested, orthogonal Givens row rotations are applied simultaneously to \code{L} and \code{ytilde}. For a lower-trapezoidal companion, the bandwidth is \code{d-r}, meaning \code{L[i,j] = 0} whenever \code{j-i > d-r}. The upper form is defined analogously by \code{L[i,j] = 0} whenever \code{i-j > d-r}.
}
\examples{
H <- diag(4) - matrix(1 / 4, 4, 4)
comp <- CompanionHypothesis(H, trapez = "lower")
nrow(comp$L) == qr(H)$rank
all.equal(crossprod(comp$L), crossprod(H))

H <- rbind(c(1, 0, -1), c(2, 0, -2))
y <- c(1, 2)
comp <- CompanionHypothesis(H, y, trapez = "upper")
all.equal(crossprod(comp$L, comp$ytilde), crossprod(H, y))
}
