dummy <- function(class) {
  structure(list(), class = class)
}

column <- function() {
  dummy("column")
}

scalar_logical <- function(default) {
  default
}

scalar_integer <- function() {
  dummy("scalar_integer")
}

arg_match <- function(spec, given) {
  if (is_call(spec, "column") && is_symbol(given)) {
    peek_chops()[[as_string(given)]]
  } else if (is_call(spec, "scalar_logical")) {
    if (is_scalar_logical(given)) {
      given
    } else if (is.null(given)) {
      spec$default
    } else {
      abort(":shrug:")
    }
  } else if (is_call(spec, "scalar_integer")) {
    if (is_scalar_integerish(given)) {
      as_integer(given)
    } else {
      abort("unspecified argument")
    }
  } else if (identical(spec, NA)) {
    given %||% NA
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

delayedAssign("hybrid_functions", env(
  empty_env(),

  mean = fun_matcher(base::mean, grouped_mean, x = column(), na.rm = scalar_logical(default = FALSE))

))

#' @export
hybrid <- function(x) x

peek_chops <- function() {
  context_peek("chops", "peek_chops()")
}
local_chops <- function(x, frame = caller_env()) {
  context_local("chops", x, frame = frame)
}


#' @export
eval_hybrid <- function(quo, chops) {
  env <- quo_get_env(quo)
  expr <- quo_get_expr(quo)
  local_chops(chops)

  fn_symbol <- node_car(expr)
  fn_meant <- eval_bare(fn_symbol, env)
  fn_hybrid <- eval_bare(fn_symbol, hybrid_functions)
  if (!identical(fn_meant, attr(fn_hybrid, "fn"))) return(NULL)

  expr <- node_poke_car(expr, fn_hybrid)
  eval_bare(expr, env = chops)
}
