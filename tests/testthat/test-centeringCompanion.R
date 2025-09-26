library(testthat)

test_that("centeringCompanion returns correct dimensions", {
  for (d in 2:10) {
    L <- centeringCompanion(d)
    expect_equal(dim(L), c(d - 1, d))
  }
})

test_that("t(L) %*% L equals centering matrix", {
  for (d in 2:10) {
    L <- centeringCompanion(d)
    Pd <- diag(d) - matrix(1, d, d) / d
    diff_norm <- norm(t(L) %*% L - Pd, "F")
    expect_lt(diff_norm, 1e-10)  # Allow for numerical tolerance
  }
})

test_that("centeringCompanion throws error on invalid input", {
  expect_error(centeringCompanion(1), "Input 'd' must be a single integer greater than 1.")
  expect_error(centeringCompanion("a"), "Input 'd' must be a single integer greater than 1.")
  expect_error(centeringCompanion(3.5), "Input 'd' must be a single integer greater than 1.")
  expect_error(centeringCompanion(c(3, 4)), "Input 'd' must be a single integer greater than 1.")
})
