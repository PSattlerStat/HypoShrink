library(testthat)

test_that("MSrootcompact returns correct square root for scalar", {
  x <- 9
  R <- MSrootcompact(x)
  expect_equal(dim(R), c(1,1))
  expect_equal(R %*% t(R), matrix(x,1,1))
})

test_that("MSrootcompact returns valid square root matrix", {
  X <- matrix(c(2, 1, 1, 2), 2, 2)
  R <- MSrootcompact(X)
  expect_equal(t(R) %*% R, X, tolerance = 1e-10)
})

test_that("modified_cholesky returns valid decomposition", {
  skip_if_not_installed("fastmatrix")

  A <- matrix(c(2, 1, 1, 2), 2, 2)
  L <- modified_cholesky(A)
  expect_equal(t(L) %*% L, A, tolerance = 1e-10)
})

test_that("modified_cholesky rejects non-symmetric matrices", {
  A <- matrix(c(1, 2, 3, 4), 2, 2)
  expect_error(modified_cholesky(A), "not symmetric")
})


test_that("CompanionHypothesis returns original if full rank", {
  H <- matrix(c(1, 0, 0, 1), 2, 2)
  res <- CompanionHypothesis(H)
  expect_equal(res$L, H)
})

test_that("CompanionHypothesis reduces rank correctly", {
  H <- matrix(c(1, 2, 1, 2), 2, 2)
  res <- suppressMessages(CompanionHypothesis(H))
  expect_lt(nrow(res$L), nrow(H))
})

test_that("CompanionHypothesis transforms  correctly", {
  H <- matrix(c(1, 2, 1, 2), 2, 2)
  y <- c(5, 10)
  res <- suppressMessages(CompanionHypothesis(H, y))
  # L %*% ytilde should approximate Hᵗ %*% y (up to scaling)
  expect_equal(t(res$L) %*% res$ytilde, t(H) %*% y, tolerance = 1e-8)
  # Lᵗ %*% L should approximate Hᵗ %*% H (up to scaling)
  expect_equal(t(res$L) %*% res$L, t(H) %*% H, tolerance = 1e-8)
})
