#' generates arma time series with shifts
#'
#' auto regressive moving average time series generation - based on
#' https://stats.stackexchange.com/questions/184828/create-random-time-series-with-shifts-in-r
#' with optional shifts in sequence
#'
#' @param N  number of time points to generate
#' @param p  order of auto regressive model
#' @param q  order of auto moving average model
#' @param e  sd of error in model
#'
#' @return vector of N numeric
#'
#' @export

armaTimeSeries <- function(N, p, q, e = .1) {

  # ar function
  ar <- function(N , p = 1, e = .1 ) {
    err <- rnorm(N, 0, e)
    Y <- rep(NA, N)
    a <- runif(p)/sum(p) # random coefficient with sum = 1 for stability
    Y[1:p] <- rnorm(p, 0, e)
    for (i in ((p + 1):N)) {
      Y[i] <- sum(Y[i - 1:p] * a, na.rm = T) + err[i]
    }
    return(Y)
  }

# ma function
 ma <- function(N, q = 1, e = .1) {
   err <- rnorm(N + q, 0, e)
   Z <- rep(NA, N + q)
   b <- runif(q)
   for (i in ((q + 1):(N + q))) {
     Z[i] <- sum(c(1, b) * err[i:(i - q)])
   }
   return(Z[!is.na(Z)])
 }
 result <- ar(N, p, e) + ma(N, q, e)
 return(result)
 }



#plot(armaTimeSeries (N=100, p= 5, q = 20, e =.1), type = "l")


## Number of shifts:
ns <- rpois(1, 10)
## The length of shifts
ls <- rpois(ns, 10)
## The positions of the shifts
ps <- cumsum(ls)
## The magnitudes of the shifts
ms <- rchisq(ns, 10)
##Shift vector
S <- rep(0, length(Y))
S[ps] <- ms
