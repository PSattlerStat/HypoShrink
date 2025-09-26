
library(testthat)

test_that("Identical hypotheses are fully equal", {
  H1 <- matrix(c(1,1,-1,-1),2,2)
  H2<-matrix(c(-sqrt(2),sqrt(2)),1,2)
  y1 <- c(0, 0)
  y2<-0
  result <- CompareHypothesis(H1, H2, y1, y2)
  expect_equal(result, "all_equal")
})

test_that("Scaled hypotheses are only standardized-equal", {
  H1 <- matrix(c(1,1,-1,-1),2,2)
  H2 <- 2 * H1
  y1 <- c(0, 0)
  y2 <- 2 * y1
  result <- CompareHypothesis(H1, H2, y1, y2)
  expect_equal(result, "standardized_equal")
})

test_that("Scaled hypotheses are only standardized-equal", {
  H1 <- matrix(c(1,1,-1,-1),2,2)
  H2 <- 2 * H1
  y1 <- c(1, 1)
  y2 <- 2 * y1
  result <- CompareHypothesis(H1, H2, y1, y2)
  expect_equal(result, "standardized_equal")
})

test_that("Scaled hypotheses are only standardized-equal", {
  H1 <- matrix(c(1,1,-1,-1),2,2)
  H2<-2*matrix(c(-sqrt(2), sqrt(2)),1,2)
  y1 <- c(0, 0)
  y2<-0
  result <- CompareHypothesis(H1, H2, y1, y2)
  expect_equal(result, "standardized_equal")
})


test_that("Different hypotheses are not equal", {
  H1 <- matrix(c(1, 0, 0, 1), nrow = 2)
  H2 <- matrix(c(0, 1, 1, 0), nrow = 2)
  y1 <- c(0, 0)
  y2 <- c(1, 1)
  result <- CompareHypothesis(H1, H2, y1, y2)
  expect_equal(result, "none_equal")
})

test_that("Function works without providing y1 and y2", {
  H <- matrix(c(1, 0, 0, 1), nrow = 2)
  result <- CompareHypothesis(H, H)
  expect_equal(result, "all_equal")
})


test_that("Identical hypotheses are fully equal", {
  H1 <- matrix(c(1,1,-1,-1),2,2)
H2<-matrix(c(-sqrt(2), sqrt(2)),1,2)
  y1 <- c(0, 0)
y2<-0
  result <- CompareHypothesis(H1, H2, y1, y2)
  expect_equal(result, "all_equal")
})

test_that("Scaled hypotheses are only standardized-equal", {
  H1 <- matrix(c(1,1,-1,-1),2,2)
  H2 <- 2 * H1
  y1 <- c(0, 0)
  y2 <- 2 * y1
  result <- CompareHypothesis(H1, H2, y1, y2)
  expect_equal(result, "standardized_equal")
})

test_that("Scaled hypotheses are only standardized-equal", {
  H1 <- matrix(c(1,1,-1,-1),2,2)
  H2 <- 2 * H1
  y1 <- c(1, 1)
  y2 <- 2 * y1
  result <- CompareHypothesis(H1, H2, y1, y2)
  expect_equal(result, "standardized_equal")
})

test_that("Scaled hypotheses are only standardized-equal", {
   H1 <- matrix(c(1,1,-1,-1),2,2)
H2<-2*matrix(c(-sqrt(2), sqrt(2)),1,2)
  y1 <- c(0, 0)
y2<-0
  result <- CompareHypothesis(H1, H2, y1, y2)
  expect_equal(result, "standardized_equal")
})


test_that("Different hypotheses are not equal", {
  H1 <- matrix(c(1, 0, 0, 1), nrow = 2)
  H2 <- matrix(c(0, 1, 1, 0), nrow = 2)
  y1 <- c(0, 0)
  y2 <- c(1, 1)
  result <- CompareHypothesis(H1, H2, y1, y2)
  expect_equal(result, "none_equal")
})

test_that("Function works without providing y1 and y2", {
  H <- matrix(c(1, 0, 0, 1), nrow = 2)
  result <- CompareHypothesis(H, H)
  expect_equal(result, "all_equal")
})
