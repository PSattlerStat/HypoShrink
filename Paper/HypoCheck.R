HypoCheck <- function(H, y) {
  if (!is.matrix(H)) {
    stop("The hypothesis matrix 'H' must be a matrix.")
  }

  if (nrow(H) == 0L || ncol(H) == 0L) {
    stop("The hypothesis matrix 'H' must have at least one row and one column.")
  }

  if (!is.numeric(H) || any(!is.finite(H))) {
    stop("The hypothesis matrix 'H' must contain only finite numeric values.")
  }

  if (is.null(dim(y)) == FALSE || !is.numeric(y) || any(!is.finite(y))) {
    stop("The corresponding vector 'y' must contain only finite numeric values.")
  }

  if (nrow(H) != length(y)) {
    stop("Dimension of matrix and vector must match.")
  }

  invisible(TRUE)
}
