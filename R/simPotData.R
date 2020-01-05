#' Simulate pot data for test
#'
#' Create 'fake' pot data to test models
#'
#' @param N typical number of observations
#' @param np number of pots per group
#' @param K number of groups
#' @param Y vector with mean effect for each group
#' @param sigma vector with sd for effect
#'
#'
#' @return df, dt with col dat, C as pot , G as group, B as block type,
#'
#' @export

simPotData <- function(N = 100, np = 20, K = 3, Y = c(-1, 0, 1), sigma = c(1, 1, 1)) {

  # Liste des dates
  dat_seq <- seq.POSIXt(Sys.time() - (N - 1) * 3600 * 24, Sys.time(), by = "day" )
  # Liste des groupes
  groups  <- factor(paste0("G", 1:K), ordered = T)
  # Liste des cuves
  pots    <- paste0("C", stringr::str_pad(1:(K*np), width = 3, side = "left", pad = "0"))
  pots    <- factor(pots, ordered = T)

  # affectation des cuves aux groupes

  DT <- data.table::as.data.table(expand.grid(dat_seq, pots))
}
