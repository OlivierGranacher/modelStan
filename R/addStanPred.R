#' Adds predictions and quantiles to data from Stan model
#'
#' Adds columns to dataframe containing model data
#'
#' @param model  a Stan fit obtained with rstan::stan()
#' @param data dataframe with data used by the Stan model
#' @param sim  character with simulated data from Stan model in Generated Quantities
#' @param q1   low value for quantiles
#' @param q2   high value for quantiles
#'
#' @return adds 4 columns to data : pred mean, pred.median, predq10 and q90
#'
#' @export

addStanPred <- function(model, data, sim, q1 = .1, q2 = .9 ) {
  post <- rstan::extract(model)
  pred <- data.frame(post[as.character(sim)])
  data$pred <- purrr::map_dbl(pred, mean)
  data$pred.median <- purrr::map_dbl(pred, median)
  data$q10  <- purrr::map_dbl(pred, quantile, probs = q1)
  data$q90  <- purrr::map_dbl(pred, quantile, probs = q2)
  return(data)
}

