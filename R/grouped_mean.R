
#' grouped means
#'
#' @examples
#' xs <- mince(c(1, 2, 3, 4), list(1:2, 3:4))
#' grouped_mean(xs)
#'
#' @importFrom purrr map map_dbl
#' @export
grouped_mean <- function(x, na.rm = FALSE) {
  UseMethod("grouped_mean", chop_ptype(x))
}

#' @export
grouped_mean.default <- function(x, na.rm = FALSE) {
  vec_c(!!!map(x, mean, na.rm = na.rm))
}

#' @export
grouped_mean.double <- function(x, na.rm = FALSE) {
  # TODO: do it in C++ instead
  map_dbl(x, mean.default, na.rm = na.rm)
}

#' @export
grouped_mean.POSIXct <- function(x, na.rm = FALSE) {
  vec_restore(
    map_dbl(x, ~mean.default(unclass(.x)), na.rm = na.rm),
    chop_ptype(x)
  )
}
