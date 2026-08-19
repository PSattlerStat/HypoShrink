% Generated from R/CompareHypotheses.R
\name{CompareHypothesis}
\alias{CompareHypothesis}
\title{Compare Two Hypothesis Representations}
\usage{
CompareHypothesis(H1, H2, y1 = NULL, y2 = NULL)
}
\arguments{
\item{H1}{A numeric matrix representing the first hypothesis matrix.}
\item{H2}{A numeric matrix representing the second hypothesis matrix.}
\item{y1}{An optional numeric vector for the first hypothesis. Defaults to a zero vector.}
\item{y2}{An optional numeric vector for the second hypothesis. Defaults to a zero vector.}
}
\value{
A character string:
\itemize{
\item \code{"all_equal"}: the classical and standardized ATS versions agree.
\item \code{"standardized_equal"}: the standardized ATS versions agree, but the classical ATS may differ by a positive scale factor.
\item \code{"none_equal"}: the required equivalence conditions are not met.
}
}
\description{
Compares two matrix-vector representations of linear hypotheses and checks whether the corresponding classical ATS and standardized ATS versions agree for every argument.
}
\details{
For the classical ATS, equality for every argument requires equality of \code{t(H) \%*\% H}, \code{t(H) \%*\% y}, and \code{sum(y^2)}. For standardized ATS versions, the same three quantities may differ by one common positive scale factor.
}
\examples{
H <- matrix(c(1, 0, 0, 1), nrow = 2)
CompareHypothesis(H, H)
}
