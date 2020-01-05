# Speed test for standardize
N <- 1e+7
library(data.table)

DT <- data.table::data.table(x = rnorm(N, 1, 2), y = c("a", "b"))
system.time(DT[, x_std_1 := modelStan::standardize(x)])

modelStan::standardizeDT(dt )

tables()
