#' @export
shift <- function(x, n = 1L, default = NULL, order_by = NULL) {
  n <- as_scalar_integer(n)
  shift_impl(x, n = n, default = default, order_by = NULL)
}

#' @export
#' @rdname shift
lag <- function(x, n = 1L, default = NULL, order_by = NULL) {
  n <- as_positive_scalar_integer(n)
  shift_impl(x, n, default, order_by)
}

#' @export
#' @rdname shift
lead <- function(x, n = 1L, default = NULL, order_by = NULL) {
  n <- as_positive_scalar_integer(n)
  shift_impl(x, n * -1L, default, order_by)
}

shift_impl <- function(x, n, default = NULL, order_by = NULL, error_call = caller_env()) {
  size <- vec_size(x)

  if (!is.null(order_by)) {
    out <- with_order(x, order_by, size, shift, n = n, default = default, error_call = error_call)
    return(out)
  }

  if (identical(n, 0L)) {
    return(x)
  }

  lag <- sign(n) > 0L
  n <- abs(n)

  if (n > size) {
    n <- size
  }

  if (is.null(default)) {
    vec_shift_slice(x, n, size, lag, error_call = error_call)
  } else {
    vec_shift_c(x, n, size, lag, default, error_call = error_call)
  }
}

as_scalar_integer <- function(n, arg_name = "n", error_call = caller_env()) {
  withCallingHandlers({
    vec_assert(n, size = 1L, arg = "n")
    vec_cast(n, integer(), x_arg = "n")
  }, error = function(cnd) {
    msg <- "{.arg {arg_name}} must be a single positive number."
    cli_abort(msg, parent = cnd, call = error_call)
  })
}

as_positive_scalar_integer <- function(n, arg_name = "n", error_call = caller_env()) {
  n <- as_scalar_integer(n, arg_name = arg_name, error_call = error_call)
  if (n < 0L) {
    msg <- "{.arg {arg_name}} must be positive."
    cli_abort(msg, call = error_call)
  }
  n
}

vec_shift_slice <- function(x, n, size, lag, error_call = caller_env()) {
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

vec_shift_c <- function(x, n, size, lag, default, error_call = caller_env()) {
  withCallingHandlers({
    vec_assert(default, size = 1L, arg = "default")
    default <- vec_cast(default, x, x_arg = "default")
  }, error = function(cnd) {
    msg <- "{.arg default} must be a scalar compatible with {.cls {vec_ptype_full(x)}}."
    cli_abort(msg, parent = cnd, call = error_call)
  })
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

with_order <- function(.x, .order_by, .size, .fn, ..., error_call = caller_env()) {
  withCallingHandlers(
    vec_assert(.order_by, size = .size, arg = "order_by"),
    error = function(cnd) {
      msg <- "{.arg order_by} must match the size of {.arg x}."
      cli_abort(msg, parent = cnd, call = error_call)
    }
  )
  o <- vec_order(.order_by)

  x <- vec_slice(.x, o)
  out <- .fn(x, ...)
  vec_slice(out, vec_order(o))
}
