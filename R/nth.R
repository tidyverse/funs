nth_default <- function(x, default = NA) {
  vec_assert(default, size = 1)
  vec_cast(default, x)
}

#' @export
nth <- function(x, n, default = NA) {
  if (vec_size(x) == 0) {
    return(nth_default(x, default))
  }

  if (!is_integerish(n)) {
    abort("`n` must be a single integer.")
  }

  x_size <- vec_size(x)
  if (n == 0 || n > x_size || n < -x_size) {
    return(nth_default(x, default))
  }

  # Negative values index from RHS
  if (n < 0) {
    n <- x_size + n + 1
  }

  vec_slice(x, n)
}

#' @export
first <- function(x, default = NA) {
  nth(x, n = 1L, default = default)
}

#' @export
last <- function(x, default = NA) {
  nth(x, n = -1L, default = default)
}
