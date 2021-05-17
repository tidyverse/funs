#' Vectorised if
#'
#' `if_else()` returns a vector filled with elements selected from `true`,
#' `false`, and (optionally) `na` based on the value of `condition`. It
#' is a type- and size-stable version of [ifelse()].
#'
#' @param condition A logical vector.
#' @param true,false Values to use for `TRUE` and `FALSE` values of `condition`.
#' @param na Values to use for `NA`.
#' @return
#' A vector with the common type of `true`, `false`, and `na`; and the size of
#' `condition`. Where `condition` is `TRUE`, the result comes from `true`,
#' where `FALSE` it comes from `false`.
#'
#' @export
#' @examples
#' x <- c(NA, 1:4)
#' if_else(x > 2, 1, 2)
#' if_else(x > 2, "small", "big")
#' if_else(x > 2, factor("small"), factor("big"))
#'
#' y <- as.Date("2020-01-01")
#' if_else(x > 2, NA, y + x)
if_else <- function(condition, true, false, na = NULL) {
  vec_assert(condition, logical())

  # output size from `condition`
  size <- vec_size(condition)

  # output type from `true`/`false`/`na`
  ptype <- vec_ptype_common(true = true, false = false, na = na)

  args <- vec_recycle_common(true = true, false = false, na = na, .size = size)
  args <- vec_cast_common(!!!args, .to = ptype)

  out <- vec_init(ptype, size)

  loc_true <- condition
  loc_false <- !condition

  out <- vec_assign(out, loc_true, vec_slice(args$true, loc_true))
  out <- vec_assign(out, loc_false, vec_slice(args$false, loc_false))

  if (!is_null(na)) {
    loc_na <- vec_equal_na(condition)
    out <- vec_assign(out, loc_na, vec_slice(args$na, loc_na))
  }

  out
}
