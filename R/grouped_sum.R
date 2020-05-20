
#' @rdname grouped
#' @export
grouped_sum <- function(x, na.rm = FALSE) {
  UseMethod("grouped_sum", list_ptype_common(x))
}

#' @export
grouped_sum.default <- function(x, na.rm = FALSE) {
  vec_c(!!!map(x, sum, na.rm = na.rm))
}
