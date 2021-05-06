default_sentinel <- structure(list(), class = "funs:::default")

#' @export
recode_when <- function(x, ...) {
  dots <- list2(...)

  are_formula <- map_lgl(dots, is_formula, lhs = TRUE)
  if (!all(are_formula)) {
    abort("All ... should be 2 sided formulas")
  }

  n <- vec_size(x)
  touched <- logical(length = n)

  for (i in seq_along(dots)) {
    f <- dots[[i]]
    lhs <- eval_bare(f_lhs(f), env = env(f_env(f), default = default_sentinel))
    rhs <- eval_bare(f_rhs(f), env = f_env(f))

    if (identical(lhs, default_sentinel)) {
      if (i != length(dots)) {
        abort("`default ~` can only be used in the last formula")
      }
      selected <- !touched
    } else {
      selected <- vec_in(x, lhs)
      touched <- touched | selected
    }

    vec_slice(x, selected) <- rhs
  }
  x
}
