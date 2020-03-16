#' Returns ggplot with pointrange for parameters
#'
#' Returns ggplot with pointrange for each parameter of Stan model
#'
#' @param model  a Stan fit obtained with rstan::stan()
#' @param param.name name (char) of parameter to get
#' @param names vector of names of groups in plot -
#'
#' @return ggplot with point range for each parameter
#'
#' @export

plotStanParam <- function(model, param.name, names = NULL) {
  post <- rstan::extract(model)
  param.post <- data.frame(post[param.name])
  param.mean <- purrr::map_dbl(param.post, mean)
  param.q10  <-  purrr::map_dbl(param.post, quantile, probs = .1)
  param.q90  <-  purrr::map_dbl(param.post, quantile, probs = .9)
  result <- data.frame(cbind(param.mean, param.q10, param.q90))
  if (is.null(names)) names <- names(param.post)
  result <- cbind(names = names, result)
  result$names <- forcats::fct_inorder(result$names)
  p <- ggplot(result) + geom_pointrange(aes(x = result[, 1],
                        y    = result[, 2],
                        ymin = result[, 3],
                        ymax = result[, 4]),
                    shape = 21,
                    color = "grey50") +
    geom_hline(yintercept = 0, linetype = 2, color = "red") +
    labs(x = "", y = "") +
    ggtitle(glue::glue("{param.name}")) +
    coord_flip() +
    theme_minimal()
  return(p)
}

