#' Compute the ATS Statistic for a hypothesis Matrix
#'
#' This function computes the classical ATS (ANOVA-Type-Statistic) value for a
#' given hypothesis matrix `H` and a vector `X`.
#'
#' @param X A numeric vector representing the data vector.
#' @param H A numeric matrix representing the hypothesis matrix.
#'
#' @return A numeric value representing the ATS statistic.
#'
#' @examples
#' X <- matrix(stats::runif(10), ncol = 1)
#' H <- matrix(stats::runif(100), nrow = 10)
#' ATS(X, H)
#' @export
ATS <- function(X, H) {
  # Compute the vector product H %*% X
  Vector = H %*% X

  # Compute the ATS as the sum of squared values of the vector
  ATS = sum(Vector^2)

  return(ATS)
}

#' Compute the standardized ATS for a Hypothesis Matrix
#'
#' This function computes the standardized ATS (ATS_s) value for a given
#' hypothesis matrix `H` and a vector `X`, optionally using a covariance
#' matrix `Sigma`. The ATS_s is the ATS statistic scaled by the trace of the
#' matrix `H%*%Sigma%*%t(H)`.
#'
#' @param X A numeric vector representing the data vector.
#' @param H A numeric matrix representing the hypothesis matrix.
#' @param Sigma An optional covariance matrix (default is the identity matrix).
#'
#' @return A numeric value representing the standardized ATS_s.
#'
#' @examples
#' X <- matrix(stats::runif(10), ncol = 1)
#' H <- matrix(stats::runif(100), nrow = 10)
#' ATS_s(X, H)
#' @export
ATS_s <- function(X, H, Sigma = NULL) {
  # If no Sigma is provided, use the identity matrix
  if (is.null(Sigma)) {
    d = length(X)
    Sigma = diag(1, d, d)
  }

  # Compute the vector product H %*% X
  Vector = H %*% X

  # Compute the matrix product H %*% Sigma %*% t(H)
  Matrix = H %*% Sigma %*% t(H)

  # Compute the ATS statistic
  ATS = sum(Vector^2)

  # Scale the ATS by the trace of Matrix
  ATS_s = ATS / sum(diag(Matrix))

  return(ATS_s)
}

#' Compute the adjusted ATS for a Hypothesis Matrix
#'
#' This function computes the adjusted ATS (ATS_f) value for a given hypothesis
#' matrix `H` and a vector `X`, optionally using a covariance matrix `Sigma`.
#' With `M = H %*% Sigma %*% t(H)`, the adjusted statistic is
#' `ATS * tr(M) / tr(M^2)`, equivalently `ATS_s * tr(M)^2 / tr(M^2)`.
#'
#' @param X A numeric vector representing the data vector.
#' @param H A numeric matrix representing the hypothesis matrix.
#' @param Sigma An optional covariance matrix (default is the identity matrix).
#'
#' @return A numeric value representing the adjusted ATS_f.
#'
#' @examples
#' X <- matrix(stats::runif(10), ncol = 1)
#' H <- matrix(stats::runif(100), nrow = 10)
#' ATS_f(X, H)
#' @export
ATS_f <- function(X, H, Sigma = NULL) {
  # If no Sigma is provided, use the identity matrix
  if (is.null(Sigma)) {
    d = length(X)
    Sigma = diag(1, d, d)
  }

  # Compute the vector product H %*% X
  Vector = H %*% X

  # Compute the matrix product H %*% Sigma %*% t(H)
  Matrix = H %*% Sigma %*% t(H)

  # Compute the ATS statistic
  ATS = sum(Vector^2)

  # Compute the adjusted ATS_f statistic as
  # ATS_s * tr(Matrix)^2 / tr(Matrix^2).
  trace_M <- sum(diag(Matrix))
  trace_M2 <- sum(diag(Matrix %*% Matrix))
  ATS_f <- ATS * trace_M / trace_M2

  return(ATS_f)
}

