#' Incremental summaries
#'
#' @param x for `incremental_any()` and `incremental_all()` A logical vector
#'
#' @return A vector the same size as `x`
#'
#' - For `incremental_any()` and `incremental_all()` : a logical vector
#'
#' @rdname incremental
#' @export
incremental_any <- function(x) {
  vec_assert(x, logical())
  .Call(funs_incremental_any, x)
}

#' @rdname incremental
#' @export
incremental_all <- function(x) {
  vec_assert(x, logical())
  .Call(funs_incremental_all, x)
}

#' @rdname incremental
#' @export
incremental_sum <- function(x) {
  cumsum(x)
}

#' @rdname incremental
#' @export
incremental_prod <- function(x) {
  cumprod(x)
}

#' @rdname incremental
#' @export
incremental_min <- function(x) {
  cummin(x)
}

#' @rdname incremental
#' @export
incremental_max <- function(x) {
  cummax(x)
}
