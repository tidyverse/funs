
#' @rdname grouped
#' @export
grouped_min <- function(x, na.rm = FALSE) {
  UseMethod("grouped_min", list_ptype_common(x))
}

#' @export
grouped_min.default <- function(x, na.rm = FALSE) {
  list_of(!!!map(x, min, na.rm = na.rm))
}
