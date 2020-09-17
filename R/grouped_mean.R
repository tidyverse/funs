#' grouped means, ...
#'
#' @param x list of vectors
#' @param na.rm Should NA values be removed ?
#'
#' @return List of means
#' @examples
#' xs <- vctrs::new_list_of(vctrs::vec_chop(c(1, 2, 3, 4), list(1:2, 3:4)), numeric())
#'
#' grouped_mean(xs)
#'
#' @importFrom purrr map
#' @importFrom vctrs list_of
#' @rdname grouped
#' @export
grouped_mean <- function(x, na.rm = FALSE) {
  UseMethod("grouped_mean", list_ptype_common(x))
}

#' @export
grouped_mean.default <- function(x, na.rm = FALSE) {
  list_of(!!!map(x, mean, na.rm = na.rm))
}

#' @export
grouped_mean.double <- function(x, na.rm = FALSE) {
  .Call(funs_grouped_mean_dbl, x, na.rm)
}
