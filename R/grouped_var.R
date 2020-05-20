
#' @rdname grouped
#' @export
grouped_var <- function(x, na.rm = FALSE) {
  UseMethod("grouped_var", list_ptype_common(x))
}

#' @export
grouped_var.default <- function(x, na.rm = FALSE) {
  vec_c(!!!map(x, var, na.rm = na.rm))
}
