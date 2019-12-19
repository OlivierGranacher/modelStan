#' returns ggplot with pointrange for each parameter
#'
#' returns ggplot with pointrange for each parameter of Stan model
#'
#' @param model  a Stan fit obtained with rstan::stan()
#' @param param.name name (char) of parameter to get
#'
#' @return ggplot with point range for each parameter
#'
#' @export

plotStanParam <- function(model, param.name) {
  post <- rstan::extract(model)
  param.post <- data.frame(post[param.name])
  param.mean <- purrr::map_dbl(param.post, mean)
  param.q10  <-  purrr::map_dbl(param.post, quantile, probs = .1)
  param.q90  <-  purrr::map_dbl(param.post, quantile, probs = .9)
  result <- data.frame(cbind(param.mean, param.q10, param.q90))
  result <- cbind(names(param.post), result)
  p <- geom_pointrange(aes(x = result[, 1],
                        y  = result[, 2],
                        ymin= result[, 3],
                        ymax = result[, 4]),
                    shape = 21,
                    color = "grey50") +
    geom_hline(yintercept = 0, linetype = 2, color = "red") +
    labs(x = "", y = "") +
    coord_flip() +
    theme_minimal()
  return(p)
}

