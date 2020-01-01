library(testthat)
library(modelStan)


# Test of function standardise
  context("test of standardize")
  x1 <- c(1, 1)
  x2 <- c(-1, 1)
  x3 <- c(1, 2, NA)
  expect_equal(standardize(x1), c(0, 0))
  expect_warning(standardize(x1))
  expect_warning(standardize(x2, log = T))
  expect_equal(standardize(x3), (x3 - mean(x3, na.rm = T))/sd(x3, na.rm = T))
