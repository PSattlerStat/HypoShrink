library(testthat)

test_that("HypothesisPotential runs and returns data frame", {
  H <- matrix(c(1, 2, 1, 2), nrow = 2)  # not full row rank
    result <- HypothesisPotential(H, duration = 0.01)
    expect_silent({
      expect_s3_class(result, "data.frame")
    expect_equal(ncol(result), 2)
    expect_named(result, c("Method", "Relative_Time_Saved"))
  })
})
