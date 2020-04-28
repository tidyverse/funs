#' mince
#'
#' @export
mince <- function(x, indices = NULL) {
  structure(
    vec_chop(x, indices),
    ptype = vec_ptype(x)
  )
}

chop_ptype <- function(x) {
  attr(x, "ptype") %||% vec_ptype_common(!!!x)
}
