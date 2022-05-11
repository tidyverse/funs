#' Find first non-missing element
#'
#' Given a set of vectors, `coalesce()` finds the first non-missing value at
#' each position. It's inspired by the SQL `COALESCE` function which does the
#' same thing for SQL `NULL`s.
#'
#' @param ... One or more vectors.
#' @param .ptype The type to cast the vectors in `...` to. If `NULL`, the
#'   vectors will be cast to their common type, which is consistent with SQL.
#' @param .size The size to recycle the vectors in `...` to. If `NULL`, the
#'   vectors will be recycled to their common size.
#' @export
#' @examples
#' # Use a single value to replace all missing values
#' x <- sample(c(1:5, NA, NA, NA))
#' coalesce(x, 0L)
#'
#' # The equivalent to a missing value in a list is NULL
#' coalesce(list(1, 2, NULL), list(NA))
#'
#' # Or generate a complete vector from partially missing pieces
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
coalesce <- function(..., .ptype = NULL, .size = NULL) {
  args <- list2(...)
  args <- discard(args, is.null)

  if (length(args) == 0L) {
    abort("`...` must contain at least one input.")
  }

  args <- vec_cast_common(!!!args, .to = .ptype)
  args <- vec_recycle_common(!!!args, .size = .size)

  out <- args[[1L]]
  args <- args[-1L]

  for (arg in args) {
    is_na <- vec_equal_na(out)

    if (!any(is_na)) {
      break
    }

    out <- vec_assign(out, is_na, vec_slice(arg, is_na))
  }

  out
}
