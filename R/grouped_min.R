
#' @rdname grouped
#' @export
grouped_min <- function(x, na.rm = FALSE) {
  UseMethod("grouped_min", list_ptype_common(x))
}

#' @export
grouped_min.default <- function(x, na.rm = FALSE) {
  vec_c(!!!map(x, min, na.rm = na.rm))
}
