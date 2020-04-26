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
#' A vector with the common type of `true`, `false`, and `na`; and the common
#' size of `condition`, `true`, `false`, and `na`. Where `condition` is `TRUE`,
#' the result comes from `true`, where `FALSE` it comes from `false`.
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
  ptype <- vec_ptype_common(true = true, false = false, na = na)
  size <- vec_size_common(condition = condition, true = true, false = false, na = na)

  vec_assert(condition, logical())
  condition <- vec_recycle(condition, size)
  true <- vec_recycle(vec_cast(true, ptype), size)
  false <- vec_recycle(vec_cast(false, ptype), size)
  na <- vec_recycle(vec_cast(na, ptype), size)

  out <- vec_init(true, size)
  vec_slice(out, condition) <- vec_slice(true, condition)
  vec_slice(out, !condition) <- vec_slice(false, !condition)
  if (!is.null(na)) {
    vec_slice(out, is.na(condition)) <- vec_slice(na, is.na(condition))
  }

  out
}
