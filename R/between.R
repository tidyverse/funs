#' Find all values within a range
#'
#' This is essentially a shortcut for `x >= left & x <= right`, but it also
#' retains the size of `x` and casts both `left` and `right` to the type of
#' `x` before making the comparison.
#'
#' @param x A vector
#' @param left,right Boundary values. Both `left` and `right` are recycled to
#'   the size of `x` and are cast to the type of `x`.
#' @param bounds One of \verb{"[]"}, \verb{"[)"}, \verb{"(]"}, or \verb{"()"},
#'   which defines whether the boundary is inclusive (with `[` or `]`) or
#'   exclusive (with `(` or `)`).
#' @return A logical vector the same size as `x`.
#' @export
#' @examples
#' between(c(1:10, NA), 4, 6)
#' between(letters, "d", "j")
#'
#' today <- Sys.Date()
#' between(today, today - 1, today + 1)
between <- function(x, left, right, bounds = "[]") {
  args <- list(left = left, right = right)
  args <- vec_cast_common(!!!args, .to = x)
  args <- vec_recycle_common(!!!args, .size = vec_size(x))
  left <- args[[1L]]
  right <- args[[2L]]

  bounds <- check_bounds(bounds)
  bounds <- switch(bounds,
    "[]" = list(`>=`, `<=`),
    "[)" = list(`>=`, `<`),
    "(]" = list(`>`, `<=`),
    "()" = list(`>`, `<`),
    abort("Unknown `bounds` specification.", .internal = TRUE)
  )

  fn_left <- bounds[[1L]]
  fn_right <- bounds[[2L]]

  left <- vec_compare(x, left)
  left <- fn_left(left, 0L)

  right <- vec_compare(x, right)
  right <- fn_right(right, 0L)

  left & right
}

check_bounds <- function(bounds, ..., error_call = caller_env()) {
  check_dots_empty0(...)

  arg_match0(
    arg = bounds,
    values = c("[]", "[)", "(]", "()"),
    arg_nm = "bounds",
    error_call = error_call
  )
}
