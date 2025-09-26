MSrootcompact <- function(X) {
  # Compute the rank of X using QR decomposition
  r <- qr(X)$rank

  # Compute the Singular Value Decomposition (SVD): X = U D V^T
  SVD <- svd(X)

  # Use only the top-r components of the SVD
  # Construct sqrt(D_r) with the largest r singular values
  # Return sqrt(D_r) * U^T (a compact square root representation)
  MSroot <- sqrt(diag(SVD$d[1:r,drop=FALSE],r,r)) %*% t(SVD$u[,1:r,drop=TRUE])

  return(MSroot)
}

modified_cholesky <- function(A, tol = 1e-10) {
  # Check whether A is symmetric
  if (!isSymmetric(A)) {
    stop("Matrix A is not symmetric.")
  }

  # Perform LDLᵗ decomposition using fastmatrix::ldl()
  # This gives: A = L %*% D %*% t(L)
  ldl_A = fastmatrix::ldl(A)

  # Multiply L (lower triangular) by sqrt(D)
  # This gives a matrix B such that t(B)%*% B ≈ A
  # Then select only the first 'rank(A)' columns to remove near-zero components
  L = t(ldl_A$lower %*% (diag(sqrt(ldl_A$d))[, 1:qr(A)$rank,drop=FALSE]))

  # Return the final matrix L such that A ≈ t(L)%*% L
  return(L)
}


#' Companion Hypothesis Matrix Transformation
#'
#' This function transforms the given hypothesis into a companion hypothesis.
#' It checks whether the original matrix `H` has full row rank. If the matrix
#' does not have full row rank, the function will proceed to generate a
#' companion matrix.  If a vector `y` is provided, a transformed vector `ytilde`
#' is calculated as well and returned together with the companion matrix.
#'
#' @param H A numeric matrix representing the hypothesis. It should be of size
#' `m x n`, where `m` is the number of rows.
#' @param y An optional numeric vector, which only has to be specified if it is
#' not a zero vector. It will be transformed alongside the matrix.
#' @param utrapez A binary option, which specifies whether the transformed
#' matrix L should be a upper trapezoidal matrix.
#'
#' @return A list with two components:
#' \itemize{
#'   \item L: The transformed matrix (companion matrix).
#'   \item ytilde: The transformed vector.
#' }
#'
#' @details
#' If the  matrix `H` has full row rank, an error message will be shown,
#' indicating that the matrix should only be used if the original matrix has
#' not full row rank.
#'
#' If the matrix `H` has no full row rank, the compact matrix square root of
#' `t(H)%*% H` is computed. The vector `y` is then transformed accordingly,
#' and the scale factor is computed to ensure the norm of the vector remains
#'  unchanged after the transformation.
#'
#' @examples
#' # Example 1: Matrix with full row rank
#' H <- matrix(c(1, 2, 3, 4), nrow = 2)
#' CompanionHypothesis(H)
#'
#' # Example 2: Matrix with not full row rank and vector y
#' H <- matrix(c(1, 2, 1, 2), nrow = 2)
#' y <- c(5, 6)
#' CompanionHypothesis(H, y)
#'
#' @export
CompanionHypothesis <- function(H, y=NULL,utrapez=0) {
  if (is.null(y)){y = rep(0, dim(H)[1])}
  HypoCheck(H,y)

  if((qr(H)$rank)==dim(H)[1])
  {cat( "\033[31m Matrix should only be used if the original matrix has not full
        row rank. \n\n\033[0m")
 # If the matrix has full row rank, return the original matrix and vector
    L = H
    ytilde=y
  } else {
    # Compute the compact matrix square root of t(H)%*% H, depending on the
    # parameter as upper trapezoidal matrix
    if(utrapez==0){ Laux <- MSrootcompact(t(H) %*% H)}
    if(utrapez==1){ Laux <- modified_cholesky(t(H) %*% H)}

    # If y is not NULL or a zero vector, also transform the vector
    if ( all(y == 0)) {
      L = Laux
      ytilde = y
    } else {
      # Solve t(L) %*% ytilde = t(H) %*% y for ytilde
      ytilde <- qr.solve(t(Laux), t(H) %*% y)

      # Scale L such that ||y|| = ||L %*% ytilde||
      scale_factor <- sqrt(sum(y^2)) / sqrt(sum(ytilde^2))
      L <- scale_factor * Laux
    }

    # Return the transformed matrix L and transformed vector ytilde
    d1=dim(H)[1]
    d2=dim(L)[1]
    cat(paste("\033[32m By using the companion matrix, the number of rows can be reduced
  from ", d1," to ", d2,". \n\n\033[0m",sep=""))}
  return(list("L" = L, "ytilde" = ytilde))
}
