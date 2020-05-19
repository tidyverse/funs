column <- function() {
  structure(list(), class = "column")
}

scalar_logical <- function(default) {
  default
}

arg_match <- function(spec, given) {
  if (is_call(spec, "column") && is_symbol(given)) {
    peek_mask()$resolve(as_string(given))
  } else if (is_call(spec, "scalar_logical")) {
    if (is_scalar_logical(given)) {
      given
    } else if (is.null(given)) {
      spec$default
    } else {
      abort(":shrug:")
    }
  } else {
    abort(":no:")
  }
}

#' @importFrom glue glue
fun_matcher <- function(fn, grouped_fn, ...) {
  spec <- as.list(match.call())[-(1:3)]
  f <- function(...) {
    call <- as.list(match.call())[-1]

    # match spec and call together
    names <- names(spec)

    for(name in names) {
      spec[[name]] <- arg_match(spec[[name]], call[[name]])
    }

    eval_bare(expr(grouped_fn(!!!spec)))
  }
  formals(f) <- formals(grouped_fn)
  attr(f, "fn") <- fn
  f
}

#' @importFrom dplyr peek_mask
delayedAssign("hybrid_functions", env(
  empty_env(),

  mean = fun_matcher(mean, grouped_mean, x = column(), na.rm = scalar_logical(default = FALSE)),

  "$" = `$`
))

#' eval summarise
#'
#' @param expr ...
#' @param mask ...
#' @export
eval_summarise <- function(expr) {
  result <- NULL
  mask <- peek_mask()

  if (is_call(expr, "hybrid")) {
    fn <- new_function(mask$args(), node_cadr(expr))
  } else if(is_call(expr, "n", n = 0)){
    fn <- function() list_sizes(mask$get_rows())
  } else {
    fn_symbol <- node_car(expr)
    fn_meant <- eval_bare(fn_symbol, caller_env(3))
    fn_hybrid <- attr(eval_bare(fn_symbol, hybrid_functions), "fn")
    if (!identical(fn_meant, fn_hybrid)) {
      abort("No match")
    }

    fn <- new_function(mask$args(), expr, env = hybrid_functions)
  }

  result <- fn()

  if (!is.null(result) && !inherits(result, "hybrid_result")) {
    if (vec_size(result) != length(mask$get_rows())) {
      abort("incompatible sizes")
    }
    result <- structure(
      list(x = result),
      class = "hybrid_result"
    )
  }

  result
}

