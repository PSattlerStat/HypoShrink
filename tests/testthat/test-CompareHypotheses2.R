library(testthat)

test_that("equivalent compact representations are fully equal", {
  H1 <- matrix(c(1, 1, -1, -1), 2, 2)
  H2 <- matrix(c(-sqrt(2), sqrt(2)), 1, 2)

  expect_equal(CompareHypothesis(H1, H2), "all_equal")
})

test_that("positive rescaling preserves standardized ATS versions", {
  H1 <- matrix(c(1, 1, -1, -1), 2, 2)
  H2 <- 2 * H1

  expect_equal(
    CompareHypothesis(H1, H2),
    "standardized_equal"
  )
})

test_that("positive rescaling with non-zero y is detected", {
  H1 <- matrix(c(1, 1, -1, -1), 2, 2)
  H2 <- 2 * H1
  y1 <- c(1, 1)
  y2 <- 2 * y1

  expect_equal(
    CompareHypothesis(H1, H2, y1, y2),
    "standardized_equal"
  )
})

test_that("different hypotheses are not classified as equal", {
  H1 <- matrix(c(1, 0, 0, 1), nrow = 2)
  H2 <- matrix(c(1, 0, 1, 0), nrow = 2)

  expect_equal(CompareHypothesis(H1, H2), "none_equal")
})

test_that("different column dimensions are rejected", {
  H1 <- diag(2)
  H2 <- diag(3)

  expect_error(
    CompareHypothesis(H1, H2),
    "same number of columns"
  )
})

test_that("empty solution sets are rejected", {
  H1 <- rbind(c(1, 0), c(2, 0))
  y1 <- c(1, 3)
  H2 <- H1
  y2 <- y1

  expect_error(
    CompareHypothesis(H1, H2, y1, y2),
    "non-empty solution sets"
  )
})
