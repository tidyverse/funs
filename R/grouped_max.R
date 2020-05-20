
#' @rdname grouped
#' @export
grouped_max <- function(x, na.rm = FALSE) {
  UseMethod("grouped_max", list_ptype_common(x))
}

#' @export
grouped_max.default <- function(x, na.rm = FALSE) {
  vec_c(!!!map(x, max, na.rm = na.rm))
}
