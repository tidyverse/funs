#' Convert values to NA
#'
#' @param x A vector to modify
#' @param y What to replace with `NA`. Can be:
#'
#' - A vector whose type matches `x`, in that case [vctrs::vec_in()] is used
#'   to determine which values are replace with `NA`.
#' - A predicate function applied to `x` returning a logical vector, integer or character vector. See [vctrs::vec_slice<-()] for details.
#'
#' @examples
#' x <- 1:10
#'
#' # turn specific values to NA
#' na_if(x, c(6, 8))
#'
#' # or use a predicate
#' na_if(x, ~ .x > 5)
#'
#' df <- data.frame(x = 1:10, y = 1:10)
#' na_if(df, ~ .x$y > 8)
#'
#' @export
na_if <- function(x, y) {
  if (is_formula(y)) {
    y <- as_function(y)
  }
  predicate <- if (is_function(y)) {
    y
  } else {
    function(x) vec_in(x, y, needles_arg = "y", haystack_arg = "x")
  }
  vec_slice(x, predicate(x)) <- NA

  x
}
