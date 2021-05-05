nth_default <- function(x, default = NA) {
  vec_assert(default, size = 1)
  vec_cast(default, x)
}

#' Extract the first, last or nth value from a vector
#'
#' @param x A vector
#' @param n A single integer specifying the position. Negative integers index from the end (i.e. -1 will return the last value in the vector).
#' @param default A default value to use if the position does not exist in `x`
#' @param value A size 1 vector of type compatible with `x`
#'
#' @return A vector of size 1 and the same type as `x`.
#'
#' @examples
#' first(month.name)
#' last(month.name)
#' nth(month.name, 2)
#' nth(month.name, -3)
#'
#' first(trees)
#' last(trees)
#' nth(trees, 2)
#'
#' lst <- list(a = 1, b = letters, c = data.frame(x = 1, y = 2))
#' first(lst)
#' last(lst)
#' nth(lst, 2)
#'
#' # assignment versions
#' numbers <- c(1, 2, 3)
#' first(numbers) <- 4
#' last(numbers) <- 5
#' nth(numbers, 2) <- 6
#' numbers
#'
#' @seealso [vctrs::vec_slice()] which these functions are wrappers of.
#'
#' @export
nth <- function(x, n, default = NA) {
  size <- vec_size(x)

  if (!is_integerish(n, n = 1L, finite = TRUE)) {
    abort("`n` must be a single integer.")
  }

  if (n == 0 || n > size || n < -size) {
    return(nth_default(x, default))
  }

  # Negative values index from RHS
  if (n < 0) {
    n <- size + n + 1
  }

  vec_slice(x, n)
}

#' @rdname nth
#' @export
first <- function(x, default = NA) {
  nth(x, n = 1L, default = default)
}

#' @rdname nth
#' @export
last <- function(x, default = NA) {
  nth(x, n = -1L, default = default)
}

#' @rdname nth
#' @export
`nth<-` <- function(x, n, value) {
  size <- vec_size(x)

  if (!is_integerish(n, n = 1L, finite = TRUE)) {
    abort("`n` must be a single integer.")
  }

  if (n == 0 || n > size || n < -size) {
    abort("`n` is out of bounds")
  }

  vec_assert(value, size = 1L)
  params <- vec_cast_common(x = x, value = value)
  x <- params$x

  # Negative values index from RHS
  if (n < 0) {
    n <- size + n + 1
  }

  vec_slice(x, n) <- params$value
  x
}

#' @rdname nth
#' @export
`first<-` <- function(x, value) {
  `nth<-`(x, 1, value)
}

#' @rdname nth
#' @export
`last<-` <- function(x, value) {
  `nth<-`(x, -1, value)
}
