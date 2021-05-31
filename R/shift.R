#' @export
shift <- function(x, n = 1L, default = NULL, order_by = NULL) {
  size <- vec_size(x)

  if (!is.null(order_by)) {
    out <- with_order(x, order_by, size, shift, n = n, default = default)
    return(out)
  }

  vec_assert(n, size = 1L, arg = "n")
  n <- vec_cast(n, integer(), x_arg = "n")

  if (identical(n, 0L)) {
    return(x)
  }

  lag <- sign(n) > 0L
  n <- abs(n)

  if (n > size) {
    n <- size
  }

  if (is.null(default)) {
    vec_shift_slice(x, n, size, lag)
  } else {
    vec_shift_c(x, n, size, lag, default)
  }
}

#' @export
#' @rdname shift
lag <- function(x, n = 1L, default = NULL, order_by = NULL) {
  vec_assert(n, size = 1L, arg = "n")
  n <- vec_cast(n, integer(), x_arg = "n")

  if (n < 0L) {
    abort("`n` must be positive.")
  }

  shift(x, n, default, order_by)
}

#' @export
#' @rdname shift
lead <- function(x, n = 1L, default = NULL, order_by = NULL) {
  vec_assert(n, size = 1L, arg = "n")
  n <- vec_cast(n, integer(), x_arg = "n")

  if (n < 0L) {
    abort("`n` must be positive.")
  }

  n <- n * -1L

  shift(x, n, default, order_by)
}

vec_shift_slice <- function(x, n, size, lag) {
  idx_default <- vec_rep(NA_integer_, n)

  if (lag) {
    idx <- seq2(1L, size - n)
    idx <- c(idx_default, idx)
    vec_slice(x, idx)
  } else {
    idx <- seq2(1L + n, size)
    idx <- c(idx, idx_default)
    vec_slice(x, idx)
  }
}

vec_shift_c <- function(x, n, size, lag, default) {
  vec_assert(default, size = 1L, arg = "default")
  default <- vec_cast(default, x, x_arg = "default")

  default <- vec_rep(default, n)

  if (lag) {
    idx <- seq2(1L, size - n)
    x <- vec_slice(x, idx)
    vec_c(default, x)
  } else {
    idx <- seq2(1L + n, size)
    x <- vec_slice(x, idx)
    vec_c(x, default)
  }
}

with_order <- function(.x, .order_by, .size, .fn, ...) {
  vec_assert(.order_by, size = .size)
  o <- vec_order(.order_by)
  x <- vec_slice(.x, o)
  out <- .fn(x, ...)
  vec_slice(out, vec_order(o))
}
