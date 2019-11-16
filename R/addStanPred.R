#' Adds predictions and quantiles to data from Stan model
#'
#' 
#' 
#' @param model  a Stan fit obtained with rstan::stan()
#' @param data dataframe with data used by the Stan model
#' @param sim  character with simulated data from Stan model Generated Quantities
#' @param q1   low value for quantiles
#' @param q2   high value for quantiles
#' 

addStanPred <- function(model, data, sim, q1 = .1, q2 = .9 ) {
  post <- rstan::extract(model)
  pred <- data.frame(post[as.character(sim)])
  data$pred <- purrr::map_dbl(pred, mean)
  data$q10  <- purrr::map_dbl(pred, quantile, probs = q1)
  data$q90  <- purrr::map_dbl(pred, quantile, probs = q2)
  return(data)
}

