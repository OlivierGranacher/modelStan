#' gets data_fame with mean and quantiles of Stan model parameters
#'
#'
#'
#' @param model  a Stan fit obtained with rstan::stan()
#' @param param.name name (char) of parameter to get

#'
#' @return dataframe with 4 columns : parameter names, mean, 10 and 90% quantiles
#'
#' @export

getStanParam <- function(model, param.name) {
  param.post <- data.frame(post[param.name])
  param.mean <- purrr::map_dbl(param.post, mean)
  param.q10  <-  purrr::map_dbl(param.post, quantile, probs = .1)
  param.q90  <-  purrr::map_dbl(param.post, quantile, probs = .9)
  result <- data.frame(cbind(param.mean, param.q10, param.q90))
  result <- cbind(names(param.post), result)
  names <- paste(param.name, c("", ".mean", ".q10", ".q90"))
  names(result) <- names
  return(result)
}

