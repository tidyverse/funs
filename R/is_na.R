#' Are values missing?
#'
#' Returns `TRUE` or `FALSE` depending on whether the value in `x` are missing.
#' Compared to `is.na()`, it follows the tidyverse size principles, so that
#' `length(is_na(df))` equals `nrow(df)`.
#'
#' @param x A vector
#' @return A logical vector with same size as x.
#' @export
#' @examples
#' is_na(c(NA, 1, NA))
#'
#' # A row of a data frame is missing if all its values are missing.
#' df <- data.frame(x = c(NA, 2, 3), y = c(NA, NA, 3))
#' is_na(df)
is_na <- function(x) {
  vec_equal_na(x)
}
