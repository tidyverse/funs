
#' @rdname grouped
#' @export
grouped_first <- function(x, default = NA) {
  UseMethod("grouped_first", list_ptype_common(x))
}

#' @export
grouped_first.default <- function(x, default = NA) {
  list_of(!!!map(x, first, default = default))
}

#' @rdname grouped
#' @export
grouped_last <- function(x, default = NA) {
  UseMethod("grouped_last", list_ptype_common(x))
}

#' @export
grouped_last.default <- function(x, default = NA) {
  list_of(!!!map(x, last, default = default))
}

#' @rdname grouped
#' @export
grouped_nth <- function(x, n, default = NA) {
  UseMethod("grouped_nth", list_ptype_common(x))
}

#' @export
grouped_nth.default <- function(x, n, default = NA) {
  list_of(!!!map(x, nth, n, default = default))
}
