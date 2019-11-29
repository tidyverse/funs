#' Find first non-missing element
#'
#' Given a set of vectors, `coalesce()` finds the first non-missing value at
#' each position. It's inspired by the SQL `COALESCE`` function which does the
#' same thing for SQL `NULL`s.
#'
#' @param ... One or more vectors. Vectors are recycled to a common length
#'   and cast to a common type.
#' @export
#' @examples
#' # Use a single value to replace all missing values
#' x <- sample(c(1:5, NA, NA, NA))
#' coalesce(x, 0L)
#'
#' # The equivalent to a missing value in a list is NULL
#' coalesce(list(1, 2, NULL), list(NA))
#'
#' # data frames are coalesced, row by row, and the output will contain
#' # columns that appear in any input
#' coalesce(
#'   data.frame(x = c(1, NA)),
#'   data.frame(x = c(NA, 2), y = 3)
#' )
#'
#' # Or match together a complete vector from missing pieces
#' y <- c(1, 2, NA, NA, 5)
#' z <- c(NA, NA, 3, 4, 5)
#' coalesce(y, z)
#'
#' # Supply lists by splicing them into dots:
#' vecs <- list(
#'   c(1, 2, NA, NA, 5),
#'   c(NA, NA, 3, 4, 5)
#' )
#' coalesce(!!!vecs)
coalesce <- function(...) {
  args <- list2(...)

  n_args <- vec_size(args)

  if (n_args == 0L) {
    return(NULL)
  }

  args <- vec_cast_common(!!! args)
  args <- vec_recycle_common(!!! args)

  out <- args[[1L]]
  args <- args[-1L]

  for (arg in args) {
    is_na <- vec_equal_na(out)

    if (!any(is_na)) {
      break
    }

    vec_slice(out, is_na) <- vec_slice(arg, is_na)
  }

  out
}
