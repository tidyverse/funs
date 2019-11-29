#' Take a random sample from a vector.
#'
#'
#' @param x A vector.
#' @param size Number of samples to take, Defaults to the size of `x`,
#'   generating a random permutation.
#' @param replace Should samples be taken with or without replacement?
#' @param w Optionally, a vector of weights. If provided should be a
#'   numeric vector the same size as x.
#' @export
#' @examples
#' sample(1:5)
#' sample(1:100, 10)
#' sample(1:10, 100, replace = TRUE)
#'
#' # samples of data frames are taken row wise, making it easy to
#' # do bootstrapping
#' sample(iris, 10, replace = TRUE)
#'
#' # Unlike base::sample(), this is safe to use with inputs of length 1
#' sample(3:5)
#' sample(4:5)
#' sample(5:5)
#' base::sample(5:5)
sample <- function(x, size = vec_size(x), replace = FALSE, w = NULL) {
  vec_assert(size, size = 1)

  if (!is.null(w)) {
    vec_assert(w, ptype = numeric(), size = vec_size(x))
  }

  idx <- sample.int(vec_size(x), size, replace = replace, prob = w)
  vec_slice(x, idx)
}
