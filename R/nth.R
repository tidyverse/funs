nth_default <- function(x, default = NA) {
  vec_assert(default, size = 1)
  vec_cast(default, x)
}

#' @export
nth <- function(x, n, default = NA) {
  size <- vec_size(x)

  if (size == 0) {
    return(nth_default(x, default))
  }

  if (!is_integerish(n, n = 1L, finite = TRUE)) {
    abort("`n` must be a single integer.")
  }

  if (n == 0 || n > size || n < -size) {
    return(nth_default(x, default))
  }

  # Negative values index from RHS
  if (n < 0) {
    n <- size + n + 1
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
