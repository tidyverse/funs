
#' @rdname grouped
#' @export
grouped_sd <- function(x, na.rm = FALSE) {
  UseMethod("grouped_sd", list_ptype_common(x))
}

#' @export
grouped_sd.default <- function(x, na.rm = FALSE) {
  vec_c(!!!map(x, sd, na.rm = na.rm))
}
