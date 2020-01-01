#' Standardize numeric vector
#'
#' returns numeric vector with standarzized values
#'
#' @param x numeric vector
#' @param log if True log of x is standardized
#'
#' @return numeric with standardized values s
#'
#' @export

standardize <- function(x, log = F) {
  if (!is.numeric(x)) {
    warning("not numeric, no change made")
    return(x)}
  if (log ) {
    # check for positive values
    if (!prod(x > 0, na.rm = T)) {
      warning("not all positive , no change made")
      return(x)
    }
    x <- log(x)
  }
  m <- mean(x, na.rm = T)
  s <- sd(x, na.rm = T)
  if (s == 0 | is.na(s)) {
    warning("sd = 0, centered only")
    s <- 1
   }
  result <-  (x - m)/s
  return(result)
}

