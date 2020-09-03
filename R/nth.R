nth_default <- function(x, default = NA) {
  vec_assert(default, size = 1)
  vec_cast(default, x)
}

#' @export
nth <- function(x, n, default = NA) {
  if (vec_size(x) == 0) {
    return(nth_default(x, default))
  }

  if (length(n) != 1 || !is.numeric(n)) {
    abort("`n` must be a single integer.")
  }
  n <- trunc(n)

  if (n == 0 || n > vec_size(x) || n < -vec_size(x)) {
    return(nth_default(x, default))
  }

  # Negative values index from RHS
  if (n < 0) {
    n <- length(x) + n + 1
  }

  vec_slice(x, n)
}

#' @export
first <- function(x, default = NA) {
  nth(x, n = 1L, default = default)
}

#' @export
last <- function(x, default = NA) {
  nth(x, n = vec_size(x), default = default)
}
