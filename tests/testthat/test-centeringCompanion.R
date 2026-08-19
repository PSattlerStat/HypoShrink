library(testthat)

test_that("centeringCompanion returns the minimal dimensions", {
  for (d in 2:10) {
    L <- centeringCompanion(d)
    expect_equal(dim(L), c(d - 1, d))
  }
})

test_that("centeringCompanion is a compact root of the centering matrix", {
  for (d in 2:10) {
    L <- centeringCompanion(d)
    P_d <- diag(d) - matrix(1 / d, d, d)

    expect_equal(crossprod(L), P_d, tolerance = 1e-10)
  }
})

test_that("centeringCompanion is lower trapezoidal with bandwidth one", {
  for (d in 2:10) {
    L <- centeringCompanion(d)
    forbidden <- outer(
      seq_len(d - 1L), seq_len(d),
      FUN = function(i, j) j - i > 1L
    )

    if (any(forbidden)) {
      expect_equal(max(abs(L[forbidden])), 0)
    }
  }
})

test_that("centeringCompanion agrees with the general companion identity", {
  for (d in 2:8) {
    P_d <- diag(d) - matrix(1 / d, d, d)
    explicit <- centeringCompanion(d)
    general <- CompanionHypothesis(P_d, trapez = "lower")$L

    expect_equal(crossprod(explicit), crossprod(general), tolerance = 1e-9)
  }
})

test_that("centeringCompanion rejects invalid input", {
  expect_error(centeringCompanion(1), "single integer greater than 1")
  expect_error(centeringCompanion("a"), "single integer greater than 1")
  expect_error(centeringCompanion(3.5), "single integer greater than 1")
  expect_error(centeringCompanion(c(3, 4)), "single integer greater than 1")
  expect_error(centeringCompanion(Inf), "single integer greater than 1")
})
