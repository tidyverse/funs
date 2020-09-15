#' grouped lead
#'
#' @param x list of vectors
#' @param n number of positions to lead by
#' @param default Value for non existing rows
#'
#' xs <- vctrs::new_list_of(vctrs::vec_chop(c(1, 2, 3, 4), list(1:2, 3:4)), numeric())
#'
#' grouped_lead(xs)
#'
#' @rdname grouped_lead
#' @export
grouped_lead <- function(x, n, default = NA) {
  if (length(n) != 1 || !is.numeric(n) || n < 0) {
    abort("`n` must be a nonnegative integer scalar")
  }
  UseMethod("grouped_lead", list_ptype_common(x))
}

#' @rdname grouped_lead
#' @export
grouped_lag <- function(x, n, default = NA) {
  if (length(n) != 1 || !is.numeric(n) || n < 0) {
    abort("`n` must be a nonnegative integer scalar")
  }
  UseMethod("grouped_lag", list_ptype_common(x))
}

#' @export
grouped_lead.default <- function(x, n, default = NA) {
  inputs <- vec_cast_common(default = default, !!!x)
  default <- inputs[[1L]]
  x <- inputs[-1L]

  i <- -seq_len(n)

  list_of(!!!map(x, function(.x) {
    vec_c(
      vec_slice(.x, i),
      vec_rep(default, n)
    )
  }))
}

#' @export
grouped_lag.default <- function(x, n, default = NA) {
  inputs <- vec_cast_common(default = default, !!!x)
  default <- inputs[[1L]]
  x <- inputs[-1L]

  list_of(!!!map(x, function(.x) {
      vec_c(
        vec_rep(default, n),
        vec_slice(.x, seq_len(length(.x) - n))
      )
    }))
}
