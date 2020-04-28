list_ptype_common <- function(x) {
  stopifnot(vec_is_list(x))
  attr(x, "ptype") %||% vec_ptype_common(!!!x)
}
