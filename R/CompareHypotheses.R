#' Compare Two Hypothesis Representations in Linear Models
#'
#' This function compares two hypothesis representations (i.e., hypothesis
#' matrices and corresponding vectors). It checks whether the classical and
#' standardized ATS (ANOVA-Type-Statistic) versions agree between the two
#' representations.
#'
#' @param H1 A numeric matrix representing the first hypothesis matrix.
#' @param H2 A numeric matrix representing the second hypothesis matrix.
#' @param y1 An optional numeric vector representing the right-hand side for the
#'  first hypothesis. Defaults to a zero vector.
#' @param y2 An optional numeric vector representing the right-hand side for the
#'  second hypothesis. Defaults to a zero vector.
#'
#' @return A character string indicating the level of agreement between the two
#' representations:
#' \itemize{
#'   \item `"all_equal"`: All ATS versions (classical and standardized) agree.
#'   \item `"standardized_equal"`: Only the standardized ATS versions agree; the
#'    classical version differs.
#'   \item `"none_equal"`: No ATS versions agree between the representations.
#' }
#' A message is also printed to inform the user.
#'
#' @examples
#' H <- matrix(c(1, 0, 0, 1), nrow = 2)
#' CompareHypothesis(H, H)  # Should return "all_equal"
#'
#' @export
CompareHypothesis <- function(H1, H2, y1 = NULL, y2 = NULL) {
  # Default right-hand sides: zero vectors
  if (is.null(y1)) y1 <- rep(0, times = nrow(H1))
  if (is.null(y2)) y2 <- rep(0, times = nrow(H2))

  # Check input validity using auxilary function HypoCheck
  HypoCheck(H1, y1)
  HypoCheck(H2, y2)

  # Matrix products for comparison
  M1 <- t(H1) %*% H1
  M2 <- t(H2) %*% H2

  V1 <- t(H1) %*% y1
  V2 <- t(H2) %*% y2

  # Check for exact equality (matrix and corresponding vector)
  eq1 <- isTRUE(all.equal(M1, M2, check.attributes = FALSE)) &&
    isTRUE(all.equal(V1, V2, check.attributes = FALSE))

  # Check for scaled equality
  eq2 <- qr(rbind(as.vector(M1),as.vector(M2)))$rank

  # Determine level of equivalence
  if (eq1 && eq2) {
    message("\033[32m For these hypothesis representations all considered
            ATS-versions coincide. \n\033[0m")
    return("all_equal")
  } else if (eq2 && !eq1) {
    message("\033[32m For these hypothesis representations the classical ATS can
            differ,\n whereas all considered standardized ATS-versions coincide.
            \n\033[0m")
    return("standardized_equal")
  } else {
    message("\033[31m For these hypothesis representations no considered
            ATS-version coincides.\n\033[0m")
    return("none_equal")
  }
}
