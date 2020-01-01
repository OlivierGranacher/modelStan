#' Standardize columns of data table
#'
#' returns DT with additional standardized numeric columns with '_std' appended to name
#'
#' @param dt data frame of data table
#' @param cols default processes all numeric cols, otherwise specified column names
#' @param log if True returns  standardized log
#'
#' @return dt with additional columns with '_std' added to name
#'
#' @example standardizeDT(dt)
#'
#' @export

standardizeDT <- function(dt, cols = 'all.numeric', log = F) {
  # columns to process
  if (cols == 'all.numeric') {
    cols <- names(dt)[sapply(dt, is.numeric)]
  }
  new_cols <- paste0(cols, "_std")
  if (log) new_cols <- paste0(cols, "_log_std")
  dt <- data.table::data.table(dt)

  dt <<- dt[, (new_cols) := lapply(.SD, standardize, log = log), .SDcols = cols]
}


