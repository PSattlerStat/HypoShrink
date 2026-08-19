library(testthat)

test_that("ATS_f uses the documented adjustment", {
  X <- matrix(c(1, 2))
  H <- matrix(c(1, 0, 1, 1), nrow = 2)
  Sigma <- diag(2)

  vector <- H %*% X
  M <- H %*% Sigma %*% t(H)
  expected <- sum(vector^2) * sum(diag(M)) / sum(diag(M %*% M))

  expect_equal(ATS_f(X, H, Sigma), expected)
})

test_that("HypothesisPotential runs and returns a data frame", {
  H <- matrix(c(1, 2, 1, 2), nrow = 2)
  result <- HypothesisPotential(H, duration = 0.01)

  expect_s3_class(result, "data.frame")
  expect_equal(ncol(result), 2)
  expect_named(result, c("Method", "Relative_Time_Saved"))
})

test_that("HypothesisPotential rejects full-row-rank matrices", {
  expect_error(
    HypothesisPotential(diag(2), duration = 0.01),
    "full row rank"
  )
})
