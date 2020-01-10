#' Simulate pot data for test
#'
#' Create 'fake' pot data to test models
#'
#' @param N number of days in simulation
#' @param np vector of number of pots per group
#' @param Y vector with mean effect for each group
#' @param sigma vector of sd for effect for pots
#' @param sigma_g vector of sd of pot means within groups
#'
#'
#' @return dt with columns dat, C as pot , G as group, B as block type and Y effect
#'
#' @export

simPotData <- function(N = 3,
                       np = c(5, 5, 5),
                       Y = c(0, 1, 3),
                       sigma = c(.3, .3, .3),
                       sigma_g = c(.1, .1, .1)) {
  # Nombre de groupes
  K <- length(np)
  # Liste des dates
  dat_seq <- seq.POSIXt(Sys.time() - (N - 1) * 3600 * 24, Sys.time(), by = "day" )
  # Liste des groupes
  groups  <- factor(paste0("G", 1:K), ordered = T)
  # Liste des cuves
  pots    <- paste0("C", stringr::str_pad(1:(sum(np)), width = 3, side = "left", pad = "0"))
  pots    <- factor(pots, ordered = T)
  # Index des groupes pour chaque cuve
  id_pot_group <- rep(1:K, times = np)
  # groupe pour chaque cuve
  pot_group    <- groups[id_pot_group]
  # Moyenne effet et sd effet pour chaquee cuve
  pot_mean_effect <- Y[id_pot_group]
  pot_g_sd_effect <- sigma_g[id_pot_group]
  pot_sd_effect   <- sigma[id_pot_group]
  # Ajout de la variation par cuve dans chaque groupe
  pot_mean_effect <- pot_mean_effect + rnorm(n = sum(np), mean = 0, sd = pot_g_sd_effect)
  # Affectation des blocs par cuve 0 ou 1:
  pot_bloc <- sample(0:1, sum(np), replace = T)
  # function de simulation de l'effet Y
  calculateY <- function(k){ # k vecteur indice de la cuve as.numeric(C)
    return(pot_mean_effect[k] + rnorm(n = length(k) , mean = 0, sd = 1) * pot_sd_effect[k])
  }

  DT <- data.table::as.data.table(expand.grid(dat_seq, pots))
  data.table::setnames(DT, old = c("Var1", "Var2"), new = c("dat", "C"))
  # Ajout du groupe pour chaque cuve
  DT[, G := pot_group[as.integer(C)]]
  # Ajout de l'effet par cuve
  DT[, Y := calculateY(C)]
  # Ajout du bloc
  DT[, B := pot_bloc[as.integer(C)]]
  return(DT)
}

