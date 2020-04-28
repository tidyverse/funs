
#' grouped means
#'
#' @examples
#' xs <- vctrs::new_list_of(vctrs::vec_chop(c(1, 2, 3, 4), list(1:2, 3:4)), numeric())
#' grouped_mean(xs)
#'
#' @importFrom purrr map map_dbl
#' @export
grouped_mean <- function(x, na.rm = FALSE) {
  UseMethod("grouped_mean", list_ptype_common(x))
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
    list_ptype_common(x)
  )
}
