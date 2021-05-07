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
    lhs <- eval_bare(f_lhs(f), env = env(
      f_env(f),
      default = default_sentinel,
      when = function(f_when){
        f_when <- as_function(f_when)
        structure(f_when(x), class = "funs:::selected")
      }
    ))
    rhs <- eval_bare(f_rhs(f), env = f_env(f))

    if (identical(lhs, default_sentinel)) {
      if (i != length(dots)) {
        abort("`default ~` can only be used in the last formula")
      }
      selected <- !touched
    } else if (inherits(lhs, "funs:::selected")) {
      selected <- unclass(lhs)
    } else {
      selected <- vec_in(x, lhs)
    }
    touched <- touched | selected

    vec_slice(x, selected) <- rhs
  }
  x
}

#' @export
when <- function(what, with) {
  patch_env <- context_peek("patch_env", "when()", "`patch()`")
  x <- patch_env$x
  step <- patch_env$step
  arg <- glue("..{step}")

  if (is_formula(what)) {
    what <- as_function(what)
  }
  if (is_function(what)) {
    selected <- vec_assert(what(x), ptype = logical(), size = vec_size(x), arg = arg)
  } else if(identical(what, default_sentinel)) {
    selected <- !patch_env$touched
  } else if (is.logical(what)) {
    selected <- what
  } else {
    selected <- vec_in(x, what, needles_arg = arg, haystack_arg = "x")
  }

  list(selected = selected, replacement = with)
}

#' @export
patch <- function(x, ...) {
  step <- 0L
  caller <- caller_env()
  env <- environment()
  context_local("patch_env", env)
  dots <- enexprs(...)

  n <- vec_size(x)
  touched <- logical(length = n)
  for (i in seq_along(dots)) {
    step <- i
    results <- eval_bare(dots[[i]], env = env(caller, default = default_sentinel))

    vec_slice(x, results$selected) <- results$replacement

    touched <- touched | results$selected
  }

  x
}
