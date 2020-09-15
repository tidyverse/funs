
#' @rdname grouped
#' @export
grouped_max <- function(x, na.rm = FALSE) {
  UseMethod("grouped_max", list_ptype_common(x))
}

#' @export
grouped_max.default <- function(x, na.rm = FALSE) {
  list_of(!!!map(x, max, na.rm = na.rm))
}
