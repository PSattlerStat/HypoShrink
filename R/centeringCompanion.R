#' Generate Companion for the centering Matrix
#'
#' Constructs an `(d-1) × d` matrix that allows to test the usual equality of d
#' elements, whereto usually the centering matrix `Pd` is used.
#' The companion has a lower number of rows than the centering matrix, but leads
#' to the same values of the ATS, MATS or WTS.
#'
#' @param d Integer. The number of elements which should be compared, which must
#' be greater than 1.
#'
#' @return A numeric matrix L of size `(d - 1) × d`, which satisfies
#' `t(L) \%*\% L = Pd`, where `Pd` is the centering matrix `diag(d) - 1/d`.
#'
#' @examples
#' L=centeringCompanion(4)
#' t(L) %*% L  # Approximate centering matrix
#'
#' @export
centeringCompanion <- function(d) {
  # Check input validity
  if (!is.numeric(d) || length(d) != 1 || d < 2 || floor(d) != d) {
    stop("Input 'd' must be a single integer greater than 1.")
  }

  # Initialize an (d-1) × d matrix with zeros
  h <- matrix(0, d - 1, d)

  # Fill the matrix row by row
  for (i in 1:(d - 1)) {
    sqrt_val <- sqrt(i * (i + 1))

    # Set the first i entries of the i-th row
    h[i, 1:i] <- 1 / sqrt_val

    # Set the (i+1)-th entry of the i-th row
    h[i, i + 1] <- -i / sqrt_val
  }

  return(h)
}