#' Compute the Wald-Type-Statistic (WTS) for a Hypothesis Matrix
#'
#' This function computes the Wald-Type-Statistic (WTS) for a given hypothesis
#' matrix `H` and a vector `X`, optionally using a covariance matrix `Sigma`.
#' For standardization, the Moore-Penrose-inverse of `H%*%Sigma%*%t(H)` is used.
#'
#' @param X A numeric vector representing the data vector.
#' @param H A numeric matrix representing the hypothesis matrix.
#' @param Sigma An optional covariance matrix (defaults to an identity matrix).
#'
#' @return A numeric value representing the weighted test statistic.
#'
#' @examples
#' X <- matrix(stats::runif(10), ncol = 1)
#' H <- matrix(stats::runif(100), nrow = 10)
#' WTS(X, H)
#' @export
WTS <- function(X, H, Sigma = NULL) {
  # If no Sigma is provided, use the identity matrix
  if (is.null(Sigma)) {
    d = length(X)
    Sigma = diag(1, d, d)
  }

  # Compute the vector product H %*% X
  Vector = H %*% X

  # Compute the matrix product H %*% Sigma %*% t(H)
  matrix = H %*% Sigma %*% t(H)

  # Compute the weighted test statistic as a quadratic form
  WTS = t(Vector) %*% (MASS::ginv(matrix)) %*% Vector

  return(WTS)
}



#' Evaluate Relative Time Savings from Companion Hypothesis Matrices
#'
#' This function compares the computational efficiency of test statistics
#' (`ATS`, `ATS_s`, `ATS_f`, and `WTS`) when using a companion hypothesis
#' matrix instead of the original hypothesis matrix `H`.
#'
#' @param H A hypothesis matrix. Must **not** have full row rank.
#' @param duration Minimum benchmark time in seconds for each comparison.
#'   Must be a positive numeric scalar; the default is 10 seconds.
#'
#' @return A data frame containing the relative time savings (in percent) for
#' each method.
#' @details The function uses the `bench` package to benchmark computation
#' times for test statistics when using the original hypothesis matrix `H`
#' versus its reduced-rank companion matrix.
#'
#' @importFrom bench mark
#' @export
#'
#' @examples
#' H <- diag(4) - matrix(1 / 4, 4, 4)
#' \dontrun{
#' HypothesisPotential(H, duration = 1)
#' }
HypothesisPotential <- function(H, duration = 10) {
  if (!is.matrix(H) || !is.numeric(H) || any(!is.finite(H))) {
    stop("'H' must be a numeric matrix containing only finite values.")
  }

  if (!is.numeric(duration) || length(duration) != 1L ||
      !is.finite(duration) || duration <= 0) {
    stop("'duration' must be a single positive numeric value.")
  }

  if (qr(H)$rank == nrow(H)) {
    stop("A companion matrix cannot reduce the number of rows because 'H' has full row rank.")
  }

  # No trapezoidal structure is needed for the benchmark.
  L <- CompanionHypothesis(H, utrapez = FALSE)$L

  X <- matrix(stats::runif(ncol(H)))

  ATSbench <- bench::mark(
    ATS(X, H), ATS(X, L),
    check = FALSE, memory = FALSE, min_time = duration,
    max_iterations = 10000000
  )
  ATS_sbench <- bench::mark(
    ATS_s(X, H), ATS_s(X, L),
    check = FALSE, memory = FALSE, min_time = duration,
    max_iterations = 10000000
  )
  ATS_fbench <- bench::mark(
    ATS_f(X, H), ATS_f(X, L),
    check = FALSE, memory = FALSE, min_time = duration,
    max_iterations = 10000000
  )
  WTSbench <- bench::mark(
    WTS(X, H), WTS(X, L),
    check = FALSE, memory = FALSE, min_time = duration,
    max_iterations = 10000000
  )

  relative_saving <- function(benchmark) {
    time_H <- as.numeric(benchmark$total_time[1])
    time_L <- as.numeric(benchmark$total_time[2])
    round(100 * (1 - time_L / time_H), 1)
  }

  data.frame(
    Method = c("ATS", "ATS_s", "ATS_f", "WTS"),
    Relative_Time_Saved = paste0(
      c(
        relative_saving(ATSbench),
        relative_saving(ATS_sbench),
        relative_saving(ATS_fbench),
        relative_saving(WTSbench)
      ),
      "%"
    ),
    row.names = NULL
  )
}
