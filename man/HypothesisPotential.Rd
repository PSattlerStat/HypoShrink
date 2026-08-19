% Generated from R/HypothesisPotential.R
\name{HypothesisPotential}
\alias{HypothesisPotential}
\title{Evaluate Relative Time Savings from Companion Hypothesis Matrices}
\usage{
HypothesisPotential(H, duration = 10)
}
\arguments{
\item{H}{A numeric hypothesis matrix that does not have full row rank.}
\item{duration}{Minimum benchmark time in seconds for each comparison. Must be a positive numeric scalar.}
}
\value{
A data frame containing the relative time savings in percent for each method.
}
\description{
Benchmarks the computational efficiency of \code{ATS}, \code{ATS_s}, \code{ATS_f}, and \code{WTS} when using a minimal-row companion matrix instead of the original hypothesis matrix \code{H}.
}
\details{
The function uses \pkg{bench} and constructs the companion without an additional trapezoidal transformation, because the benchmark concerns row reduction rather than a specific matrix structure.
}
\examples{
H <- diag(4) - matrix(1 / 4, 4, 4)
\dontrun{
HypothesisPotential(H, duration = 1)
}
}
