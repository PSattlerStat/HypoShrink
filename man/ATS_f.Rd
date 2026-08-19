% Generated from R/HypothesisPotential.R
\name{ATS_f}
\alias{ATS_f}
\title{Compute the Adjusted ATS Statistic for a Hypothesis Matrix}
\usage{
ATS_f(X, H, Sigma = NULL)
}
\arguments{
\item{X}{A numeric vector representing the data vector.}
\item{H}{A numeric matrix representing the hypothesis matrix.}
\item{Sigma}{An optional covariance matrix; defaults to the identity matrix.}
}
\value{
A numeric value representing the adjusted ATS statistic.
}
\description{
Computes the adjusted ATS (ATS_f) for a hypothesis matrix \code{H}. With \code{M = H \%*\% Sigma \%*\% t(H)}, the statistic is the standardized ATS multiplied by \code{tr(M)^2 / tr(M^2)}, equivalently \code{ATS * tr(M) / tr(M^2)}.
}
\examples{
X <- matrix(stats::runif(10), ncol = 1)
H <- matrix(stats::runif(100), nrow = 10)
ATS_f(X, H)
}
