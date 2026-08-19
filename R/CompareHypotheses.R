.scaled_equal <- function(x1, x2, tol = sqrt(.Machine$double.eps)) {
  scale2 <- max(abs(x2))

  if (scale2 == 0) {
    return(FALSE)
  }

  index <- which.max(abs(x2))
  a <- x1[index] / x2[index]

  if (!is.finite(a) || a <= 0) {
    return(FALSE)
  }

  error <- max(abs(x1 - a * x2))
  scale <- max(1, max(abs(x1)), abs(a) * scale2)

  error <= tol * scale
}

#' Compare Two Hypothesis Representations
#'
#' Compares two matrix-vector representations of linear hypotheses and checks
#' whether the corresponding classical ATS and standardized ATS versions agree
#' for every argument.
#'
#' @param H1 A numeric matrix representing the first hypothesis matrix.
#' @param H2 A numeric matrix representing the second hypothesis matrix.
#' @param y1 An optional numeric vector for the first hypothesis. Defaults to a
#'   zero vector.
#' @param y2 An optional numeric vector for the second hypothesis. Defaults to a
#'   zero vector.
#'
#' @return A character string indicating the level of agreement:
#' \itemize{
#'   \item `"all_equal"`: The classical and standardized ATS versions agree.
#'   \item `"standardized_equal"`: The standardized ATS versions agree, but
#'     the classical ATS may differ by a positive scale factor.
#'   \item `"none_equal"`: The required equivalence conditions are not met.
#' }
#'
#' @details
#' For the classical ATS, equality for every argument requires equality of
#' `t(H) %*% H`, `t(H) %*% y`, and `sum(y^2)`. For standardized ATS versions,
#' the same three quantities may differ by one common positive scale factor.
#'
#' @examples
#' H <- matrix(c(1, 0, 0, 1), nrow = 2)
#' CompareHypothesis(H, H)
#'
#' @export
CompareHypothesis <- function(H1, H2, y1 = NULL, y2 = NULL) {
  if (is.null(y1)) {
    y1 <- rep(0, nrow(H1))
  }
  if (is.null(y2)) {
    y2 <- rep(0, nrow(H2))
  }

  HypoCheck(H1, y1)
  HypoCheck(H2, y2)

  if (ncol(H1) != ncol(H2)) {
    stop("The two hypothesis matrices must have the same number of columns.")
  }

  if (qr(cbind(H1, y1))$rank > qr(H1)$rank ||
      qr(cbind(H2, y2))$rank > qr(H2)$rank) {
    stop("Both hypotheses must have non-empty solution sets.")
  }

  M1 <- crossprod(H1)
  M2 <- crossprod(H2)
  V1 <- drop(crossprod(H1, y1))
  V2 <- drop(crossprod(H2, y2))
  n1 <- sum(y1^2)
  n2 <- sum(y2^2)

  exact_equal <-
    isTRUE(all.equal(M1, M2, check.attributes = FALSE)) &&
    isTRUE(all.equal(V1, V2, check.attributes = FALSE)) &&
    isTRUE(all.equal(n1, n2, check.attributes = FALSE))

  if (exact_equal) {
    return("all_equal")
  }

  quantities1 <- c(as.vector(M1), V1, n1)
  quantities2 <- c(as.vector(M2), V2, n2)

  if (.scaled_equal(quantities1, quantities2)) {
    return("standardized_equal")
  }

  "none_equal"
}
