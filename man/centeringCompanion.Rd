% Generated from R/centeringCompanion.R
\name{centeringCompanion}
\alias{centeringCompanion}
\title{Generate a Companion for the Centering Matrix}
\usage{
centeringCompanion(d)
}
\arguments{
\item{d}{Integer. The number of elements to be compared; must be greater than 1.}
}
\value{
A numeric matrix \code{L} of size \code{(d - 1) x d} satisfying \code{t(L) \%*\% L = P_d}, where \code{P_d = diag(d) - matrix(1 / d, d, d)} is the centering matrix.
}
\description{
Constructs the explicit \code{(d - 1) x d} companion of the centering matrix. The resulting matrix is lower trapezoidal with bandwidth 1 and is related to the Helmert matrix.
}
\examples{
L <- centeringCompanion(4)
crossprod(L)
}
