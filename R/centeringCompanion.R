#' Generate a Companion for the Centering Matrix
#'
#' Constructs the explicit `(d - 1) x d` companion of the centering matrix.
#' The resulting matrix is lower trapezoidal with bandwidth 1 and is related to
#' the Helmert matrix.
#'
#' @param d Integer. The number of elements to be compared; must be greater
#'   than 1.
#'
#' @return A numeric matrix `L` of size `(d - 1) x d` satisfying
#' `t(L) %*% L = P_d`, where `P_d = diag(d) - matrix(1 / d, d, d)` is the
#' centering matrix.
#'
#' @examples
#' L <- centeringCompanion(4)
#' crossprod(L)
#'
#' @export
centeringCompanion <- function(d) {
  if (!is.numeric(d) || length(d) != 1L || is.na(d) ||
      !is.finite(d) || d < 2 || floor(d) != d) {
    stop("Input 'd' must be a single integer greater than 1.")
  }

  L <- matrix(0, d - 1L, d)

  for (i in seq_len(d - 1L)) {
    sqrt_val <- sqrt(i * (i + 1))
    L[i, seq_len(i)] <- 1 / sqrt_val
    L[i, i + 1L] <- -i / sqrt_val
  }

  L
}
