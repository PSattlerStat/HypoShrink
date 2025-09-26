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
#' The ATS_f statistic adjusts the ATS by a factor involving
#' the matrix `H%*%Sigma%*%t(H)`.
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

  # Compute the adjusted ATS_f statistic
  ATS_f = ATS * sum(diag(Matrix %*% Matrix)) / (sum(diag(Matrix))^2)

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
#' @param duration Minimum time (in seconds) that each benchmark comparison
#'        should run, with defaults setting are 10 seconds. which should not be
#'        undercut, and  even set higher for more reliable results.
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
#' # Example usage (requires functions like ATS, ATS_s, etc., to be defined):
#' # H <- matrix(c(1, 0, 1, 1), nrow = 2)
#' # HypothesisPotential(H, duration = 5)
HypothesisPotential <- function(H, duration = 10) {
  # Generate companion hypothesis matrix L from H
  L <- CompanionHypothesis(H)$L

  # Simulate a random vector X with appropriate number of columns
  X <- matrix(stats::runif(ncol(H)))

  # Ensure that the original matrix H does NOT have full row rank
  if (qr(H)$rank == nrow(H)) {
    stop("Companion matrix should only be used if the original matrix does not
         have full row rank.\n")
  }

  # Benchmark each method with H and its companion matrix L
  # Settings: no memory check, run for at least `duration` seconds, and cap at
  # 10M iterations
  ATSbench   <- bench::mark(ATS(X, H), ATS(X, L), check = FALSE,
                            memory = FALSE, min_time = duration,
                            max_iterations = 10000000)
  ATS_sbench <- bench::mark(ATS_s(X, H), ATS_s(X, L), check = FALSE,
                            memory = FALSE, min_time = duration,
                            max_iterations = 10000000)
  ATS_fbench <- bench::mark(ATS_f(X, H), ATS_f(X, L), check = FALSE,
                            memory = FALSE, min_time = duration,
                            max_iterations = 10000000)
  WTSbench   <- bench::mark(WTS(X, H), WTS(X, L), check = FALSE, memory = FALSE,
                            min_time = duration, max_iterations = 10000000)

  # Helper function to compute relative time saved (%)
  relative_saving <- function(bench) {
    time_H <- as.numeric(bench$total_time[1])
    time_L <- as.numeric(bench$total_time[2])
    round(100 * (1 - time_L / time_H), 1)
  }

  # Compile results in a readable data frame
  df=data.frame(
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
return(df)}
