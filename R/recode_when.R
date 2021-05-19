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
when <- function(what, ...) {
  patch_env <- context_peek("patch_env", "when()", "`patch()` or `case()`")
  x <- patch_env$x
  step <- patch_env$step
  arg <- glue("..{step}")

  if (is_formula(what)) {
    what <- as_function(what)
  }
  if (is_function(what)) {
    if (inherits(x, "case_sentinel")) abort("cannot use function in case()")
    selected <- vec_assert(what(x), ptype = logical(), size = vec_size(x), arg = arg)
  } else if(identical(what, default_sentinel)) {
    selected <- !patch_env$touched
  } else if (is.logical(what)) {
    selected <- what
  } else {
    if (inherits(x, "case_sentinel")) abort("cannot use values in case()")
    selected <- vec_in(x, what, needles_arg = arg, haystack_arg = "x")
  }

  replacement <- if (is.data.frame(x)) {
    df <- vctrs::data_frame(...)
    x[names(df)] <- df
    x
  } else {
    ..1
  }

  list(selected = selected, replacement = replacement)
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

    size_replacement <- vec_size(results$replacement)
    # TODO: deal with selected here as in case(when())
    if (size_replacement == 1L) {
      vec_slice(x, results$selected) <- results$replacement
    } else if (size_replacement == n){
      vec_slice(x, results$selected) <- vec_slice(results$replacement, results$selected)
    } else {
      # TODO: maybe check this is a when() call and extract the with=
      abort(c(
        glue("Incompatible replacement size in `..{ i }`"),
        x = glue("`..{i}` should be size 1 or { n }, not { size_replacement }."),
        i = glue("`..{i}` is `{as_label(dots[[i]])}`. ")
      ))
    }

    touched <- touched | results$selected
  }

  x
}

#' @export
case <- function(...) {
  step <- 0L
  caller <- caller_env()
  env <- environment()
  context_local("patch_env", env)
  patch_type <- "patch"
  dots <- enexprs(...)

  x <- structure(list(), class = "case_sentinel")
  touched <- NULL
  out <- NULL

  for (i in seq_along(dots)) {
    step <- i
    results <- eval_bare(dots[[i]], env = env(caller, default = default_sentinel))

    n <- vec_size(results$selected)
    if (step == 1) {
      out <- vec_init(results$replacement, n)
    }

    size_replacement <- vec_size(results$replacement)
    selected <- results$selected
    if (!is.null(touched)) {
      selected <- selected & !touched
    }
    if (size_replacement == 1L) {
      vec_slice(out, selected) <- results$replacement
    } else if (size_replacement == n){
      vec_slice(out, selected) <- vec_slice(results$replacement, selected)
    } else {
      # TODO: maybe check this is a when() call and extract the with=
      abort(c(
        glue("Incompatible replacement size in `..{ i }`"),
        x = glue("`..{i}` should be size 1 or { n }, not { size_replacement }."),
        i = glue("`..{i}` is `{as_label(dots[[i]])}`. ")
      ))
    }

    touched <- if (is.null(touched)) {
      results$selected
    } else(
      touched | results$selected
    )
  }

  out
}


