#' @export
cumany <- function(x) {
  vec_assert(x, logical())
  .Call(funs_cumany, x)
}

#' @export
cumaall <- function(x) {
  vec_assert(x, logical())
  .Call(funs_cumall, x)
}
