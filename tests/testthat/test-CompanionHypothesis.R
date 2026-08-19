library(testthat)

check_companion <- function(H, result, trapez = "none", tolerance = 1e-9) {
  L <- result$L
  r <- qr(H)$rank
  d <- ncol(H)
  k <- d - r

  expect_equal(nrow(L), r)
  expect_equal(ncol(L), d)
  expect_equal(crossprod(L), crossprod(H), tolerance = tolerance)

  if (trapez == "lower" && r > 0L) {
    forbidden <- outer(
      seq_len(r), seq_len(d),
      FUN = function(i, j) j - i > k
    )
    if (any(forbidden)) {
      expect_equal(max(abs(L[forbidden])), 0)
    }
  }

  if (trapez == "upper" && r > 0L) {
    forbidden <- outer(
      seq_len(r), seq_len(d),
      FUN = function(i, j) i - j > k
    )
    if (any(forbidden)) {
      expect_equal(max(abs(L[forbidden])), 0)
    }
  }
}

test_that("CompanionHypothesis returns a minimal compact root", {
  H <- matrix(c(1, 2, 1, 2), 2, 2)
  result <- CompanionHypothesis(H, utrapez = FALSE)

  check_companion(H, result, "none")
})

test_that("lower-trapezoidal companions have bandwidth d-r", {
  for (d in 2:10) {
    H <- diag(d) - matrix(1 / d, d, d)
    result <- CompanionHypothesis(H, trapez = "lower")

    check_companion(H, result, "lower")
  }
})

test_that("upper-trapezoidal companions satisfy the required bandwidth", {
  for (d in 2:10) {
    H <- diag(d) - matrix(1 / d, d, d)
    result <- CompanionHypothesis(H, trapez = "upper")

    check_companion(H, result, "upper")
  }
})

test_that("non-zero right-hand sides satisfy all companion conditions", {
  H <- rbind(
    c(1, 0, -1, 0),
    c(0, 1, 0, -1),
    c(1, 1, -1, -1)
  )
  theta <- c(2, -1, 0.5, 3)
  y <- drop(H %*% theta)

  for (form in c("none", "lower", "upper")) {
    result <- CompanionHypothesis(H, y, trapez = form)

    check_companion(H, result, form)
    expect_length(result$ytilde, qr(H)$rank)
    expect_equal(
      crossprod(result$L, result$ytilde),
      crossprod(H, y),
      tolerance = 1e-9
    )
    expect_equal(sum(result$ytilde^2), sum(y^2), tolerance = 1e-9)
  }
})

test_that("the zero right-hand side is reduced to the companion dimension", {
  H <- matrix(c(1, 2, 1, 2), 2, 2)
  result <- CompanionHypothesis(H)

  expect_length(result$ytilde, qr(H)$rank)
  expect_true(all(result$ytilde == 0))
})

test_that("full-row-rank matrices retain the minimal row count", {
  H <- matrix(c(1, 2, 0, 1, -1, 3), nrow = 2, byrow = TRUE)
  result <- CompanionHypothesis(H, trapez = "lower")

  check_companion(H, result, "lower")
  expect_equal(nrow(result$L), nrow(H))
})

test_that("zero-rank hypotheses are handled", {
  H <- matrix(0, nrow = 3, ncol = 4)
  result <- CompanionHypothesis(H, trapez = "lower")

  expect_equal(dim(result$L), c(0, 4))
  expect_length(result$ytilde, 0)
  expect_equal(crossprod(result$L), crossprod(H))
})

test_that("legacy utrapez behavior remains available", {
  H <- diag(4) - matrix(1 / 4, 4, 4)

  upper <- CompanionHypothesis(H, utrapez = TRUE)
  none <- CompanionHypothesis(H, utrapez = FALSE)

  check_companion(H, upper, "upper")
  check_companion(H, none, "none")
})

test_that("inconsistent right-hand sides are rejected", {
  H <- rbind(c(1, 0), c(2, 0))
  y <- c(1, 3)

  expect_error(
    CompanionHypothesis(H, y),
    "empty solution set"
  )
})

test_that("controlled rank-deficient matrices remain accurate", {
  set.seed(2026)

  for (d in 3:8) {
    for (r in seq_len(d - 1L)) {
      B <- matrix(rnorm(r * d), nrow = r)
      H <- rbind(B, B[1, , drop = FALSE])

      result <- CompanionHypothesis(H, trapez = "lower")
      check_companion(H, result, "lower", tolerance = 1e-8)
    }
  }
})

test_that("invalid trapezoidal options are rejected", {
  H <- diag(2)

  expect_error(CompanionHypothesis(H, trapez = "diagonal"))
  expect_error(CompanionHypothesis(H, utrapez = 2))
})
