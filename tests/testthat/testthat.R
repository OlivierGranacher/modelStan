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

# Test of standardizeDT
  context("test of standardizeDT")
  dt <- data.table::data.table(x = 1:10, y = letters[1:2])
  standardizeDT(dt)
  expect_equal(names(dt)[3], expected = "x_std")
  expect_equal(dt[1, x_std], -1.4863011)
  dt <- data.table::data.table(x = 1:10, y = letters[1:2])
  standardizeDT(dt, log = T)
  expect_equal(names(dt)[3], expected = "x_log_std")
  expect_equal(dt[1, x_log_std], -2.0605622)
  dt <- data.table::data.table(x = 1:10, y = letters[1:2])
  standardizeDT(dt, cols = "x")
  expect_equal(names(dt)[3], expected = "x_std")
  expect_equal(dt[1, x_std], -1.4863011)

