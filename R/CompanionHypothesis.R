.compact_companion <- function(H, y, r) {
  d <- ncol(H)

  if (r == 0L) {
    return(list(
      L = matrix(numeric(0), nrow = 0L, ncol = d),
      ytilde = numeric(0)
    ))
  }

  # Compute the compact SVD directly from H. This avoids forming H^T H,
  # whose condition number is the square of the condition number of H.
  sv <- svd(H, nu = r, nv = r)

  U <- sv$u[, seq_len(r), drop = FALSE]
  V <- sv$v[, seq_len(r), drop = FALSE]
  singular_values <- sv$d[seq_len(r)]

  # L = D_r V_r^T satisfies L^T L = H^T H and has exactly r rows.
  L <- sweep(t(V), 1L, singular_values, `*`)

  # If H theta = y is non-empty, y belongs to col(H). Hence
  # ytilde = U_r^T y satisfies L^T ytilde = H^T y and ||ytilde|| = ||y||.
  ytilde <- drop(crossprod(U, y))

  list(L = L, ytilde = ytilde)
}

.safe_hypot <- function(x, y) {
  scale <- max(abs(x), abs(y))

  if (scale == 0) {
    return(0)
  }

  scale * sqrt((x / scale)^2 + (y / scale)^2)
}

.make_lower_trapezoidal <- function(L, ytilde) {
  r <- nrow(L)
  d <- ncol(L)

  if (r <= 1L) {
    return(list(L = L, ytilde = ytilde))
  }

  k <- d - r

  # The lower-trapezoidal condition with bandwidth k = d-r is equivalent
  # to a lower triangular rightmost r x r block. Orthogonal Givens row
  # rotations create the required zeros while preserving L^T L.
  for (q in seq.int(r, 2L, by = -1L)) {
    j <- k + q
    pivot <- q

    for (i in seq_len(q - 1L)) {
      x <- L[i, j]
      y <- L[pivot, j]

      if (x == 0) {
        next
      }

      rho <- .safe_hypot(x, y)
      cc <- y / rho
      ss <- -x / rho

      row_i <- L[i, ]
      row_pivot <- L[pivot, ]

      L[i, ] <- cc * row_i + ss * row_pivot
      L[pivot, ] <- -ss * row_i + cc * row_pivot

      y_i <- ytilde[i]
      y_pivot <- ytilde[pivot]
      ytilde[i] <- cc * y_i + ss * y_pivot
      ytilde[pivot] <- -ss * y_i + cc * y_pivot

      # This entry is zero in exact arithmetic. Assigning zero explicitly
      # prevents harmless floating-point remnants from obscuring the structure.
      L[i, j] <- 0
    }
  }

  list(L = L, ytilde = ytilde)
}

.make_upper_trapezoidal <- function(L, ytilde) {
  r <- nrow(L)

  if (r <= 1L) {
    return(list(L = L, ytilde = ytilde))
  }

  # An upper triangular leftmost r x r block is stronger than the required
  # upper-trapezoidal condition with bandwidth d-r and therefore satisfies it.
  # Again, only orthogonal Givens row rotations are used.
  for (j in seq_len(r - 1L)) {
    pivot <- j

    for (i in seq.int(r, j + 1L, by = -1L)) {
      x <- L[pivot, j]
      y <- L[i, j]

      if (y == 0) {
        next
      }

      rho <- .safe_hypot(x, y)
      cc <- x / rho
      ss <- y / rho

      row_pivot <- L[pivot, ]
      row_i <- L[i, ]

      L[pivot, ] <- cc * row_pivot + ss * row_i
      L[i, ] <- -ss * row_pivot + cc * row_i

      y_pivot <- ytilde[pivot]
      y_i <- ytilde[i]
      ytilde[pivot] <- cc * y_pivot + ss * y_i
      ytilde[i] <- -ss * y_pivot + cc * y_i

      L[i, j] <- 0
    }
  }

  list(L = L, ytilde = ytilde)
}

