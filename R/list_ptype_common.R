list_ptype_common <- function(x) {
  attr(x, "ptype") %||% vec_ptype_common(!!!x)
}
