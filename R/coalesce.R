#' Find first non-missing element
#'
#' Given a set of vectors, `coalesce()` finds the first non-missing value at
#' each position. It's inspired by the SQL `COALESCE` function which does the
#' same thing for SQL `NULL`s.
#'
#' @param ... One or more vectors.
#' @param .ptype The type to cast the vectors in `...` to. If `NULL`, the
#'   vectors will be cast to a common type, which is consistent with SQL.
#' @param .size The size to recycle the vectors in `...` to. If `NULL`, the
#'   vectors will be recycled to a common size.
#' @export
#' @examples
#' # Use a single value to replace all missing values
#' x <- sample(c(1:5, NA, NA, NA))
#' coalesce(x, 0L)
#'
#' # In cases like the one above, you may want to require that the return
#' # type has the same type as the first input (here, `x`) rather than the
#' # common type of all inputs. To do that, set the `.ptype` argument to a
#' # vector with your preferred type.
#' typeof(coalesce(x, 0))
#' typeof(coalesce(x, 0, .ptype = x))
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
