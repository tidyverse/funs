#' Cumulative versions of any() and all()
#'
#' @param x A logical vector
#'
#' @return A logical vector the same size as `x`
#'
#' @export
cumany <- function(x) {
  vec_assert(x, logical())
  .Call(funs_cumany, x)
}

#' @rdname cumany
#' @export
cumall <- function(x) {
  vec_assert(x, logical())
  .Call(funs_cumall, x)
}