#' Companion Hypothesis Matrix Transformation
#'
#' Constructs a companion representation of a linear hypothesis `H %*% theta = y`
#' with the minimal number of rows. The numerical rank is determined by
#' `qr(H)$rank`. The companion is computed from a singular value decomposition
#' of `H` directly, avoiding the numerically less favorable formation and
#' decomposition of `t(H) %*% H`.
#'
#' @param H A numeric hypothesis matrix of size `m x d`.
#' @param y An optional numeric vector of length `m`. If omitted, the zero
#'   vector is used. The solution set `H %*% theta = y` must be non-empty.
#' @param utrapez Legacy logical/binary option kept for backward compatibility.
#'   If `trapez` is `NULL`, `TRUE` (or `1`) requests an upper-trapezoidal
#'   companion and `FALSE` (or `0`) requests no trapezoidal transformation.
#'   New code should use `trapez` instead.
#' @param trapez Optional character string specifying the structure of the
#'   companion matrix: `"lower"`, `"upper"`, or `"none"`. If specified, this
#'   argument takes precedence over `utrapez`.
#'
#' @return A list with two components:
#' \itemize{
#'   \item `L`: A numeric matrix with `rank(H)` rows satisfying
#'     `t(L) %*% L = t(H) %*% H` up to floating-point accuracy.
#'   \item `ytilde`: A numeric vector of length `rank(H)` satisfying the
#'     corresponding companion conditions.
#' }
#'
#' @details
#' Let `r = rank(H)` and consider the compact singular value decomposition
#' `H = U_r D_r V_r^T`. The initial companion is `L = D_r V_r^T`, for which
#' `t(L) %*% L = t(H) %*% H`. For a non-empty hypothesis,
#' `ytilde = t(U_r) %*% y` additionally satisfies
#' `t(L) %*% ytilde = t(H) %*% y` and preserves the Euclidean norm of the
#' right-hand side.
#'
#' If a trapezoidal form is requested, orthogonal Givens row rotations are
#' applied simultaneously to `L` and `ytilde`. Hence all companion conditions
#' remain unchanged. For a lower-trapezoidal companion, the bandwidth is
#' `d-r`, meaning `L[i, j] = 0` whenever `j-i > d-r`. The upper form is defined
#' analogously by `L[i, j] = 0` whenever `i-j > d-r`.
#'
#' @examples
#' # Rank-deficient centered hypothesis
#' H <- diag(4) - matrix(1 / 4, 4, 4)
#' comp <- CompanionHypothesis(H, trapez = "lower")
#' nrow(comp$L) == qr(H)$rank
#' all.equal(crossprod(comp$L), crossprod(H))
#'
#' # Non-zero right-hand side with a non-empty solution set
#' H <- rbind(c(1, 0, -1), c(2, 0, -2))
#' y <- c(1, 2)
#' comp <- CompanionHypothesis(H, y, trapez = "upper")
#' all.equal(crossprod(comp$L, comp$ytilde), crossprod(H, y))
#'
#' @export
CompanionHypothesis <- function(H, y = NULL, utrapez = TRUE, trapez = NULL) {
  if (is.null(y)) {
    y <- rep(0, nrow(H))
  }

  HypoCheck(H, y)

  qr_H <- qr(H)
  r <- qr_H$rank

  # The companion construction for non-zero y requires a non-empty solution
  # set. Using the same QR-based rank concept keeps this check consistent with
  # the numerical rank used for the row reduction.
  if (qr(cbind(H, y))$rank > r) {
    stop("The hypothesis H %*% theta = y has an empty solution set.")
  }

  if (is.null(trapez)) {
    if (length(utrapez) != 1L || is.na(utrapez) ||
        !(utrapez %in% c(FALSE, TRUE, 0, 1))) {
      stop("'utrapez' must be TRUE/FALSE or 0/1.")
    }

    trapez <- if (isTRUE(as.logical(utrapez))) "upper" else "none"
  } else {
    if (!is.character(trapez) || length(trapez) != 1L || is.na(trapez)) {
      stop("'trapez' must be one of 'lower', 'upper', or 'none'.")
    }

    trapez <- match.arg(tolower(trapez), c("lower", "upper", "none"))
  }

  companion <- .compact_companion(H, y, r)

  if (trapez == "lower") {
    companion <- .make_lower_trapezoidal(companion$L, companion$ytilde)
  } else if (trapez == "upper") {
    companion <- .make_upper_trapezoidal(companion$L, companion$ytilde)
  }

  companion
}
